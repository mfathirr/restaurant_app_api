import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) => null,
    );
  }

  Future simpleNotification() async {
    var restaurant = await ApiService().fetchData();
    var restaurantList = restaurant.restaurants;
    var randomIndex = Random().nextInt((restaurantList.length));
    var randomRestaurant = restaurantList[randomIndex];

    await flutterLocalNotificationsPlugin.show(
        1,
        "Testing",
        randomRestaurant.name,
        const NotificationDetails(
            android: AndroidNotificationDetails('simple notif', 'channel notif',
                channelDescription: ' channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker')));
  }

  Future scheduledNotification() async {
    var restaurant = await ApiService().fetchData();
    var restaurantList = restaurant.restaurants;
    var randomIndex = Random().nextInt((restaurantList.length));
    var randomRestaurant = restaurantList[randomIndex];

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Trending Restaurant',
        randomRestaurant.name,
        setTimeDailyNotification(),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  setTimeDailyNotification() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
