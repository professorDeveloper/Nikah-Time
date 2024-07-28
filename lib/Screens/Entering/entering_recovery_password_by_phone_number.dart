import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Entering/entering_recovery_password_input_code.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/generated/locale_keys.g.dart';


class EnteringRecoveryPasswordByPhoneNumberScreen extends StatefulWidget {
  const EnteringRecoveryPasswordByPhoneNumberScreen();

  @override
  State<EnteringRecoveryPasswordByPhoneNumberScreen> createState() => _EnteringRecoveryPasswordByPhoneNumberScreenState();
}

class _EnteringRecoveryPasswordByPhoneNumberScreenState extends State<EnteringRecoveryPasswordByPhoneNumberScreen> {
  final TextEditingController _emailTextController = TextEditingController(text: "+7");
  bool _isLoadingComplete = true;
  bool _isError = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),

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
                          const _MyNumber(),
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
                              hintText: LocaleKeys.entering_recoveryBy_number_hint.tr(),
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
                          //_PhoneNumber(),
                        ]
                    )
                )
            ),
            _registerButton(),
            const SizedBox(height: 16),
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
          color: const Color.fromARGB(255,00,0xCF,0x91),
          disabledColor: const Color.fromARGB(255,00,0xCF,0x91),

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
        LocaleKeys.entering_recoveryBy_number_get.tr(),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        style: GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: const Color.fromARGB(255,255,255,255),
        ),
      );
    } else {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  _sendLoginRequest() async {
    if(_emailTextController.text == ""){
      return;
    }
    String number = _emailTextController.text.replaceAll("+", "").replaceAll(" ", "").replaceAll("-", "");
    if(RegExp(r'^((\+7|7)+([0-9]){10})$').hasMatch(number) != true){
      _isLoadingComplete = true;
      _isError = true;
      errorMessage = LocaleKeys.entering_error_badNumber.tr();
      debugPrint("ERR");
      setState(() {});
      return;
    }

    _isLoadingComplete = true;
    var response = await NetworkService().RestoreAccountPasswordCode(
        "phoneNumber",
        number
    );
    if(response.statusCode != 200){
      debugPrint(response.body);
      _isError = true;
      if(response.statusCode == 422){
        errorMessage = LocaleKeys.entering_error_nouser.tr();
      }else{
        errorMessage = LocaleKeys.entering_recoveryBy_error.tr();
      }

      setState(() {});
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => EnteringSelectRecoveryPasswordInputCodeScreen(
            "phoneNumber",
            _emailTextController.text.replaceAll("+", "").replaceAll(" ", "").replaceAll("-", "")
        ),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }

}

class _MyNumber extends StatelessWidget{
  const _MyNumber ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.entering_recoveryBy_number_header.tr(),
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
  const _Message ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.entering_recoveryBy_number_msg.tr(),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.justify,
      style: GoogleFonts.rubik(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: const Color.fromARGB(255, 117, 116, 115),
      ),
      maxLines: 3,
    );
  }
}
