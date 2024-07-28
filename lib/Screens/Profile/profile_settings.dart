import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Payment/payment.dart';
import 'package:untitled/Screens/Profile/bloc/profile_bloc.dart';
import 'package:untitled/Screens/Employeers/employee_information.dart';
import 'package:untitled/Screens/Profile/contacts_page.dart';
import 'package:untitled/Screens/Profile/web_view_page.dart';
import 'package:untitled/Screens/welcome.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import '../../components/widgets/custom_appbar.dart';

import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:untitled/generated/locale_keys.g.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool isPushEnabled = true;

  bool isEnglish = true;

  String userTariff = 'Базовый';

  Widget tariffWidget(BuildContext context, ProfileInitial state) {
    Tariff? userTariff = state.userProfileData!.userTariff;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.profileScreen_settings_subscription_header.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: const Color.fromARGB(255, 33, 33, 33),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      LocaleKeys.profileScreen_settings_subscription_type_header
                          .tr(),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: const Color.fromARGB(255, 33, 33, 33),
                      ),
                    ),
                    Text(
                      getTariffTitle(userTariff: userTariff),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color.fromARGB(255, 33, 33, 33),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: userTariff != null && userTariff.expiredAt != null,
                  child: Row(
                    children: [
                      Text(
                        LocaleKeys.profileScreen_settings_subscription_expires
                            .tr(),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: const Color.fromARGB(255, 33, 33, 33),
                        ),
                      ),
                      Text(
                        userTariff?.expiredAt ?? "",
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color.fromARGB(255, 33, 33, 33),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
                visible: userTariff == null || (userTariff.expiredAt != null),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const PaymentView(),
                      ),
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: LocaleKeys
                              .profileScreen_settings_subscription_subscribe
                              .tr(),
                          style: GoogleFonts.rubik(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: const Color.fromARGB(255, 00, 207, 145),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ],
    );
  }

  String getTariffTitle({Tariff? userTariff}) {
    if (userTariff == null) {
      return LocaleKeys.profileScreen_settings_subscription_type_no.tr();
    } else {
      switch (userTariff.title!) {
        case "1 месяц":
          return LocaleKeys.profileScreen_settings_subscription_type_1_month
              .tr();
        case "3 месяца":
          return LocaleKeys.profileScreen_settings_subscription_type_3_months
              .tr();
        case "6 месяцев":
          return LocaleKeys.profileScreen_settings_subscription_type_6_months
              .tr();
        case "Тестовый период":
          return LocaleKeys.profileScreen_settings_subscription_type_trial.tr();
        default:
          if (userTariff.expiredAt == null) {
            return LocaleKeys.profileScreen_settings_subscription_type_unlimited
                .tr();
          } else {
            return userTariff.title!;
          }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(),
          body: Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            width: double.infinity,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    LocaleKeys.profileScreen_settings_header.tr(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      color: const Color.fromARGB(255, 33, 33, 33),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  //==========================
                  //тариф
                  tariffWidget(context, state as ProfileInitial),
                  const Divider(
                    thickness: 1,
                    height: 16,
                  ),
                  //==========================
                  //О нас
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      MyTracker.trackEvent("Open \"About Us\" page", {});
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const EmployeeInformation(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LocaleKeys.profileScreen_settings_about.tr(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: const Color.fromARGB(255, 33, 33, 33),
                            ),
                          ),
                          Text(
                            LocaleKeys.user_more.tr(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 00, 207, 145),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 16,
                  ),
                  //положения
                  Text(
                    LocaleKeys.profileScreen_settings_common.tr(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 33, 33, 33),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      //_launchInBrowser("http://nikahtime.ru/privacy/policy");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomWebView(
                                initialUrl:
                                    "https://www.nikahtime.ru/privacy/policy",
                                header: LocaleKeys
                                    .profileScreen_settings_privacy
                                    .tr(),
                              )));
                    },
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                LocaleKeys.profileScreen_settings_privacy.tr(),
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 00, 207, 145),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      //_launchInBrowser("https://www.nikahtime.ru/user/agreement");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomWebView(
                                initialUrl:
                                    "https://www.nikahtime.ru/user/agreement",
                                header: LocaleKeys
                                    .profileScreen_settings_agreement
                                    .tr(),
                              )));
                    },
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: LocaleKeys.profileScreen_settings_agreement
                                .tr(),
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 00, 207, 145),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      //_launchInBrowser("http://nikahtime.ru/user/app_use_terms");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomWebView(
                                initialUrl:
                                    "https://www.nikahtime.ru/user/app_use_terms",
                                header: LocaleKeys
                                    .profileScreen_settings_useTerms
                                    .tr(),
                              )));
                    },
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                LocaleKeys.profileScreen_settings_useTerms.tr(),
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 00, 207, 145),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      //_launchInBrowser("https://www.nikahtime.ru/payment/rules");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomWebView(
                                initialUrl:
                                    "https://www.nikahtime.ru/payment/rules",
                                header: LocaleKeys
                                    .profileScreen_settings_paymentRules
                                    .tr(),
                              )));
                    },
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: LocaleKeys.profileScreen_settings_paymentRules
                                .tr(),
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 00, 207, 145),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      //_launchInBrowser("https://www.nikahtime.ru/refund/policy");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomWebView(
                                initialUrl:
                                    "https://www.nikahtime.ru/refund/policy",
                                header: LocaleKeys
                                    .profileScreen_settings_refundRules
                                    .tr(),
                              )));
                    },
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: LocaleKeys.profileScreen_settings_refundRules
                                .tr(),
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 00, 207, 145),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () async {
                      //_launchInBrowser("https://www.nikahtime.ru/refund/policy");
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomWebView(
                                initialUrl: "https://www.nikahtime.ru/tariffs",
                                header: LocaleKeys
                                    .profileScreen_settings_tariffs
                                    .tr(),
                              )));
                    },
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                LocaleKeys.profileScreen_settings_tariffs.tr(),
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 00, 207, 145),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 16,
                  ),
                  //==========================
                  //Помощь
                  Text(
                    LocaleKeys.profileScreen_settings_help.tr(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 33, 33, 33),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final Email email = Email(
                        recipients: ['nikahtime@bk.ru'],
                        isHTML: false,
                      );
                      try {
                        await FlutterEmailSender.send(email);
                      } catch (error) {
                        if (error is PlatformException) {
                          if (error.code == 'not_available') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: Text(LocaleKeys
                                      .profileScreen_settings_error_header
                                      .tr()),
                                  content: Text(LocaleKeys
                                      .profileScreen_settings_error_text
                                      .tr())),
                            );
                            return;
                          }
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                              title: Text(LocaleKeys
                                  .profileScreen_settings_error_header
                                  .tr()),
                              content: Text(
                                  LocaleKeys.profileScreen_settings_mail.tr() +
                                      error.toString())),
                        );
                      }
                    },
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: LocaleKeys
                                .profileScreen_settings_connectToDevs
                                .tr(),
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 00, 207, 145),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 16,
                  ),
                  //==========================
                  //язык
                  Text(
                    LocaleKeys.profileScreen_settings_language_header.tr(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: const Color.fromARGB(255, 33, 33, 33),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.profileScreen_settings_language_text.tr(),
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: const Color.fromARGB(255, 33, 33, 33),
                        ),
                      ),
                      Switch(
                          value: context.locale == const Locale("en"),
                          onChanged: (isEnglish) {
                            if (!isEnglish) {
                              localize.EasyLocalization.of(context)
                                  ?.setLocale(const Locale("ru"));
                            } else {
                              localize.EasyLocalization.of(context)
                                  ?.setLocale(const Locale("en"));
                            }

                            setState(() {
                              //this.isEnglish = isEnglish;
                            });
                          }),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 16,
                  ),
                  //==========================
                  // Удаление аккаунта

                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      _showDeleteAccountAlertDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.delete_outline,
                            color: Color.fromARGB(255, 0xF4, 0x43, 0x36),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            LocaleKeys.profileScreen_settings_deleteAccount
                                .tr(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color:
                                  const Color.fromARGB(255, 0xF4, 0x43, 0x36),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (buildContext) => const ContactsPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.contacts_outlined,
                              color: Colors.blue),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'contacts'.tr(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.rubik(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 16,
                  ),
                  //Выход
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      await NetworkService().SendLogoutGet(
                          (context.read<ProfileBloc>().state as ProfileInitial)
                              .userProfileData!
                              .accessToken!);
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("token", "empty");
                      prefs.setString("userGender", "empty");
                      prefs.setInt("userId", 0);

                      try {
                        FirebaseMessaging messaging =
                            FirebaseMessaging.instance;
                        await messaging.deleteToken();
                      } catch (_) {}

                      context.read<ProfileBloc>().add(const ClearProfileInfo());

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const WelcomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.exit_to_app),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            LocaleKeys.profileScreen_settings_exit.tr(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 16,
                  ),
                ])),
          ),
        );
      },
    );
  }

  void _showDeleteAccountAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
          LocaleKeys.profileScreen_settings_deleteAccountAlert_cancel.tr()),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    Widget confirmButton = TextButton(
      child: Text(
          LocaleKeys.profileScreen_settings_deleteAccountAlert_confirm.tr()),
      onPressed: () async {
        try {
          await NetworkService().deleteAccount(
              accessToken: (context.read<ProfileBloc>().state as ProfileInitial)
                  .userProfileData!
                  .accessToken!);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("token", "empty");
          prefs.setString("userGender", "empty");
          prefs.setInt("userId", 0);

          try {
            FirebaseMessaging messaging = FirebaseMessaging.instance;
            await messaging.deleteToken();
          } catch (_) {}

          context.read<ProfileBloc>().add(const ClearProfileInfo());

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const WelcomeScreen(),
            ),
            (route) => false,
          );
        } catch (_) {
          Navigator.of(context).pop();
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
          LocaleKeys.profileScreen_settings_deleteAccountAlert_header.tr()),
      content:
          Text(LocaleKeys.profileScreen_settings_deleteAccountAlert_msg.tr()),
      actions: [cancelButton, confirmButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
