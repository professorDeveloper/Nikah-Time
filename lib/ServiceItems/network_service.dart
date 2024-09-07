import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Employeers/employee_information.dart';
import 'package:untitled/components/models/nikah_error.dart';
import 'package:untitled/components/models/paginated_news_list.dart';
import 'package:untitled/components/models/paginated_user_list.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';
import 'package:untitled/main.dart';

import '../components/models/get_chat_response.dart';
import '../components/models/paginated_chat_list.dart';

class NetworkService {
  final Dio _dio = Dio();

  NetworkService() {
    _dio.interceptors.addAll([
      LogInterceptor(),
      InterceptorsWrapper(
        onResponse: (response, handler) {
          // Do something with response data
          if (response.statusCode == 406) {
            navigatorKey.currentState?.pushReplacementNamed('/entering');
          }
          return handler.next(response); // continue
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: `handler.reject(dioError)`
        },
      )
    ]);

    _dio.options.headers["accept"] = "application/json";
  }

  final String baseUrl = "https://dev.nikahtime.ru/api"; // story didn`t use socket  i think i will work with dev api
//LOGIN
  final String login = "/login";
//REGISTRATION
  final String registration = "/registration";
  final String registration_second = "/registration/code";
  final String registration_verify = "/registration/code/verify";
//ACCOUNT
  final String account_pin_code_request = "/account/password/code";
  final String account_pin_code_verify = "/account/password/code/verify";
  final String account_password_reset = "/account/password/reset";
  final String account_user_info_update = "/account/user/update";
  final String accout_user_get_info = "/account/user";
  final String account_user_store_image = "/store/file";
  final String account_user_logout = "/account/logout/";

  //-------V1-------
  Future<PaginatedUserList> searchUsers(
      {required String accessToken,
      required UserFilter filter,
      required int page,
      List<int> exceptIds = const [],
      bool isExpandedFilter = false}) async {
    Map<String, dynamic> request;
    if (isExpandedFilter) {
      request = {
        "filterType": "complicatedFilter",
        "minAge": filter.minAge,
        "maxAge": filter.maxAge,
        "nationality": (filter.nationality != "") ? filter.nationality : null,
        "country": (filter.country != "") ? filter.country : null,
        "city": (filter.city != "") ? filter.city : null,
        "education": (filter.education != "") ? filter.education : null,
        "maritalStatus":
            (filter.maritalStatus != "") ? filter.maritalStatus : null,
        "haveChildren": filter.haveChildren,
        "haveBadHabits": filter.haveBadHabbits ?? false,
        "badHabits": filter.badHabits,
        "isOnline": (filter.isOnline != null) ? filter.isOnline : false,
        "type": filter.typeReligion,
        "observeCanons": filter.observeIslamCanons,
        "exceptIds": exceptIds
      };
    } else {
      request = {
        "filterType": "simpleFilter",
        "minAge": filter.minAge,
        "maxAge": filter.maxAge,
        "isOnline": (filter.isOnline != null) ? filter.isOnline : false,
        "exceptIds": exceptIds
      };
    }
    debugPrint(request.toString());

    var response = await _dio.put("$baseUrl/search/v1/users",
        data: request,
        queryParameters: {
          "page": page,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return PaginatedUserList.fromJson(response.data);
  }

  Future<PaginatedUserList> searchUsersByName({
    required String accessToken,
    required String name,
    required int page,
  }) async {
    var response = await _dio.get("$baseUrl/search/users/$name",
        queryParameters: {
          "page": page,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return PaginatedUserList.fromJson(response.data);
  }

  Future<PaginatedUserList> getFavoriteUsers(
      {required String accessToken, required int page}) async {
    var response = await _dio.get("$baseUrl/favourites/v1/get",
        queryParameters: {
          "page": page,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return PaginatedUserList.fromJson(response.data);
  }

  Future<PaginatedUserList> getUsersWhoFavoriteMe(
      {required String accessToken, required int page}) async {
    var response = await _dio.get("$baseUrl/favourites/v1/get/likes",
        queryParameters: {
          "page": page,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return PaginatedUserList.fromJson(response.data);
  }

  Future<PaginatedUserList> getGuests(
      {required String accessToken, required int page}) async {
    var response = await _dio.get("$baseUrl/guests/v1/get",
        queryParameters: {
          // "page" : page,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return PaginatedUserList.fromJson(response.data);
  }

  Future<PaginatedChatList> getChats(
      {required String accessToken, required int page}) async {
    var response = await _dio.get("$baseUrl/chats/v1/user",
        queryParameters: {
          "page": page,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return PaginatedChatList.fromJson(response.data);
  }

  Future<GetChatResponse> getChat(
      {required String accessToken,
      required int chatId,
      required int page}) async {
    var response = await _dio.get("$baseUrl/chats/v1/get/$chatId",
        queryParameters: {
          "page": page,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return GetChatResponse.fromJson(response.data);
  }

  //-------V0-------
  Future<void> deleteAccount({required String accessToken}) async {
    await _dio.delete("$baseUrl/account/delete",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));
  }

  SendLoginByEmailRequest(
      String email, String password, String firebaseToken) async {
    //debugPrint("Notif ID firebaseToken");
    var response = await http.post(Uri.parse(baseUrl + login), body: {
      "grantType": "email",
      "email": email,
      "password": password,
      "notificationId": firebaseToken.toString()
    }, headers: {
      'Accept': 'application/json'
    });
    return response;
  }

  SendLoginByNumberRequest(
      String number, String password, String firebaseToken) async {
    debugPrint(firebaseToken);
    var response = await http.post(Uri.parse(baseUrl + login), body: {
      "grantType": "phoneNumber",
      "phoneNumber": number,
      "password": password,
      "notificationId": firebaseToken
    }, headers: {
      'Accept': 'application/json'
    });
    return response;
  }

  sendLoginByAppleIdRequest(String idToken, String? firebaseToken) async {
    var response = await http.post(Uri.parse(baseUrl + login), body: {
      "grantType": "appleIdToken",
      "idToken": idToken,
      "notificationId": firebaseToken
    }, headers: {
      'Accept': 'application/json'
    });
    return response;
  }

  sendLoginByGoogleRequest(String idToken, String? firebaseToken) async {
    var response = await http.post(Uri.parse(baseUrl + login), body: {
      "grantType": "googleIdToken",
      "idToken": idToken,
      "notificationId": firebaseToken
    }, headers: {
      'Accept': 'application/json'
    });
    return response;
  }

  SendRegistrationRequest(String email, String password) async {
    var response = await http.post(Uri.parse(baseUrl + registration),
        body: {"grantType": "email", "email": email, "password": password},
        headers: {'Accept': 'application/json'});
    return response;
  }

  sendRegistrationRequestByAppleId(
      String idToken, String? notificationId) async {
    var response = await http.post(Uri.parse(baseUrl + registration), body: {
      "grantType": "appleIdToken",
      "idToken": idToken,
      "notificationId": notificationId,
    }, headers: {
      'Accept': 'application/json'
    });
    return response;
  }

  sendRegistrationRequestByGoogle(
      String idToken, String? notificationId) async {
    var response = await http.post(Uri.parse(baseUrl + registration), body: {
      "grantType": "googleIdToken",
      "idToken": idToken,
      "notificationId": notificationId,
    }, headers: {
      'Accept': 'application/json'
    });
    return response;
  }

  SendRegistrationRequestAgain(String email, String type) async {
    var response =
        await http.post(Uri.parse(baseUrl + registration_second), body: {
      "grantType": type,
      "email": email,
    }, headers: {
      'Accept': 'application/json'
    });
    return response;
  }

  SendRegistrationVerifyRequest(String email, String code) async {
    var response = await http.post(Uri.parse(baseUrl + registration_verify),
        body: {"grantType": "email", "email": email, "code": code},
        headers: {'Accept': 'application/json'});
    return response;
  }

  SendLogoutGet(String accessToken) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String token = (await messaging.getToken())!;
    var response = await http.get(
      Uri.parse(baseUrl + account_user_logout + token),
      headers: {'authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  GetUserInfoByID(String accessToken, int userID) async {
    ///TODO: swap to DIO
    //debugPrint("LoadUserByID");
    var response = await http.get(
      Uri.parse("$baseUrl/account/user/$userID"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    //debugPrint("${response.statusCode}");
    //debugPrint("${response.body}");
    return response;
  }

  GetUserInfo(String accessToken) async {
    ///TODO: swap to DIO
    var response = await http.get(
      Uri.parse(baseUrl + accout_user_get_info),
      headers: {'authorization': 'Bearer $accessToken'},
    );
    return response;
  }

  UpdateuserInfo(String accessToken, Object? body) async {
    print(body);

    ///TODO: swap to DIO
    var response = await http.put(
      Uri.parse("https://www.nikahtime.ru/api/account/user/update"),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
        'authorization': 'Bearer $accessToken'
      },
      body: body,
    );

    return response;
  }

  UploadFileRequest(
      String accessToken, String imagePath, String fileType) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $accessToken",
      "Content-Type": "multipart/form-data"
    };
    var request = http.MultipartRequest(
        "POST", Uri.parse("${NetworkService().baseUrl}/store/file"));
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));
    request.fields['file'] = imagePath;
    request.fields['fileType'] = fileType;
    request.headers.addAll(headers);
    print(request.fields);
    var response = await request.send();
    return response;
  }

  Future<void> blockUser({required int userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await _dio.put("$baseUrl/block/user/$userId",
        options: Options(
          headers: {
            'authorization': 'Bearer ${prefs.getString("token") ?? ""}',
          },
        ));
  }

  Future<void> unblockUser({required int userId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await _dio.delete("$baseUrl/block/user/delete/$userId",
        options: Options(
          headers: {
            'authorization': 'Bearer ${prefs.getString("token") ?? ""}',
          },
        ));
  }

//SEARCH
/*  SearchGetSelectionUsers(
    String accessToken,
  ) async {
    // получение кандидатур, которые подобрал сервер в соответствии с интересами пользователя
    var response = await http.get(
      Uri.parse("${baseUrl}/search/get/selection/users"),
      headers: {
        'authorization': 'Bearer ${accessToken}',
      },
    );
    return response;
  }*/

/*  SearchSaveSeenUsers(String accessToken, List<dynamic> seenUsersId) async {
    var response = await http.post(
        Uri.parse('https://www.nikahtime.ru/api/search/save/seen/users'),
        body: seenUsersId.toString(),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        });

    return response;
  }*/

/*  SearchUsers(String accessToken, UserProfileData item,
      {bool expandedFilter = false}) async {
    // Поиск пользователей по фильтрам из подбора кандидатур по интересам
    Object? bodyValue = (expandedFilter)
        ? json.encode({
            "filterType": "complicatedFilter",
            "minAge": item.filter.minAge,
            "maxAge": item.filter.maxAge,
            "nationality": (item.filter.nationality != "")
                ? item.filter.nationality
                : null,
            "country": (item.filter.country != "") ? item.filter.country : null,
            "city": (item.filter.city != "") ? item.filter.city : null,
            "education":
                (item.filter.education != "") ? item.filter.education : null,
            "maritalStatus": (item.filter.maritalStatus != "")
                ? item.filter.maritalStatus
                : null,
            "haveChildren": item.filter.haveChildren,
            "haveBadHabits": item.filter.haveBadHabbits ?? false,
            "badHabits": item.filter.badHabits,
            "isOnline":
                (item.filter.isOnline != null) ? item.filter.isOnline : false,
            "type": item.filter.typeReligion,
            "observeCanons": item.filter.observeIslamCanons,
          })
        : json.encode({
            "filterType": "simpleFilter",
            "minAge": item.filter.minAge,
            "maxAge": item.filter.maxAge,
            "isOnline":
                (item.filter.isOnline != null) ? item.filter.isOnline : false
          });
    debugPrint(bodyValue.toString());

    var response = await http.post(
        Uri.parse('https://www.nikahtime.ru/api/search/users'),
        body: bodyValue,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        });
    //debugPrint("ФИЛЬТР: ${response.statusCode}");
    //debugPrint("ФИЛЬТР: ${response.body}");
    return response;
  }*/

//GUESTS

  GuestAddUserID(String accessToken, int userID) async {
    ///TODO: swap to DIO
    //debugPrint("GuestAddUserID");
    var response = await http.put(
      Uri.parse("$baseUrl/guests/add/$userID"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    //debugPrint("${response.statusCode}");
    //debugPrint("${response.body}");
    return response;
  }

/*  GuestGet(
    String accessToken,
  ) async {
    var response = await http.get(
      Uri.parse("${baseUrl}/guests/get"),
      headers: {
        'authorization': 'Bearer ${accessToken}',
      },
    );
    return response;
  }*/

//FAVORITES

/*  FavoritesGet(String accessToken) async {
    var response = await http.get(
      Uri.parse("${baseUrl}/favourites/get"),
      headers: {
        'authorization': 'Bearer ${accessToken}',
      },
    );
    return response;
  }

  FavoritesGetLikes(String accessToken) async {
    var response = await http.get(
      Uri.parse("${baseUrl}/favourites/get/likes"),
      headers: {
        'authorization': 'Bearer ${accessToken}',
      },
    );
    return response;
  }*/

  FavoritesAddUserID(String accessToken, int userID) async {
    ///TODO: swap to DIO
    var response = await http.put(
      Uri.parse("$baseUrl/favourites/add/$userID"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    //debugPrint("${response.statusCode}");
    //debugPrint("${response.body}");

    return response;
  }

  FavoritesDeleteUserID(String accessToken, int userID) async {
    ///TODO: swap to DIO
    var response = await http.delete(
      Uri.parse("$baseUrl/favourites/delete/$userID"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    //debugPrint("${response.statusCode}");
    //debugPrint("${response.body}");
    return response;
  }

//CHATS

  ChatsUser(String accessToken) async {
    ///TODO: swap to DIO
    var response = await http.get(
      Uri.parse("$baseUrl/chats/user"),
      headers: {
        'authorization': 'Bearer $accessToken',
        'accept': 'application/json'
      },
    );
    if (response.statusCode != 200) {
      //debugPrint("ChatsUser ${response.body}");
    }
    return response;
  }

  ChatsAddUserID(String accessToken, int userID) async {
    ///TODO: swap to DIO
    var response = await http.post(Uri.parse('$baseUrl/chats/add/$userID'),
        body: json.encode({"userId": userID}),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        });
    if (response.statusCode != 200) {
      //debugPrint("ChatsAddUserID ${response.body}");
    }
    return response;
  }

  ChatsGetChatID(String accessToken, int chatID) async {
    ///TODO: swap to DIO
    var response = await http.get(
      Uri.parse("$baseUrl/chats/get/$chatID"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode != 200) {
      //debugPrint("ChatsGetChatID ${response.body}");
    }
    return response;
  }

  ChatsBlockChatID(String accessToken, int chatID) async {
    ///TODO: swap to DIO
    var response = await http.put(
      Uri.parse("$baseUrl/chats/block/$chatID"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode != 200) {
      //debugPrint("ChatsBlockChatID ${response.body}");
    }
    return response;
  }

  ChatsSendMessage(String accessToken, String message, int chatID,
      String messageType) async {
    ///TODO: swap to DIO
    var response = await http.post(Uri.parse('$baseUrl/chats/send/message'),
        body: json.encode(
            {"message": message, "chatId": chatID, "messageType": messageType}),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        });
    if (response.statusCode != 200) {
      //debugPrint("ChatsSendMessage ${response.body}");
    }
    return response;
  }

  Future<void> chatsDeleteChatID({required int chatID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await _dio.delete("$baseUrl/chats/delete/$chatID",
        options: Options(
          headers: {
            'authorization': 'Bearer ${prefs.getString("token") ?? ""}',
          },
        ));
  }

  ChatsGetMessageByID(String accessToken, int messageID) async {
    ///TODO: swap to DIO
    var response = await http.get(
      Uri.parse("$baseUrl/chats/get/message/$messageID"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode != 200) {
      //debugPrint("ChatsGetMessageByID ${response.body}");
    }
    return response;
  }

  ChatsSeenMessageID(String accessToken, int messageID) async {
    ///TODO: swap to DIO
    var response = await http.put(
      Uri.parse("$baseUrl/chats/seen/message/$messageID"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode != 200) {
      //debugPrint("ChatsSeenMessageID ${response.body}");
    }
    return response;
  }

//RESTOREPASSWORD

  RestoreAccountPasswordCode(String grantType, String value) async {
    var response =
        await http.post(Uri.parse(baseUrl + account_pin_code_request), body: {
      "grantType": grantType,
      grantType: value,
    }, headers: {
      'Accept': 'application/json'
    });

    return response;
  }

  RestoreAccountPasswordCodeVerify(
      String grantType, String value, String code) async {
    var response = await http.post(Uri.parse(baseUrl + account_pin_code_verify),
        body: {"grantType": grantType, grantType: value, "code": code},
        headers: {'Accept': 'application/json'});
    return response;
  }

  RestoreAccountPasswordCodeReset(
      String grantType, String value, String code, String password) async {
    var response = await http.post(Uri.parse(baseUrl + account_password_reset),
        body: {
          "grantType": grantType,
          grantType: value,
          "password": password,
          "code": code
        },
        headers: {
          'Accept': 'application/json'
        });
    return response;
  }

  Future<List<Map<String, dynamic>>> DadataRequest(String str) async {
    debugPrint(str);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Token aed78f6529ea020c8af3cea5014cdfadc585fa37',
    };

    var data = '{ "query": "$str" }';

    var res = await http.post(
        Uri.parse(
            'https://suggestions.dadata.ru/suggestions/api/4_1/rs/suggest/address'),
        headers: headers,
        body: data);
    if (res.statusCode != 200) {
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    }
    List<dynamic> result = jsonDecode(res.body)["suggestions"];
    List<Map<String, dynamic>> retVal = [];
    for (int i = 0; i < result.length; i++) {
      //Map<String, dynamic> item = result[i]["data"];
      try {
        String name = result[i]["data"]['city_with_type'] ??
            result[i]["data"]['settlement_with_type'];
        String region = result[i]["data"]["region_with_type"];
        Map<String, dynamic> item = {"name": name, "region": region};
        print(item);
        //retVal.add("${item["city_with_type"]}, ${item["region_with_type"]}");
        if (retVal.contains(item) == true) {
          print("ident");
          continue;
        }

        retVal.add(item);
      } catch (err) {
        continue;
      }
    }
    return retVal;
  }

  SendComplain(

      ///TODO: swap to DIO
      String accessToken,
      int userId,
      String title,
      String message) async {
    var response = await http.post(Uri.parse('$baseUrl/complain'),
        body:
            json.encode({"title": title, "userId": userId, "message": message}),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        });
    if (response.statusCode != 200) {
      debugPrint("ChatsSendMessage ${response.body}");
    }
    return response;
  }

  SendComplainComment(

      ///TODO: swap to DIO
      String accessToken,
      int commentId,
      String title,
      String message) async {
    var response = await http.post(Uri.parse('$baseUrl/complain/comment'),
        body: json.encode(
            {"commentId": commentId, "title": title, "message": message}),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        });
    if (response.statusCode != 200) {
      debugPrint("ChatsSendMessage ${response.body}");
    }
    return response;
  }

  SendDonate(int sum, String language) async {
    ///TODO: swap to DIO
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";

    var response = await http.post(Uri.parse('$baseUrl/payment'),
        body: json.encode({
          "sum": sum,
          "language": language,
        }),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        });
    if (response.statusCode != 200) {
      debugPrint("Donate Error ${response.body}");
    }
    return response;
  }

  Future<String> buyTariffByCard({
    required int tariffId,
    required String language,
    required String emailForReceipt,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token") ?? "";

    try {
      var response = await _dio.post("$baseUrl/payment",
          data: {
            "tariffId": tariffId,
            "language": language,
            "email": emailForReceipt,
          },
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          ));

      return response.data["redirectUrl"];
    } on DioError catch (e) {
      if (e.response != null) {
        try {
          throw NikahError.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      } else {
        rethrow;
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<void> verifyPaymentByApplePay({required String receiptData}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token") ?? "";

    await _dio.post("$baseUrl/payment/validate/apple/transaction",
        data: {
          "receiptData": receiptData,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));
  }

  GetTariffs({required String accessToken}) async {
    ///TODO: swap to DIO
    var response = await http.get(
      Uri.parse("$baseUrl/tariffs"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    return response;
  }

  GetStaffInfo(
      {required String accessToken, required EmployerType type}) async {
    ///TODO: swap to DIO
    if (kDebugMode) {
      print(type.toString());
    }
    var response = await http.get(
      Uri.parse("$baseUrl/staff/${type.name}"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    return response;
  }

  GetStaffInfo_v1({
    required String accessToken,
  }) async {
    var response = await http.get(
      Uri.parse("$baseUrl/staff/v1"),
      headers: {
        'authorization': 'Bearer $accessToken',
        "Content-Language": LocaleKeys.app_locale.tr()
      },
    );
    return response;
  }

  GetStaffProfileInfo({required String accessToken, required int id}) async {
    ///TODO: swap to DIO
    var response = await http.get(
      Uri.parse("$baseUrl/staff/profile/$id"),
      headers: {
        'authorization': 'Bearer $accessToken',
      },
    );
    return response;
  }

  Future<PaginatedNewsList> getNews(
      {required String accessToken,
      required String searchString,
      required int page}) async {
    var response = await _dio.get("$baseUrl/news",
        queryParameters: {"page": page, "searchString": searchString},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return PaginatedNewsList.fromJson(response.data);
  }

  Future<NewsItem> getNewsItem(
      {required String accessToken, required int id}) async {
    var response = await _dio.get("$baseUrl/news/get/$id",
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return NewsItem.fromJson(response.data);
  }

  Future<bool> newsToggleLike(
      {required String accessToken, required int id}) async {
    try {
      var response = await _dio.put("$baseUrl/news/toggle-like/$id",
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          ));
      if (response.statusCode != 200) return false;
    } catch (err) {
      return false;
    }

    return true;
  }

  Future<bool> newsMakeSeen(
      {required String accessToken, required int id}) async {
    try {
      var response = await _dio.put("$baseUrl/news/make/seen/$id",
          options: Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          ));
      if (response.statusCode != 200) return false;
    } catch (err) {
      return false;
    }

    return true;
  }

  Future<PaginatedCommentariesList> getComments(
      {required String accessToken, required int id, required int page}) async {
    var response = await _dio.get("$baseUrl/news/comments/$id",
        queryParameters: {
          "page": page,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return PaginatedCommentariesList.fromJson(response.data);
  }

  Future<List<CommentaryItem>> getCommentAnswers(
      {required String accessToken, required int id, required int page}) async {
    var response = await _dio.get("$baseUrl/news/comments/answers/$id",
        queryParameters: {
          "page": page,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return (response.data["data"] as List)
        .map((x) => CommentaryItem.fromJson(x))
        .toList();
  }

  Future<CommentaryItem> addCommentaryToNews(
      {required String accessToken,
      required int newsId,
      int? commentId,
      required String text}) async {
    var response = await _dio.post("$baseUrl/news/comments/add",
        data: (commentId == null)
            ? {
                "newsId": newsId,
                "text": text,
              }
            : {"newsId": newsId, "text": text, "commentId": commentId},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ));

    return CommentaryItem.fromJson(response.data);
  }
}
