import 'setting_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/api/api_service.dart';
import '../provider/restaurant_list_provider.dart';
import '../theme/theme.dart';
import '../utils/notification_helper.dart';
import 'detail_page.dart';
import 'restaurant_list_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  static const String _headlineText = 'Restaurant';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(DetailScreen.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  int _bottomNavIndex = 0;

  final List<Widget> _listWidget = [
    ChangeNotifierProvider<RestaurantListProvider>(
      create: (_) => RestaurantListProvider(apiService: ApiService()),
      child: const RestaurantListScreen(),
    ),
     const SearchScreen(),
    const SettingsPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.public),
      label: HomeScreen._headlineText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: SearchScreen.title,
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      label: SettingsPage.title,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _listWidget[_bottomNavIndex]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: secondaryColor,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
