import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/News/format_data.dart';

Widget button({
  required IconData iconData,
  required Color iconColor,
  Color backgroundColor = Colors.white,
  bool disableShadow = false,
  required int value,
  bool showZero = false,
  Function? action
})
{
  return GestureDetector(
    onTap: (){
      if(action != null) action();
    },
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: disableShadow ? Colors.transparent : Colors.black12,
            offset: const Offset(
              0.0,
              2.0,
            ),
            blurRadius: 2.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 30,
            child: Icon(
              iconData,
              size: 24,
              color: iconColor,
            ),
          ),
          Visibility(
              visible: showZero || value != 0,
              child: Row(
                children: [
                  const SizedBox(width: 6,),
                  Text(
                    formatDigits(value),
                    style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color.fromRGBO(0, 0, 0, 1)
                    ),
                  )
                ],
              )
          )

        ],
      ),
    ),
  );
}