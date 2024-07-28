import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/Screens/Registration/registration_pin.dart';

import 'package:http/http.dart' as http;
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/widgets/policy_agreement_block.dart';
import 'package:untitled/generated/locale_keys.g.dart';

bool _isLoadingComplete = true;
TextEditingController _emailTextController = TextEditingController();
TextEditingController _firstPasswordTextController = TextEditingController();
TextEditingController _secondPasswordTextController = TextEditingController();

class RegistrationEmailScreen extends StatefulWidget {
  const RegistrationEmailScreen();

  @override
  State<RegistrationEmailScreen> createState() => _RegistrationEmailScreenState();
}

class _RegistrationEmailScreenState extends State<RegistrationEmailScreen> {
  bool emailError = false;
  bool passwordError = false;
  bool ageError = false;
  String errorMessage = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body:  Container (
        margin: const EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        //margin: EdgeInsets.only(top: 104),
        child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.registration_type_email_header.tr(),//'Мой Email',
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: Color.fromARGB(255,33,33,33),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LocaleKeys.registration_type_email_text.tr(),//'Пожалуйста, введите ваш действующий Email адрес. Мы отправим вам 6-значный код для подтверждения вашей учетной записи.',
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromARGB(255, 117, 116, 115),
                        height: 1.4
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    enabled: _isLoadingComplete,
                    controller: _emailTextController,
                    decoration: customInputDecoration(false, LocaleKeys.registration_type_email_hintMail.tr()),
                    onChanged: (value){
                      setState(() {
                        emailError = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: emailError,
                      child: Text(
                        errorMessage,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      )
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    enabled: _isLoadingComplete,
                    controller: _firstPasswordTextController,
                    obscureText: !_passwordVisible,
                    decoration: customInputDecoration(true, LocaleKeys.registration_type_email_hintPass.tr()),
                    onChanged: (value){
                      setState(() {
                        passwordError = false;
                      });
                    },
                  ),
                  Visibility(
                      visible: passwordError,
                      child: Text(
                        errorMessage,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      )
                  ),
                  const SizedBox(height: 16),
                  TextField(
                      onChanged: (value){
                        setState(() {
                          passwordError = false;
                        });
                      },
                      controller: _secondPasswordTextController,
                      enabled: _isLoadingComplete,
                      obscureText: !_passwordVisible,
                      decoration: customInputDecoration(true, LocaleKeys.registration_type_email_hintSecPass.tr())
                  ),
                  Visibility(
                      visible: passwordError,
                      child: Text(
                        errorMessage,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.red,
                        ),
                      )
                  ),
                  const SizedBox(height: 16),
                  _registerButton(),
                  SizedBox(height: 16),
                  PolicyAgreement()
                ]
            )
        )
      ),
    );
  }

  Widget _registerButton(){
    return SizedBox(
        width: double.infinity,
        child:
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          height: 56,
          color: Color.fromARGB(255,00,0xCF,0x91),
          disabledColor: Color.fromARGB(255,00,0xCF,0x91),

          child: _enterButtonAction(),
          onPressed: _isLoadingComplete ? () {
            if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailTextController.text) == false){
              setState(() {
                emailError = true;
                errorMessage = LocaleKeys.registration_error_msg.tr();
              });
              return;
            }
            if(_secondPasswordTextController.text != _firstPasswordTextController.text || _secondPasswordTextController.text == "")
            {
              setState(() {
                passwordError = true;
                errorMessage =LocaleKeys.registration_error_diffPass.tr();
              });
              return;
            }
            if(_secondPasswordTextController.text.length < 8){
              setState(() {
                passwordError = true;
                errorMessage =LocaleKeys.registration_error_badPass.tr();
              });
              return;
            }
            setState(() {
              if (_isLoadingComplete) {
                _isLoadingComplete = false;
                _sendRequestPostBodyHeaders();
              }
            }) ;
          } : null,
        )
    );
  }

  Widget _enterButtonAction() {
    if (_isLoadingComplete == true) {
      return Text(
        LocaleKeys.registration_sendCode.tr(),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        style: GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color.fromARGB(255,255,255,255),
        ),
      );
    } else {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  _sendRequestPostBodyHeaders() async {

    var response = await http.post(Uri.parse(NetworkService().baseUrl + NetworkService().registration),
        body: {
          "grantType": "email",
          "email": _emailTextController.text,
          "password": _firstPasswordTextController.text
        },
        headers: {'Accept':'application/json'}
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("emailForReceipt", _emailTextController.text);

    setState(() {
      _isLoadingComplete = true;
    });

    if(response.statusCode == 422){
      setState(() {
        emailError = true;
        errorMessage = LocaleKeys.registration_type_email_error.tr();
      });
      return;
    }

    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     pageBuilder: (_, __, ___) => RegistrationPinScreen(LocaleKeys.registration_type_email_nextScreenMessage.tr(), _emailTextController.text, "email"),
    //     transitionDuration: const Duration(seconds: 0),
    //   ),
    // );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => RegistrationPinScreen(
            LocaleKeys.registration_type_email_nextScreenMessage.tr(),
            _emailTextController.text, "email"
        ),
      ),
      (route) => false,
    );
  }

  bool _passwordVisible = false;

  InputDecoration customInputDecoration(bool needSuffixIcon, String hintText){
    return InputDecoration(
      suffixIcon: (needSuffixIcon == true) ? IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(_passwordVisible ? Icons.visibility_off : Icons.remove_red_eye)
      ) : null,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 218, 216, 215),
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      hintText: hintText,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 0, 207, 145),
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }



}



