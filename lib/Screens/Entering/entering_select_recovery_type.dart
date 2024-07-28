import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Screens/Entering/entering_recovery_password_by_email.dart';
import 'package:untitled/Screens/Entering/entering_recovery_password_by_phone_number.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:untitled/generated/locale_keys.g.dart';

class EnteringSelectRecoveryPasswordTypeScreen extends StatefulWidget {
  const EnteringSelectRecoveryPasswordTypeScreen();

  @override
  State<EnteringSelectRecoveryPasswordTypeScreen> createState() => _EnteringSelectRecoveryPasswordTypeScreenState();
}

class _EnteringSelectRecoveryPasswordTypeScreenState extends State<EnteringSelectRecoveryPasswordTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body:  Container (
        margin: const EdgeInsets.only(left: 16, right: 16),
        width: double.infinity,
        //margin: EdgeInsets.only(top: 104),
        child: Column(
          children: [
            Header(),
            SizedBox(height: 16,),
            Container(
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
                      LocaleKeys.entering_checkType_number.tr(),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed:(){
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const EnteringRecoveryPasswordByPhoneNumberScreen(),
                          transitionDuration: const Duration(seconds: 0),
                        ),
                      );
                    }
                )
            ),
            SizedBox(height: 16,),
            Container(
              width: double.infinity,
              child:
              MaterialButton(
                  height: 64,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(width: 1, color: Color.fromARGB(255, 218, 216, 215)),
                  ),
                  child: Text(
                    LocaleKeys.entering_checkType_email.tr(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 207, 145),
                    ),
                  ),
                  onPressed:(){
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const EnteringRecoveryPasswordByEmailScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    );
                    setState(() {});
                  }
              ),
            ),

          ],
        ),
      ),




    );
  }
}

class Header extends StatelessWidget{
  const Header ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.entering_checkType_header.tr(),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      style: GoogleFonts.rubik(
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: const Color.fromARGB(255,33,33,33),
      ),
    );
  }
}




