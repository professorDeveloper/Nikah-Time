

import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/generated/locale_keys.g.dart';

PreferredSizeWidget BackNavigateAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: IconDecoration(),
            child: IconButton(
                splashRadius: 1,
                iconSize: 20.0,
                padding: const EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color.fromARGB(255, 117, 116, 115),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
          ),
        ]
    ),
    automaticallyImplyLeading: false,
  );
}

PreferredSizeWidget simpleAppBarWithSearch(
  BuildContext context,
  {
    required Function onSearchAction
  }
)
{
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.news_header.tr(),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          style: GoogleFonts.rubik(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: const Color.fromARGB(255, 33, 33, 33),
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: IconDecoration(),
          child: IconButton(
            splashRadius: 1,
            iconSize: 20.0,
            padding: const EdgeInsets.all(0),
            icon: const Icon(
              Icons.search,
              color: Color.fromARGB(255, 117, 116, 115),
            ),
            onPressed: () {
              onSearchAction();

            }
          ),
        ),
      ]
    ),
    automaticallyImplyLeading: false,
  );
}


PreferredSizeWidget searchAppBar(BuildContext context,
  {
    required TextEditingController textEditingController,
    required Function onBackAction,
    required Function onClearAction,
    required Function onSubmitAction
  })
{
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: IconDecoration(),
          child: IconButton(
            splashRadius: 1,
            iconSize: 20.0,
            padding: const EdgeInsets.all(0),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color.fromARGB(255, 117, 116, 115),
            ),
            onPressed: () {
              onBackAction();
            }
          ),
        ),
        const SizedBox(width: 8,),
        Flexible(
          flex: 1,
          child: Container(
            height: 32,
            padding: const EdgeInsets.only(left: 6),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0xfb, 0xfb, 0xff, 1),
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              border: Border.all(
                color: Colors.green,
              )
            ),
            child: Center(
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromRGBO(0x5A, 0x5A, 0xEE, 0),
                  suffixIcon: GestureDetector(
                    onTap: (){
                      onClearAction();
                    },
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Color.fromARGB(255, 117, 116, 115),
                    ),
                  ),
                  hintText: LocaleKeys.news_searchHint.tr(),
                  hintStyle: const TextStyle(
                      color: Color.fromRGBO(110, 122, 145, 1),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1
                  ),
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(110, 122, 145, 1),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  border: const UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: const BorderSide(color: Color.fromRGBO(0xfb, 0xfb, 0xff, 1)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: const BorderSide(color: const Color.fromRGBO(0xfb, 0xfb, 0xff, 1)),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: const Color.fromRGBO(0xfb, 0xfb, 0xff, 1)),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: const BorderSide(color: Color.fromRGBO(0xff, 0x45, 0x67, 1)),
                  ),
                  focusedErrorBorder: const UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: Color.fromRGBO(0xff, 0x45, 0x67, 1)),
                  ),
                ),
                onSubmitted: (value){
                  onSubmitAction(value);
                },
              ),
            ),
          )
        )
      ]
    ),
    automaticallyImplyLeading: false,
  );
}


BoxDecoration IconDecoration() {
  return BoxDecoration(
    border: Border.all(
      width: 1.0,
      color: const Color.fromARGB(255, 218, 216, 215),
    ),
    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
  );
}