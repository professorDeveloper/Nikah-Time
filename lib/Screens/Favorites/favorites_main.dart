import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:provider/provider.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/Screens/Favorites/iLiked.dart';
import 'package:untitled/Screens/Payment/payment.dart';
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart';
import 'package:untitled/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Favorites/favorites_visited_me.dart';
import 'package:untitled/components/widgets/create_chat.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';

import '../../components/widgets/likeAnimation.dart';

class FavoriteMainPageScreen extends StatefulWidget {
  const FavoriteMainPageScreen(this.userProfileData, {super.key});

  final UserProfileData userProfileData;

  @override
  State<FavoriteMainPageScreen> createState() => _FavoriteMainPageScreenState();
}

class _FavoriteMainPageScreenState extends State<FavoriteMainPageScreen> {
  bool show = false;

  @override
  void initState() {
    sendAnketesRequest();
    super.initState();
    _scrollController.addListener(_onScroll);
    MyTracker.trackEvent("Watch Favourites page", {});
  }

  final _scrollController = ScrollController();
  int lastBuildItemIndex = 0;

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (anketas.length > 10) {
      if (lastBuildItemIndex + 2 >= anketas.length) {
        sendAnketesRequest();
        lastBuildItemIndex = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ProfileInitial state = context.read<ProfileBloc>().state as ProfileInitial;
    bool needPay = state.userProfileData?.userTariff == null;

    if (needPay) {
      return Center(child: paymentStub(context));
    }

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      //margin: EdgeInsets.only(top: 104),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Builder(builder: (context) {
            if (show) {
              show = false;
              return LikeAnimationWidget(true);
            } else {
              return const SizedBox.shrink();
            }
          }),
          const SizedBox(height: 16),
          _Header(widget.userProfileData),
          SizedBox(
            width: double.infinity,
            child: MaterialButton(
                height: 40,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(
                      width: 1, color: Color.fromARGB(255, 0, 207, 145)),
                ),
                child: Text(
                  LocaleKeys.common_vizited_q.tr(),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color.fromARGB(255, 0, 207, 145),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          PeopleWhoVizitedMeScreen(widget.userProfileData),
                      transitionDuration: const Duration(seconds: 0),
                    ),
                  );
                }),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: isLoadingComplete
                ? gridViewWithPhotos(context)
                : Center(
                    child: waitBox(),
                  ),
          ),
          // const SizedBox(
          //   height: 2,
          // ),
          // DonateButton()
        ],
      ),
    );
  }

  Widget gridViewWithPhotos(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      itemBuilder: (BuildContext context, int index) {
        lastBuildItemIndex = index;
        debugPrint(index.toString());
        return itemWithBottomNavigationBar(anketas[index]);
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.75,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      controller: _scrollController,
      itemCount: anketas.length,
    );
  }

  Widget itemWithBottomNavigationBar(UserProfileData item) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleUser(anketa: item),
                )).then((_) => {setState(() {})});
          },
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Color.fromARGB(255, 236, 235, 235),
              ),
              child: (item.images == null || item.images!.isEmpty)
                  ? const Icon(Icons.photo_camera,
                      color: Color.fromRGBO(230, 230, 230, 1), size: 60)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(item.images![0].preview.toString(),
                          fit: BoxFit.cover),
                    )),
        ),
        /*Positioned(
            left: 8,
            //top: 8,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 1.0,
                  sigmaY: 1.0,
                ),
                child: Opacity(
                  opacity: 0.7,
                  child: Chip(
                    labelPadding: const EdgeInsets.only(right: 10),
                    avatar: (item.isOnline!)
                        ? const Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 14,
                          )
                        : null,
                    label: Text(
                      (item.isOnline!)
                          ? LocaleKeys.common_online.tr()
                          : LocaleKeys.common_offline.tr(),
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    elevation: 6.0,
                  ),
                ),
              ),
            )),*/
        Align(
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              height: 40,
              color: Colors.black45,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Opacity(
                    opacity: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          minWidth: 50,
                          onPressed: () {
                            anketas.remove(item);
                            NetworkService().FavoritesDeleteUserID(
                                widget.userProfileData.accessToken!, item.id!);
                            setState(() {});
                          },
                          child: const Icon(Icons.close,
                              color: Colors.white, size: 40),
                        ),
                        const VerticalDivider(
                          color: Color.fromARGB(0xff, 0x6e, 0x6e, 0x6e),
                          width: 1,
                        ),
                        MaterialButton(
                          minWidth: 80,
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            CreateChat(
                                    context,
                                    widget.userProfileData.gender ?? "",
                                    widget.userProfileData.id ?? 0)
                                .createChatWithUser(item.id!);
                          },
                          child: const Icon(Icons.chat_rounded,
                              color: Colors.white, size: 30),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
        Positioned(
          top: 140,
          left: 12,
          child: SizedBox(
            width: 180,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.firstName ?? ""} ${item.lastName ?? ""}",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${localized.plural(LocaleKeys.user_yearsCount, item.age ?? 0)}, ${item.city ??= ""}',
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  bool isLoadingComplete = false;
  int page = 1;
  List<UserProfileData> anketas = [];

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

  sendAnketesRequest() async {
    try {
      var response = await NetworkService().getFavoriteUsers(
          accessToken: widget.userProfileData.accessToken!, page: page);
      page++;
      anketas.addAll(response.users as Iterable<UserProfileData>);

      setState(() {
        isLoadingComplete = true;
      });
    } catch (e) {
      return;
    }
  }
}

class _Header extends StatelessWidget {
  final UserProfileData _userProfileData;

  const _Header(this._userProfileData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        LocaleKeys.usersScreen_favorites.tr(),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.left,
        style: GoogleFonts.rubik(
          fontWeight: FontWeight.w700,
          fontSize: 18,
          color: const Color.fromARGB(255, 33, 33, 33),
        ),
      ),
      GestureDetector(
        child: Text(
          LocaleKeys.usersScreen_youFavorite.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: const Color.fromRGBO(0, 0, 0, 0.38),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => ILikedScreen(_userProfileData),
                transitionDuration: const Duration(seconds: 0),
              ));
        },
      )
    ]);
  }
}
