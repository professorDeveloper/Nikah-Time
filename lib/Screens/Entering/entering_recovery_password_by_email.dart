import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Entering/entering_recovery_password_input_code.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/ServiceItems/network_service.dart';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';


class EnteringRecoveryPasswordByEmailScreen extends StatefulWidget {
  const EnteringRecoveryPasswordByEmailScreen();

  @override
  State<EnteringRecoveryPasswordByEmailScreen> createState() => _EnteringRecoveryPasswordByEmailScreenState();
}

class _EnteringRecoveryPasswordByEmailScreenState extends State<EnteringRecoveryPasswordByEmailScreen> {

  final TextEditingController _emailTextController = TextEditingController();
  bool _isLoadingComplete = true;
  bool _isError = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),

      body:  Container (
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
                          const _Header(),
                          const SizedBox(height: 8),
                          const _Message(),
                          const SizedBox(height: 32),
                          TextField(
                            controller: _emailTextController,
                            onChanged: (value){
                              setState(() {
                                _isError = false;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 218, 216, 215),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              hintText: LocaleKeys.entering_recoveryBy_email_hint.tr(),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 207, 145),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: _isError,
                              child: Text(
                                errorMessage,
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              )
                          ),
                          const SizedBox(height: 8),
                        ]
                    )
                )
            ),
            _registerButton(),
            SizedBox(height: 16),
          ],
        ),
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
            setState(() {
              if (_isLoadingComplete) {
                setState(() {
                  _isLoadingComplete = false;
                });

                _sendLoginRequest();
              }
            }) ;
          } : null,
        )
    );
  }

  Widget _enterButtonAction() {
    if (_isLoadingComplete == true) {
      return Text(
        LocaleKeys.entering_recoveryBy_email_get.tr(),
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

  _sendLoginRequest() async {
    if(_emailTextController.text == "" || _emailTextController.text == null){
      _isLoadingComplete = true;
      return;
    }

    if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_emailTextController.text) == false){
      _isLoadingComplete = true;
      _isError = true;
      errorMessage = LocaleKeys.entering_error_badEmail.tr();
      debugPrint("ERR");
      return;
    }

    _isLoadingComplete = true;
    var response = await NetworkService().RestoreAccountPasswordCode("email", _emailTextController.text);
    if(response.statusCode != 200){
      debugPrint(response.body);
      _isError = true;
      errorMessage = LocaleKeys.entering_error_nouser.tr();
      return;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => EnteringSelectRecoveryPasswordInputCodeScreen("email", _emailTextController.text),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }

}

class _Header extends StatelessWidget{
  const _Header ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.entering_recoveryBy_email_header.tr(),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: const Color.fromARGB(255,33,33,33),
      ),
    );
  }
}

class _Message extends StatelessWidget{
  const _Message ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.entering_recoveryBy_email_msg.tr(),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.justify,
      style: GoogleFonts.rubik(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color.fromARGB(255, 117, 116, 115),
      ),
      maxLines: 3,
    );
  }
}

