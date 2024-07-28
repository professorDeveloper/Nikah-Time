import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/components/items/app_utils.dart';
import 'package:untitled/generated/locale_keys.g.dart';

class PolicyAgreement extends StatelessWidget {
  const PolicyAgreement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.only(left: 48),
        padding: const EdgeInsets.only(bottom: 24),
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: LocaleKeys.registration_appendix_text.tr(),
                      style: const TextStyle(
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color.fromARGB(255, 117, 116, 115),
                      ),
                    ),
                    TextSpan(
                      text: LocaleKeys.registration_appendix_item1.tr(),
                      style: const TextStyle(
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color.fromARGB(255, 00, 0xCF, 0x91),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          AppUtils.launchInBrowser(
                              "http://nikahtime.ru/privacy/policy");
                        },
                    ),
                    TextSpan(
                      text: LocaleKeys.registration_appendix_and.tr(),
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: const Color.fromARGB(255, 117, 116, 115),
                      ),
                    ),
                    TextSpan(
                      text: LocaleKeys.registration_appendix_item2.tr(),
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: const Color.fromARGB(255, 00, 0xCF, 0x91),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          AppUtils.launchInBrowser(
                              "http://nikahtime.ru/user/agreement");
                        },
                    ),
                  ],
                ),
              ),
            ]
        )
    );
  }
}
