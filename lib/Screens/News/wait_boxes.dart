import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/generated/locale_keys.g.dart';

Widget newsListWaitBox() {
  return _waitBox(label: LocaleKeys.news_loading_feed.tr());
}

Widget singleNewsWaitBox() {
  return _waitBox(label: LocaleKeys.news_loading_news.tr());
}

Widget answersWaitBox() {
  return _waitBox(label: LocaleKeys.news_loading_commentaries.tr());
}

Widget _waitBox({required String label}) {
  return Center(
    child: Column(
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
          label,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: const Color.fromRGBO(0, 0xcf, 0x91, 1),
          ),
        ),
      ],
    ),
  );
}
