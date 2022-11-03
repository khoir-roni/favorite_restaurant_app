
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/api/api_service.dart';
import 'data/db/db_helper.dart';
import 'data/models/restaurant_list.dart';
import 'data/preferences/preferences_helper.dart';
import 'provider/db_provider.dart';
import 'provider/preferences_provider.dart';
import 'provider/restaurant_list_provider.dart';
import 'provider/scheduling_provider.dart';
import 'screens/detail_page.dart';
import 'screens/favorite_page.dart';
import 'screens/home_page.dart';
import 'screens/search_result_screen.dart';
import 'screens/setting_page.dart';
import 'theme/theme.dart';
import 'utils/background_service.dart';
import 'utils/notification_helper.dart';
import 'package:http/http.dart' show Client;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  await AndroidAlarmManager.initialize();
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DatabaseProvider>(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider<RestaurantListProvider>(
            create: (_) => RestaurantListProvider(apiService: ApiService(Client()))),
        ChangeNotifierProvider<SchedulingProvider>(
            create: (_) => SchedulingProvider()),
        ChangeNotifierProvider<PreferencesProvider>(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: primaryColor,
                    onPrimary: Colors.black,
                    secondary: secondaryColor,
                  ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                ), // border button 0
              ),
              appBarTheme: const AppBarTheme(elevation: 0),
              textTheme: myTextTheme,
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          initialRoute: HomeScreen.routeName,
          routes: {
            HomeScreen.routeName: (context) => const HomeScreen(),
            DetailScreen.routeName: (context) => DetailScreen(
                  restaurant:
                      ModalRoute.of(context)?.settings.arguments as Restaurant,
                ),
            SearchResultScreen.routeName: (context) => SearchResultScreen(
                  query: ModalRoute.of(context)?.settings.arguments as String,
                ),
            FavoriteScreen.routeName: (context) => const FavoriteScreen(),
            SettingsPage.routeName: (context) => const SettingsPage(),
          }),
    );
  }
}
