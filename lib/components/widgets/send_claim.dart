import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/components/widgets/custom_input_decoration.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/components/models/user_profile_data.dart';
import 'package:untitled/generated/locale_keys.g.dart';

enum ClaimType
{
  photo,
  commentary
}

class SendClaim{
  final int claimObjectId;
  final ClaimType type;

  List<String> claimReason = <String>[
    LocaleKeys.claim_claimReason_propaganda.tr(),
    LocaleKeys.claim_claimReason_misleading.tr(),
    LocaleKeys.claim_claimReason_promo.tr(),
    LocaleKeys.claim_claimReason_bulling.tr(),
    LocaleKeys.claim_claimReason_adults.tr(),
    LocaleKeys.claim_claimReason_spam.tr(),
    LocaleKeys.claim_claimReason_finance.tr(),
  ];


  SendClaim({required this.claimObjectId, required this.type});

  String claim = "";
  TextEditingController cntrl = TextEditingController();
  bool needFillField = true;

  ShowAlertDialog(BuildContext context) async {
    Widget continueButton = TextButton(
      child: Text(LocaleKeys.claim_send.tr()),
      onPressed:  () async {
        if(needFillField) return;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString("token") ?? "";

        Navigator.of(context).pop();
        switch(type){
          case ClaimType.photo:
            NetworkService().SendComplain(
                token,
                claimObjectId,
                claim,
                cntrl.text
            );
            break;
          case ClaimType.commentary:
            NetworkService().SendComplainComment(
                token,
                claimObjectId,
                claim,
                cntrl.text
            );
            break;
        }

      },
    );
    Widget cancelButton = TextButton(
      child: Text(LocaleKeys.common_cancel.tr()),
      onPressed:  () async {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LocaleKeys.claim_reason.tr()),
      content: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(LocaleKeys.claim_description).tr(),
              const SizedBox(height: 8,),
              TextDropdownFormField(
                options: claimReason,
                decoration: CustomInputDecoration(
                  hintText: LocaleKeys.claim_reason.tr(),
                ).GetDecoration(),
                dropdownHeight: 150,
                onChanged: (dynamic value){
                  claim = value;
                },
                onSaved: (dynamic value){
                  claim = value;
                },
              ),
              const SizedBox(height: 8,),
              TextField(
                decoration: CustomInputDecoration(
                  hintText: LocaleKeys.claim_comment.tr(),
                ).GetDecoration(),
                minLines: 1,
                maxLines: 5,
                maxLength: cntrl.text.isEmpty ? null : 255,
                controller: cntrl,
                onChanged: (value){
                  setState((){
                    needFillField = cntrl.text.isEmpty;
                  });
                },
              ),
              Visibility(
                  visible: needFillField,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      LocaleKeys.common_errorHintText.tr(),
                      style: GoogleFonts.rubik(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  )
              )
            ],
          );
        },
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: alert,
        );
      },
    );
  }

}