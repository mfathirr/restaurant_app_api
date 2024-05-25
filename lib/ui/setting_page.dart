import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/sharedpreferences_helper.dart';
import 'package:restaurant_app_api/provider/notification_provider.dart';
import 'package:restaurant_app_api/provider/sharedpreferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: _bodySetting(context),
      providers: [
        ChangeNotifierProvider(
          create: (context) => SharedPreferencesProvider(
              preferencesHelper: PreferencesHelper(
                  sharedPreferences: SharedPreferences.getInstance())),
        ),
        ChangeNotifierProvider(create: (context) => NotificationProvider())
      ],
    );
  }

  SafeArea _bodySetting(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Consumer<NotificationProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Scheduled Notification",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Consumer<SharedPreferencesProvider>(
                  builder: (BuildContext context,
                      SharedPreferencesProvider provider, Widget? child) {
                    return Switch(
                      value: provider.isDailyNotifActive,
                      onChanged: (result) {
                        value.switchNotification(result);
                        provider.enableDailyNotif(result);
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
