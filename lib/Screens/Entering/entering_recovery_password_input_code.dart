import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Entering/entering_recovery_password_create_new.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/ServiceItems/network_service.dart';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';

class EnteringSelectRecoveryPasswordInputCodeScreen extends StatefulWidget {
  EnteringSelectRecoveryPasswordInputCodeScreen(this.connectionType, this.value);

  String connectionType = '';
  String value = '';

  @override
  State<EnteringSelectRecoveryPasswordInputCodeScreen> createState() => _EnteringSelectRecoveryPasswordInputCodeScreenState();
}

class _EnteringSelectRecoveryPasswordInputCodeScreenState extends State<EnteringSelectRecoveryPasswordInputCodeScreen> {

  final TextEditingController _verifyCodeController = TextEditingController();
  bool _isLoadingComplete = true;
  bool error = false;
  String errMessage = "";
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
                          _Header(),
                          SizedBox(height: 8),
                          _Message((widget.connectionType == "phoneNumber") ? LocaleKeys.entering_code_number.tr() : LocaleKeys.entering_code_email.tr(), widget.value),
                          SizedBox(height: 32),
                          TextField(
                            controller: _verifyCodeController,
                            onChanged: (val){error = false;},
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 218, 216, 215),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              hintText: LocaleKeys.entering_code_hint.tr(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 207, 145),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: error,
                              child: Text(
                                errMessage,
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              )
                          ),
                          SizedBox(height: 8),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: LocaleKeys.entering_code_again.tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: const Color.fromARGB(255,00,0xCF,0x91),
                                  ),
                                  recognizer: TapGestureRecognizer()..onTap = () async {
                                    debugPrint("click");
                                    var response = await NetworkService().RestoreAccountPasswordCode(widget.connectionType, widget.value);
                                    if(response.statusCode != 200){
                                      errMessage = LocaleKeys.entering_code_error.tr();
                                      error = true;
                                      setState(() {

                                      });
                                    }
                                    debugPrint("${response.statusCode}");
                                    debugPrint("${response.body}");
                                  },
                               ),
                              ],
                            ),
                          )

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
        LocaleKeys.entering_code_action.tr(),
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
    if(_verifyCodeController.text == "" || _verifyCodeController.text == null){
      errMessage = LocaleKeys.entering_code_hint.tr();
      error = true;
      _isLoadingComplete = true;
      return;
    }

    var response = await NetworkService().RestoreAccountPasswordCodeVerify(widget.connectionType, widget.value, _verifyCodeController.text);
    _isLoadingComplete = true;
    if(response.statusCode != 200){
      debugPrint("${widget.connectionType}");
      debugPrint("${widget.value}");
      debugPrint("${response.body}");
      errMessage = LocaleKeys.entering_code_error_uncorrect.tr();
      error = true;
      setState(() {

      });
      return;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => EnteringRecoveryPasswordCreateNewScreen(widget.connectionType, widget.value, _verifyCodeController.text),
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
      LocaleKeys.entering_code_header.tr(),
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
  _Message (this.connectionType, this.value, {Key? key}) : super (key:key);

  String connectionType = '';
  String value = '';

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.entering_code_message.tr(args: [connectionType,value]),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.justify,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color.fromARGB(255, 117, 116, 115),
      ),
      maxLines: 3,
    );
  }
}


class _EmailAddress extends StatefulWidget{
  _EmailAddress ({Key? key}) : super (key:key);

  @override
  State<_EmailAddress> createState() => _EmailAddressState();
}

class _EmailAddressState extends State<_EmailAddress> {
  @override
  Widget build(BuildContext context){
    return TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 218, 216, 215),
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: LocaleKeys.entering_code_hint.tr(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 207, 145),
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }



}
