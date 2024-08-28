import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart';
import 'package:untitled/Screens/welcome.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/widgets/nikah_app_updater.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/Screens/Registration/registration_create_profile.dart';
import 'package:untitled/Screens/main_page.dart';
import 'package:untitled/my_tracker_params.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString("token") ?? "";
  debugPrint(token);
  var response;
  if (token != "empty") {
    response = await NetworkService().GetUserInfo(token);
  }
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  /*SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Color.fromARGB(255, 0xf5, 0xf5, 0xf5),
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark
  ));*/

  //WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (Platform.isIOS) {
    StreamSubscription? subscription;
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {
      if (purchaseDetailsList.isEmpty) {
        subscription?.cancel();
        return;
      }
      purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
        if (purchaseDetails.status == PurchaseStatus.pending) {
        } else {
          if (purchaseDetails.status == PurchaseStatus.error) {
          } else if (purchaseDetails.status == PurchaseStatus.purchased ||
              purchaseDetails.status == PurchaseStatus.restored) {
            try {
              String receiptData =
                  purchaseDetails.verificationData.localVerificationData;
              await NetworkService()
                  .verifyPaymentByApplePay(receiptData: receiptData);
            // ignore: deprecated_member_use
            } on DioError catch (error) {
              debugPrint(error.toString());
              return;
            }
          } else if (purchaseDetails.status == PurchaseStatus.canceled) {}
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
          }
        }
      });
      subscription?.cancel();
    }, onDone: () {
      subscription?.cancel();
    }, onError: (error) {
      debugPrint(error);
    });
  }

  MyTrackerConfig trackerConfig = MyTracker.trackerConfig;
  trackerConfig.setLaunchTimeout(300);
  trackerConfig.setBufferingPeriod(60);
  trackerConfig.setTrackingLocationEnabled(false);

  //MyTracker.setDebugMode(true);
  await MyTracker.init(MyTrackerSDK.getKeySDK());

  // runApp(MyApp(token, response));
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ru')],
        path:
            'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MyApp(token, response)),
  );
}

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

class MyApp extends StatelessWidget {
  MyApp(this.token, this.response, {super.key});
  String token;
  var response;
  Map<int, Color> colorCodes = {
    50: const Color.fromRGBO(00, 0xcf, 0x91, .1),
    100: const Color.fromRGBO(00, 0xcf, 0x91, .2),
    200: const Color.fromRGBO(00, 0xcf, 0x91, .3),
    300: const Color.fromRGBO(00, 0xcf, 0x91, .4),
    400: const Color.fromRGBO(00, 0xcf, 0x91, .5),
    500: const Color.fromRGBO(00, 0xcf, 0x91, .6),
    600: const Color.fromRGBO(00, 0xcf, 0x91, .7),
    700: const Color.fromRGBO(00, 0xcf, 0x91, .8),
    800: const Color.fromRGBO(00, 0xcf, 0x91, .9),
    900: const Color.fromRGBO(00, 0xcf, 0x91, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ProfileBloc(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Nikah Time',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: MaterialColor(0xFF00CF91, colorCodes),
            primaryColor: const Color.fromARGB(255, 00, 0xcf, 0x91),
            fontFamily: 'Rubik'),
        home: buildAppBody(context),
        navigatorKey: navigatorKey,
        routes: {
          '/entering': (context) => const WelcomeScreen(),
        },
      ),
    );
  }

  Widget buildAppBody(BuildContext context) {
    if (token == "empty") {
      return const AppBody(
        initialScreen: AppBodyScreen.welcome,
      );
    }

    if (response.statusCode != 200) {
      return const AppBody(initialScreen: AppBodyScreen.welcome);
    }
    print(response.body);
    UserProfileData userProfileData = UserProfileData();
    userProfileData.accessToken = token;
    userProfileData.jsonToData(jsonDecode(response.body)[0]);

    return Builder(builder: (context) {
      context
          .read<ProfileBloc>()
          .add(UpdateProfileDataEvent(userProfileData: userProfileData));
      return AppBody(
        initialScreen: (userProfileData.isValid())
            ? AppBodyScreen.main
            : AppBodyScreen.registrationCreateProfile,
        userProfileData: userProfileData,
      );
    });
  }
}

enum AppBodyScreen { welcome, main, registrationCreateProfile }

class AppBody extends StatelessWidget {
  final AppBodyScreen initialScreen;
  final UserProfileData? userProfileData;

  const AppBody({super.key, required this.initialScreen, this.userProfileData});

  String getCountryIsoCode() {
    final WidgetsBinding instance = WidgetsBinding.instance;
    final List<Locale> systemLocales = instance.window.locales;
    String? isoCountryCode = systemLocales.first.countryCode;
    if (isoCountryCode != null) {
      return isoCountryCode;
    } else {
      throw Exception("Unable to get Country ISO code");
    }
  }

  @override
  Widget build(BuildContext context) {
    var country = "US";
    try {
      country = getCountryIsoCode();
    } catch (e) {
      country = "US";
    }

    final appUpdater = NikahAppUpdater(country: country);
    appUpdater.showUpdateDialogIfNecessary(context: context);

    // FlutterAppBadger.removeBadge();

    switch (initialScreen) {
      case AppBodyScreen.welcome:
        return const WelcomeScreen();
      case AppBodyScreen.main:
        MyTrackerParams trackerParams = MyTracker.trackerParams;

        trackerParams.setCustomUserIds([userProfileData!.id!.toString()]);
        trackerParams.setAge(DateTime.now()
                .difference(
                    DateFormat("dd.MM.yyyy").parse(userProfileData!.birthDate!))
                .abs()
                .inDays ~/
            365);
        trackerParams.setGender(userProfileData!.gender == null
            ? MyTrackerGender.UNKNOWN
            : ((userProfileData!.gender == "male")
                ? MyTrackerGender.MALE
                : MyTrackerGender.FEMALE));

        MyTracker.trackRegistrationEvent(
            (userProfileData?.id ?? -1).toString(),
            null, // vkConnectId or a proper value if available
            {}    // The third argument, typically a Map or an additional parameter
        );
        //MyTracker.trackRegistrationEvent(widget.userProfileData.id!.toString(),{});
        return MainPage(userProfileData!);
      case AppBodyScreen.registrationCreateProfile:
        return RegistrationCreateProfileScreen(userProfileData!);
    }
  }
}
