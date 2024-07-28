import 'package:easy_localization/easy_localization.dart' as locale;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:untitled/Screens/Anketes/anketes.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';
import '../../components/widgets/custom_appbar.dart';


class ILikedScreen extends StatefulWidget {
  const ILikedScreen(this.userProfileData, {super.key});

  final UserProfileData userProfileData;

  @override
  State<ILikedScreen> createState() => ILikedScreenState();
}

class ILikedScreenState extends State<ILikedScreen> {
  int page = 1;
  bool isLoadingComplete = false;
  List<UserProfileData> vizitedMeAnketas = [];

  @override
  void initState()
  {
    sendAnketesRequest();
    super.initState();
    MyTracker.trackEvent("Watch I Liked page", {});
  }

  sendAnketesRequest() async{
    try
    {
      var response = await NetworkService().getUsersWhoFavoriteMe(
        accessToken: widget.userProfileData.accessToken!,
        page: page
      );
      page++;
      vizitedMeAnketas.addAll(response.users as Iterable<UserProfileData>);

      setState(() {
        isLoadingComplete = true;
      });

    } catch(e){
      return;
    }

  }

  Widget waitBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 00, 207, 145)),
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
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: const CustomAppBar(),
        body: isLoadingComplete
            ? SizedBox(
                //margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                width: double.infinity,
                //margin: EdgeInsets.only(top: 104),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        LocaleKeys.usersScreen_liked.tr(),
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
