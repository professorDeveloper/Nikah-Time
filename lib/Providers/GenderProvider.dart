import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/ServiceItems/network_service.dart';

class GenderProvider extends ChangeNotifier {
  bool _isMale = true;

  bool get isMale => _isMale;

  void SetGender(bool isMale) {
    _isMale = isMale;
    notifyListeners();
  }
}
