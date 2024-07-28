import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:untitled/Screens/Registration/registration_create_profile.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/widgets/policy_agreement_block.dart';
import 'package:untitled/components/models/user_profile_data.dart';

import 'package:untitled/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' as localize;

import 'package:http/http.dart' as http;

import '../../components/widgets/custom_appbar.dart';

class RegistrationPinScreen extends StatefulWidget {
  String _messageStr = "";
  String _validatorType = "";
  String registerType = "";

  RegistrationPinScreen(
      this._messageStr,
      this._validatorType,
      this.registerType,
      {Key? key}
  ) : super(key: key);

  @override
  State<RegistrationPinScreen> createState() => _RegistrationPinScreenState();
}

class _RegistrationPinScreenState extends State<RegistrationPinScreen> {
  bool _isLoadingComplete = true;
  bool err = false;
  String msg = "";

  final TextEditingController _pinCodeTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        //margin: EdgeInsets.only(top: 104),
        child: Column(
          children: <Widget>[
            //SizedBox(height: 16),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                  CustomInputDecoration().titleText(LocaleKeys.registration_PIN_header.tr()),
                  SizedBox(height: 8),
                  _SubHeader(widget._messageStr, widget._validatorType),
                  SizedBox(height: 32),
                  _PIN_Entering(pinCodeTextController: _pinCodeTextController,),
                  CustomInputDecoration().errorBox(err, errMessage: msg),
                  SizedBox(height: 16),
                  _sendCodeAgain(widget._validatorType),
                  SizedBox(height: 44),
                ]))),
            _registerButton(),
            SizedBox(height: 16),
            PolicyAgreement()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                    if (_isLoadingComplete) {
                      setState(() {
                        _isLoadingComplete = false;
                      });

                      _sendRequestPostBodyHeaders();
                    }
                  });
                }
              : null,
        ));
  }

  Widget _enterButtonAction() {
    if (_isLoadingComplete == true) {
      return Text(
        LocaleKeys.registration_PIN_action.tr(),
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

  _sendRequestPostBodyHeaders() async {
    String? token = "";
    FirebaseMessaging messaging = await FirebaseMessaging.instance;
    token = (await messaging.getToken());
    err = false;
    var response = await http.post(
        Uri.parse(
            NetworkService().baseUrl + NetworkService().registration_verify),
        body: (widget.registerType == "email")
            ? {
                "grantType": "email",
                "email": widget._validatorType,
                "code": _pinCodeTextController.text,
                "notificationId": token
              }
            : {
                "grantType": "phoneNumber",
                "phoneNumber": widget._validatorType
                    .replaceAll("+", "")
                    .replaceAll(" ", "")
                    .replaceAll("-", ""),
                "code": _pinCodeTextController.text,
                "notificationId": token
              },
        headers: {'Accept': 'application/json'});

    setState(() {
      _isLoadingComplete = true;
    });

    _pinCodeTextController.text = "";
    if (response.statusCode != 200) {
      err = true;
      msg = LocaleKeys.registration_error_badPIN.tr();
      return;
    }

    UserProfileData userProfileData = UserProfileData();
    userProfileData.accessToken = jsonDecode(response.body)["accessToken"];

    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     pageBuilder: (_, __, ___) =>
    //         RegistrationCreateProfileScreen(userProfileData),
    //     transitionDuration: const Duration(seconds: 0),
    //   ),
    // );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => RegistrationCreateProfileScreen(userProfileData),
      ),
          (route) => false,
    );
  }
}

class _SubHeader extends StatelessWidget {
  _SubHeader(this._messageStr, this._validator, {Key? key}) : super(key: key);

  String _messageStr = "";
  String _validator = "";

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        //text: 'Код отправлен на $_messageStr:\n $_validator',
        text: LocaleKeys.registration_PIN_message.tr(args: [_messageStr, _validator]),
        style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color.fromARGB(255, 117, 116, 115),
            height: 1.4),
      ),
    );
  }
}

class _PIN_Entering extends StatelessWidget {
  _PIN_Entering({
    Key? key,
    required this.pinCodeTextController
  }) : super(key: key);

  FocusNode focusNode = FocusNode();
  final TextEditingController pinCodeTextController;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PinCodeTextField(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                //color: const Color.fromARGB(255,33,33,33),
              ),
              controller: pinCodeTextController,
              length: 6,
              obscureText: false,
              animationType: AnimationType.none,
              pinTheme: PinTheme(
                  //disabledColor: Color.fromARGB(255, 255, 255, 255),
                  inactiveColor: Color.fromARGB(255, 0xc4, 0xc3, 0xc1),
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  borderWidth: 1,
                  fieldHeight: 48,
                  fieldWidth: 48,
                  selectedColor: Color.fromARGB(255, 00, 0xcf, 0x91),
                  activeColor: Color.fromARGB(255, 00, 0xcf, 0x91)
                  // activeFillColor: Color.fromARGB(255,0xc4,0xc3,0xc1)
                  ),
              animationDuration: Duration(milliseconds: 0),
              backgroundColor: Colors.transparent,
              enableActiveFill: false,
              enablePinAutofill: true,
              onCompleted: (v) {
                print(v);
              },
              onChanged: (value) {
                print(value);
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              ],
              appContext: context,
            )
          ],
        ),
      ),
    );
  }
}

class _sendCodeAgain extends StatefulWidget {
  _sendCodeAgain(this._codeConfirmedAddress, {Key? key}) : super(key: key);
  String _codeConfirmedAddress;

  @override
  State<_sendCodeAgain> createState() => _sendCodeAgainState();
}

late Timer _timer;
int _start = 60;

class _sendCodeAgainState extends State<_sendCodeAgain> {
  @override
  Widget build(BuildContext context) {
    if (_start == 60) startTimer();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.registration_PIN_sendAgain.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color.fromARGB(255, 00, 0xCF, 0x91),
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (_start == 0) {
                      _start = 60;
                      startTimer();
                      _sendRequestPostBodyHeaders();
                    }
                  },
              ),
            ],
          ),
        ),
        Text(
          "$_start",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color.fromARGB(255, 00, 0xCF, 0x91),
          ),
        ),
      ],
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  _sendRequestPostBodyHeaders() async {
    debugPrint("SEND PIN AGAIN");
    debugPrint("sended email address: ${widget._codeConfirmedAddress}");
    // debugPrint("sended pin code: ${_pinCodeTextController.text}");

    var response = await http.post(
        Uri.parse(
            NetworkService().baseUrl + NetworkService().registration_second),
        body: {
          "grantType": "email",
          "email": widget._codeConfirmedAddress,
        },
        headers: {
          'Accept': 'application/json'
        });

    debugPrint("${response.statusCode}");
    debugPrint("${response.body}");

    if (response.statusCode == 202) {
      debugPrint("SUCCESS");
    } else {
      debugPrint("FAILED");
      return;
    }
  }
}
