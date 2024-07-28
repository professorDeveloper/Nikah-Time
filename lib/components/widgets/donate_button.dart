import 'dart:convert';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Profile/web_view_page.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class DonateButton extends StatelessWidget
{
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        height: 40,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(
              width: 1, color: Color.fromARGB(255, 0, 207, 145)),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 2,
            ),
            Text(
              LocaleKeys.profileScreen_settings_donate_msg
                  .tr(), //"2202 2032 5291 7218",
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color.fromARGB(255, 0, 207, 145),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.credit_card_rounded,
                  color: Color.fromARGB(255, 0, 207, 145),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  "2202 2032 5291 7218", //,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Color.fromARGB(255, 0, 207, 145),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
          ],
        ),
        onPressed: () {
          showAlertDialog(context);
        }
      ),
    );
  }

  showAlertDialog(BuildContext context) async {
    Widget continueButton = TextButton(
      child: Text(LocaleKeys.common_confirm.tr()),
      onPressed: () async {
        Navigator.of(context).pop();
        showDonateDialog(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text(LocaleKeys.common_cancel.tr()),
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LocaleKeys.profileScreen_settings_donate_msg.tr()),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(LocaleKeys.profileScreen_settings_donate_msg_text.tr()),
          Container(
            width: double.infinity,
            child: paymentInfo(context),
          )
        ],
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget paymentInfo(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 8,),
        GestureDetector(
          onTap: () async {
            //_launchInBrowser("https://www.nikahtime.ru/payment/rules");
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => CustomWebView(
                      initialUrl: "https://www.nikahtime.ru/payment/rules",
                      header: "Правила оплаты",
                    )
                )
            );
          },
          child: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                  LocaleKeys.profileScreen_settings_paymentRules.tr(),
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
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => CustomWebView(
                      initialUrl: "https://www.nikahtime.ru/refund/policy",
                      header: "Политика возвратов",
                    )
                )
            );
          },
          child: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                  LocaleKeys.profileScreen_settings_refundRules.tr(),
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
      ],
    );
  }

  showDonateDialog(BuildContext context) async {
    Widget continueButton = TextButton(
      child: Text(LocaleKeys.common_apply.tr()),
      onPressed: () async {
        final response = await NetworkService().SendDonate(int.parse(controller.text), context.locale.languageCode);

        if (response.statusCode != 200) {
          debugPrint("Donate Error ${response.body}");
          Navigator.of(context).pop();
          showSnackBar(context);
          return;
        }

        String url = jsonDecode(response.body)["redirectUrl"];

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CustomWebView(
              initialUrl: url,
              header: "",
            )
          )
        ).then((value) => Navigator.of(context).pop());

      },
    );
    Widget cancelButton = TextButton(
      child: Text(LocaleKeys.common_cancel.tr()),
      onPressed: () async {
        controller.text = "";
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LocaleKeys.profileScreen_settings_donate_msg.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            decoration: CustomInputDecoration(
              hintText: "0 ₽",
            ).GetDecoration(),
            controller: controller,
          ),
        ],
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void showSnackBar(BuildContext context) {
    SnackBar snackBar = SnackBar(
      content: Text(LocaleKeys.entering_recoveryBy_error.tr()),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}