import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/Screens/Registration/registration_info_about_user.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/components/items/strings_list.dart';
import 'package:untitled/components/models/user_profile_data.dart';

import 'package:untitled/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' as localize;


bool isDataInserted = false;

class RegistrationAddInterestTagsScreen extends StatefulWidget {
  RegistrationAddInterestTagsScreen(this.userProfileData);

  UserProfileData userProfileData;

  @override
  State<RegistrationAddInterestTagsScreen> createState() => _RegistrationAddInterestTagsScreenState();
}

class _RegistrationAddInterestTagsScreenState extends State<RegistrationAddInterestTagsScreen> {
  @override

  String showTagLabelCurrentLocale(String str)
  {

    if(context.locale.languageCode == "en")
    {
      debugPrint(str);
      try{
        str = standartInterestList[str]!;
      }catch(err){debugPrint("EXEC");}
    }

    return str;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.userProfileData.toString());
    return Scaffold(
      appBar: const CustomAppBar(),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const _PhotoPlace(),
                          CustomInputDecoration().titleText(LocaleKeys.registration_interest_header.tr()),
                          CustomInputDecoration().subtitleText(LocaleKeys.registration_interest_subheader.tr()),
                          _Tags(),
                          _RegisterButton(widget.userProfileData),
                        ]
                    )
                )
            ),

            // SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<interestTag> notUsedItems = interestList;
  List<interestTag> usedItems = [];
  String currText = "";

  TextEditingController myController = TextEditingController();

  void addNew() {
    setState(() {

    });

    if (myController.text.isEmpty) {
      return;
    }

    for(int i = 0; i < usedItems.length; i++){
      if(usedItems[i].str == myController.text){
        myController.text = "";
        return;
      }
    }

    interestTag newItem = interestTag(
        myController.text,
        const Color.fromRGBO(0xc4, 0xee, 0xf3, 1)
    );

    for (int i = 0; i < notUsedItems.length; i++) {
      if(notUsedItems[i].str == myController.text) {
        newItem = notUsedItems[i];
        notUsedItems.remove(newItem);
        break;
      }
    }

    usedItems.add(newItem);
    widget.userProfileData.interests!.add(newItem.str);
    myController.text = "";
  }

  @override
  Widget _Tags() {
    return Column(
        children: [
          SizedBox(
            height: 40,
            child: TextField(
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8.0),
                hintText: LocaleKeys.registration_interest_addNew.tr(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: (){
                    addNew();
                  },
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 218, 216, 215),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 0, 207, 145),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              controller: myController,
              onSubmitted: (text){
                addNew();
              },
            ),
          ),

          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 12,
              runSpacing: 0,
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              children: usedChips(),
            ),
          ),

          if (usedItems.isNotEmpty && notUsedItems.isNotEmpty)
            const Column(
                children: [
                  SizedBox(height: 16),
                  Divider(
                      height: 1,
                      thickness: 1,
                      color: Color.fromRGBO(0, 0, 0, 0.12)
                  ),
                  SizedBox(height: 16),
                ]
            ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 12,
              runSpacing: 0,
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              children: notUsedChips(),
            ),
          ),
        ]
    );
  }

  List<Widget> notUsedChips () {
    List<Widget> chips = [];
    for (int i=0; i< notUsedItems.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.all(0),
        child: ChoiceChip(
          selected: false,
          label: Text(notUsedItems[i].str.tr()),
          labelStyle: const TextStyle(color: Colors.black),
          backgroundColor: notUsedItems[i].clr,
          //selected: selectedIndex == i,
          onSelected: (bool value)
          {
            setState(() {
              usedItems.add(notUsedItems[i]);
              widget.userProfileData.interests ??= [];
              widget.userProfileData.interests!.add(showTagLabelCurrentLocale(notUsedItems[i].str.tr()));
              notUsedItems.removeAt(i);
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  List<Widget> usedChips () {
    List<Widget> chips = [];
    for (int i = 0; i < usedItems.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.all(0),
        child: InputChip(
          selected: false,
          label: Text(usedItems[i].str.tr()),
          labelStyle: const TextStyle(color: Colors.black),
          backgroundColor: usedItems[i].clr,
          onDeleted: ()
          {
            setState(() {
              notUsedItems.add(usedItems[i]);
              widget.userProfileData.interests!.remove(usedItems[i].str.tr());
              usedItems.removeAt(i);
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }



}

class _PhotoPlace extends StatelessWidget{
  const _PhotoPlace ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return
      Container(
        width: double.infinity,
        height: 160,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/icons/gamepad.png'
            ),
            fit: BoxFit.contain,
          ),
          shape: BoxShape.rectangle,
        ),
      );
  }
}

class _RegisterButton extends StatelessWidget{
  _RegisterButton (this.userProfileData, {Key? key}) : super (key:key);
  UserProfileData userProfileData;
  @override
  Widget build(BuildContext context){
    return Container(
        padding: const EdgeInsets.only(top: 18, bottom: 24),
        width: double.infinity,
        child:
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 00, 0xcf, 0x91),
              elevation: 0,
              fixedSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              LocaleKeys.common_confirm.tr(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Color.fromARGB(255,255,255,255),
              ),
            ),
            onPressed:(){
              //debugPrint("${userProfileData.interests}");
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => RegistrationInfoAboutUserScreen(userProfileData),
                  transitionDuration: const Duration(seconds: 0),
                ),
              );
            }
        )
    );
  }
}

