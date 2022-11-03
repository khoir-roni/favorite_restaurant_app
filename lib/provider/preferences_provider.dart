import 'package:flutter/foundation.dart';

import '../data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  late PreferencesHelper preferencesHelper;

  bool _isDailyRestoActive = false;
  bool get isDailyRestaurantActivate => _isDailyRestoActive;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyRestoPreferences();
  }

  void _getDailyRestoPreferences() async {
    _isDailyRestoActive = await preferencesHelper.isDailyRestoActivated;
    notifyListeners();
  }

  void enableDailyRestaurant(bool value) {
    preferencesHelper.setDailyResto(value);
    _getDailyRestoPreferences();
  }
}
