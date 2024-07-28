import 'dart:async';

import 'package:easy_localization/easy_localization.dart' as locale;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';
import '../../components/widgets/custom_appbar.dart';

class PeopleWhoVizitedMeScreen extends StatefulWidget {
  const PeopleWhoVizitedMeScreen(this.userProfileData, {super.key});

  final UserProfileData userProfileData;

  @override
  State<PeopleWhoVizitedMeScreen> createState() =>
      PeopleWhoVizitedMeScreenState();
}

class PeopleWhoVizitedMeScreenState extends State<PeopleWhoVizitedMeScreen> {
  int page = 1;
  bool isLoadingComplete = false;
  bool isLoadingEnd = false;
  List<UserProfileData> vizitedMeAnketas = [];
  Timer? timer;
  sendAnketesRequest() async {
    try {
      var response = await NetworkService().getGuests(
          accessToken: widget.userProfileData.accessToken!, page: page);
      page++;
      vizitedMeAnketas = [];
      vizitedMeAnketas.addAll(response.users as Iterable<UserProfileData>);

      if (response.users.length < 20) {
        setState(() {
          isLoadingEnd = true;
        });
      }

      setState(() {
        isLoadingComplete = true;
      });
    } catch (e) {
      return;
    }
  }

  sendAnketesRequestWithoutPage() async {
    var response = await NetworkService()
        .getGuests(accessToken: widget.userProfileData.accessToken!, page: 2);
    vizitedMeAnketas = [];
    vizitedMeAnketas.addAll(response.users as Iterable<UserProfileData>);

    if (response.users.length < 20) {
      setState(() {
        isLoadingEnd = true;
      });
    }

    setState(() {
      isLoadingComplete = true;
    });
  }

  Widget waitBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 00, 207, 145)),
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
            color: const Color.fromARGB(255, 00, 207, 145),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    if (timer == null) {
      sendAnketesRequest();
    }
    super.initState();
    MyTracker.trackEvent("Watch Vizited Me page", {});
    timer = Timer.periodic(
        const Duration(
          seconds: 2,
        ), (timer) {
      sendAnketesRequest();
    });
  }

  @override
  dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: isLoadingComplete
            ? SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        LocaleKeys.common_vizited.tr(),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: const Color.fromARGB(255, 33, 33, 33),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Expanded(
                      child: FeedVerticalGridView(
                        userProfileData: widget.userProfileData,
                        anketas: vizitedMeAnketas,
                        uploadMore: () async {
                          sendAnketesRequest();
                        },
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: waitBox(),
              ));
  }
}
