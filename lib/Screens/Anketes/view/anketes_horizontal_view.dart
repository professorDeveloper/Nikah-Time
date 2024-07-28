part of '../anketes.dart';

class FeedHorizontalListView extends StatefulWidget {
  FeedHorizontalListView(
      {super.key,
      required this.userProfileData,
      required this.anketas,
      this.likeFunction,
      this.uploadMore});

  UserProfileData userProfileData;
  List<UserProfileData> anketas;
  Function? likeFunction;
  Function? uploadMore;
  int lastBuildItemIndex = 0;

  @override
  State<FeedHorizontalListView> createState() => _FeedHorizontalListViewState();
}

class _FeedHorizontalListViewState extends State<FeedHorizontalListView> {
  CarouselController buttonCarouselController = CarouselController();
  final _scrollController = ScrollController();
  int lastGuestId = -1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.anketas.length > 10) {
      if (widget.lastBuildItemIndex + 2 == widget.anketas.length) {
        widget.uploadMore!();
        widget.lastBuildItemIndex = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileInitial state = context.read<ProfileBloc>().state as ProfileInitial;
    bool needPay = state.userProfileData?.userTariff == null;

    return Column(
      children: [
        CarouselSlider(
          items: widget.anketas.map((item) => userCardExpanded(item)).toList(),
          carouselController: buttonCarouselController,
          options: CarouselOptions(
              viewportFraction: 1,
              height: MediaQuery.of(context).size.height -
                  255 -
                  (Platform.isIOS ? 26 : 0),
              enableInfiniteScroll: false,
              autoPlay: false,
              enlargeCenterPage: false,
              disableCenter: true,
              onPageChanged: (index, reason) {
                swipeIndex = index;
                if (swipeIndex + 2 == widget.anketas.length) {
                  widget.uploadMore!();
                }
                setState(() {});
              }),
        ),
        Flexible(
            flex: 1,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (needPay) {
                        await showPaymentDialog(context,
                            text: LocaleKeys.common_payment_alert_titleForAction
                                .tr());
                        return;
                      }

                      debugPrint("Начать чат с пользователем №");
                      CreateChat(
                          this.context,
                          widget.userProfileData.gender ?? "",
                          widget.userProfileData.id ?? 0,
                          afterPopCallback: (chatWithLastMessage) {
                        setState(() {
                          widget.anketas[swipeIndex].isBlocked =
                              chatWithLastMessage.isChatBlocked;
                        });
                      }).createChatWithUser(widget.anketas[swipeIndex].id!);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(0),
                      fixedSize: const Size(55, 55),
                    ),
                    child: const Icon(MainPageCustomIcon.message,
                        color: Color.fromRGBO(00, 0xcf, 0x91, 1), size: 30),
                  ),
                  Visibility(
                    visible: widget.anketas[swipeIndex].isBlocked == false,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (needPay) {
                              await showPaymentDialog(context,
                                  text: LocaleKeys
                                      .common_payment_alert_titleForAction
                                      .tr());
                              return;
                            }

                            if (widget.likeFunction != null) {
                              await widget.likeFunction!(
                                  !widget.anketas[swipeIndex].inFavourite);
                            }

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String accessToken = prefs.getString("token") ?? "";

                            var response = await NetworkService()
                                .FavoritesAddUserID(accessToken,
                                    widget.anketas[swipeIndex].id!);
                            if (response.statusCode == 202) {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => CrossMatch(
                                      widget.anketas[swipeIndex],
                                      widget.userProfileData.id ?? 0,
                                      widget.userProfileData.gender ?? ""),
                                  transitionDuration:
                                      const Duration(seconds: 0),
                                ),
                              );
                            }
                            widget.anketas[swipeIndex].inFavourite =
                                widget.anketas[swipeIndex].inFavourite == false;
                            setState(() {});
                            debugPrint("Поставить лайк пользователю №");
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.only(
                              right: 8,
                            ),
                            fixedSize: const Size(55, 55),
                          ),
                          child: Icon(
                              widget.anketas[swipeIndex].inFavourite
                                  ? MainPageCustomIcon.heart
                                  : MainPageCustomIcon.heart_outlined,
                              color: Colors.red,
                              size: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }

  int swipeIndex = 0;

  Widget userCardExpanded(UserProfileData item) {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 0.0; // or something else..
      if (maxScroll - currentScroll <= delta) {
        // whatever you determine here
        if (lastGuestId != widget.anketas[swipeIndex].id) {
          if (widget.anketas[swipeIndex].id != null) {
            debugPrint("$lastGuestId ${widget.anketas[swipeIndex].id}");
            try {
              NetworkService().GuestAddUserID(
                  widget.userProfileData.accessToken!,
                  widget.anketas[swipeIndex].id!);
              lastGuestId = widget.anketas[swipeIndex].id!;
            } catch (error) {
              debugPrint(error.toString());
            }
          } else {
            debugPrint("widget.anketas[swipeIndex].id = null");
          }
        }
      }
    });

    //debugPrint("${item.about}");
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: Color.fromARGB(255, 236, 235, 235),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: Color.fromARGB(255, 236, 235, 235),
                                ),
                                height:
                                    MediaQuery.of(context).size.height / 1.5,
                                width: MediaQuery.of(context).size.width,
                                child: (item.images != null &&
                                        item.images!.isNotEmpty)
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        child: displayPhotoOrVideo(context,
                                            item.images![0].preview.toString(),
                                            items: item.images!
                                                .map((e) => e.main)
                                                .toList()
                                                .cast<String>(),
                                            initPage: 0,
                                            photoOwnerId: item.id),
                                      )
                                    : const Icon(
                                        Icons.photo_camera,
                                        color: Color.fromRGBO(230, 230, 230, 1),
                                        size: 60,
                                      )),
                          ),
                          Positioned(
                            right: 16,
                            top: 16,
                            child: Visibility(
                              visible: (item.isProfileParametersMatched !=
                                          null &&
                                      item.isProfileParametersMatched == true)
                                  ? true
                                  : false,
                              child: Chip(
                                avatar: const Icon(
                                  Icons.star,
                                  color: Color.fromRGBO(0, 0xcf, 0x91, 1),
                                  size: 14,
                                ),
                                label: Text(
                                  (item.isProfileParametersMatched != null &&
                                          item.isProfileParametersMatched ==
                                              true)
                                      ? LocaleKeys.usersScreen_selectedForYou
                                          .tr()
                                      : "",
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    //color: const Color.fromARGB(255,33,33,33),
                                  ),
                                ),
                                elevation: 2.0,
                                padding: const EdgeInsets.all(8.0),
                                backgroundColor:
                                    const Color.fromARGB(255, 246, 255, 237),
                              ),
                            ),
                          ),
                          /*Positioned(
                          right: 16,
                          top: (item.isProfileParametersMatched != null &&
                                  item.isProfileParametersMatched == true)
                              ? 60
                              : 16,
                          child: Chip(
                            labelPadding: const EdgeInsets.all(2.0),
                            avatar: (item.isOnline!)
                                ? const Icon(
                                    Icons.circle,
                                    color: Color.fromRGBO(0, 0xcf, 0x91, 1),
                                    size: 14,
                                  )
                                : null,
                            label: Text(
                              (item.isOnline!) ? LocaleKeys.common_online.tr() : LocaleKeys.common_offline.tr(),
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                //color: const Color.fromARGB(255,33,33,33),
                              ),
                            ),
                            elevation: 2.0,
                            padding: const EdgeInsets.all(8.0),
                            backgroundColor:
                                const Color.fromARGB(255, 246, 255, 237),
                          ),
                        ),*/
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ), //BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                width: double
                                    .infinity, //MediaQuery.of(context).size.width / 1.5,
                                padding: const EdgeInsets.all(16),
                                color: Colors.black45,
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10.0,
                                    sigmaY: 0.0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item.firstName ?? ""} ${item.lastName ?? ""}",
                                        style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${localized.plural(LocaleKeys.user_yearsCount, item.age ?? 0)}, ${item.city ??= ""}',
                                        style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 16,
                            child: PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                //offset: const Offset(0, 50),
                                shape: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white, width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        onTap: () {
                                          Future.delayed(
                                              const Duration(seconds: 0),
                                              () => SendClaim(
                                                      claimObjectId: item.id!,
                                                      type: ClaimType.photo)
                                                  .ShowAlertDialog(
                                                      this.context));
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons.block),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                                child: Container(
                                              child: const Text(
                                                LocaleKeys.claim_toReport,
                                              ).tr(),
                                            ))
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          if (item.isBlocked) {
                                            unblockUser(item);
                                          } else {
                                            blockUser(item);
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(Icons.lock_rounded),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                                child: Container(
                                              child: item.isBlocked
                                                  ? const Text(
                                                      LocaleKeys.chat_unblock,
                                                    ).tr()
                                                  : const Text(
                                                      LocaleKeys.chat_block,
                                                    ).tr(),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ]),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomInputDecoration()
                        .anketasHeaderName(LocaleKeys.user_interests.tr()),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.start,
                        children: makeChipsArray(item.interests!),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_nationality.tr(),
                        GlobalStrings.translateNationalityFromRu(
                            context, item.nationality)),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_aboutMe.tr(), item.about),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_education.tr(),
                        educationList['${item.education}']?.tr()),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_placeOfStudy.tr(), item.placeOfStudy),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_placeOfWork.tr(), item.placeOfWork),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_workPosition.tr(), item.workPosition),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_maritalStatus.tr(),
                        familyState["${item.maritalStatus}"]?.tr()),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_haveChildren_title.tr(),
                        (item.haveChildren == true)
                            ? LocaleKeys.childrenState_yes.tr()
                            : LocaleKeys.childrenState_no.tr()),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_faith.tr(),
                        faithState['${item.typeReligion}']?.tr()),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_canons.tr(),
                        item.gender == "male"
                            ? observantOfTheCanonsMaleState[
                                    '${item.observeIslamCanons}']
                                ?.tr()
                            : observantOfTheCanonsFemaleState[
                                    '${item.observeIslamCanons}']
                                ?.tr()),
                    CustomInputDecoration().anketesTextItem(
                        LocaleKeys.user_badHabits.tr(), parseBadHabits(item)),
                    Visibility(
                      visible: (item.photos!.length > 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          CustomInputDecoration()
                              .anketasHeaderName(LocaleKeys.user_photos.tr()),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 90,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        color:
                                            Color.fromARGB(255, 236, 235, 235),
                                      ),
                                      width: 120,
                                      child: (item.images!.length > index + 1)
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              child: displayPhotoOrVideo(
                                                  this.context,
                                                  item.images![index + 1]
                                                      .preview
                                                      .toString(),
                                                  items: item.images!
                                                      .map((e) => e.main)
                                                      .toList()
                                                      .cast<String>(),
                                                  initPage: index + 1,
                                                  photoOwnerId: item.id),
                                            )
                                          : const Icon(
                                              Icons.photo_camera,
                                              color: Colors.white,
                                              size: 60,
                                            ));
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    width: 10,
                                  );
                                },
                                itemCount: (item.images?.length ?? 1) -
                                    1 //item.getAdditionalPhotosLength(),
                                ),
                          ),
                        ],
                      ),
                    )
                  ],
                ))),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }

  void blockUser(UserProfileData item) async {
    try {
      await NetworkService().blockUser(userId: item.id!);
    } catch (e) {
      return;
    }
    setState(() {
      item.isBlocked = true;
      item.inFavourite = false;
    });
  }

  void unblockUser(UserProfileData item) async {
    try {
      await NetworkService().unblockUser(userId: item.id!);
    } catch (e) {
      return;
    }
    setState(() {
      item.isBlocked = false;
    });
  }

  List<Widget> makeChipsArray(List<String> items) {
    List<Widget> chips = [];
    for (int i = 0; i < items.length; i++) {
      Widget item = ChoiceChip(
        selected: false,
        label: Text(
          showTagLabelCurrentLocale(items[i]),
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        disabledColor: tagsColors[Random().nextInt(tagsColors.length)],
        labelStyle: const TextStyle(color: Colors.black),
      );
      chips.add(item);
    }
    return chips;
  }

  String showTagLabelCurrentLocale(String str) {
    if (context.locale.languageCode == "en") {
      try {
        var reversed = Map.fromEntries(
            standartInterestList.entries.map((e) => MapEntry(e.value, e.key)));
        str = reversed[str]!;
      } catch (err) {
        return str;
      }
    }

    return str;
  }

  String? parseBadHabits(UserProfileData item) {
    if (item.badHabits == null) {
      return null;
    }
    if (item.isBadHabitsFilled == false) {
      return null;
    }
    if (item.isBadHabitsFilled == true && item.badHabits!.isEmpty) {
      return LocaleKeys.badHabbits_missing.tr();
    }

    String str = "";
    try {
      for (int i = 0; i < item.badHabits!.length; i++) {
        final badHabitLocalized = addictionList[item.badHabits![i]]?.tr();
        if (badHabitLocalized == null) {
          continue;
        } else {
          str += badHabitLocalized;
          if (i < item.badHabits!.length - 1) {
            str += ", ";
          }
        }
      }
      return str;
    } catch (err) {
      return null;
    }
  }
}
