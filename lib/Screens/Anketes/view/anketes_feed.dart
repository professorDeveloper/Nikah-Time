part of '../anketes.dart';

UserFilter userFilter = UserFilter();
TextEditingController textEditingController = TextEditingController();
AnketesBloc? anketesBloc;

class AnketesFeedScreen extends StatefulWidget {
  const AnketesFeedScreen(this._userProfileData, {super.key});

  final UserProfileData _userProfileData;

  @override
  State<AnketesFeedScreen> createState() => AnketesFeedScreenState();
}

class AnketesFeedScreenState extends State<AnketesFeedScreen>
    with TickerProviderStateMixin {
  bool isOnline = false;
  bool show = false;

  void likeAnimation(dynamic e) {
    setState(() {
      show = true;
    });
  }

  @override
  void initState() {
    super.initState();

    userFilter = widget._userProfileData.filter;
  }

  @override
  void dispose() {
    show = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AnketesBloc(),
      child: Builder(
        builder: (BuildContext context) {
          return BlocBuilder<AnketesBloc, AnketesState>(
            builder: (context, state) {
              state as AnketesInitial;
              anketesBloc = context.read<AnketesBloc>();

              return RefreshIndicator(
                  onRefresh: () async {
                    context.read<AnketesBloc>().add(const OnRefresh());
                  },
                  child: _mainWidget(context, state));
            },
          );
        },
      ),
    );
  }

  Widget _mainWidget(BuildContext context, AnketesInitial state) {
    return Scaffold(
      appBar: (state.isSearchName)
          ? searchAppBar(context, textEditingController: textEditingController,
              onSubmitAction: (value) {
              context
                  .read<AnketesBloc>()
                  .add(SetupSearchName(searchValue: value));
              context.read<AnketesBloc>().add(const LoadAnketas());
              textEditingController.selection = TextSelection.collapsed(
                  offset: textEditingController.text.length);
              // TextSelection.fromPosition(TextPosition(
              //     offset: textEditingController.text.length));
            }, onClearAction: () {
              textEditingController.clear();
              context.read<AnketesBloc>().add(const ClearSearchName());
            }, onBackAction: () {
              context.read<AnketesBloc>().add(const SwitchSearchMode());
              anketesBloc!.add(const LoadAnketas());
            })
          : buildSimpleAppBar(context),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: bodyWidget(context, state: state),
          ),
          SizedBox(
            width: double.infinity,
            child: Builder(builder: (context) {
              if (show) {
                show = false;
                return LikeAnimationWidget(true);
              } else {
                return const SizedBox.shrink();
              }
            }),
          )
        ],
      ),
    );
  }

  AppBar buildSimpleAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          LocaleKeys.usersScreen_tittle,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: const Color.fromARGB(255, 33, 33, 33),
          ),
        ).tr(),
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: iconDecoration(),
              child: IconButton(
                  splashRadius: 1,
                  iconSize: 20.0,
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 117, 116, 115),
                  ),
                  onPressed: () {
                    context.read<AnketesBloc>().add(const SwitchSearchMode());
                  }),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 32,
              height: 32,
              decoration: iconDecoration(),
              child: IconButton(
                  splashRadius: 1,
                  iconSize: 20.0,
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: Color.fromARGB(255, 117, 116, 115),
                  ),
                  onPressed: () {
                    showFilters(context);
                  }),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 32,
              height: 32,
              decoration: iconDecoration(),
              child: IconButton(
                  splashRadius: 1,
                  iconSize: 20.0,
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.vertical_split,
                    color: Color.fromARGB(255, 117, 116, 115),
                  ),
                  onPressed: () {
                    context.read<AnketesBloc>().add(const SwitchShowMode());
                  }),
            ),
          ],
        ),
      ]),
      automaticallyImplyLeading: false,
    );
  }

  PreferredSizeWidget searchAppBar(BuildContext context,
      {required TextEditingController textEditingController,
      required Function onBackAction,
      required Function onClearAction,
      required Function onSubmitAction}) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: iconDecoration(),
              child: IconButton(
                  splashRadius: 1,
                  iconSize: 20.0,
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color.fromARGB(255, 117, 116, 115),
                  ),
                  onPressed: () {
                    onBackAction();
                  }),
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
                flex: 1,
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(0xfb, 0xfb, 0xff, 1),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      border: Border.all(
                        color: Colors.green,
                      )),
                  child: Center(
                    child: TextField(
                      onChanged: (value) {
                        onSubmitAction(value);
                      },
                      controller: textEditingController,
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 14, height: 1),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(0x5A, 0x5A, 0xEE, 0),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            onClearAction();
                          },
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Color.fromARGB(255, 117, 116, 115),
                          ),
                        ),
                        hintText: LocaleKeys.usersScreen_searchHint.tr(),
                        hintStyle: const TextStyle(
                            color: Color.fromRGBO(110, 122, 145, 1),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelStyle: const TextStyle(
                          color: Color.fromRGBO(110, 122, 145, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        border: const UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0xfb, 0xfb, 0xff, 1)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0xfb, 0xfb, 0xff, 1)),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0xfb, 0xfb, 0xff, 1)),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0xff, 0x45, 0x67, 1)),
                        ),
                        focusedErrorBorder: const UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0xff, 0x45, 0x67, 1)),
                        ),
                      ),
                      onSubmitted: (value) {
                        // onSubmitAction(value);
                      },
                    ),
                  ),
                )),
            /*const SizedBox(
              width: 8,
            ),
            Container(
              width: 32,
              height: 32,
              decoration: iconDecoration(),
              child: IconButton(
                  splashRadius: 1,
                  iconSize: 20.0,
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(
                    Icons.vertical_split,
                    color: Color.fromARGB(255, 117, 116, 115),
                  ),
                  onPressed: () {
                    context.read<AnketesBloc>().add(const SwitchShowMode());
                  }),
            ),*/
          ]),
      automaticallyImplyLeading: false,
    );
  }

  Widget bodyWidget(
    BuildContext context, {
    required AnketesInitial state,
  }) {
    if (state.anketas.isEmpty) {
      if (state.screenState == AnketasScreenState.preload) {
        context.read<AnketesBloc>().add(const LoadAnketas());
        return Padding(
          padding: const EdgeInsets.all(16),
          child: waitBox(),
        );
      } else if (state.isSearchName && state.searchName == null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Text(
              LocaleKeys.usersScreen_searchMainHint.tr(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: const Color.fromRGBO(0, 0xcf, 0x91, 1),
              ),
            ),
          ),
        );
      } else if (state.isSearchName) {
        return Center(
          child: Text(
            LocaleKeys.usersScreen_searchNotFound.tr(),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: const Color.fromRGBO(0, 0xcf, 0x91, 1),
            ),
          ),
        );
      } else {
        return Center(
          child: Text(
            LocaleKeys.usersScreen_notFound.tr(),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: const Color.fromRGBO(0, 0xcf, 0x91, 1),
            ),
          ),
        );
      }
    }

    if (state.isVertical) {
      return FeedVerticalGridView(
        userProfileData: widget._userProfileData,
        anketas: state.anketas,
        likeFunction: (bool show) async {
          debugPrint("press");
          if (show) {
            likeAnimation("like pressed");
          }
        },
        uploadMore: () {
          context.read<AnketesBloc>().add(const LoadAnketas());
        },
        appendix:
            (context.read<AnketesBloc>().state as AnketesInitial).screenState ==
                    AnketasScreenState.noMoreItem
                ? null
                : const CircularProgressIndicator(),
      );
    }

    return FeedHorizontalListView(
      userProfileData: widget._userProfileData,
      anketas: state.anketas,
      likeFunction: (bool show) async {
        debugPrint("press");
        if (show) {
          likeAnimation("like pressed");
        }
      },
      uploadMore: () {
        context.read<AnketesBloc>().add(const LoadAnketas());
      },
    );
  }

  Widget waitBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Color.fromRGBO(0, 0xcf, 0x91, 1)),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          LocaleKeys.usersScreen_loading.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: const Color.fromRGBO(0, 0xcf, 0x91, 1),
          ),
        ),
      ],
    );
  }

  void showFilters(BuildContext contextBloc) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        verticalDirection: VerticalDirection.up,
                        children: [
                          Text(
                            LocaleKeys.filters_tittle.tr(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  userFilter = UserFilter();
                                  contextBloc
                                      .read<AnketesBloc>()
                                      .add(const ResetAnketas());
                                  Navigator.pop(context);
                                },
                                child: RichText(
                                  textAlign: TextAlign.end,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: LocaleKeys.filters_reset.tr(),
                                        style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: const Color.fromARGB(
                                              255, 0, 207, 145),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  LocaleKeys.filters_close,
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color:
                                        const Color.fromARGB(255, 0, 207, 145),
                                  ),
                                ).tr(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const _AgeSlide(),
                      // const SizedBox(height: 16),
                      /*Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  LocaleKeys.filters_isOnline,
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: const Color.fromARGB(255, 33, 33, 33),
                                  ),
                                ).tr(),
                                BottomSheetSwitch(
                                  valueChanged: (value) {
                                    isOnline = !isOnline;
                                    userFilter.isOnline = isOnline;
                                  },
                                  switchValue: (contextBloc.read<AnketesBloc>().state as AnketesInitial).filterItem?.isOnline ?? false,
                                ),
                              ],
                            ),*/
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 18),
                        width: double.infinity,
                        child: MaterialButton(
                          height: 56,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 0, 207, 145),
                            ),
                          ),
                          child: const Text(
                            LocaleKeys.filters_complicatedFilter,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 207, 145),
                            ),
                          ).tr(),
                          onPressed: () {
                            widget._userProfileData.filter = userFilter;
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => ExpandedFilter(
                                  userFilter,
                                  widget._userProfileData.gender ?? "male",
                                ),
                                transitionDuration: const Duration(seconds: 0),
                              ),
                            ).then((value) {
                              Navigator.pop(context);
                              contextBloc
                                  .read<AnketesBloc>()
                                  .add(LoadFilter(filter: value));
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 207, 145),
                            elevation: 0,
                            fixedSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          child: const Text(
                            LocaleKeys.filters_find,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ).tr(),
                          onPressed: () {
                            contextBloc
                                .read<AnketesBloc>()
                                .add(LoadFilter(filter: userFilter));
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration iconDecoration() {
    return BoxDecoration(
      border: Border.all(
        width: 1.0,
        color: const Color.fromARGB(255, 218, 216, 215),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    );
  }
}

class _AgeSlide extends StatefulWidget {
  const _AgeSlide();

  @override
  State<_AgeSlide> createState() => _AgeSlideState();
}

class _AgeSlideState extends State<_AgeSlide> {
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

  double minValue = 18;
  double maxValue = 99;

  double _prevStartValue = 18;
  double _prevEndValue = 99;

  _AgeSlideState() {
    startController =
        TextEditingController(text: userFilter.minAge.toStringAsFixed(0));
    endController =
        TextEditingController(text: userFilter.maxAge.toStringAsFixed(0));
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
    if (value > userFilter.maxAge) {
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
    if (value < userFilter.minAge) {
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
        userFilter.minAge = double.parse(startController.text).roundToDouble();
      });
    }
    //print("First text field: ${startController.text}");
  }

  _setEndValue() {
    if (_isStartValueValid(startController.text) &&
        _isEndValueValid(endController.text)) {
      setState(() {
        userFilter.maxAge = double.parse(endController.text).roundToDouble();
      });
    }
    //print("Second text field: ${endController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  textInputAction: TextInputAction.done,
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
                  controller: startController,
                  onSubmitted: (text) {
                    if (_isStartValueValid(text) == false) {
                      setState(() {
                        userFilter.minAge = _prevStartValue;
                        startController.text =
                            _prevStartValue.toStringAsFixed(0);
                      });
                    } else {
                      _prevStartValue = userFilter.minAge;
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
                  onSubmitted: (text) {
                    if (_isEndValueValid(text) == false) {
                      setState(() {
                        userFilter.maxAge = _prevEndValue;
                        endController.text = _prevEndValue.toStringAsFixed(0);
                      });
                    } else {
                      _prevEndValue = userFilter.maxAge;
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
        ageSliderItem()
      ],
    );
  }

  Widget ageSliderItem() {
    return RangeSlider(
      activeColor: const Color.fromARGB(255, 00, 0xcf, 0x91),
      values: RangeValues(userFilter.minAge, userFilter.maxAge),
      min: minValue,
      max: maxValue,
      onChanged: (RangeValues values) {
        //print(values);
        setState(() {
          userFilter.minAge = values.start.roundToDouble();
          userFilter.maxAge = values.end.roundToDouble();
          _prevStartValue = userFilter.minAge;
          _prevEndValue = userFilter.maxAge;
          startController.text =
              values.start.roundToDouble().toStringAsFixed(0);
          endController.text = values.end.roundToDouble().toStringAsFixed(0);
        });
      },
    );
  }
}

class BottomSheetSwitch extends StatefulWidget {
  const BottomSheetSwitch(
      {super.key, required this.switchValue, required this.valueChanged});

  final bool switchValue;
  final ValueChanged valueChanged;

  @override
  _BottomSheetSwitch createState() => _BottomSheetSwitch();
}

class _BottomSheetSwitch extends State<BottomSheetSwitch> {
  late bool _switchValue;

  @override
  void initState() {
    _switchValue = widget.switchValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
        value: _switchValue,
        onChanged: (bool value) {
          setState(() {
            _switchValue = value;
            widget.valueChanged(value);
          });
        });
  }
}
