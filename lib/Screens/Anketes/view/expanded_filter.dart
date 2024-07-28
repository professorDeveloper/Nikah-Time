part of '../anketes.dart';

class ExpandedFilter extends StatefulWidget {
  ExpandedFilter(this._userFilter, this.gender, {super.key});

  UserFilter _userFilter;
  String gender;

  @override
  State<ExpandedFilter> createState() => _ExpandedFilterState();
}

class _ExpandedFilterState extends State<ExpandedFilter> {
  bool isOpened = false;
  bool haveBadHabitsSwitch = false;

  @override
  void initState() {
    var badHabits = widget._userFilter.badHabits;
    bool haveBadHabits = true;
    if (badHabits == null) {
      haveBadHabits = false;
    } else {
      if (badHabits.isNotEmpty && badHabits[0].isEmpty) {
        badHabits = [];
      }
      haveBadHabits = badHabits.isNotEmpty;
    }
    haveBadHabitsSwitch = haveBadHabits;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userFilter = widget._userFilter;
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
                  CustomInputDecoration().titleText(
                      LocaleKeys.filters_complicatedFilterTittle.tr()),
                  CustomInputDecoration()
                      .subtitleText(LocaleKeys.user_age.tr()),
                  _FilterAgeSlide(18, 99, widget._userFilter),
                  // religion
                CustomInputDecoration().subtitleText('religionSubtitle'.tr()),
         InputDecorator(
  decoration: CustomInputDecoration().GetDecoration(),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
  value: userFilter.religionId != null
      ? userFilter.religionId == 1
          ? 'Islam'
          : userFilter.religionId == 2
              ? 'Christianity'
              : userFilter.religionId == 3
                  ? 'Judaism'
                  : 'Islam'
      : 'Islam',
  isDense: true,
  onChanged: (val) {
    setState(() {
      switch (val) {
        case 'Islam':
          userFilter.religionId = 1;
          break;
        case 'Christianity':
          userFilter.religionId = 2;
          break;
        case 'Judaism':
          userFilter.religionId = 3;
          break;
      }
    });
  },
  items: [
    DropdownMenuItem<String>(
      value: 'Islam',
      child: Text('Islam'.tr()),
    ),
    DropdownMenuItem<String>(
      value: 'Christianity',
      child: Text('Christianity'.tr()),
    ),
    DropdownMenuItem<String>(
      value: 'Judaism',
      child: Text('Judaism'.tr()),
    ),
  ],
),

  ),
),

                  CustomInputDecoration()
                      .subtitleText(LocaleKeys.user_country.tr()),
                  DropdownFormField<String>(
                    decoration: CustomInputDecoration().GetDecoration(),
                    onSaved: (dynamic str) {
                      userFilter.country = "$str";
                      setState(() {});
                    },
                    onChanged: (dynamic item) {
                      userFilter.country = "$item";
                      setState(() {});
                    },
                    displayItemFn: (dynamic str) => Text(
                      translateCountryName(userFilter.country ?? ""),
                      style: const TextStyle(fontSize: 16),
                    ),
                    findFn: (dynamic str) async => getCountry(str),
                    dropdownItemFn: (dynamic item, int position, bool focused,
                            bool selected, Function() onTap) =>
                        ListTile(
                      title: Text(translateCountryName(item)),
                      tileColor: focused
                          ? const Color.fromARGB(20, 0, 0, 0)
                          : Colors.transparent,
                      onTap: onTap,
                    ),
                  ),

                  CustomInputDecoration()
                      .subtitleText(LocaleKeys.user_city.tr()),
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
                      onSubmitted: (value) {
                        userFilter.city = _nonRussianCountryController.text;
                      },
                    ),
                  ),
                  CustomInputDecoration()
                      .subtitleText(LocaleKeys.user_nationality.tr()),
                  DropdownFormField<String>(
                    decoration: CustomInputDecoration().GetDecoration(),
                    onSaved: (dynamic str) {},
                    onChanged: (dynamic item) {
                      userFilter.nationality = item;
                    },
                    displayItemFn: (dynamic item) => Text(
                      translateNationName(userFilter.nationality ??
                          LocaleKeys.nationalityState_notSelected.tr()),
                      style: const TextStyle(fontSize: 16),
                    ),
                    findFn: (dynamic str) async => getNationalityList(str),
                    dropdownItemFn: (dynamic item, int position, bool focused,
                            bool selected, Function() onTap) =>
                        ListTile(
                      title: Text(translateNationName(item)),
                      tileColor: focused
                          ? const Color.fromARGB(20, 0, 0, 0)
                          : Colors.transparent,
                      onTap: onTap,
                    ),
                  ),
                  CustomInputDecoration()
                      .subtitleText(LocaleKeys.user_education.tr()),
                  InputDecorator(
                    decoration: CustomInputDecoration().GetDecoration(),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text((userFilter.education == null ||
                                userFilter.education == "")
                            ? LocaleKeys.filters_educationTitle.tr() //
                            : educationList[userFilter.education!]!.tr()),
                        isDense: true,
                        onChanged: (val) {
                          userFilter.education = val;
                          setState(() {});
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
                  CustomInputDecoration()
                      .subtitleText(LocaleKeys.user_maritalStatus.tr()),
                  InputDecorator(
                    decoration: CustomInputDecoration().GetDecoration(),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text((userFilter.maritalStatus == null ||
                                userFilter.maritalStatus == "")
                            ? LocaleKeys.filters_maritalStatusTitle.tr()
                            : familyState[userFilter.maritalStatus!]!.tr()),
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
                                  ));
                            })
                            .values
                            .toList(),
                      ),
                    ),
                  ),
                  CustomInputDecoration()
                      .subtitleText(LocaleKeys.user_faith.tr()),
                  InputDecorator(
                    decoration: CustomInputDecoration().GetDecoration(),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text((userFilter.typeReligion == null ||
                                userFilter.typeReligion == "")
                            ? LocaleKeys.user_faith.tr()
                            : faithState[userFilter.typeReligion!]!.tr()),
                        isDense: true,
                        onChanged: (val) {
                          setState(() {
                            userFilter.typeReligion = val;
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
                  CustomInputDecoration()
                      .subtitleText(LocaleKeys.user_canons.tr()),
                  InputDecorator(
                    decoration: CustomInputDecoration().GetDecoration(),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text((userFilter.observeIslamCanons == null ||
                                userFilter.observeIslamCanons == "")
                            ? LocaleKeys.user_canons.tr()
                            : widget.gender == 'male'
                                ? observantOfTheCanonsMaleState[
                                        userFilter.observeIslamCanons!]!
                                    .tr()
                                : observantOfTheCanonsFemaleState[
                                        userFilter.observeIslamCanons!]!
                                    .tr()),
                        isDense: true,
                        onChanged: (val) {
                          setState(() {
                            userFilter.observeIslamCanons = val;
                          });
                        },
                        items: widget.gender == 'male'
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
                  CustomInputDecoration()
                      .subtitleText(LocaleKeys.user_haveChildren_title.tr()),
                  InputDecorator(
                    decoration: CustomInputDecoration(
                            hintText: LocaleKeys.user_haveChildren_hint.tr())
                        .GetDecoration(),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<bool>(
                        hint: Text((userFilter.haveChildren == null)
                            ? LocaleKeys.user_haveChildren_hint.tr()
                            : ""),
                        value: userFilter.haveChildren,
                        isDense: true,
                        onChanged: (newValue) {
                          setState(() {
                            userFilter.haveChildren = newValue;
                          });
                        },
                        items: chldrnState
                            .map((description, value) {
                              return MapEntry(
                                  description,
                                  DropdownMenuItem<bool>(
                                    value: description,
                                    child: Text(value).tr(),
                                  ));
                            })
                            .values
                            .toList(),
                      ),
                    ),
                  ),
                  CustomInputDecoration()
                      .subtitleText(LocaleKeys.user_badHabits.tr()),
                  Visibility(
                    visible: haveBadHabitsSwitch,
                    child: CustomizableMultiselectField(
                      decoration: CustomInputDecoration().GetDecoration(),
                      customizableMultiselectWidgetOptions:
                          CustomizableMultiselectWidgetOptions(
                        chipShape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        hintText: Text(LocaleKeys.common_selectOptions.tr()),
                      ),
                      customizableMultiselectDialogOptions:
                          CustomizableMultiselectDialogOptions(
                              okButtonLabel: LocaleKeys.common_confirm.tr(),
                              cancelButtonLabel: LocaleKeys.common_cancel.tr(),
                              enableSearchBar: false),
                      dataSourceList: [
                        DataSource<String>(
                          dataList: GlobalStrings.getBadHabits(),
                          valueList: widget._userFilter.badHabits ?? [],
                          options: DataSourceOptions(
                            valueKey: 'value',
                            labelKey: 'label',
                          ),
                        ),
                      ],
                      onChanged: ((List<List<dynamic>> value) {
                        userFilter.badHabits = [];
                        for (int i = 0; i < value[0].length; i++) {
                          userFilter.badHabits!.add(value[0][i]);
                        }
                      }),
                    ),
                  ),
                  CustomSwitcher(
                    switchValue: !haveBadHabitsSwitch,
                    label: LocaleKeys.badHabbits_missing.tr(),
                    valueChanged: (value) {
                      if (haveBadHabitsSwitch) {
                        debugPrint("badHabbitsSwitch == true");

                        userFilter.badHabits = [];
                        userFilter.haveBadHabbits = false;
                      } else {
                        debugPrint("badHabbitsSwitch == false");

                        userFilter.haveBadHabbits = true;
                        userFilter.badHabits = [];
                      }
                      haveBadHabitsSwitch = !haveBadHabitsSwitch;
                      setState(() {});
                    },
                  )
                ]))),
            const SizedBox(height: 8),
            Container(
                padding: const EdgeInsets.only(bottom: 24),
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromARGB(255, 00, 0xcf, 0x91),
                      elevation: 0,
                      fixedSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      LocaleKeys.filters_find.tr(),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    onPressed: () {
                      widget._userFilter = UserFilter();
                      widget._userFilter = userFilter;
                      if (widget._userFilter.badHabits == null) {
                        widget._userFilter.haveBadHabbits = false;
                      } else {
                        if (widget._userFilter.badHabits!.isEmpty) {
                          widget._userFilter.haveBadHabbits = false;
                        }
                      }

                      Navigator.pop(context, widget._userFilter);
                    })),
          ],
        ),
      ),
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

  List<String> getNationalityList(String str) {
    List<String> founded = <String>[];
    if (context.locale.languageCode == "en") {
      for (int i = 0; i < nationalityListEn.length; i++) {
        if (nationalityListEn[i].toLowerCase().contains(str.toLowerCase())) {
          founded.add(nationalityList[i]);
        }
      }
    } else {
      for (int i = 0; i < nationalityList.length; i++) {
        if (nationalityList[i].toLowerCase().contains(str.toLowerCase())) {
          founded.add(nationalityList[i]);
        }
      }
    }
    return founded;
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

  final TextEditingController _nonRussianCountryController =
      TextEditingController();
}

class _FilterAgeSlide extends StatefulWidget {
  final double minValue;
  final double maxValue;

  const _FilterAgeSlide(this.minValue, this.maxValue, this._userFilter);
  final UserFilter _userFilter;
  @override
  State<_FilterAgeSlide> createState() =>
      _FilterAgeSlideState(minValue, maxValue);
}

class _FilterAgeSlideState extends State<_FilterAgeSlide> {
  late final double minValue;
  late final double maxValue;

  late double _startValue;
  late double _endValue;

  late final startController;
  late final endController;

  late double _prevStartValue;
  late double _prevEndValue;

  _FilterAgeSlideState(
    this.minValue,
    this.maxValue,
  ) {
    _startValue = minValue;
    _endValue = maxValue;

    _prevStartValue = _startValue;
    _prevEndValue = _endValue;
  }

  @override
  void initState() {
    super.initState();

    startController = TextEditingController(
        text: widget._userFilter.minAge.toStringAsFixed(0));
    endController = TextEditingController(
        text: widget._userFilter.maxAge.toStringAsFixed(0));

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
    if (_isStartValueValid(startController.text) &&
        _isEndValueValid(endController.text)) {
      setState(() {
        _startValue = double.parse(startController.text).roundToDouble();
      });
    }
    print("First text field: ${startController.text}");
  }

  _setEndValue() {
    if (_isStartValueValid(startController.text) &&
        _isEndValueValid(endController.text)) {
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
              const Text(
                LocaleKeys.filters_from,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color.fromARGB(255, 117, 116, 115),
                ),
              ).tr(),
              const SizedBox(width: 8),
              Flexible(
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: false),
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
                    onChanged: (value) {
                      userFilter.minAge = double.parse(value);
                    },
                    controller: startController,
                    onSubmitted: (text) {
                      if (_isStartValueValid(text) == false) {
                        setState(() {
                          _startValue = _prevStartValue;
                          startController.text =
                              _prevStartValue.toStringAsFixed(0);
                        });
                      } else {
                        _prevStartValue = _startValue;
                        userFilter.minAge = double.parse(text);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                LocaleKeys.filters_to,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color.fromARGB(255, 117, 116, 115),
                ),
              ).tr(),
              const SizedBox(width: 8),
              Flexible(
                child: SizedBox(
                  height: 36,
                  child: TextField(
                    controller: endController,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: false, decimal: false),
                    onChanged: (value) {
                      userFilter.maxAge = double.parse(value);
                    },
                    onSubmitted: (text) {
                      if (_isEndValueValid(text) == false) {
                        setState(() {
                          _endValue = _prevEndValue;
                          endController.text = _prevEndValue.toStringAsFixed(0);
                        });
                      } else {
                        _prevEndValue = _endValue;
                        userFilter.maxAge = double.parse(text);
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

  Widget AgeSlider() {
    return RangeSlider(
      activeColor: const Color.fromARGB(255, 00, 0xcf, 0x91),
      values: RangeValues(_startValue, _endValue),
      min: minValue,
      max: maxValue,
      onChanged: (RangeValues values) {
        setState(() {
          userFilter.minAge = values.start.roundToDouble();
          userFilter.maxAge = values.end.roundToDouble();
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
