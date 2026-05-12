import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/sleep_log.dart';
import 'package:lifelinker/model/sleep_routine.dart';
import 'package:lifelinker/repository/sleep_routine_repo.dart';

class SleepProvider extends ChangeNotifier {
  List<SleepRoutineModel> _routines = [];
  List<SleepLogModel> _logs = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _currentPatientId;

  StreamSubscription<List<SleepRoutineModel>>? _routineSub;
  StreamSubscription<List<SleepLogModel>>? _logSub;

  List<SleepRoutineModel> get routines => _routines;
  List<SleepLogModel> get logs => _logs;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  SleepRoutineModel? get activeRoutine =>
      _routines.isNotEmpty ? _routines.first : null;

  double get weeklyAvgHours {
    if (_logs.isEmpty) return 0;
    final total = _logs.fold(0.0, (sum, l) => sum + l.actualHours);
    return total / _logs.length;
  }

  int get metTargetCount => _logs.where((l) => l.metTarget).length;

  void initialize(String patientId) {
    if (_currentPatientId == patientId) return;
    _currentPatientId = patientId;
    _isLoading = true;
    notifyListeners();
    _routineSub?.cancel();
    _logSub?.cancel();
    _routineSub = SleepRepository.listenToRoutines(patientId).listen((list) {
      _routines = list;
      _isLoading = false;
      notifyListeners();
    });
    _logSub = SleepRepository.listenToLogs(patientId).listen((list) {
      _logs = list;
      notifyListeners();
    });
  }

  Future<void> addRoutine({
    required BuildContext context,
    required SleepRoutineModel routine,
    required VoidCallback onSuccess,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await SleepRepository.addRoutine(routine);
      _isSaving = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to save sleep routine');
      }
    }
  }

  Future<void> updateRoutine({
    required BuildContext context,
    required SleepRoutineModel routine,
    required VoidCallback onSuccess,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await SleepRepository.updateRoutine(routine);
      _isSaving = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to update routine');
      }
    }
  }

  Future<void> deleteRoutine({
    required BuildContext context,
    required String routineId,
  }) async {
    try {
      await SleepRepository.deleteRoutine(routineId);
    } catch (_) {
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to remove routine');
      }
    }
  }

  Future<void> logSleep({
    required BuildContext context,
    required SleepLogModel log,
    required VoidCallback onSuccess,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await SleepRepository.addLog(log);
      _isSaving = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to log sleep');
      }
    }
  }

  SleepLogModel? getTodayLog(String routineId) {
    final now = DateTime.now();
    try {
      return _logs.firstWhere(
        (l) =>
            l.routineId == routineId &&
            l.date.year == now.year &&
            l.date.month == now.month &&
            l.date.day == now.day,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _routineSub?.cancel();
    _logSub?.cancel();
    super.dispose();
  }
}
