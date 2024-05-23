import 'package:flutter/material.dart';

class ScreenindexProvider extends ChangeNotifier {
  int screenIndex = 0;
  int get fetchCurrentScreenIndex {
    return screenIndex;
  }

  void updateScreenIndex(int newIndex) {
    screenIndex = newIndex;
    notifyListeners();
  }
}