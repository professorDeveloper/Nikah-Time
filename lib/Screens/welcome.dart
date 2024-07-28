import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:untitled/Screens/Entering/entering.dart';
import 'package:untitled/Screens/Profile/web_view_page.dart';
import 'package:untitled/generated/locale_keys.g.dart';

import 'Registration/registration_select_type.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        child: const Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget> [
                  AppFeaturesCarousel()
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CreateAccountButton(),
                    SizedBox(height: 16),
                    _LoginButton()
                    //_AuthLink()
                  ]
              )
            )

          ],
        )
      )
    );
  }
}

class _CreateAccountButton extends StatelessWidget{
  const _CreateAccountButton ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 00, 0xcf, 0x91),
              fixedSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),

            child: Text(
              LocaleKeys.welcome_screen_createAcc.tr(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            onPressed:() async {
              await ageConfirmationDialog(
                context: context,
              );
            }
        )
    );
  }
}

class _LoginButton extends StatelessWidget{
  const _LoginButton ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 0, 207, 145),
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(
              Radius.circular(12.0)
          ),
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              fixedSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),

            child: Text(
              LocaleKeys.welcome_screen_authorize.tr(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color.fromARGB(255, 00, 0xcf, 0x91),
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

ageConfirmationDialog({required BuildContext context}) async {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(LocaleKeys.welcome_screen_ageConfirmed_bad.tr()),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text(LocaleKeys.welcome_screen_ageConfirmed_good.tr()),
    onPressed:  () {
      Navigator.of(context).pop();
      useTermsConfirmation(context: context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(LocaleKeys.welcome_screen_ageConfirmed_question.tr()),
    content: Text(LocaleKeys.welcome_screen_ageConfirmed_action.tr()),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

useTermsConfirmation({required BuildContext context}) async {
  showModalBottomSheet(
    enableDrag: false,
    //expand: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)
        )
    ),
    context: context,
    builder: (buildContext) => Material(
      color: Colors.white,
      child: Column(
        children: [
          const Expanded(
            child: CustomWebView(
                initialUrl: "https://www.nikahtime.ru/user/app_use_terms",
                header: ""
            ),
          ),
          const SizedBox(height: 8,),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const RegistrationSelectTypeScreen()/*RegistrationPhoneNumberScreen()*/,
                  transitionDuration: const Duration(seconds: 0),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 00, 0xcf, 0x91),
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 207, 145),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(12.0)
                  ),
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.common_confirm.tr(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16,),
          GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 0, 207, 145),
                    width: 1.0,
                  ),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(12.0)
                  ),
                ),
                child: Center(
                  child: Text(
                    LocaleKeys.common_cancel.tr(),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color.fromARGB(255, 00, 0xcf, 0x91),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    )
  );

}

class NikahCarouselItem {
  String icon;
  String title;
  String description;
  Color color;

  NikahCarouselItem(this.icon, this.title, this.description, this.color);
}

final List<NikahCarouselItem> nikahCarouselItems = [
  NikahCarouselItem(
      'assets/icons/about_app_features/filters.png',
      LocaleKeys.welcome_screen_carousel_item1_header.tr(),
      LocaleKeys.welcome_screen_carousel_item1_text.tr(),
      const Color.fromARGB(255, 0x84, 0x43, 0xf9)
  ),
  NikahCarouselItem(
      'assets/icons/about_app_features/people.png',
      LocaleKeys.welcome_screen_carousel_item2_header.tr(),
      LocaleKeys.welcome_screen_carousel_item2_text.tr(),
      const Color.fromARGB(255, 0xff, 0xa4, 0x05)
  ),
  NikahCarouselItem(
      'assets/icons/about_app_features/chating.png',
      LocaleKeys.welcome_screen_carousel_item3_header.tr(),
      LocaleKeys.welcome_screen_carousel_item3_text.tr(),
      const Color.fromARGB(255, 0xef, 0x3e, 0x4a)
  )
];

final List<Widget> itemSliders = nikahCarouselItems
    .map((item) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 160,
                  maxWidth: 160,
                  minHeight: 160,
                  maxHeight: 160
                ),
                child: Image.asset(item.icon, fit: BoxFit.contain)
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
                flex: 0,
                child: Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: item.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      fontFamily: 'Rubik',
                    )
                )
            ),
            const SizedBox(height: 8),
            Expanded(
                flex: 0,
                child:  Text(
                    item.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0x21, 0x21, 0x21),
                      fontSize: 14,
                      fontFamily: 'Rubik',
                      height: 1.4
                    )
                )
            ),
          ],
)).toList();

class AppFeaturesCarousel extends StatefulWidget {
  const AppFeaturesCarousel({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppFeaturesCarouselState();
  }
}

class _AppFeaturesCarouselState extends State<AppFeaturesCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(

        mainAxisSize: MainAxisSize.max,
        children: [
          CarouselSlider(
            items: itemSliders,
            carouselController: _controller,
            options: CarouselOptions(
                height: 340,
                autoPlay: true,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                disableCenter: true,
                aspectRatio: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        // const SizedBox(height: 90),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: nikahCarouselItems.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == entry.key ? entry.value.color : const Color.fromARGB(255, 0xc4, 0xc3, 0xc1),
              ),
            ));
          }).toList(),
        ),
      ]);
  }
}