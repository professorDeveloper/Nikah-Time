import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/welcome.dart';

class ServicePreferences {
  static String get baseUrl {
    return "https://www.nikahtime.ru/api";
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LocaleQueuedInterceptor extends QueuedInterceptor {
  LocaleQueuedInterceptor();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    //options.headers.addAll({'Content-Language' : locale});
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}


class AuthQueuedInterceptor extends QueuedInterceptor {
  late final Dio _dio;

  AuthQueuedInterceptor() {
    _dio = Dio();
    _dio.interceptors.addAll([
      LocaleQueuedInterceptor(),
      LogInterceptor(),
    ]);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers['requiresToken'] == false) {
      // Если запросу не нужен токен, происходит переход к следующему перехватчику.
      options.headers.remove('requiresToken'); // Удаление заголовка.
      return handler.next(options);
    }

    final accessToken = (await SharedPreferences.getInstance()).getString("token");

    if (accessToken == null) {
      await _performLogout();

      // Создание кастомной ошибки dio.
      options.extra['tokenErrorType'] = 'ERR_TOKEN_NOT_FOUND_IN_LOCAL_STORAGE';
      final error = DioException(requestOptions: options);
      return handler.reject(error);
    }


    // Добавление access token в заголовок запроса.
    options.headers['Authorization'] = 'Bearer $accessToken';
    options.headers.remove('requiresToken'); // Удаление заголовка.
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if (/*statusCode == 403 ||*/ statusCode == 401) {
      // Если при обновлении токена произошла ошибка, необходимо разлогинить пользователя.
      await _performLogout();

      // Создание кастомной ошибки dio.
      err.requestOptions.extra['tokenErrorType'] = 'ERR_INVALID_ACCESS_TOKEN';
    }

    return handler.next(err);
  }

  Future<void> _performLogout() async {
    SharedPreferences prefs =
    await SharedPreferences.getInstance();
    prefs.setString("token", "empty");
    prefs.setString("userGender", "empty");
    prefs.setInt("userId", 0);

    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.deleteToken();
    } catch (_) {}

    // Возврат на страницу логина без context.
    // https://stackoverflow.com/a/53397266/9101876
    await navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }

}