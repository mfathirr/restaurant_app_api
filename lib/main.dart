import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_api/common/navigation.dart';
import 'package:restaurant_app_api/data/api/api_service.dart';
import 'package:restaurant_app_api/provider/db_provider.dart';
import 'package:restaurant_app_api/provider/restaurant_provider.dart';
import 'package:restaurant_app_api/provider/screen_provider.dart';
import 'package:restaurant_app_api/ui/home_page.dart';
import 'package:restaurant_app_api/ui/restaurant_detail_page.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'common/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScreenindexProvider()),
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(
            ApiService(Client()),
          ),
        ),
        ChangeNotifierProvider(create: (context) => DbProvider())
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Restaurant App with API',
        theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily,
            textTheme: Theme.of(context)
                .textTheme
                .apply(fontFamily: GoogleFonts.poppins().fontFamily)),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          DetailPage.routeName: (context) => DetailPage(
              id: ModalRoute.of(context)?.settings.arguments as String),
        },
      ),
    );
  }
}
