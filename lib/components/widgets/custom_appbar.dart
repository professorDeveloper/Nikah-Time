import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar ({Key? key}) : super (key:key);

  final double barHeight = 72.0;
  double getStatusbarHeight(BuildContext context) {
    return MediaQuery
        .of(context)
        .padding
        .top;
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(barHeight + getStatusbarHeight(context)),
        child: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white,
              statusBarColor: Color.fromARGB(255, 0xf5, 0xf5, 0xf5),
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.dark
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            height: barHeight + getStatusbarHeight(context),
            padding: EdgeInsets.only(top: getStatusbarHeight(context), left: 8),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Transform.scale(
              scale: 0.7,
              child: IconButton(
                  splashRadius: 34.0,
                  iconSize: 32.0,
                  padding: const EdgeInsets.all(0),
                  icon: Image.asset("assets/icons/arrow_back.png"),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
            ),
              ],
            ),
          ),
        )
    );
  }

  @override
  //TODO: + getStatusbarHeight(context)
  Size get preferredSize => Size.fromHeight(barHeight + 0);
}