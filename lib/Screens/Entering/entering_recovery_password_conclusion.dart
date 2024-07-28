import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Entering/entering.dart';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';

class EnteringRecoveryPasswordConclusionScreen extends StatefulWidget {
  const EnteringRecoveryPasswordConclusionScreen();

  @override
  State<EnteringRecoveryPasswordConclusionScreen> createState() => _EnteringRecoveryPasswordConclusionScreenState();
}

class _EnteringRecoveryPasswordConclusionScreenState extends State<EnteringRecoveryPasswordConclusionScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(),

      body:  Container (
        margin: const EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        //margin: EdgeInsets.only(top: 104),
        child: Column(
          children: <Widget>[
            //SizedBox(height: 16),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          SizedBox(height: 62),
                          Container(
                            width: double.infinity,
                            height: 240,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/icons/confirmation.png'
                                ),
                                fit: BoxFit.contain,
                              ),
                              shape: BoxShape.rectangle,
                            ),
                          ),

                          SizedBox(height: 8),
                          _MyNumber(),
                          SizedBox(height: 8),
                          _Message(),
                          SizedBox(height: 32),
                        ]
                    )
                )
            ),
            _RegisterButton(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _MyNumber extends StatelessWidget{
  const _MyNumber ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.entering_conclusion_header.tr(),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: const Color.fromARGB(255,33,33,33),
      ),
    );
  }
}

class _Message extends StatelessWidget{
  const _Message ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.entering_conclusion_msg.tr(),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: GoogleFonts.rubik(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Color.fromARGB(255, 117, 116, 115),
      ),
      maxLines: 3,
    );
  }
}


class _RegisterButton extends StatelessWidget{
  const _RegisterButton ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Container(
        width: double.infinity,
        child:
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),

            child: Text(
              LocaleKeys.entering_conclusion_ok.tr(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: GoogleFonts.rubik(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            onPressed:(){
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => EnteringScreen(),
                  transitionDuration: const Duration(seconds: 0),
                ),
              );
            }
        )
    );
  }
}