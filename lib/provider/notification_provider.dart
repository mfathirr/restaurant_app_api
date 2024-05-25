import 'package:flutter/material.dart';
import 'package:restaurant_app_api/common/notification.dart';

class NotificationProvider extends ChangeNotifier {
  bool _isNotificationEnabled = false;

  bool get isNotificationEnabled => _isNotificationEnabled;

  final NotificationService notificationService = NotificationService();
  Future<void> switchNotification(bool isEnabled) async {
    _isNotificationEnabled = isEnabled;
    notifyListeners();

    if (isEnabled) {
      await notificationService.scheduledNotification();
      print("nyla min ;");
    } else {
      await NotificationService.flutterLocalNotificationsPlugin.cancelAll();
      print("mokad min ;");
    }
  }
}
