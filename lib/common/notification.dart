import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/data/model/restaurant.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

import 'navigation.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationService {
  static NotificationService? _instance;

  NotificationService._internal() {
    _instance = this;
  }

  factory NotificationService() => _instance ?? NotificationService._internal();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future init(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
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
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        final payload = details.payload;
        if (payload != null) {
          print('notification payload: ' + payload);
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Welcome result) async {
    var androidPlatform = AndroidNotificationDetails('1', "channel_1",
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatform,
    );

    var restaurant = await ApiService(Client()).fetchData();
    var restaurantList = restaurant.restaurants;
    var randomIndex = Random().nextInt((restaurantList.length));
    var randomRestaurant = restaurantList[randomIndex];

    await flutterLocalNotificationsPlugin.show(0, "Best Restaurant for you",
        randomRestaurant.name, platformChannelSpecifics,
        payload: json.encode(result.toJson()));
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = Welcome.fromJson(json.decode(payload));
        var article = data.restaurants[0];
        Navigation.intenWithData(route, article);
      },
    );

    // Future scheduledNotification() async {
    //   var restaurant = await ApiService(Client()).fetchData();
    //   var restaurantList = restaurant.restaurants;
    //   var randomIndex = Random().nextInt((restaurantList.length));
    //   var randomRestaurant = restaurantList[randomIndex];

    //   await flutterLocalNotificationsPlugin.zonedSchedule(
    //       0,
    //       'Trending Restaurant',
    //       randomRestaurant.name,
    //       setTimeDailyNotification(),
    //       const NotificationDetails(
    //           android: AndroidNotificationDetails(
    //               'your channel id', 'your channel name',
    //               channelDescription: 'your channel description',
    //               importance: Importance.max,
    //               priority: Priority.high,
    //               ticker: 'ticker')),
    //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    //       uiLocalNotificationDateInterpretation:
    //           UILocalNotificationDateInterpretation.absoluteTime);
    // }

    // setTimeDailyNotification() {
    //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    //   tz.TZDateTime scheduledDate =
    //       tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);

    //   if (scheduledDate.isBefore(now)) {
    //     scheduledDate = scheduledDate.add(const Duration(days: 1));
    //   }
    //   return scheduledDate;
    // }
  }
}
