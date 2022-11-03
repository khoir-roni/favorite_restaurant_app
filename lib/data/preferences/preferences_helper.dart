import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  late final Future<SharedPreferences> sharedPreferences;
  static const dailyResto = 'DAILY RESTO';

  PreferencesHelper({required this.sharedPreferences});

  Future<bool> get isDailyRestoActivated async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyResto) ?? false;
  }

  void setDailyResto(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(dailyResto, value);
  }
}
