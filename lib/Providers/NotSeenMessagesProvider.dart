import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ServiceItems/network_service.dart';

class NotSeenMessagesProvider extends ChangeNotifier {
  var _numberNotSeenMessages;

  get numberNotSeenMessages => _numberNotSeenMessages;

  void GetNumberNotSeenMessagesFromServer(String accessToken) async {
    var response = await NetworkService().ChatsUser(accessToken);
    var responseJson = jsonDecode(response.body);
    var count = 0;
    for (var field in responseJson) {
      count += field["numberNotSeenMessages"] as int;
    }

    if (response.statusCode != 200) {
      debugPrint("${response.body}");
      return;
    }

    count.toString() != _numberNotSeenMessages.toString()
        ? notifyListeners()
        : null;
    _numberNotSeenMessages = count.toString();
  }
}
