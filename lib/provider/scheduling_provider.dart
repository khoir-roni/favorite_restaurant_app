import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';

import '../utils/background_service.dart';
import '../utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<bool> scheduleFavorite(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      print('Notification Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Notification Deactivated');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}