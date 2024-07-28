import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:untitled/components/widgets/policy_agreement_block.dart';
import 'package:untitled/generated/locale_keys.g.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Registration/registration_pin.dart';
import 'package:untitled/ServiceItems/network_service.dart';

import '../../components/widgets/custom_appbar.dart';

bool _passwordVisible = false;
bool _isLoadingComplete = true;
TextEditingController _numberTextController = TextEditingController();
TextEditingController _firstPasswordTextController = TextEditingController();
TextEditingController _secondPasswordTextController = TextEditingController();

class RegistrationPhoneNumberScreen extends StatefulWidget {
  const RegistrationPhoneNumberScreen();

  @override
  State<RegistrationPhoneNumberScreen> createState() => _RegistrationPhoneNumberScreenState();
}

class _RegistrationPhoneNumberScreenState extends State<RegistrationPhoneNumberScreen> {
  bool passwordError = false;
  bool phoneError = false;
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
                    const _MyNumber(),
                    const SizedBox(height: 8),
                    const _Message(),
                    const SizedBox(height: 32),
                    _PhoneNumber(),
                    Visibility(
                        visible: phoneError,
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
                      decoration: customInputDecoration(true, LocaleKeys.registration_type_phone_hintPass.tr()),
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
                      controller: _secondPasswordTextController,
                      enabled: _isLoadingComplete,
                      obscureText: !_passwordVisible,
                      decoration: customInputDecoration(true, LocaleKeys.registration_type_phone_hintSecPass.tr()),
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
                    _registerButton(),
                    const SizedBox(height: 16),
                    const PolicyAgreement()
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
          color: const Color.fromARGB(255,00,0xCF,0x91),
          disabledColor: const Color.fromARGB(255,00,0xCF,0x91),
          onPressed: _isLoadingComplete ? () {
            if(_secondPasswordTextController.text != _firstPasswordTextController.text || _secondPasswordTextController.text == "")
            {
              setState(() {
                passwordError = true;
                errorMessage = LocaleKeys.registration_error_diffPass.tr();
              });
              return;
            }
            if(_secondPasswordTextController.text.length < 8){
              setState(() {
                passwordError = true;
                errorMessage = LocaleKeys.registration_error_badPass.tr();
              });
              return;
            }
            setState(() {
              if (_isLoadingComplete) {
                setState(() {
                  _isLoadingComplete = false;
                });

                _sendRequestPostBodyHeaders();
              }
            }) ;
          } : null,

          child: _enterButtonAction(),
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
          color: const Color.fromARGB(255,255,255,255),
        ),
      );
    } else {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  _sendRequestPostBodyHeaders() async {
    String phoneNumber = _numberTextController.text.replaceAll("+", "").replaceAll(" ", "").replaceAll("-", "");
    var item =  await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, "RU");
    phoneNumber = item.phoneNumber.toString().replaceAll("+", "");
    var response = await http.post(Uri.parse(NetworkService().baseUrl + NetworkService().registration),
        body: {
          "grantType": "phoneNumber",
          "phoneNumber": phoneNumber,
          "password": _firstPasswordTextController.text
        },
        headers: {'Accept':'application/json'}
    );
    setState(() {
      _isLoadingComplete = true;
    });

    if(response.statusCode == 422) {
      setState(() {
        phoneError = true;
        errorMessage = LocaleKeys.registration_type_phone_error.tr();
      });
      return;
    }

    if(response.statusCode != 200)
      {
        debugPrint(response.body);
        setState(() {
          phoneError = true;
          errorMessage = LocaleKeys.entering_recoveryBy_error.tr();
        });
        return;
      }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => RegistrationPinScreen(
          LocaleKeys.registration_type_phone_nextScreenMessage.tr(),
          phoneNumber, "phone"
        ),
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }


  String initialCountry = 'RU';
  PhoneNumber number = PhoneNumber(isoCode: 'RU');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget _PhoneNumber(){
    return Form(
      child: Container(
          height: 59,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 218, 216, 215),
              width: 1, //                   <--- border width here
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(10.0) //                 <--- border radius here
            ),

          ),
          child:
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                InternationalPhoneNumberInput(
                  inputBorder: InputBorder.none,
                  searchBoxDecoration: InputDecoration(
                    hintText: LocaleKeys.common_phoneNumberHint.tr(),
                  ),
                  onInputChanged: (PhoneNumber number) {
                    debugPrint(number.phoneNumber);
                  },
                  onInputValidated: (bool value) {
                    debugPrint(value.toString());
                  },
                  selectorConfig: const SelectorConfig(
                    setSelectorButtonAsPrefixIcon: true,
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  hintText: '___ ___ __ __',
                  maxLength: 13,
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: _numberTextController,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  //inputBorder: OutlineInputBorder(),
                  onSaved: (PhoneNumber number) {
                    debugPrint('On Saved: $number');
                  },
                ),
              ],

            ),
          )
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

class _MyNumber extends StatelessWidget{
  const _MyNumber ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.registration_type_phone_header.tr(),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: Color.fromARGB(255,33,33,33),
      ),
    );
  }
}

class _Message extends StatelessWidget{
  const _Message ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.registration_type_phone_text.tr(),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color.fromARGB(255, 117, 116, 115),
          height: 1.4
      ),
      maxLines: 3,
    );
  }
}