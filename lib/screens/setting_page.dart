import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/preferences_provider.dart';
import '../provider/scheduling_provider.dart';

class SettingsPage extends StatelessWidget {
  static const title = "Setting";
  static const String routeName = '/setting_page';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Material(
        child: Consumer<PreferencesProvider>(
          builder: (context, provider, child) {
            return ListTile(
              title: const Text('Restaurant App Notification'),
              trailing: Consumer<SchedulingProvider>(
                builder: (context, scheduled, _) {
                  return Switch.adaptive(
                    value: provider.isDailyRestaurantActivate,
                    onChanged: (value) async {
                      scheduled.scheduleFavorite(value);
                      provider.enableDailyRestaurant(value);
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
