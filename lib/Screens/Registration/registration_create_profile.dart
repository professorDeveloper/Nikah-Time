import 'package:customizable_multiselect_field/customizable_multiselect_flutter.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Providers/GenderProvider.dart';

import 'package:untitled/Screens/Registration/registration_add_interest_tags.dart';
import 'package:untitled/Screens/welcome.dart';
import 'package:untitled/components/items/nationality_list.dart';

import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/items/strings_list.dart';
import 'package:untitled/components/widgets/image_grid_widget.dart';

import 'package:untitled/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' as localize;

class RegistrationCreateProfileScreen extends StatefulWidget {
  RegistrationCreateProfileScreen(this.userProfileData, {Key? key})
      : super(key: key);

  UserProfileData userProfileData;

  @override
  State<RegistrationCreateProfileScreen> createState() =>
      _RegistrationCreateProfileScreenState();
}

class _RegistrationCreateProfileScreenState
    extends State<RegistrationCreateProfileScreen> {
  bool isBadHabitsSwitchOn = false;
  bool genderMale = true;
//==============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _CustomAppBar(),
      body: ChangeNotifierProvider<GenderProvider>(
          create: (context) => GenderProvider(),
          builder: (context, child) {
            final provider = Provider.of<GenderProvider>(context);
            if (familyState.containsKey('married')) {
              !provider.isMale
                  ? familyState.remove('married')
                  : familyState.containsKey('married')
                      ? null
                      : familyState.addAll({'married': 'familyState.married'});
            } else {
              provider.isMale
                  ? familyState.addAll({'married': 'familyState.married'})
                  : null;
            }

            return Container(
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
                            CustomInputDecoration().titleText(
                                LocaleKeys.registration_profile_header.tr()),
                            const SizedBox(
                              height: 24,
                            ),
                            PhotoPlace(widget.userProfileData, () {}),
                            CustomInputDecoration().errorBox(photoEmpty),
                            // CustomInputDecoration().subtitleText("Имя"),
                            TextField(
                              decoration: CustomInputDecoration(
                                hintText: (widget.userProfileData.firstName == null)
                                    ? LocaleKeys.user_firstName.tr()
                                    : widget.userProfileData.firstName!,
                              ).GetDecoration(),
                              controller: _firstNameTextController,
                              onChanged: (value) {
                                if (firstNameEmpty == true) {
                                  firstNameEmpty = false;
                                  setState(() {});
                                }
                              },
                            ),
                            CustomInputDecoration().errorBox(firstNameEmpty),

                            const SizedBox(
                              height: 8,
                            ),
                            TextField(
                              decoration: CustomInputDecoration(
                                hintText: (widget.userProfileData.lastName == null)
                                    ? LocaleKeys.user_lastName.tr()
                                    : widget.userProfileData.lastName!,
                              ).GetDecoration(),
                              controller: _lastNameTextController,
                              onChanged: (value) {
                                if (lastNameEmpty == true) {
                                  lastNameEmpty = false;
                                  setState(() {});
                                }
                              },
                            ),
                            CustomInputDecoration().errorBox(lastNameEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_gender_title.tr()),
                            _Gender(widget.userProfileData, provider),
                            CustomInputDecoration().errorBox(genderEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_nationality.tr(), isFieldRequired: false),
                            DropdownFormField<String>(
                              decoration: CustomInputDecoration().GetDecoration(),
                              onSaved: (dynamic str) {},
                              onChanged: (dynamic item) {
                                widget.userProfileData.nationality = item;
                                updateUserData();
                              },
                              displayItemFn: (dynamic item) => Text(
                                translateNationName(widget
                                        .userProfileData.nationality ??
                                    LocaleKeys.nationalityState_notSelected.tr()),
                                style: const TextStyle(fontSize: 16),
                              ),
                              findFn: (dynamic str) async => getNationalityy(str),
                              dropdownItemFn: (dynamic item,
                                      int position,
                                      bool focused,
                                      bool selected,
                                      Function() onTap) =>
                                  ListTile(
                                title: Text(translateNationName(item)),
                                tileColor: focused
                                    ? const Color.fromARGB(20, 0, 0, 0)
                                    : Colors.transparent,
                                onTap: onTap,
                              ),
                            ),

                            // CustomInputDecoration().errorBox(nationalityEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_birthDate.tr()),
                            BirthDate(widget.userProfileData),
                            CustomInputDecoration().errorBox(birthDateEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_country.tr()),
                            DropdownFormField<String>(
                              decoration: CustomInputDecoration().GetDecoration(),
                              onSaved: (dynamic str) {
                                widget.userProfileData.country = "$str";
                              },
                              onChanged: (dynamic item) {
                                widget.userProfileData.country = "$item";
                                updateUserData();
                              },
                              displayItemFn: (dynamic str) => Text(
                                translateCountryName(
                                    widget.userProfileData.country ?? ""),
                                style: const TextStyle(fontSize: 16),
                              ),
                              findFn: (dynamic str) async => getCountry(str),
                              dropdownItemFn: (dynamic item,
                                      int position,
                                      bool focused,
                                      bool selected,
                                      Function() onTap) =>
                                  ListTile(
                                title: Text(translateCountryName(item)),
                                tileColor: focused
                                    ? const Color.fromARGB(20, 0, 0, 0)
                                    : Colors.transparent,
                                onTap: onTap,
                              ),
                            ),
                            CustomInputDecoration().errorBox(countryEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_city.tr()),
                            Visibility(
                              visible: widget.userProfileData.country == "Россия",
                              child: DropdownFormField<Map<String, dynamic>>(
                                decoration: CustomInputDecoration().GetDecoration(),
                                onSaved: (dynamic str) {},
                                onChanged: (dynamic item) {
                                  widget.userProfileData.city =
                                      "${item["name"]!}, ${item["region"]!}";
                                },
                                displayItemFn: (dynamic item) =>
                                    //Text("${item["name"]!}, ${item["region"]!}",
                                    Text(
                                  widget.userProfileData.city ??= "",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                findFn: (dynamic str) async =>
                                    NetworkService().DadataRequest(str),
                                dropdownItemFn: (dynamic item,
                                        int position,
                                        bool focused,
                                        bool selected,
                                        Function() onTap) =>
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
                              visible: widget.userProfileData.country != "Россия",
                              child: TextField(
                                decoration: CustomInputDecoration(
                                  hintText: widget.userProfileData.city ?? "",
                                ).GetDecoration(),
                                controller: _nonRussianCountryController,
                                onChanged: (value) {
                                  widget.userProfileData.city =
                                      _nonRussianCountryController.text;
                                  updateUserData();
                                },
                                onSubmitted: (value) {
                                  widget.userProfileData.city =
                                      _nonRussianCountryController.text;
                                  updateUserData();
                                },
                              ),
                            ),
                            CustomInputDecoration().errorBox(cityEmpty),

                            Container(
                              child: Row(
                                children: [
                                  CustomInputDecoration().subtitleText(
                                      LocaleKeys.user_contactPhoneNumber.tr(), isFieldRequired: false),
                                  IconButton(
                                    padding: const EdgeInsets.only(top: 16),
                                    splashRadius: 1,
                                    iconSize: 14,
                                    icon:
                                        const Icon(Icons.star_border_purple500_outlined),
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) => Wrap(children: [
                                                const Text(LocaleKeys
                                                        .common_usingPhoneNumberHint)
                                                    .tr()
                                              ]));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            userPhoneNumber(), //PhoneNumberField(widget.userProfileData),
                            // CustomInputDecoration().errorBox(phoneNumberEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_education.tr()),
                            InputDecorator(
                              decoration: CustomInputDecoration(
                                      hintText: LocaleKeys.user_education.tr())
                                  .GetDecoration(),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text(
                                      (widget.userProfileData.education == null)
                                          ? LocaleKeys
                                              .registration_profile_educationHint
                                              .tr()
                                          : educationList[
                                                  widget.userProfileData.education!]
                                              .toString()
                                              .tr()),
                                  isDense: true,
                                  onChanged: (val) {
                                    setState(() {
                                      widget.userProfileData.education =
                                          val.toString();
                                      educationEmpty = false;
                                    });
                                  },
                                  items: educationList
                                      .map((description, value) {
                                        return MapEntry(
                                            description,
                                            DropdownMenuItem<String>(
                                              value: description,
                                              child: Text(value).tr(),
                                            ));
                                      })
                                      .values
                                      .toList(),
                                ),
                              ),
                            ),
                            CustomInputDecoration().errorBox(educationEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_placeOfStudy.tr(), isFieldRequired: false),
                            TextField(
                              decoration: CustomInputDecoration(
                                hintText:
                                    (widget.userProfileData.placeOfStudy == null)
                                        ? ""
                                        : widget.userProfileData.placeOfStudy!,
                              ).GetDecoration(),
                              controller: _studyPlaceTextController,
                            ),
                            // CustomInputDecoration().errorBox(placeOfStudy),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_placeOfWork.tr()),
                            TextField(
                              decoration: CustomInputDecoration(
                                hintText:
                                    (widget.userProfileData.placeOfWork != null)
                                        ? widget.userProfileData.placeOfWork!
                                        : "",
                              ).GetDecoration(),
                              controller: _workPlaceTextController,
                            ),
                            CustomInputDecoration().errorBox(placeOfWorkEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_workPosition.tr(), isFieldRequired: false),
                            TextField(
                              decoration: CustomInputDecoration(
                                hintText:
                                    (widget.userProfileData.workPosition != null)
                                        ? widget.userProfileData.workPosition!
                                        : "",
                              ).GetDecoration(),
                              controller: _workPositionTextController,
                            ),
                            // CustomInputDecoration().errorBox(workPosition),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_maritalStatus.tr()),
                            InputDecorator(
                              decoration: CustomInputDecoration().GetDecoration(),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text(
                                      (widget.userProfileData.maritalStatus == null)
                                          ? LocaleKeys.common_setMaritalStatus.tr()
                                          : familyState[widget
                                                  .userProfileData.maritalStatus]!
                                              .tr()),
                                  //const Text('Выберите Ваше семейное положение'),
                                  isDense: true,
                                  onChanged: (val) {
                                    setState(() {
                                      widget.userProfileData.maritalStatus =
                                          val.toString();
                                      familyStateEmpty = false;
                                    });
                                  },
                                  items: familyState
                                      .map((description, value) {
                                        return MapEntry(
                                            description,
                                            DropdownMenuItem<String>(
                                              value: description,
                                              child: Text(value).tr(),
                                            ));
                                      })
                                      .values
                                      .toList(),
                                ),
                              ),
                            ),
                            CustomInputDecoration().errorBox(familyStateEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_faith.tr(), isFieldRequired: false),
                            InputDecorator(
                              decoration: CustomInputDecoration().GetDecoration(),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text((widget.userProfileData.typeReligion ==
                                          null)
                                      ? LocaleKeys.user_faith.tr()
                                      : faithState[
                                              widget.userProfileData.typeReligion]!
                                          .tr()),
                                  //const Text('Выберите Ваше семейное положение'),
                                  isDense: true,
                                  onChanged: (val) {
                                    setState(() {
                                       if (val == "notSelected") {
                                         widget.userProfileData.typeReligion = null;
                                         faithStateEmpty = true;
                                       } else {
                                         widget.userProfileData.typeReligion =
                                             val;
                                         faithStateEmpty = false;
                                       }
                                    });
                                  },
                                  items: faithState
                                      .map((description, value) {
                                        return MapEntry(
                                            description,
                                            DropdownMenuItem<String>(
                                              value: description,
                                              child: Text(value).tr(),
                                            ));
                                      })
                                      .values
                                      .toList(),
                                ),
                              ),
                            ),
                            // CustomInputDecoration().errorBox(faithStateEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_canons.tr()),
                            InputDecorator(
                              decoration: CustomInputDecoration().GetDecoration(),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  hint: Text((widget.userProfileData
                                                  .observeIslamCanons ==
                                              null)
                                          ? LocaleKeys.user_canons.tr()
                                          : provider.isMale
                                              ? observantOfTheCanonsMaleState[widget
                                                      .userProfileData
                                                      .observeIslamCanons]!
                                                  .tr()
                                              : observantOfTheCanonsFemaleState[
                                                  widget.userProfileData
                                                      .observeIslamCanons]!)
                                      .tr(),
                                  //const Text('Выберите Ваше семейное положение'),
                                  isDense: true,
                                  onChanged: (val) {
                                    setState(() {
                                      widget.userProfileData.observeIslamCanons =
                                          val.toString();
                                      canonsStateEmpty = false;
                                    });
                                  },
                                  items: provider.isMale
                                      ? observantOfTheCanonsMaleState
                                          .map((description, value) {
                                            return MapEntry(
                                                description,
                                                DropdownMenuItem<String>(
                                                  value: description,
                                                  child: Text(value).tr(),
                                                ));
                                          })
                                          .values
                                          .toList()
                                      : observantOfTheCanonsFemaleState
                                          .map((description, value) {
                                            return MapEntry(
                                                description,
                                                DropdownMenuItem<String>(
                                                  value: description,
                                                  child: Text(value).tr(),
                                                ));
                                          })
                                          .values
                                          .toList(),
                                ),
                              ),
                            ),
                            CustomInputDecoration().errorBox(canonsStateEmpty),

                            CustomInputDecoration().subtitleText(
                                LocaleKeys.user_haveChildren_title.tr()),
                            FormField<String>(
                                builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: CustomInputDecoration().GetDecoration(),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: widget.userProfileData.haveChildren ==
                                            null
                                        ? Text(
                                            LocaleKeys.user_haveChildren_hint.tr())
                                        : (widget.userProfileData.haveChildren ==
                                                true
                                            ? Text(
                                                LocaleKeys.childrenState_yes.tr())
                                            : Text(
                                                LocaleKeys.childrenState_no.tr())),
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        widget.userProfileData
                                            .haveChildren = (newValue ==
                                                LocaleKeys.childrenState_yes.tr())
                                            ? true
                                            : false;
                                        childrenStateEmpty = false;
                                        state.didChange(newValue);
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
                              );
                            }),
                            CustomInputDecoration().errorBox(childrenStateEmpty),

                            CustomInputDecoration()
                                .subtitleText(LocaleKeys.user_badHabits.tr(), isFieldRequired: false),
                            Visibility(
                              visible: isBadHabitsSwitchOn == false,
                              child: CustomizableMultiselectField(
                                decoration: CustomInputDecoration().GetDecoration(),
                                customizableMultiselectWidgetOptions:
                                    CustomizableMultiselectWidgetOptions(
                                  chipShape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.red, width: 1),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  hintText:
                                      Text(LocaleKeys.common_chooseOptions.tr()),
                                ),
                                customizableMultiselectDialogOptions:
                                    CustomizableMultiselectDialogOptions(
                                        okButtonLabel: LocaleKeys.common_confirm.tr(),
                                        cancelButtonLabel: LocaleKeys.common_cancel.tr(),
                                        enableSearchBar: false),
                                dataSourceList: [
                                  DataSource<String>(
                                    dataList: GlobalStrings.getBadHabits(),
                                    valueList: widget.userProfileData.badHabits ?? [],
                                    options: DataSourceOptions(
                                      valueKey: 'value',
                                      labelKey: 'label',
                                    ),
                                  ),
                                ],
                                onChanged: (List<List<dynamic>> value) {
                                  badHabbitsEmpty = false;
                                  widget.userProfileData.badHabits = [];
                                  for (int i = 0; i < value[0].length; i++) {
                                    widget.userProfileData.badHabits!
                                        .add(value[0][i]);
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                            CustomSwitcher(
                              switchValue: isBadHabitsSwitchOn,
                              label: LocaleKeys.badHabbits_missing.tr(),
                              valueChanged: (value) {
                                isBadHabitsSwitchOn = isBadHabitsSwitchOn == false;
                                if (isBadHabitsSwitchOn == true) {
                                  widget.userProfileData.badHabits = [];
                                  // widget.userProfileData.badHabits!.add("other");
                                }
                                setState(() {});
                              },
                            ),
                            // CustomInputDecoration().errorBox(badHabbitsEmpty),
                            const SizedBox(height: 24),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:const Color.fromARGB(255, 00, 0xcf, 0x91), 
                                      fixedSize: const Size(double.infinity, 56),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: Text(
                                      LocaleKeys.common_confirm.tr(),
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.rubik(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: const Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      //widget.userProfileData.returnUserData();
                                      if (updateUserData() == false) {
                                        debugPrint("have errors");
                                        return;
                                      }
                                      widget.userProfileData.returnUserData();
                                      debugPrint("check");
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              RegistrationAddInterestTagsScreen(
                                                  widget.userProfileData),
                                          transitionDuration: const Duration(seconds: 0),
                                        ),
                                      );
                                    })),
                            const SizedBox(height: 24),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  String translateNationName(String str) {
    try {
      if (context.locale.languageCode == "en") {
        str = nationalityListEn[nationalityList.indexOf(str)];
      }
      return str;
    } catch (err) {
      return str;
    }
  }

  List<String> getNationalityy(String str) {
    List<String> finded = <String>[];
    if (context.locale.languageCode == "en") {
      for (int i = 0; i < nationalityListEn.length; i++) {
        if (nationalityListEn[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(nationalityList[i]);
        }
      }
    } else {
      for (int i = 0; i < nationalityList.length; i++) {
        if (nationalityList[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(nationalityList[i]);
        }
      }
    }
    return finded;
  }

  String translateCountryName(String str) {
    try {
      if (context.locale.languageCode == "en") {
        str = countryListEn[countryList.indexOf(str)];
      }
      return str;
    } catch (err) {
      return str;
    }
  }

  List<String> getCountry(String str) {
    List<String> finded = <String>[];
    if (context.locale.languageCode == "en") {
      for (int i = 0; i < countryListEn.length; i++) {
        if (countryListEn[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(countryList[i]);
        }
      }
    } else {
      for (int i = 0; i < countryList.length; i++) {
        if (countryList[i].toLowerCase().contains(str.toLowerCase())) {
          finded.add(countryList[i]);
        }
      }
    }
    return finded;
  }
//==============================================================================

  bool updateUserData() {
    bool retVal = false;
    if (_firstNameTextController.text != "") {
      widget.userProfileData.firstName = _firstNameTextController.text;
    } else {
      firstNameEmpty = true;
    }

    if (_lastNameTextController.text != "") {
      widget.userProfileData.lastName = _lastNameTextController.text;
    } else {
      lastNameEmpty = true;
    }

    widget.userProfileData.placeOfStudy = _studyPlaceTextController.text;
    // if (_studyPlaceTextController.text != "") {
    //   widget.userProfileData.placeOfStudy = _studyPlaceTextController.text;
    // }else {
    //   placeOfStudy = true;
    // }

    if (_workPlaceTextController.text != "") {
      widget.userProfileData.placeOfWork = _workPlaceTextController.text;
    }else {
      placeOfWorkEmpty = true;
    }

    widget.userProfileData.workPosition = _workPositionTextController.text;
    // if (_workPositionTextController.text != "") {
    //   widget.userProfileData.workPosition = _workPositionTextController.text;
    // }else {
    //   workPosition = true;
    // }

    debugPrint(widget.userProfileData.firstName);

    photoEmpty = (widget.userProfileData.images == null ||
        widget.userProfileData.images!.isEmpty);
    birthDateEmpty = (widget.userProfileData.birthDate == null);
    countryEmpty = (widget.userProfileData.country == null);
    cityEmpty = (widget.userProfileData.city == null);

    // phoneNumberEmpty = (widget.userProfileData.contactPhoneNumber == null);
    educationEmpty = (widget.userProfileData.education == null);

    familyStateEmpty = (widget.userProfileData.maritalStatus == null);
    genderEmpty = (widget.userProfileData.gender == null);
    childrenStateEmpty = (widget.userProfileData.haveChildren == null);

    // nationalityEmpty = (widget.userProfileData.nationality == null);
    // placeOfStudy = (widget.userProfileData.placeOfStudy == null);

    placeOfWorkEmpty = (widget.userProfileData.placeOfWork == null);
    // workPosition = (widget.userProfileData.workPosition == null);

    // faithStateEmpty = (widget.userProfileData.typeReligion == null);
    canonsStateEmpty = (widget.userProfileData.observeIslamCanons == null);

    if (widget.userProfileData.badHabits != null) {
      // badHabbitsEmpty = widget.userProfileData.badHabits!.isEmpty;
    } else {
      // widget.userProfileData.badHabits = [];
    }
    // debugPrint(widget.userProfileData.badHabits.toString());

    if (isBadHabitsSwitchOn) {
      widget.userProfileData.isBadHabitsFilled = true;
    } else {
      if (widget.userProfileData.badHabits?.isNotEmpty ?? false) {
        widget.userProfileData.isBadHabitsFilled = true;
      } else {
        widget.userProfileData.isBadHabitsFilled = false;
      }
    }

    retVal = photoEmpty ||
        firstNameEmpty ||
        lastNameEmpty ||
        birthDateEmpty ||
        countryEmpty ||
        cityEmpty ||
        canonsStateEmpty ||
        // faithStateEmpty ||
        placeOfStudyEmpty ||
        placeOfWorkEmpty ||
        workPositionEmpty ||
        phoneNumberEmpty ||
        educationEmpty ||
        familyStateEmpty ||
        childrenStateEmpty ||
        genderEmpty; // ||
    //badHabbitsEmpty;
    setState(() {});
    return retVal == false;
  }

  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _studyPlaceTextController =
      TextEditingController();
  final TextEditingController _workPlaceTextController =
      TextEditingController();
  final TextEditingController _workPositionTextController =
      TextEditingController();
  final TextEditingController _nonRussianCountryController =
      TextEditingController();

  bool photoEmpty = false;
  bool firstNameEmpty = false;
  bool lastNameEmpty = false;
  bool birthDateEmpty = false;
  bool countryEmpty = false;
  bool cityEmpty = false;
  bool phoneNumberEmpty = false;
  bool educationEmpty = false;
  bool familyStateEmpty = false;
  bool faithStateEmpty = false;
  bool canonsStateEmpty = false;
  bool childrenStateEmpty = false;
  bool badHabbitsEmpty = false;
  bool genderEmpty = false;
  bool nationalityEmpty = false;
  bool placeOfStudyEmpty = false;
  bool placeOfWorkEmpty = false;
  bool workPositionEmpty = false;

  final String initialCountry = 'RU';
  late PhoneNumber number;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controller = TextEditingController();

  Widget userPhoneNumber() {
    number = PhoneNumber(
        phoneNumber: widget.userProfileData.contactPhoneNumber, isoCode: "RU");
    return Form(
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(255, 218, 216, 215),
              width: 1, //                   <--- border width here
            ),
            borderRadius: const BorderRadius.all(
                Radius.circular(10.0) //                 <--- border radius here
                ),
          ),
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InternationalPhoneNumberInput(
                  inputBorder: InputBorder.none,
                  searchBoxDecoration: InputDecoration(
                    hintText: LocaleKeys.common_phoneNumberHint.tr(),
                  ),
                  onInputChanged: (PhoneNumber temp) {
                    number = temp;
                    //debugPrint(number.toString());
                  },
                  onInputValidated: (bool value) {
                    if (value == true) {
                      debugPrint(number.toString());
                      widget.userProfileData.contactPhoneNumber = number.phoneNumber.toString();
                    }
                  },
                  selectorConfig: const SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  hintText: number.phoneNumber,
                  maxLength: 13,
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  //inputBorder: OutlineInputBorder(),
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                    widget.userProfileData.contactPhoneNumber =
                        number.phoneNumber.toString();
                  },
                ),
              ],
            ),
          )),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  final double barHeight = 72.0;
  double getStatusbarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(barHeight + getStatusbarHeight(context)),
        child: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              statusBarColor: Color.fromARGB(255, 0xf5, 0xf5, 0xf5),
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            height: barHeight + getStatusbarHeight(context),
            padding: EdgeInsets.only(top: getStatusbarHeight(context), left: 8),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 0.7,
                  child: IconButton(
                      splashRadius: 34.0,
                      iconSize: 32.0,
                      padding: const EdgeInsets.all(0),
                      icon: Image.asset("assets/icons/arrow_back.png"),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const WelcomeScreen(),
                          ),
                          (route) => false,
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  //TODO: + getStatusbarHeight(context)
  Size get preferredSize => Size.fromHeight(barHeight + 0);
}

class _Gender extends StatefulWidget {
  _Gender(this.userProfileData, this.provider, {Key? key}) : super(key: key);
  UserProfileData userProfileData;
  GenderProvider provider;
  @override
  State<_Gender> createState() => _GenderState();
}

class _GenderState extends State<_Gender> {
  Color activeColor = const Color.fromARGB(255, 00, 207, 145);
  Color passiveColor = Colors.white;

  bool isMale = false;
  bool isFemale = false;

  @override
  Widget build(BuildContext context) {
    //widget.userProfileData.gender = "male";
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
          height: 60,
          padding: const EdgeInsets.all(3.5),
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 00, 207, 145),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: InkWell(
                      onTap: () {
                        widget.provider.SetGender(true);
                        isMale = true;
                        isFemale = false;
                        widget.userProfileData.gender = "male";
                        debugPrint(widget.userProfileData.gender!);
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: (isMale == isFemale)
                                ? passiveColor
                                : (isMale == true ? activeColor : passiveColor),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                topLeft: Radius.circular(12))),
                        child: Text(LocaleKeys.user_gender.tr(gender: "male"),
                            style: TextStyle(
                              color: (isMale == isFemale)
                                  ? activeColor
                                  : (isMale == true
                                      ? passiveColor
                                      : activeColor),
                              fontSize: 17,
                            )),
                      ))),
              const VerticalDivider(
                width: 4,
              ),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        widget.provider.SetGender(false);
                        isMale = false;
                        isFemale = true;
                        widget.userProfileData.gender = "female";
                        debugPrint(widget.userProfileData.gender!);
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: (isMale == isFemale)
                                ? passiveColor
                                : (isFemale == true
                                    ? activeColor
                                    : passiveColor),
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: Text(LocaleKeys.user_gender.tr(gender: "female"),
                            style: TextStyle(
                                color: (isMale == isFemale)
                                    ? activeColor
                                    : (isFemale == true
                                        ? passiveColor
                                        : activeColor),
                                fontSize: 17)),
                      ))),
            ],
          )),
    );
  }
}
