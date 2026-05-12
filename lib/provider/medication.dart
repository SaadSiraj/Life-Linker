import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/medication_log.dart';
import 'package:lifelinker/model/medication_scheduled.dart';
import 'package:lifelinker/repository/medication_repo.dart';

class MedicationProvider extends ChangeNotifier {
  List<MedicationScheduleModel> _medications = [];
  List<MedicationLogModel> _todayLogs = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _patientId;

  StreamSubscription<List<MedicationScheduleModel>>? _medSub;
  StreamSubscription<List<MedicationLogModel>>? _logSub;

  List<MedicationScheduleModel> get medications => _medications;
  List<MedicationLogModel> get todayLogs => _todayLogs;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  void initialize(String patientId) {
    if (_patientId == patientId) return;
    _patientId = patientId;
    _isLoading = true;
    notifyListeners();
    _medSub?.cancel();
    _logSub?.cancel();
    _medSub = MedicationRepository.listenToMedications(patientId).listen((
      list,
    ) {
      _medications = list;
      _isLoading = false;
      notifyListeners();
    });
    _logSub = MedicationRepository.listenToTodayLogs(patientId).listen((list) {
      _todayLogs = list;
      notifyListeners();
    });
  }

  MedicationLogModel? getLogForSlot(String medicationId, String time) {
    final dateKey = _todayDateKey();
    final id = '${medicationId}_${dateKey}_$time';
    try {
      return _todayLogs.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  String _todayDateKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  double get todayAdherenceRate {
    if (_todayLogs.isEmpty) return 0;
    final taken = _todayLogs.where((l) => l.isTaken).length;
    return taken / _todayLogs.length;
  }

  Future<void> addMedication({
    required BuildContext context,
    required String patientId,
    required String caregiverId,
    required String name,
    required String dosage,
    required MedicationFrequency frequency,
    required List<String> times,
    String? notes,
    required VoidCallback onSuccess,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      final med = MedicationScheduleModel(
        id: '',
        patientId: patientId,
        caregiverId: caregiverId,
        name: name,
        dosage: dosage,
        frequency: frequency,
        times: times,
        notes: notes,
        isActive: true,
        createdAt: DateTime.now(),
      );
      await MedicationRepository.addMedication(med);
      _isSaving = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to add medication');
      }
    }
  }

  Future<void> updateMedication({
    required BuildContext context,
    required MedicationScheduleModel medication,
    required VoidCallback onSuccess,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await MedicationRepository.updateMedication(medication);
      _isSaving = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to update medication');
      }
    }
  }

  Future<void> deleteMedication({
    required BuildContext context,
    required String medicationId,
  }) async {
    try {
      await MedicationRepository.deleteMedication(medicationId);
    } catch (_) {
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to delete medication');
      }
    }
  }

  Future<void> markMedication({
    required BuildContext context,
    required MedicationScheduleModel medication,
    required String time,
    required MedicationStatus status,
  }) async {
    if (_patientId == null) return;
    try {
      await MedicationRepository.logMedicationStatus(
        medicationId: medication.id,
        patientId: _patientId!,
        medicationName: medication.name,
        dosage: medication.dosage,
        scheduledTime: time,
        status: status,
        scheduledDate: DateTime.now(),
      );
    } catch (_) {
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to update status');
      }
    }
  }

  @override
  void dispose() {
    _medSub?.cancel();
    _logSub?.cancel();
    super.dispose();
  }
}
