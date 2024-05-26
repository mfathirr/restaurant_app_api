import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app_api/common/notification.dart';

import '../common/background_service.dart';
import '../common/date_time.dart';

class NotificationProvider extends ChangeNotifier {
  bool _isNotificationEnabled = false;

  bool get isNotificationEnabled => _isNotificationEnabled;

  // final NotificationService notificationService = NotificationService();
  // Future<void> switchNotification(bool isEnabled) async {
  //   _isNotificationEnabled = isEnabled;
  //   notifyListeners();

  //   if (isEnabled) {
  //     await notificationService.scheduledNotification();
  //     print("nyla min ;");
  //   } else {
  //     await NotificationService.flutterLocalNotificationsPlugin.cancelAll();
  //     print("mokad min ;");
  //   }
  // }

Future<bool> scheduledNews(bool value) async {
    _isNotificationEnabled = value;
    if (_isNotificationEnabled) {
      print('Scheduling News Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling News Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
