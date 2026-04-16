import 'package:lifelinker/model/activity.dart';
import 'package:lifelinker/model/heart_rate.dart';
import 'package:lifelinker/model/spleep.dart';
import 'package:lifelinker/model/steps.dart';
import 'package:lifelinker/model/weekly_day.dart';

class HealthDataModel {
  final StepsModel steps;
  final HeartRateModel heartRate;
  final SleepModel sleep;
  final ActivityModel activity;
  final List<WeeklyDayModel> weeklyData;

  const HealthDataModel({
    required this.steps,
    required this.heartRate,
    required this.sleep,
    required this.activity,
    required this.weeklyData,
  });
}