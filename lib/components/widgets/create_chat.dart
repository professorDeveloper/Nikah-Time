import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mytracker_sdk/mytracker_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/Screens/Chat/chat_class.dart';
import 'package:untitled/ServiceItems/network_service.dart';
import 'package:untitled/generated/locale_keys.g.dart';

import '../../Screens/Chat/chat_with_user.dart';

class CreateChat{
  BuildContext context;
  final String userProfileGender;
  final int userProfileID;
  final void Function(ChatWithLastMessage)? afterPopCallback;

  CreateChat(
    this.context,
    this.userProfileGender,
    this.userProfileID,
    {this.afterPopCallback,}
  );

  void createChatWithUser(int userID) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token") ?? "";

    var response = await NetworkService().ChatsAddUserID(accessToken, userID);
    debugPrint("Попытка создания нового чата ${response.statusCode}");
    debugPrint("Результат ${response.body}");

    if(response.statusCode != 200){
      _showAlertDialog(context);
      return;
    }
    MyTracker.trackEvent("Create new chat", {});
    int chatID = jsonDecode(response.body)["chatId"];
    response = await NetworkService().ChatsUser(accessToken);

    debugPrint("Загрузка всех чатов пользователя. Код: ${response.statusCode}");
    //debugPrint("${response.body}");

    debugPrint("ChatID ${chatID.toString()}");

    List<dynamic> userChats = jsonDecode(response.body);
    debugPrint(userChats.length.toString());
    for(int i = 0; i < userChats.length; i++){
      ChatWithLastMessage newChat = ChatWithLastMessage();
      newChat.GetDataFromJson(userChats[i]);
      if(newChat.chatId == chatID){
        debugPrint("New chat ID ${newChat.chatId.toString()}");
        debugPrint("!!!");
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ChatWithUserScreen(newChat, userProfileGender, userProfileID),
            transitionDuration: const Duration(seconds: 0),
          ),
        ).then((chatWithLastMessage) {
          if (chatWithLastMessage is ChatWithLastMessage) {
            if (afterPopCallback != null) {
              afterPopCallback!(chatWithLastMessage);
            }
          }
        });
      }
    }
  }


  _showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(LocaleKeys.chat_cancelButtonText.tr()),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );


    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LocaleKeys.chat_attentionHeader.tr()),
      content: Text(LocaleKeys.chat_attentionText.tr()),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}