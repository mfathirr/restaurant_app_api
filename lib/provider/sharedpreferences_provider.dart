import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/sharedpreferences_helper.dart';

class SharedPreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  SharedPreferencesProvider({required this.preferencesHelper}){
    _getDailyNotigPreferences();
  }

  bool _isDailyNotifActive = false;
  bool get isDailyNotifActive => _isDailyNotifActive;

  void _getDailyNotigPreferences() async {
    _isDailyNotifActive = await preferencesHelper.isDailyNotifActive();
    notifyListeners();
  }

  void enableDailyNotif(bool value) {
    preferencesHelper.setDailyNotif(value);
    _getDailyNotigPreferences();
  }
}
