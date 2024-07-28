import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Entering/entering_recovery_password_conclusion.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/ServiceItems/network_service.dart';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';

class EnteringRecoveryPasswordCreateNewScreen extends StatefulWidget {
  EnteringRecoveryPasswordCreateNewScreen(this.connectionType, this.value, this.verifyCode);

  String connectionType = '';
  String value = '';
  String verifyCode = '';

  @override
  State<EnteringRecoveryPasswordCreateNewScreen> createState() => _EnteringRecoveryPasswordCreateNewScreenState();
}

class _EnteringRecoveryPasswordCreateNewScreenState extends State<EnteringRecoveryPasswordCreateNewScreen> {

  final TextEditingController _newPasswordController1 = TextEditingController();
  final TextEditingController _newPasswordController2 = TextEditingController();
  bool _isLoadingComplete = true;
  bool _passwordVisible = false;
  bool _error = false;
  String _errMessage = "";

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
                          _Message(),
                          CustomInputDecoration().errorBox(_error, errMessage: _errMessage),
                          SizedBox(height: 32),
                          TextField(
                            enabled: _isLoadingComplete,
                            controller: _newPasswordController1,
                            obscureText: !_passwordVisible,
                            decoration: customInputDecoration(true, LocaleKeys.entering_create_hint.tr()),
                            onChanged: (value){
                              setState(() {
                                _error = false;
                              });
                            },
                          ),
                          SizedBox(height: 8),
                          TextField(
                            enabled: _isLoadingComplete,
                            controller: _newPasswordController2,
                            obscureText: !_passwordVisible,
                            decoration: customInputDecoration(true, LocaleKeys.entering_create_hint.tr()),
                            onChanged: (value){
                              setState(() {
                                //passwordError = false;
                              });
                            },
                          ),
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
        LocaleKeys.entering_create_continue.tr(),
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
    if(_newPasswordController1.text != _newPasswordController2.text){
      _isLoadingComplete = true;
      _error = true;
      _errMessage = LocaleKeys.entering_create_error_diff.tr();
      return;
    }

    if(_newPasswordController1.text.length < 8){
      _isLoadingComplete = true;
      _error = true;
      _errMessage = LocaleKeys.entering_create_error_length.tr();
      return;
    }

    var response = await NetworkService().RestoreAccountPasswordCodeReset(widget.connectionType, widget.value, widget.verifyCode, _newPasswordController1.text);
    _isLoadingComplete = true;
    setState(() {

    });
    debugPrint("${response.statusCode}");
    if(response.statusCode != 200){
      debugPrint("${response.body}");
      _error = true;
      _errMessage = LocaleKeys.entering_create_error_bad.tr();
      return;
    }
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => EnteringRecoveryPasswordConclusionScreen(),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }

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

class _Header extends StatelessWidget{
  const _Header ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.entering_create_header.tr(),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: GoogleFonts.rubik(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: const Color.fromARGB(255,33,33,33),
      ),
    );
  }
}

class _Message extends StatelessWidget{
  _Message ({Key? key}) : super (key:key);


  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.entering_create_msg.tr(),
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

