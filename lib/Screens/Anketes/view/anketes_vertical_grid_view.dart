part of '../anketes.dart';

class FeedVerticalGridView extends StatefulWidget {
  FeedVerticalGridView(
      {super.key,
      required this.userProfileData,
      required this.anketas,
      this.appendix,
      this.likeFunction,
      this.uploadMore});

  UserProfileData userProfileData;
  List<UserProfileData> anketas;
  Function(bool)? likeFunction;
  Function? uploadMore;
  int lastBuildItemIndex = 0;
  Widget? appendix;

  @override
  State<FeedVerticalGridView> createState() => _FeedVerticalGridViewState();
}

class _FeedVerticalGridViewState extends State<FeedVerticalGridView> {
  final _scrollController = ScrollController();

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
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileInitial state = context.read<ProfileBloc>().state as ProfileInitial;
    bool needPay = state.userProfileData?.userTariff == null;

    debugPrint("${widget.anketas.length}");
    return ListView.separated(
      findChildIndexCallback: (a) {
        print(a);
        return null;
      },
      itemBuilder: (BuildContext context, int index) {
        widget.lastBuildItemIndex = index;

        if (index == widget.anketas.length - 1) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserCardExpanded(
                profile: widget.userProfileData,
                item: widget.anketas[index],
                activeAction: needPay == false,
                likeFunction: widget.likeFunction,
              ),
              // userCardExpanded(widget.anketas[index], !needPay),
              const SizedBox(
                height: 12,
              ),
              widget.appendix ?? const SizedBox()
            ],
          );
        }

        return UserCardExpanded(
          profile: widget.userProfileData,
          item: widget.anketas[index],
          activeAction: needPay == false,
          likeFunction: widget.likeFunction,
        );
        // return userCardExpanded(widget.anketas[index], !needPay);
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 16),
      itemCount: widget.anketas.length,
      padding: const EdgeInsets.only(left: 16, top: 0, right: 16, bottom: 16),
      controller: _scrollController,
    );
  }

  // Widget userCardExpanded(UserProfileData item, bool activeAction) {
  //   return Container(
  //     width: double.infinity,
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       shape: BoxShape.rectangle,
  //       borderRadius: BorderRadius.all(Radius.circular(12)),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black12,
  //           offset: Offset(
  //             0.0,
  //             7.0,
  //           ),
  //           blurRadius: 5.0,
  //           spreadRadius: 2.0,
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: 160,
  //           child: Stack(
  //             children: [
  //               Positioned(
  //                 left: 16,
  //                 top: 16,
  //                 child: Container(
  //                     decoration: const BoxDecoration(
  //                       shape: BoxShape.rectangle,
  //                       borderRadius: BorderRadius.all(Radius.circular(12)),
  //                       color: Color.fromARGB(255, 236, 235, 235),
  //                     ),
  //                     height: 140,
  //                     width: 100,
  //                     child: (item.images == null || item.images!.isEmpty)
  //                         ? const Icon(
  //                             Icons.photo_camera,
  //                             color: Color.fromRGBO(230, 230, 230, 1),
  //                             size: 60,
  //                           )
  //                         : ClipRRect(
  //                             borderRadius: BorderRadius.circular(12.0),
  //                             child: displayPhotoOrVideo(
  //                                 context, item.images![0].preview.toString(),//item.photos![0].toString(),
  //                                 items: item.images!.map((e) => e.main).toList().cast<String>(),  //item.photos!.cast<String>(),
  //                                 initPage: 0,
  //                                 photoOwnerId: item.id
  //                             ),
  //                           )),
  //               ),
  //               Positioned(
  //                   top: 16,
  //                   left: 132,
  //                   child: SizedBox(
  //                     width: 180,
  //                     child: Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           "${item.firstName ?? ""} ${item.lastName ?? ""}",
  //                           style: GoogleFonts.rubik(
  //                             fontWeight: FontWeight.w700,
  //                             fontSize: 16,
  //                             color: Colors.black,
  //                           ),
  //                           maxLines: 2,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //
  //                         Text(
  //                           '${localized.plural(LocaleKeys.user_yearsCount, item.age ?? 0)}, ${item.city ??= ""}',
  //                           style: GoogleFonts.rubik(
  //                             fontWeight: FontWeight.w400,
  //                             fontSize: 12,
  //                             color: Colors.black,
  //                           ),
  //                           maxLines: 2,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ],
  //                     ),
  //                   )),
  //               //Positioned(
  //               //  left: 132,
  //               //  top: 116,
  //               //  child: Chip(
  //               //    avatar: (item.isOnline!)
  //               //      ? const Icon(
  //               //          Icons.circle,
  //               //          color: Color.fromRGBO(0, 0xcf, 0x91, 1),
  //               //          size: 14) : null,
  //               //    label: Text(
  //               //      (item.isOnline!) ? LocaleKeys.common_online.tr() : LocaleKeys.common_offline.tr(),
  //               //      style: GoogleFonts.rubik(
  //               //        fontWeight: FontWeight.w400,
  //               //        fontSize: 12,
  //               //        //color: const Color.fromARGB(255,33,33,33),
  //               //      ),
  //               //    ),
  //               //    elevation: 2.0,
  //               //    //padding: EdgeInsets.all(2.0),
  //               //    backgroundColor: const Color.fromARGB(255, 246, 255, 237),
  //               //  ),
  //               //),
  //               Positioned(
  //                 left: 132,
  //                 top: 116,//82,
  //                 child: Visibility(
  //                   //visible: true,
  //                   visible: (item.isProfileParametersMatched != null &&
  //                           item.isProfileParametersMatched == true)
  //                       ? true
  //                       : false,
  //                   child: Chip(
  //                     avatar: const Icon(
  //                       Icons.star,
  //                       color: Color.fromRGBO(0, 0xcf, 0x91, 1),
  //                       size: 14,
  //                     ),
  //                     label: Text(
  //                       LocaleKeys.usersScreen_selectedForYou.tr(),
  //                       style: GoogleFonts.rubik(
  //                         fontWeight: FontWeight.w400,
  //                         fontSize: 12,
  //                         //color: const Color.fromARGB(255,33,33,33),
  //                       ),
  //                     ),
  //                     elevation: 2.0,
  //                     //padding: EdgeInsets.all(2.0),
  //                     backgroundColor: const Color.fromARGB(255, 246, 255, 237),
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 right: 0,
  //                 top: 16,
  //                 child: GestureDetector(
  //                   child: PopupMenuButton(
  //                       color: Colors.white,
  //                       offset: const Offset(0, 50),
  //                       shape: const OutlineInputBorder(
  //                         borderSide:
  //                             BorderSide(color: Colors.transparent, width: 2),
  //                         borderRadius: BorderRadius.all(Radius.circular(10)),
  //                       ),
  //                       itemBuilder: (context) => [
  //                         PopupMenuItem(
  //                           onTap: () {
  //                             Future.delayed(
  //                                 const Duration(seconds: 0),
  //                                 () => SendClaim(
  //                                     claimObjectId: item.id!,
  //                                     type: ClaimType.photo
  //                                 ).ShowAlertDialog(this.context));
  //                           },
  //                           child: Row(
  //                             children: [
  //                               const Icon(Icons.block),
  //                               const SizedBox(
  //                                 width: 16,
  //                               ),
  //                               Expanded(
  //                                 child: Container(
  //                                   child: const Text(
  //                                     LocaleKeys.claim_toReport,
  //                                   ).tr(),
  //                                 )
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         PopupMenuItem(
  //                           onTap: () {
  //                             Future.delayed(
  //                                 const Duration(seconds: 0),
  //                                     () => SendClaim(
  //                                     claimObjectId: item.id!,
  //                                     type: ClaimType.photo
  //                                 ).ShowAlertDialog(this.context));
  //                           },
  //                           child: Row(
  //                             children: [
  //                               const Icon(Icons.lock_rounded),
  //                               const SizedBox(
  //                                 width: 16,
  //                               ),
  //                               Expanded(
  //                                   child: Container(
  //                                     child: const Text(
  //                                       LocaleKeys.chat_block,
  //                                     ).tr(),
  //                                   )
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ]),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         SizedBox(
  //           height: 80,
  //           child: Stack(
  //             children: <Widget>[
  //               Positioned(
  //                   left: 14,
  //                   bottom: 16,
  //                   child: ElevatedButton(
  //                     onPressed: () async {
  //                       if(!activeAction)
  //                       {
  //                         await showPaymentDialog(context, text: LocaleKeys.common_payment_alert_titleForAction.tr());
  //                         return;
  //                       }
  //                       debugPrint(
  //                           "Начать чат с пользователем № ${item.id!}");
  //                       CreateChat(context, widget.userProfileData.gender ?? "", widget.userProfileData.id ?? 0)
  //                           .createChatWithUser(item.id!);
  //                     },
  //                     child: const Icon(MainPageCustomIcon.message,
  //                         color: Color.fromRGBO(00, 0xcf, 0x91, 1),
  //                         size: 30),
  //                     style: ElevatedButton.styleFrom(
  //                       shape: const CircleBorder(),
  //                       backgroundColor: Colors.white,
  //                       padding: const EdgeInsets.all(0),
  //                       //padding: const EdgeInsets.all(0),
  //                       fixedSize: const Size(55, 55),
  //                     ),
  //                   )),
  //               Positioned(
  //                   left: 87,
  //                   bottom: 16,
  //                   child: ElevatedButton(
  //                     onPressed: () async {
  //                       if(!activeAction)
  //                       {
  //                         await showPaymentDialog(context, text: LocaleKeys.common_payment_alert_titleForAction.tr());
  //                         return;
  //                       }
  //
  //                       if(widget.likeFunction != null)
  //                       {
  //                         await widget.likeFunction!(!item.inFavourite);
  //                       }
  //
  //                       SharedPreferences prefs = await SharedPreferences.getInstance();
  //                       String accessToken = prefs.getString("token") ?? "";
  //
  //                       var response = await NetworkService().FavoritesAddUserID(accessToken, item.id ?? 0);
  //                       if(response.statusCode == 202){
  //                         Navigator.push(
  //                           context,
  //                           PageRouteBuilder(
  //                             pageBuilder: (_, __, ___) => CrossMatch(
  //                               item,
  //                               widget.userProfileData.id ?? 0,
  //                               widget.userProfileData.gender ?? ""
  //                             ),
  //                             transitionDuration: const Duration(seconds: 0),
  //                           ),
  //                         );
  //                       }
  //                       item.inFavourite = !item.inFavourite;
  //                       setState(() {});
  //                       debugPrint("1Поставить лайк пользователю №");
  //                     },
  //                     child: Icon(
  //                         item.inFavourite ? MainPageCustomIcon.heart : MainPageCustomIcon.heart_outlined,
  //                         color: Colors.red,
  //                         size: 30
  //                     ),
  //                     style: ElevatedButton.styleFrom(
  //                       shape: const CircleBorder(),
  //                       backgroundColor: Colors.white,
  //                       padding: const EdgeInsets.only(right: 8,),
  //                       fixedSize: const Size(55,55),
  //                     ),
  //                   )
  //               ),
  //               Positioned(
  //                 bottom: 27,
  //                 right: 21,
  //                 child: GestureDetector(
  //                   onTap: () async {
  //                     MyTracker.trackEvent("Press \"More\"button on anketes vertical feed", {});
  //                     await Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) =>
  //                               SingleUser(anketa: item),
  //                         )
  //                     ).then((_){
  //                       NetworkService().GuestAddUserID(
  //                         widget.userProfileData.accessToken!, item.id!
  //                       );
  //                       setState(() {
  //                         item.inFavourite = _;
  //                       });
  //                     });
  //
  //                   },
  //                   child: RichText(
  //                     textAlign: TextAlign.end,
  //                     text: TextSpan(
  //                       children: [
  //                         TextSpan(
  //                           text: (item.isVisible) ? LocaleKeys.user_hide.tr() : LocaleKeys.user_more.tr(),
  //                           style: GoogleFonts.rubik(
  //                             fontWeight: FontWeight.w500,
  //                             fontSize: 16,
  //                             color: const Color.fromARGB(255, 00, 207, 145),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     )
  //   );
  // }
}

class UserCardExpanded extends StatefulWidget {
  final UserProfileData profile;
  final UserProfileData item;
  final bool activeAction;
  final Function(bool)? likeFunction;

  const UserCardExpanded({
    super.key,
    required this.profile,
    required this.item,
    required this.activeAction,
    required this.likeFunction,
  });

  @override
  State<StatefulWidget> createState() => _UserCardExpandedState();
}

class _UserCardExpandedState extends State<UserCardExpanded> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(
                0.0,
                7.0,
              ),
              blurRadius: 5.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color:  Color.fromARGB(255, 236, 235, 235),
                        ),
                          height: 140,
                          width: 100,
                        child: (widget.item.images == null ||
                                widget.item.images!.isEmpty)
                            ? const Icon(
                                Icons.photo_camera,
                                color: Color.fromRGBO(230, 230, 230, 1),
                                size: 60,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: displayPhotoOrVideo(
                                    context,
                                    widget.item.images![0].preview
                                        .toString(), //item.photos![0].toString(),
                                    items: widget.item.images!
                                        .map((e) => e.main)
                                        .toList()
                                        .cast<
                                            String>(), //item.photos!.cast<String>(),
                                    initPage: 0,
                                    photoOwnerId: widget.item.id),
                              )),
                  ),
                  Positioned(
                      top: 16,
                      left: 132,
                      child: SizedBox(
                        width: 180,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.item.firstName ?? ""} ${widget.item.lastName ?? ""}",
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${localized.plural(LocaleKeys.user_yearsCount, widget.item.age ?? 0)}, ${widget.item.city ??= ""}',
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )),
                  //Positioned(
                  //  left: 132,
                  //  top: 116,
                  //  child: Chip(
                  //    avatar: (item.isOnline!)
                  //      ? const Icon(
                  //          Icons.circle,
                  //          color: Color.fromRGBO(0, 0xcf, 0x91, 1),
                  //          size: 14) : null,
                  //    label: Text(
                  //      (item.isOnline!) ? LocaleKeys.common_online.tr() : LocaleKeys.common_offline.tr(),
                  //      style: GoogleFonts.rubik(
                  //        fontWeight: FontWeight.w400,
                  //        fontSize: 12,
                  //        //color: const Color.fromARGB(255,33,33,33),
                  //      ),
                  //    ),
                  //    elevation: 2.0,
                  //    //padding: EdgeInsets.all(2.0),
                  //    backgroundColor: const Color.fromARGB(255, 246, 255, 237),
                  //  ),
                  //),
                  Positioned(
                    left: 132,
                    top: 116, //82,
                    child: Visibility(
                      //visible: true,
                      visible: (widget.item.isProfileParametersMatched !=
                                  null &&
                              widget.item.isProfileParametersMatched == true)
                          ? true
                          : false,
                      child: Chip(
                        avatar: const Icon(
                          Icons.star,
                          color: Color.fromRGBO(0, 0xcf, 0x91, 1),
                          size: 14,
                        ),
                        label: Text(
                          LocaleKeys.usersScreen_selectedForYou.tr(),
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            //color: const Color.fromARGB(255,33,33,33),
                          ),
                        ),
                        elevation: 2.0,
                        //padding: EdgeInsets.all(2.0),
                        backgroundColor:
                            const Color.fromARGB(255, 246, 255, 237),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 16,
                    child: GestureDetector(
                      child: PopupMenuButton(
                          color: Colors.white,
                          offset: const Offset(0, 50),
                          shape: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(seconds: 0),
                                        () => SendClaim(
                                                claimObjectId: widget.item.id!,
                                                type: ClaimType.photo)
                                            .ShowAlertDialog(this.context));
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
                                    if (widget.item.isBlocked) {
                                      unblockUser();
                                    } else {
                                      blockUser();
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
                                        child: widget.item.isBlocked
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
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 80,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      left: 14,
                      bottom: 16,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (widget.activeAction == false) {
                            await showPaymentDialog(context,
                                text: LocaleKeys
                                    .common_payment_alert_titleForAction
                                    .tr());
                            return;
                          }
                          debugPrint(
                              "Начать чат с пользователем № ${widget.item.id!}");
                          CreateChat(context, widget.profile.gender ?? "",
                              widget.profile.id ?? 0,
                              afterPopCallback: (chatWithLastMessage) {
                            setState(() {
                              widget.item.isBlocked =
                                  chatWithLastMessage.isChatBlocked;
                            });
                          }).createChatWithUser(widget.item.id!);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(0),
                          //padding: const EdgeInsets.all(0),
                          fixedSize: const Size(55, 55),
                        ),
                        child: const Icon(MainPageCustomIcon.message,
                            color: Color.fromRGBO(00, 0xcf, 0x91, 1), size: 30),
                      )),
                  Positioned(
                      left: 87,
                      bottom: 16,
                      child: Visibility(
                        visible: widget.item.isBlocked == false,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (widget.activeAction == false) {
                              await showPaymentDialog(context,
                                  text: LocaleKeys
                                      .common_payment_alert_titleForAction
                                      .tr());
                              return;
                            }

                            if (widget.item.isBlocked) {
                              return;
                            }

                            if (widget.likeFunction != null) {
                              await widget.likeFunction!(
                                  widget.item.inFavourite == false);
                            }

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            String accessToken = prefs.getString("token") ?? "";

                            var response = await NetworkService()
                                .FavoritesAddUserID(
                                    accessToken, widget.item.id ?? 0);
                            if (response.statusCode == 202) {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => CrossMatch(
                                      widget.item,
                                      widget.profile.id ?? 0,
                                      widget.profile.gender ?? ""),
                                  transitionDuration:
                                      const Duration(seconds: 0),
                                ),
                              );
                            }
                            setState(() {
                              widget.item.inFavourite =
                                  widget.item.inFavourite == false;
                            });
                            debugPrint("1Поставить лайк пользователю №");
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
                              widget.item.inFavourite
                                  ? MainPageCustomIcon.heart
                                  : MainPageCustomIcon.heart_outlined,
                              color: Colors.red,
                              size: 30),
                        ),
                      )),
                  Positioned(
                    bottom: 27,
                    right: 21,
                    child: GestureDetector(
                      onTap: () async {
                        MyTracker.trackEvent(
                            "Press \"More\"button on anketes vertical feed",
                            {});
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SingleUser(anketa: widget.item),
                            )).then((_) {
                          NetworkService().GuestAddUserID(
                              widget.profile.accessToken!, widget.item.id!);
                          setState(() {
                            widget.item.inFavourite = _;
                          });
                        });
                      },
                      child: RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: (widget.item.isVisible)
                                  ? LocaleKeys.user_hide.tr()
                                  : LocaleKeys.user_more.tr(),
                              style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: const Color.fromARGB(255, 00, 207, 145),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  void blockUser() async {
    try {
      await NetworkService().blockUser(userId: widget.item.id!);
    } catch (e) {
      return;
    }
    setState(() {
      widget.item.isBlocked = true;
      widget.item.inFavourite = false;
    });
  }

  void unblockUser() async {
    try {
      await NetworkService().unblockUser(userId: widget.item.id!);
    } catch (e) {
      return;
    }
    setState(() {
      widget.item.isBlocked = false;
    });
  }
}
