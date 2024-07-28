import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:untitled/Screens/Registration/registration_create_profile.dart';
import 'package:untitled/Screens/Registration/registration_email_1.dart';
import 'package:untitled/Screens/Registration/registration_phone_number_1.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/widgets/policy_agreement_block.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class RegistrationSelectTypeScreen extends StatefulWidget {
  const RegistrationSelectTypeScreen();

  @override
  State<RegistrationSelectTypeScreen> createState() =>
      _RegistrationSelectTypeScreenState();
}

class _RegistrationSelectTypeScreenState
    extends State<RegistrationSelectTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        //margin: EdgeInsets.only(top: 104),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(),
                SizedBox(
                  height: 16,
                ),
                Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 00, 0xcf, 0x91)  ,
                          elevation: 0,
                          fixedSize: Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: Text(
                          LocaleKeys.registration_type_phone_by.tr(),
                          textDirection: TextDirection.ltr,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                              const RegistrationPhoneNumberScreen(),
                              transitionDuration:
                              const Duration(seconds: 0),
                            ),
                          );
                        })),
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  child: MaterialButton(
                      height: 64,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 218, 216, 215)),
                      ),
                      child: Text(
                        LocaleKeys.registration_type_email_by.tr(),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromARGB(255, 0, 207, 145),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) =>
                            const RegistrationEmailScreen(),
                            transitionDuration:
                            const Duration(seconds: 0),
                          ),
                        );
                        setState(() {});
                      }),
                ),
                const SizedBox(height: 44),
                Row(children: <Widget>[
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 10.0, right: 15.0),
                        child: const Divider(
                            height: 1,
                            color: Color.fromRGBO(0, 0, 0, 23))),
                  ),
                  Text(LocaleKeys.registration_type_message.tr(),),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 15.0, right: 10.0),
                        child: const Divider(
                            height: 1,
                            color: Color.fromRGBO(0, 0, 0, 23))),
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
                    //       const BorderRadius.all(Radius.circular(10)),
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
                            color:
                            const Color.fromARGB(255, 218, 216, 215),
                            width: 1,
                          ),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.google),
                          color: Color.fromRGBO(00, 0xcf, 0x91, 1),
                          onPressed: () async {
                            _sendGoogleSignInRegistrationRequest();
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
                            color:
                            const Color.fromARGB(255, 218, 216, 215),
                            width: 1,
                          ),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.apple),
                          color: Color.fromRGBO(00, 0xcf, 0x91, 1),
                          onPressed: () async {
                            _sendAppleSignInRegistrationRequest();
                            return;
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
                    //       const BorderRadius.all(Radius.circular(10)),
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
                SizedBox(height: 16),
                PolicyAgreement()
              ]
          ),
        ),
      ),
    );
  }

  _sendAppleSignInRegistrationRequest() async {
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
      String? token = "";
      FirebaseMessaging messaging = await FirebaseMessaging.instance;
      token = (await messaging.getToken());

      final service = NetworkService();
      final response = await service
          .sendRegistrationRequestByAppleId(credential.identityToken!, token);

      if (response.statusCode != 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Text(
                    '${response.statusCode}\n${jsonDecode(response.body)["detail"]}')));
        return;
      }

      UserProfileData userProfileData = UserProfileData();
      userProfileData.accessToken = jsonDecode(response.body)["accessToken"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", userProfileData.accessToken!);
      if (userProfileData.gender != null) {
        prefs.setString("userGender", userProfileData.gender!);
      }
      if (userProfileData.id != null) {
        prefs.setInt("userId", userProfileData.id!);
      }

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              RegistrationCreateProfileScreen(userProfileData),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } catch (error) {
      if (error is SignInWithAppleAuthorizationException) {
        if (error.code == AuthorizationErrorCode.canceled) {
          return;
        }
      }
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(title: Text(error.toString())),
      );
    }
  }

  _sendGoogleSignInRegistrationRequest() async {
    try {
      String? clientId = null;

      if (Platform.isIOS) {
        clientId =
            '1023685173404-go99snh3am30qgjgd8up1kld3mbr7ra8.apps.googleusercontent.com';
      }

      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
        clientId: clientId,
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
      final response = await service
          .sendRegistrationRequestByGoogle(googleSignInAuthentication.idToken!, token);

      if (response.statusCode != 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Text(
                    '${response.statusCode}\n${jsonDecode(response.body)["detail"]}')));
        return;
      }

      UserProfileData userProfileData = UserProfileData();
      userProfileData.accessToken = jsonDecode(response.body)["accessToken"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", userProfileData.accessToken!);
      if (userProfileData.gender != null) {
        prefs.setString("userGender", userProfileData.gender!);
      }
      if (userProfileData.id != null) {
        prefs.setInt("userId", userProfileData.id!);
      }

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              RegistrationCreateProfileScreen(userProfileData),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } catch (error) {
      // if (error is GoogleSignIn.kSignInCanceledError) {
      //   if (error.code == AuthorizationErrorCode.canceled) {
      //     return;
      //   }
      // }
      showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(title: Text(error.toString())),
      );
    }
  }
}

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.registration_header.tr(),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.left,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: const Color.fromARGB(255, 33, 33, 33),
            ),
          )
        ]);
  }
}