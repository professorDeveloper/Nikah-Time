import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class CustomInputDecoration{
  CustomInputDecoration({this.hintText = "", this.Icon, this.labeltext});
  String hintText;
  String? labeltext;
  var Icon;

  Widget errorBox(bool error, {String errMessage = LocaleKeys.common_errorHintText}){
    return Visibility(
        visible: error,
        child: Text(
          errMessage.tr(),
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Colors.red,
          ),
        )
    );
  }

  InputDecoration GetDecoration(){
    return InputDecoration(
      suffixIcon: (Icon == null) ? null : Icon,
      hintText: hintText,
      //labelText: labeltext,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 218, 216, 215),
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromARGB(255, 0, 207, 145),
          width: 1,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  Widget subtitleText(String str, {bool isFieldRequired = true}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                str,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.left,
                style: GoogleFonts.rubik(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: const Color.fromARGB(255,0,0,0),
                ),
              ),
            ),
            Visibility(
              visible: isFieldRequired == false,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    LocaleKeys.common_fieldNotRequired.tr(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: const Color.fromARGB(255,0,0,0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget titleText(String str){
    return Text(
      str,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: const Color.fromARGB(255,33,33,33),
      ),
    );
  }

  Widget anketesTextItem(String label, String? text){
    return Visibility(
      visible: !(text == null || text == ""),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          anketasHeaderName(label),
          const SizedBox(height: 8,),
          anketasBodyText(text.toString()),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget anketasBodyText(String str){
    return Text(
      str,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
        color: Color.fromARGB(255, 117, 117, 117),
      ),
    );
  }

  Widget anketasHeaderName(String str){
    return Text(
      str,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

}


class BirthDate extends StatefulWidget{
  BirthDate (
      this.userProfileData,
      {this.onPick,
      Key? key}
  ) : super (key:key);
  UserProfileData userProfileData;
  Function()? onPick;

  @override
  State<BirthDate> createState() => BirthDateState();
}

class BirthDateState extends State<BirthDate> {
  DateTime _dateTime = DateTime(0);

  TextEditingController _textEditingController = TextEditingController();
  void showPicker(){
    showDatePicker(
        context: this.context,
        initialDate: DateTime(
            DateTime.now().year - 18,
            DateTime.now().month,
            DateTime.now().day
        ),
        firstDate: DateTime(1900),
        lastDate: DateTime(
            DateTime.now().year - 18,
            DateTime.now().month,
            DateTime.now().day
        )
    ).then(
            (date){
          setState(() {
            _dateTime = date!;
            _textEditingController.text = "${_dateTime.day.toString()}.${_dateTime.month.toString().padLeft(2,'0')}.${_dateTime.year.toString().padLeft(4,'0')}";
            widget.userProfileData.birthDate = "${_dateTime.day.toString()}-${_dateTime.month.toString().padLeft(2,'0')}-${_dateTime.year.toString().padLeft(4,'0')}";
            if (widget.onPick != null) {
              widget.onPick!();
            }
          });
        }

    ) ;
  }

  @override
  Widget build(BuildContext context){
    return TextField(
      controller: _textEditingController,
      onTap: (){
        showPicker();
      },
      readOnly: true,
      decoration: CustomInputDecoration(
        hintText: (widget.userProfileData.birthDate != null) ? widget.userProfileData.birthDate!.replaceAll("-", ".") : "xx.xx.xxxx",
        Icon: const Icon(Icons.calendar_today, color: Colors.grey,),
      ).GetDecoration(),
    );
  }
}


class PhoneNumberField extends StatefulWidget{
  PhoneNumberField(this.userProfileData);
  UserProfileData userProfileData;
  @override
  State<PhoneNumberField> createState() => PhoneNumberFieldState();
}

class PhoneNumberFieldState extends State<PhoneNumberField> {

  final String initialCountry = 'RU';
  late PhoneNumber number;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  @override
  void initState(){
    try{
      number = PhoneNumber(isoCode: 'RU', phoneNumber: widget.userProfileData.contactPhoneNumber!.replaceAll("+7", ""));
    }catch(err){
      number = PhoneNumber(isoCode: 'RU');
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Form(
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromARGB(255, 218, 216, 215),
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
                  onInputChanged: (PhoneNumber number) {},
                  onInputValidated: (bool value) {
                    if(value == true){
                      widget.userProfileData.contactPhoneNumber = number.phoneNumber;
                    }
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  hintText: number.phoneNumber,
                  maxLength: 13,
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: controller,
                  keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  //inputBorder: OutlineInputBorder(),
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                    widget.userProfileData.contactPhoneNumber = number.toString();
                  },
                ),
              ],

            ),
          )
      ),
    );
  }
}


class CustomSwitcher extends StatefulWidget {
  CustomSwitcher({required this.switchValue, required this.valueChanged, required this.label});

  late bool switchValue;
  late ValueChanged valueChanged;
  late String label;

  @override
  CustomSwitcherState createState() => CustomSwitcherState();
}

class CustomSwitcherState extends State<CustomSwitcher> {
  late bool _switchValue;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          children: [
            CupertinoSwitch(
                value: _switchValue,
                onChanged: (bool value) {
                  setState(() {
                    _switchValue = value;
                    widget.valueChanged(value);
                  });
                }),
            Text(widget.label),
          ],
        ),
      ],
    );
  }
}


