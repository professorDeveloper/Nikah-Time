import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Entering/entering_by_selected_type.dart';

import 'package:untitled/Screens/Entering/entering_select_recovery_type.dart';
import 'package:untitled/Screens/Registration/registration_create_profile.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/Screens/main_page.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/widgets/policy_agreement_block.dart';
import 'package:untitled/components/models/user_profile_data.dart';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';

class EnteringScreen extends StatefulWidget {
  EnteringScreen();

  @override
  State<EnteringScreen> createState() => _EnteringScreenState();
}

class _EnteringScreenState extends State<EnteringScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInputDecoration().titleText(LocaleKeys.entering_main_header.tr()),
                      const SizedBox(height: 8),

                      Container(
                          width: double.infinity,
                          child:
                          ElevatedButton(
                            
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 00, 0xcf, 0x91),
                                fixedSize: Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),

                              child: Text(
                                LocaleKeys.entering_checkType_number.tr(),
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed:(){
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => EnteringBySelectedTypeScreen(
                                      LocaleKeys.entering_recoveryBy_number_hint.tr(),
                                      r'^((\+7|7|8)+([0-9]){10})$',
                                      "+7"
                                    ),
                                    transitionDuration: const Duration(seconds: 0),
                                  ),
                                );
                              }
                          )
                      ),
                      const SizedBox(height: 16,),
                      Container(
                        width: double.infinity,
                        child:
                        MaterialButton(
                            height: 64,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(width: 1, color: Color.fromARGB(255, 218, 216, 215)),
                            ),
                            child: Text(
                              LocaleKeys.entering_checkType_email.tr(),
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 0, 207, 145),
                              ),
                            ),
                            onPressed:(){
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => EnteringBySelectedTypeScreen(
                                    LocaleKeys.entering_recoveryBy_email_hint.tr(),
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                    ""
                                  ),
                                  transitionDuration: const Duration(seconds: 0),
                                ),
                              );
                              setState(() {});
                            }
                        ),
                      ),
                      const SizedBox(height: 16,),

                      const _RegisterBy(),
                      const SizedBox(height: 44),
                      Row(children: <Widget>[
                        Expanded(
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10.0, right: 15.0),
                              child: const Divider(
                                  height: 1, color: Color.fromRGBO(0, 0, 0, 23))),
                        ),
                        Text(LocaleKeys.entering_main_divider.tr()),
                        Expanded(
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 15.0, right: 10.0),
                              child: const Divider(
                                  height: 1, color: Color.fromRGBO(0, 0, 0, 23))),
                        ),
                      ]),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(
                          //     height: 48,
                          //     width: 48,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(
                          //         color: const Color.fromARGB(255, 218, 216, 215),
                          //         width: 1,
                          //       ),
                          //       borderRadius:
                          //           const BorderRadius.all(Radius.circular(10)),
                          //     ),
                          //     child: IconButton(
                          //       icon: const FaIcon(FontAwesomeIcons.facebook),
                          //       color: Colors.green,
                          //       onPressed: () {
                          //         ;
                          //       },
                          //     )),
                          Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 218, 216, 215),
                                  width: 1,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: IconButton(
                                icon: const FaIcon(FontAwesomeIcons.google),
                                color: Color.fromRGBO(00, 0xcf, 0x91, 1),
                                onPressed: () async {
                                  _sendGoogleSignInLoginRequest();
                                },
                              )),
                          const SizedBox(
                            width: 16,
                          ),
                          Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 218, 216, 215),
                                  width: 1,
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: IconButton(
                                icon: const FaIcon(FontAwesomeIcons.apple),
                                color: Color.fromRGBO(00, 0xcf, 0x91, 1),
                                onPressed: () async {
                                  _sendAppleSignInLoginRequest();
                                },
                              )),
                          // Container(
                          //     height: 48,
                          //     width: 48,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(
                          //         color: const Color.fromARGB(255, 218, 216, 215),
                          //         width: 1,
                          //       ),
                          //       borderRadius:
                          //           const BorderRadius.all(Radius.circular(10)),
                          //     ),
                          //     child: IconButton(
                          //       icon: const FaIcon(FontAwesomeIcons.instagram),
                          //       color: Colors.green,
                          //       onPressed: () {
                          //         ;
                          //       },
                          //     )),
                          // Container(
                          //     height: 48,
                          //     width: 48,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(
                          //         color: Color.fromARGB(255, 218, 216, 215),
                          //         width: 1,
                          //       ),
                          //       borderRadius: BorderRadius.all(Radius.circular(10)),
                          //     ),
                          //     child: IconButton(
                          //       icon: const FaIcon(FontAwesomeIcons.vk),
                          //       color: Colors.green,
                          //       onPressed: () {
                          //         ;
                          //       },
                          //     )),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ]
                )
              )
            ),

            const SizedBox(height: 16),
            PolicyAgreement(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  _sendAppleSignInLoginRequest() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'ru.nikahtime.web',
          redirectUri: Uri.parse(
            'https://www.nikahtime.ru/api/auth/apple/callback',
          ),
        ),
      );
      final service = NetworkService();
      String? token = "";
      FirebaseMessaging messaging = await FirebaseMessaging.instance;
      token = (await messaging.getToken());
      final response = await service.sendLoginByAppleIdRequest(
          credential.identityToken!, token);

      if (response.statusCode != 200) {
        return;
      }

      UserProfileData userProfileData = UserProfileData();
      userProfileData.getDataFromJSON(jsonDecode(response.body));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", userProfileData.accessToken!);
      if (userProfileData.gender != null) {
        prefs.setString("userGender", userProfileData.gender!);
      }
      if (userProfileData.id != null) {
        prefs.setInt("userId", userProfileData.id!);
      }

      NextStep(userProfileData.isValid(), userProfileData);
    } catch (error) {
      if (error is SignInWithAppleAuthorizationException) {
        if (error.code == AuthorizationErrorCode.canceled) {
          return;
        }
      }
    }
  }

  _sendGoogleSignInLoginRequest() async {
    try {

      String? clientId = null;

      if (Platform.isIOS) {
        clientId = '1023685173404-go99snh3am30qgjgd8up1kld3mbr7ra8.apps.googleusercontent.com';
      }

      GoogleSignIn _googleSignIn = GoogleSignIn(
          scopes: [
            'email',
          ],
          clientId: clientId
      );

      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      GoogleSignInAccount? googleSignInAccount;

      try {
        googleSignInAccount = await _googleSignIn.signIn();
      } catch (error) {
        if (error is PlatformException) {
          if (error.code == 'sign_in_canceled') {
            return;
          }
        }
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
              title: const Text("Ошибка"), content: Text(error.toString())),
        );
      }

      if (googleSignInAccount == null) {
        return;
      }

      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      String? token = "";
      FirebaseMessaging messaging = await FirebaseMessaging.instance;
      token = (await messaging.getToken());
      final service = NetworkService();
      final response = await service.sendLoginByGoogleRequest(
          googleSignInAuthentication.idToken!, token);

      if (response.statusCode != 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Text(
                    '${response.statusCode}\n${jsonDecode(response.body)["detail"]}')));
        return;
      }

      UserProfileData userProfileData = UserProfileData();
      userProfileData.getDataFromJSON(jsonDecode(response.body));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", userProfileData.accessToken!);
      if (userProfileData.gender != null) {
        prefs.setString("userGender", userProfileData.gender!);
      }
      if (userProfileData.id != null) {
        prefs.setInt("userId", userProfileData.id!);
      }

      NextStep(userProfileData.isValid(), userProfileData);
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: const Text("Ошибка"), content: Text(error.toString())),
      );
    }
  }

  void NextStep(bool isValid, UserProfileData userProfileData) {
    if (isValid) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => MainPage(userProfileData),
        ),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              RegistrationCreateProfileScreen(userProfileData),
        ),
        (route) => false,
      );
    }
  }
}

class _RegisterBy extends StatelessWidget {
  const _RegisterBy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        children: [
          TextSpan(
            text: LocaleKeys.entering_main_hintRecPass.tr(),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: const Color.fromARGB(255, 00, 0xCF, 0x91),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        const EnteringSelectRecoveryPasswordTypeScreen(),
                    transitionDuration: const Duration(seconds: 0),
                  ),
                );
              },
          ),
        ],
      ),
    );
  }
}
