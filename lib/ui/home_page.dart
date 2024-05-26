import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/notification.dart';
import 'package:restaurant_app_api/provider/screen_provider.dart';
import 'package:restaurant_app_api/ui/favorite_page.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';
import 'package:restaurant_app_api/ui/restaurant_list_page.dart';
import 'package:restaurant_app_api/ui/setting_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService _notificationHelper = NotificationService();
  final List<dynamic> screens = [
    const RestaurantList(),
    const FavoritePage(),
    const SettingPage()
  ];

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(DetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenProvider = Provider.of<ScreenindexProvider>(context);
    int currentIndexScreen = _screenProvider.fetchCurrentScreenIndex;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: const Color(0xFF1A4D2E),
          onTap: (value) {
            _screenProvider.updateScreenIndex(value);
          },
          currentIndex: currentIndexScreen,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.food_bank), label: 'Restaurants'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorites'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ]),
      body: screens[currentIndexScreen],
    );
  }
}
