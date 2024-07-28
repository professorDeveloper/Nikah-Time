import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:untitled/Screens/Registration/registration_create_profile.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/Screens/main_page.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/widgets/policy_agreement_block.dart';
import 'package:untitled/components/models/user_profile_data.dart';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';

class EnteringBySelectedTypeScreen extends StatefulWidget {
  EnteringBySelectedTypeScreen(this.hintText, this.regExp, this.startValue)
  {
    _emailTextController.text = startValue;
  }

  String hintText;
  String regExp;
  String startValue;

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  State<EnteringBySelectedTypeScreen> createState() => _EnteringBySelectedTypeScreenState();
}

class _EnteringBySelectedTypeScreenState extends State<EnteringBySelectedTypeScreen> {
  String email = "";
  String password = "";

  bool _passwordVisible = false;
  bool _isLoadingComplete = true;
  bool _isError = false;
  String errorMessage = "";

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
                    _emailAddressField(),
                    CustomInputDecoration().errorBox(_isError, errMessage: errorMessage),
                    const SizedBox(height: 16),
                    _passwordField(),
                    const SizedBox(height: 16),

                  ]
                )
              )
            ),
            _registerButton(),
            const SizedBox(height: 16),
            PolicyAgreement(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  _sendLoginRequest() async {
    String token =
        "";

    FirebaseMessaging messaging = await FirebaseMessaging.instance;
    token = (await messaging.getToken())!;
    var response;

    bool validData = RegExp(
        widget.regExp)
        .hasMatch(widget._emailTextController.text);

    if (validData != true) {
      _isLoadingComplete = true;
      _isError = true;
      errorMessage = LocaleKeys.entering_error_dataType;
      setState(() {});
      return;
    }

    if (widget._emailTextController.text.contains("@")) {
      response = await NetworkService().SendLoginByEmailRequest(
          widget._emailTextController.text, widget._passwordTextController.text, token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("emailForReceipt", widget._emailTextController.text);
    } else {
      response = await NetworkService().SendLoginByNumberRequest(
          widget._emailTextController.text
              .replaceAll("+", "")
              .replaceAll(" ", "")
              .replaceAll("(", "")
              .replaceAll(")", "")
              .replaceAll("-", ""),
          widget._passwordTextController.text,
          token);
    }

    setState(() {
      _isLoadingComplete = true;
    });

    if (response.statusCode != 200) {
      debugPrint(response.body);
      widget._passwordTextController.text = "";
      _isError = true;
      if(response.statusCode == 422){
        errorMessage = LocaleKeys.entering_error_nouser.tr();
      }else{
        errorMessage = LocaleKeys.entering_recoveryBy_error.tr();
      }
      return;
    }

    UserProfileData userProfileData = UserProfileData();
    userProfileData.getDataFromJSON(jsonDecode(response.body));



    NextStep(userProfileData.isValid(), userProfileData);
  }

  Widget _emailAddressField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _isError = false;
        });
      },
      enabled: _isLoadingComplete,
      controller: widget._emailTextController,
      decoration: CustomInputDecoration(
          hintText: widget.hintText
      ).GetDecoration(),
    );
  }

  Widget _passwordField() {

    return TextField(
      enabled: _isLoadingComplete,
      obscureText: !_passwordVisible,
      controller: widget._passwordTextController,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: const Icon(Icons.remove_red_eye)),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 218, 216, 215),
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: LocaleKeys.entering_main_hintPass.tr(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 207, 145),
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
        width: double.infinity,
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          height: 56,
          color: Color.fromARGB(255, 00, 0xCF, 0x91),
          disabledColor: Color.fromARGB(255, 00, 0xCF, 0x91),
          child: _enterButtonAction(),
          onPressed: _isLoadingComplete
              ? () {
                setState(() {
                  _isLoadingComplete = false;
                });
                _sendLoginRequest();}
              : null,
        ));
  }

  Widget _enterButtonAction() {
    if (_isLoadingComplete == true) {
      return Text(
        LocaleKeys.entering_main_enter.tr(),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        style: GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      );
    } else {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  void NextStep(bool isValid, UserProfileData userProfileData) async {
    if (isValid) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", userProfileData.accessToken!);
      prefs.setString("userGender", userProfileData.gender!);
      prefs.setInt("userId", userProfileData.id!);

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

