import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/health_record.dart';
import 'package:lifelinker/repository/helth_repo.dart';

class HealthProvider extends ChangeNotifier {
  List<HealthRecordModel> _records = [];
  bool _isLoading = false;
  bool _isSaving = false;
  StreamSubscription<List<HealthRecordModel>>? _sub;

  List<HealthRecordModel> get records => _records;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  HealthRecordModel? get latest => _records.isEmpty ? null : _records.first;

  void initialize(String patientId) {
    _isLoading = true;
    notifyListeners();
    _sub?.cancel();
    _sub = HealthRepository.listenToRecords(patientId).listen((list) {
      _records = list;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addRecord({
    required BuildContext context,
    required HealthRecordModel record,
    required VoidCallback onSuccess,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await HealthRepository.addRecord(record);
      _isSaving = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to save record');
      }
    }
  }

  Future<void> deleteRecord(BuildContext context, String id) async {
    try {
      await HealthRepository.deleteRecord(id);
    } catch (_) {
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to delete record');
      }
    }
  }

  // Last 7 heart rate points for chart
  List<double> get heartRatePoints => _records
      .take(7)
      .map((r) => r.heartRate.toDouble())
      .toList()
      .reversed
      .toList();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
