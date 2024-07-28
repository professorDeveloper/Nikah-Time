import 'package:flutter/material.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Chat/chat_settings.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import '../../components/widgets/custom_appbar.dart';
import 'package:untitled/Screens/Registration/registration_setup_interest_user_settings.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:http/http.dart' as http;

import 'package:untitled/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' as localize;

bool isDataInserted = false;

class RegistrationInfoAboutUserScreen extends StatefulWidget {
  RegistrationInfoAboutUserScreen(this.userProfileData, {Key? key})
      : super(key: key);

  UserProfileData userProfileData;

  @override
  State<RegistrationInfoAboutUserScreen> createState() =>
      _RegistrationInfoAboutUserScreenState();
}

class _RegistrationInfoAboutUserScreenState
    extends State<RegistrationInfoAboutUserScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();
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
                  const _PhotoPlace(),
                  CustomInputDecoration()
                      .titleText(LocaleKeys.registration_about_header.tr()),
                  CustomInputDecoration().subtitleText(
                      LocaleKeys.registration_about_subheader.tr()),
                  TextField(
                    controller: _controller,
                    onSubmitted: (value) {
                      widget.userProfileData.about = _controller.text;
                    },
                    onChanged: (value) {
                      widget.userProfileData.about = _controller.text;
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 218, 216, 215),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintStyle: const TextStyle(height: 1.4),
                      hintText: LocaleKeys.registration_about_example.tr(),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 207, 145),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    style: const TextStyle(height: 1.4),
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                  )
                ]))),
            _RegisterButton(widget.userProfileData),
          ],
        ),
      ),
    );
  }
}

class _PhotoPlace extends StatelessWidget {
  const _PhotoPlace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/aboutU.png'),
          fit: BoxFit.contain,
        ),
        shape: BoxShape.rectangle,
      ),
    );
  }
}

class _RegisterButton extends StatefulWidget {
  _RegisterButton(this.userProfileData, {Key? key}) : super(key: key);

  UserProfileData userProfileData;
  Future<void> _putNewUserInfo() async {
    debugPrint("UPDATE USER PROFILE START");
    var response = await http.put(
      Uri.parse("https://www.nikahtime.ru/api/account/user/update"),
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
        'authorization': 'Bearer ${userProfileData.accessToken.toString()}'
      },
      body: userProfileData.returnUserData(),
    );
    debugPrint("${response.statusCode}");
    debugPrint(response.body);
    if (response.statusCode != 200) {
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", userProfileData.accessToken!);
    prefs.setString("userGender", userProfileData.gender!);
    if (userProfileData.id != null) {
      prefs.setInt("userId", userProfileData.id!);
    }

    MyTrackerParams trackerParams = MyTracker.trackerParams;

    trackerParams.setCustomUserIds([(userProfileData.id ?? 0).toString()]);
    trackerParams.setAge(DateTime.now()
            .difference(localize.DateFormat("dd-MM-yyyy")
                .parse(userProfileData.birthDate!))
            .abs()
            .inDays ~/
        365);
    trackerParams.setGender(userProfileData.gender == null
        ? MyTrackerGender.UNKNOWN
        : ((userProfileData.gender == "male")
            ? MyTrackerGender.MALE
            : MyTrackerGender.FEMALE));

    MyTracker.trackRegistrationEvent((userProfileData.id ?? -1).toString(), {});

    debugPrint("UPDATE USER PROFILE END");
  }

  @override
  State<_RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<_RegisterButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 18, bottom: 24),
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 00, 0xcf, 0x91),
              elevation: 0,
              fixedSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              LocaleKeys.common_confirm.tr(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            onPressed: () async {
              await widget._putNewUserInfo().then((value) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ChatSettings(
                      goNextButton: Container(
                        padding: const EdgeInsets.only(top: 16),
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
                              LocaleKeys.common_confirm.tr(),
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      RegistrationSetupInterestUserSettingsScreen(
                                          widget.userProfileData),
                                  transitionDuration:
                                      const Duration(seconds: 0),
                                ),
                              );
                            }),
                      ),
                    ),
                    transitionDuration: const Duration(seconds: 0),
                  ),
                );
              });
            }));
  }
}
