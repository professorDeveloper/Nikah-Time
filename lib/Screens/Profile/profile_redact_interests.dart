import 'dart:math';

import 'package:easy_localization/easy_localization.dart' as localize;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/components/widgets/custom_appbar.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/items/strings_list.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';

bool isDataInserted = false;

class UpdateInterests extends StatefulWidget {
  UpdateInterests(this.userProfileData);

  UserProfileData userProfileData;

  @override
  State<UpdateInterests> createState() => _UpdateInterestsState();
}

class _UpdateInterestsState extends State<UpdateInterests> {

  String showTagLabelCurrentLocale(String str)
  {
    if(context.locale.languageCode == "en")
    {
      try{
        var reversed = Map.fromEntries(standartInterestList.entries.map((e) => MapEntry(e.value, e.key)));
        str = reversed[str]!;
      }catch(err){debugPrint("EXEC");}
    }

    return str;
  }

  @override
  void initState() {
    debugPrint("init");
    usedItems = widget.userProfileData.interests!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.userProfileData.toString());
    for(int i = 0; i < widget.userProfileData.interests!.length;i++){
      if(notUsedItems.contains(widget.userProfileData.interests![i])){
        notUsedItems.remove(widget.userProfileData.interests![i]);
      }
    }
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
                          const _Header(),
                          const SizedBox(height: 8),
                          Text(
                            LocaleKeys.registration_interest_subheader.tr(),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Color.fromARGB(255, 117, 116, 115),
                                height: 1.4
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 24),
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

  List<String> notUsedItems = standartInterestList.values.toList();

  late List<String> usedItems;
  String currText = "";

  TextEditingController myController = TextEditingController();

  void addNew() {
    setState(() {

    });

    if (myController.text.isEmpty) {
      return;
    }

    if(usedItems.contains(myController.text)){
      myController.text = "";
      return;
    }

    if(myController.text.length > 25){
      error = true;
      errorMsg = LocaleKeys.registration_error_maxLength.tr();
      return;
    }

    String newItem = myController.text;


    for (int i = 0; i < notUsedItems.length; i++) {
      if(notUsedItems[i] == myController.text) {
        newItem = notUsedItems[i];
        notUsedItems.remove(newItem);
        break;
      }
    }

    usedItems.add(newItem);
    myController.text = "";
  }

  bool error = false;
  String errorMsg = "";

  @override
  Widget _Tags() {
    return Column(
        children: [
          SizedBox(
            height: 40,
            child: TextField(
              textCapitalization: TextCapitalization.words,
              onChanged: (value){
                if(error == true){
                  error = false;
                  setState(() {

                  });
                }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                hintText: LocaleKeys.registration_interest_addNew.tr(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
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
          CustomInputDecoration().errorBox(error, errMessage: errorMsg),
          SizedBox(height: 10),
          Container(
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
            Column(
                children: const [
                  SizedBox(height: 16),
                  Divider(
                      height: 1,
                      thickness: 1,
                      color: Color.fromRGBO(0, 0, 0, 0.12)
                  ),
                  SizedBox(height: 16),
                ]
            ),
          Container(
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
      if(widget.userProfileData.interests!.contains(notUsedItems[i])){
        continue;
      }
      Widget item = Padding(
        padding: const EdgeInsets.all(0),
        child: ChoiceChip(
          selected: false,
          label: Text(showTagLabelCurrentLocale(notUsedItems[i])),
          labelStyle: TextStyle(color: Colors.black),
          disabledColor: tagsColors[Random().nextInt(tagsColors.length - 1)],
          backgroundColor: tagsColors[Random().nextInt(tagsColors.length - 1)],
          onSelected: (bool value)
          {
              if(usedItems.contains(notUsedItems[i]) == false){
                usedItems.add(notUsedItems[i]);
              }
              widget.userProfileData.interests!= usedItems;
              notUsedItems.removeAt(i);
              setState(() {});
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
          label: Text(showTagLabelCurrentLocale(usedItems[i])),
          labelStyle: TextStyle(color: Colors.black),
          backgroundColor: tagsColors[Random().nextInt(tagsColors.length - 1)],
          onDeleted: ()
          {
              if(notUsedItems.contains(usedItems[i]) == false){
                notUsedItems.add(usedItems[i]);
              }
              usedItems.removeAt(i);
              widget.userProfileData.interests!= usedItems;
              setState(() {});
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

}


class _Header extends StatelessWidget{
  const _Header ({Key? key}) : super (key:key);

  @override
  Widget build(BuildContext context){
    return Text(
      LocaleKeys.registration_interest_header.tr(),
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
              fixedSize: Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              LocaleKeys.common_confirm.tr(),
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: const Color.fromARGB(255,255,255,255),
              ),
            ),
            onPressed:() async {
              await NetworkService().UpdateuserInfo(userProfileData.accessToken.toString(), userProfileData.returnUserData());
              Navigator.pop(context);
            }
        )
    );
  }
}

