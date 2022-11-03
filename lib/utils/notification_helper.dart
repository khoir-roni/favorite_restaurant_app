import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import '../common/navigation.dart';
import '../data/models/restaurant_list.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettings = const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'));

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        final payload = details.payload;
        if (payload != null) {
          print('notification payload: $payload');
        }
        selectNotificationSubject.add(payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantList restaurant) async {
    var channelId = '1';
    var channelName = 'channel_01';
    var channelDescription = 'Restaurant app channel';
    final random = Random();

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    var titleNotification = '<b>Restaurant App</b>';
    var resto = restaurant.restaurants;
    var randomNumber = random.nextInt(resto.length);
    // var restoRandom = resto[randomNumber];
    var titleResto = resto[randomNumber].name;

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      titleResto,
      platformChannelSpecifics,
      payload: json.encode(resto[randomNumber].toJson()),
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((String payload) async {
      var resto = Restaurant.fromJson(json.decode(payload));
      Navigation.intentWithData(route, resto.id);
    });
  }
}
