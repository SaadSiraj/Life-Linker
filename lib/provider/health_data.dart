import 'package:flutter/material.dart';
import 'package:lifelinker/model/activity.dart';
import 'package:lifelinker/model/health_data.dart';
import 'package:lifelinker/model/heart_rate.dart';
import 'package:lifelinker/model/spleep.dart';
import 'package:lifelinker/model/steps.dart';
import 'package:lifelinker/model/weekly_day.dart';

class HealthDataProvider extends ChangeNotifier {
  HealthDataModel? _data;
  bool _isLoading = false;
  bool _hasError = false;

  HealthDataModel? get data => _data;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  HealthDataProvider() {
    fetchHealthData();
  }

  Future<void> fetchHealthData() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // TODO: Replace with real API call
      await Future.delayed(const Duration(milliseconds: 800));

      _data = HealthDataModel(
        steps: const StepsModel(currentSteps: 1482, goalSteps: 2000),
        heartRate: const HeartRateModel(
          bpmPoints: [
            68,
            72,
            75,
            71,
            74,
            80,
            76,
            72,
            69,
            73,
            78,
            82,
            75,
            70,
            72,
            76,
            71,
            74,
            72,
            70,
          ],
          currentBpm: 72,
          minBpm: 65,
          avgBpm: 72,
          maxBpm: 82,
          lastReadingTime: '12 mins ago',
        ),
        sleep: const SleepModel(
          totalHours: 7.2,
          deepRatio: 0.15,
          coreRatio: 0.45,
          remRatio: 0.25,
          awakeRatio: 0.15,
          bedtime: '10:30 PM',
          wakeUp: '6:45 AM',
          sleepNote: 'Sleep calories   3.4 hr m',
        ),
        activity: const ActivityModel(
          calories: 320,
          distanceKm: 2.4,
          activeMinutes: 42,
        ),
        weeklyData: const [
          WeeklyDayModel(day: 'Mon', stepsFraction: 0.6, isToday: false),
          WeeklyDayModel(day: 'Tue', stepsFraction: 0.8, isToday: false),
          WeeklyDayModel(day: 'Wed', stepsFraction: 0.45, isToday: false),
          WeeklyDayModel(day: 'Thu', stepsFraction: 0.9, isToday: false),
          WeeklyDayModel(day: 'Fri', stepsFraction: 0.74, isToday: true),
          WeeklyDayModel(day: 'Sat', stepsFraction: 0.3, isToday: false),
          WeeklyDayModel(day: 'Sun', stepsFraction: 0.55, isToday: false),
        ],
      );
    } catch (_) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void refresh() => fetchHealthData();
}
