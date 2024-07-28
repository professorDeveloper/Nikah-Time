import 'package:customizable_multiselect_field/models/customizable_multiselect_dialog_options.dart';
import 'package:customizable_multiselect_field/models/customizable_multiselect_widget_options.dart';
import 'package:customizable_multiselect_field/models/data_source.dart';
import 'package:customizable_multiselect_field/models/data_source_options.dart';
import 'package:customizable_multiselect_field/widgets/customizable_multiselect_Field.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/components/items/nationality_list.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/items/strings_list.dart';
import 'package:untitled/Screens/main_page.dart';

import 'package:untitled/components/models/user_profile_data.dart';

import 'package:untitled/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' as localize;


UserFilter userFilter = UserFilter();

class RegistrationSetupInterestUserSettingsScreen extends StatefulWidget {
  RegistrationSetupInterestUserSettingsScreen(this._userProfileData);

  UserProfileData _userProfileData;

  @override
  State<RegistrationSetupInterestUserSettingsScreen> createState() => _RegistrationSetupInterestUserSettingsScreenState();
}

class _RegistrationSetupInterestUserSettingsScreenState extends State<RegistrationSetupInterestUserSettingsScreen> {
  bool isOpened = false;
  bool haveBadHabbitsSwitch = false;

  String setButtonName(isOpened){
    if(isOpened) {
      return LocaleKeys.filters_simpleFilter.tr();
    }
    return LocaleKeys.filters_complicatedFilter.tr();
  }

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
                          const _PhotoPlace(),
                          CustomInputDecoration().titleText(LocaleKeys.filters_complicatedFilterTittle.tr()),
                          CustomInputDecoration().subtitleText(LocaleKeys.user_age.tr()),
                          _AgeSlide(18, 99),

                          CustomInputDecoration().subtitleText(LocaleKeys.user_country.tr()),
                          DropdownFormField<String>(
                            decoration: CustomInputDecoration().GetDecoration(),
                            onSaved: (dynamic str) {
                              userFilter.country = "$str";
                              setState(() {});
                            },
                            onChanged: (dynamic item){
                              userFilter.country = "$item";
                              setState(() {});
                            },
                            displayItemFn: (dynamic str) =>
                                Text(translateCountryName(userFilter.country ?? ""),
                                  style: const TextStyle(fontSize: 16),
                                ),
                            findFn: (dynamic str) async => getCountry(str),
                            dropdownItemFn: (dynamic item, int position, bool focused,
                                bool selected, Function() onTap) =>
                                ListTile(
                                  title: Text(translateCountryName(item)),
                                  tileColor:
                                  focused ? const Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
                                  onTap: onTap,
                                ),
                          ),

                          Visibility(
                            visible: isOpened,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomInputDecoration().subtitleText(LocaleKeys.user_nationality.tr()),
                                DropdownFormField<String>(
                                  decoration: CustomInputDecoration().GetDecoration(),
                                  onSaved: (dynamic str) {},
                                  onChanged: (dynamic item){
                                    userFilter.nationality = item;
                                  },
                                  displayItemFn: (dynamic item) =>
                                      Text(translateNationName(userFilter.nationality ?? LocaleKeys.nationalityState_notSelected.tr()),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                  findFn: (dynamic str) async => getNationalityy(str),
                                  dropdownItemFn: (dynamic item, int position, bool focused,
                                      bool selected, Function() onTap) =>
                                      ListTile(
                                        title: Text(translateNationName(item)),
                                        tileColor:
                                        focused ? const Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
                                        onTap: onTap,
                                      ),
                                ),

                                CustomInputDecoration().subtitleText(LocaleKeys.user_city.tr()),
                                Visibility(
                                  visible: userFilter.country == "Россия",
                                  child: DropdownFormField<Map<String, dynamic>>(
                                    decoration: CustomInputDecoration().GetDecoration(),
                                    onSaved: (dynamic str) {},
                                    onChanged: (dynamic item) {
                                      userFilter.city =
                                      "${item["name"]!}, ${item["region"]!}";
                                    },
                                    displayItemFn: (dynamic item) =>
                                    //Text("${item["name"]!}, ${item["region"]!}",
                                    Text(
                                      userFilter.city ??= "",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    findFn: (dynamic str) async =>
                                        NetworkService().DadataRequest(str),
                                    dropdownItemFn: (dynamic item, int position, bool focused,
                                        bool selected, Function() onTap) =>
                                        ListTile(
                                          title: Text(item['name'] ?? ' '),
                                          subtitle: Text(
                                            item['region'] ?? '',
                                          ),
                                          tileColor: focused
                                              ? const Color.fromARGB(20, 0, 0, 0)
                                              : Colors.transparent,
                                          onTap: onTap,
                                        ),
                                  ),
                                ),
                                Visibility(
                                  visible: userFilter.country != "Россия",
                                  child: TextField(
                                    decoration: CustomInputDecoration(
                                      hintText: userFilter.city ?? "",
                                    ).GetDecoration(),
                                    controller: _nonRussianCountryController,
                                    onSubmitted: (value){
                                      userFilter.city = _nonRussianCountryController.text;
                                    },
                                  ),
                                ),

                                CustomInputDecoration().subtitleText(LocaleKeys.user_education.tr()),
                                InputDecorator(
                                  decoration: CustomInputDecoration().GetDecoration(),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: Text(
                                          (userFilter.education == null || userFilter.education == "")
                                              ? LocaleKeys.registration_profile_educationHint.tr()
                                              : educationList[userFilter.education!]!.tr()
                                      ),
                                      isDense: true,
                                      onChanged: (val) {
                                        userFilter.education = val;
                                        setState(() {

                                        });
                                      },
                                      items: educationList
                                          .map((description, value) {
                                        return MapEntry(
                                            description,
                                            DropdownMenuItem<String>(
                                              value: description,
                                              child: Text(value).tr(),
                                            )
                                        );
                                      }).values.toList(),
                                    ),
                                  ),
                                ),

                                CustomInputDecoration().subtitleText(LocaleKeys.user_maritalStatus.tr()),
                                InputDecorator(
                                  decoration: CustomInputDecoration().GetDecoration(),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: Text(
                                          (userFilter.maritalStatus == null || userFilter.maritalStatus == "")
                                              ? LocaleKeys.filters_maritalStatusTitle.tr()
                                              : familyState[userFilter.maritalStatus!]!.tr()
                                      ),
                                      isDense: true,
                                      onChanged: (val) {
                                        setState(() {
                                          userFilter.maritalStatus = val;
                                        });
                                      },
                                      items: familyState
                                          .map((description, value) {
                                        return MapEntry(
                                            description,
                                            DropdownMenuItem<String>(
                                              value: description,
                                              child: Text(value).tr(),
                                            )
                                        );
                                      }).values.toList(),
                                    ),
                                  ),
                                ),

                                CustomInputDecoration().subtitleText(LocaleKeys.user_haveChildren_title.tr()),
                                InputDecorator(
                                  decoration: CustomInputDecoration(hintText: LocaleKeys.user_haveChildren_hint.tr()).GetDecoration(),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: Text(
                                          (userFilter.haveChildren == null)
                                              ? LocaleKeys.user_haveChildren_hint.tr()//
                                              : (userFilter.haveChildren!)? LocaleKeys.childrenState_yes.tr() : LocaleKeys.childrenState_no.tr()
                                      ),
                                      isDense: true,
                                      onChanged: (val) {
                                        setState(() {
                                          userFilter.haveChildren = (val ==  LocaleKeys.childrenState_yes.tr()) ? true : false;
                                        });
                                      },
                                      items: childrenState.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),

                                CustomInputDecoration().subtitleText(LocaleKeys.user_badHabits.tr()),
                                Visibility(
                                  visible: haveBadHabbitsSwitch,
                                  child: CustomizableMultiselectField(
                                    decoration: CustomInputDecoration().GetDecoration(),
                                    customizableMultiselectWidgetOptions: CustomizableMultiselectWidgetOptions(
                                      chipShape: RoundedRectangleBorder(
                                        side: const BorderSide(color: Colors.red, width: 1),
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                    ),
                                    customizableMultiselectDialogOptions: CustomizableMultiselectDialogOptions(
                                        okButtonLabel: LocaleKeys.common_confirm.tr(),
                                        cancelButtonLabel: LocaleKeys.common_cancel.tr(),
                                        enableSearchBar: false
                                    ),
                                    dataSourceList: [
                                      DataSource<String>(
                                        dataList: GlobalStrings.getBadHabits(),
                                        options: DataSourceOptions(
                                          valueKey: 'value',
                                          labelKey: 'label',
                                        ),
                                      ),
                                    ],
                                    onChanged: ((List<List<dynamic>> value) {
                                      userFilter.badHabits = [];
                                      for(int i = 0; i<value[0].length; i++){
                                        userFilter.badHabits!.add(value[0][i]);
                                      }
                                    }),
                                  ),
                                ),
                                CustomSwitcher(
                                  switchValue: !haveBadHabbitsSwitch,
                                  label: LocaleKeys.badHabbits_missing.tr(),
                                  valueChanged: (value) {
                                    haveBadHabbitsSwitch = !haveBadHabbitsSwitch;
                                    userFilter.haveBadHabbits = haveBadHabbitsSwitch;
                                    userFilter.badHabits ??= [];
                                    // userFilter.badHabits!.add("other");
                                    setState(() {});
                                  },
                                )
                              ],
                            )
                          ),

                        ]
                    )
                )
            ),

            Container(
                padding: const EdgeInsets.only(top: 18),
                width: double.infinity,
                child:
                MaterialButton(
                    height: 56,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: const BorderSide(width: 1, color: Color.fromARGB(255, 0, 207, 145)),
                    ),
                    child: Text(
                      setButtonName(isOpened),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 207, 145),
                      ),
                    ),
                    onPressed:(){
                      isOpened = !isOpened;
                      setState(() {});
                    }
                ),
            ),
            const SizedBox(height: 8),
            Container(
                padding: const EdgeInsets.only(bottom: 24),
                width: double.infinity,
                child:
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:const Color.fromARGB(255, 00, 0xcf, 0x91),
                      elevation: 0,
                      fixedSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),

                    child: Text(
                      LocaleKeys.registration_PIN_action.tr(),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color.fromARGB(255,255,255,255),
                      ),
                    ),
                    onPressed:(){
                      widget._userProfileData.filter = UserFilter();
                      widget._userProfileData.filter = userFilter;
                      if (widget._userProfileData.filter.badHabits == null) {
                        widget._userProfileData.filter.haveBadHabbits = false;
                      } else {
                        if (widget._userProfileData.filter.badHabits!.isEmpty) {
                          widget._userProfileData.filter.haveBadHabbits = false;
                        }
                      }
                      widget._userProfileData.filter.isOnline = false;

                      // Navigator.push(
                      //   context,
                      //   PageRouteBuilder(
                      //     pageBuilder: (_, __, ___) => MainPage(widget._userProfileData),
                      //     transitionDuration: const Duration(seconds: 0),
                      //   ),
                      // );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => MainPage(widget._userProfileData),
                        ),
                            (route) => false,
                      );
                    }
                )
            ),
          ],
        ),
      ),
    );
  }

  String translateNationName(String str)
  {
    try{
      if(context.locale.languageCode == "en")
      {
        str = nationalityListEn[nationalityList.indexOf(str)];
      }
      return str;
    }catch(err){
      return str;
    }
  }

  List<String> getNationalityy(String str)
  {
    List<String> finded = <String>[];
    if(context.locale.languageCode == "en"){
      for (int i = 0; i < nationalityListEn.length; i++) {
        if (nationalityListEn[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(nationalityList[i]);
        }
      }
    }else{
      for (int i = 0; i < nationalityList.length; i++) {
        if (nationalityList[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(nationalityList[i]);
        }
      }
    }
    return finded;
  }

  String translateCountryName(String str)
  {
    try{
      if(context.locale.languageCode == "en")
      {
        str = countryListEn[countryList.indexOf(str)];
      }
      return str;
    }catch(err){
      return str;
    }
  }

  List<String> getCountry(String str)
  {
    List<String> finded = <String>[];
    if(context.locale.languageCode == "en"){
      for (int i = 0; i < countryListEn.length; i++) {
        if (countryListEn[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(countryList[i]);
        }
      }
    }else{
      for (int i = 0; i < countryList.length; i++) {
        if (countryList[i].toLowerCase().contains(str.toLowerCase())) {

          finded.add(countryList[i]);
        }
      }
    }
    return finded;
  }

  final TextEditingController _nonRussianCountryController =
  TextEditingController();
}

class _PhotoPlace extends StatelessWidget {
  const _PhotoPlace({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: double.infinity,
        height: 160,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/icons/people_filters.png'
            ),
            fit: BoxFit.contain,
          ),
          shape: BoxShape.rectangle,
        ),
      );
  }
}

class _AgeSlide extends StatefulWidget{
  late final double minValue;
  late final double maxValue;

  _AgeSlide(this.minValue, this.maxValue);

  @override
  State<_AgeSlide> createState() =>
      _AgeSlideState(
          minValue,
          maxValue
      );
}

class _AgeSlideState extends State<_AgeSlide> {
  late final double minValue;
  late final double maxValue;

  late final startController;
  late final endController;

  late double _startValue;
  late double _endValue;

  late double _prevStartValue;
  late double _prevEndValue;

  _AgeSlideState(this.minValue, this.maxValue) {
    _startValue = minValue;
    _endValue = maxValue;

    _prevStartValue = _startValue;
    _prevEndValue = _endValue;

    startController = TextEditingController(text: minValue.toStringAsFixed(0));
    endController = TextEditingController(text: maxValue.toStringAsFixed(0));
  }

  @override
  void initState() {
    super.initState();

    startController.addListener(_setStartValue);
    endController.addListener(_setEndValue);
  }

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();

    super.dispose();
  }

  bool _isValueValid(String text) {
    if (text.isEmpty) {
      return false;
    }
    int? value = int.tryParse(text);
    if (value == null) {
      return false;
    }
    return true;
  }

  bool _isStartValueValid(String text) {
    if (_isValueValid(text) == false) {
      return false;
    }

    int value = int.parse(text);
    if (value > _endValue) {
      return false;
    }
    if (value < minValue) {
      return false;
    }
    return true;
  }

  bool _isEndValueValid(String text) {
    if (_isValueValid(text) == false) {
      return false;
    }

    int value = int.parse(text);
    if (value < _startValue) {
      return false;
    }
    if (value > maxValue) {
      return false;
    }
    return true;
  }

  _setStartValue() {
    if (_isStartValueValid(startController.text)
        && _isEndValueValid(endController.text)
    ) {
      setState(() {
        _startValue = double.parse(startController.text).roundToDouble();
      });
    }
    print("First text field: ${startController.text}");
  }

  _setEndValue() {
    if (_isStartValueValid(startController.text)
        && _isEndValueValid(endController.text)
    ) {
      setState(() {
        _endValue = double.parse(endController.text).roundToDouble();
      });
    }
    print("Second text field: ${endController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                LocaleKeys.filters_from.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color.fromARGB(255, 117, 116, 115),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  height: 36,
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: false
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 218, 216, 215),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      hintText: "",
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 207, 145),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                    ),
                    controller: startController,
                    onSubmitted: (text) {
                      if (_isStartValueValid(text) == false) {
                        setState(() {
                          _startValue = _prevStartValue;
                          startController.text = _prevStartValue.toStringAsFixed(0);
                        });
                      } else {
                        _prevStartValue = _startValue;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                LocaleKeys.filters_to.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color.fromARGB(255, 117, 116, 115),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                    height: 36,
                    child: TextField(
                      controller: endController,
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false
                      ),
                      onSubmitted: (text){
                        if (_isEndValueValid(text) == false) {
                          setState(() {
                            _endValue = _prevEndValue;
                            endController.text = _prevEndValue.toStringAsFixed(0);
                          });
                        } else {
                          _prevEndValue = _endValue;
                        }
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 218, 216, 215),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        hintText: "",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 0, 207, 145),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                    ),
                ),
              ),
            ],
          ),
          AgeSlider()
        ],
      ),
    );
  }

  Widget AgeSlider(){
    return RangeSlider(
      activeColor: const Color.fromARGB(255, 00, 0xcf, 0x91),
      values: RangeValues(_startValue, _endValue),
      min: minValue,
      max: maxValue,
      // divisions: 81,

      // labels: RangeLabels(
      //   _startValue.round().toStringAsFixed(0),
      //   _endValue.round().toStringAsFixed(0),
      // ),
      onChanged: (RangeValues values) {
        print(values);
        setState(() {
          _startValue = values.start.roundToDouble();
          _endValue = values.end.roundToDouble();
          _prevStartValue = _startValue;
          _prevEndValue = _endValue;
          startController.text =
              values.start.roundToDouble().toStringAsFixed(0);
          endController.text = values.end.roundToDouble().toStringAsFixed(0);
        });
      },
    );
  }

}
