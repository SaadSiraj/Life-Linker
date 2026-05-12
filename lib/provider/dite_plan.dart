import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/dite_plan.dart';
import 'package:lifelinker/repository/dite.dart';

class DietPlanProvider extends ChangeNotifier {
  List<DietPlanModel> _plans = [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _currentPatientId;
  StreamSubscription<List<DietPlanModel>>? _sub;

  List<DietPlanModel> get plans => _plans;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  DietPlanModel? get activePlan =>
      _plans.isNotEmpty ? _plans.first : null;

  void initialize(String patientId) {
    if (_currentPatientId == patientId) return;
    _currentPatientId = patientId;
    _isLoading = true;
    notifyListeners();
    _sub?.cancel();
    _sub = DietPlanRepository.listenToPlans(patientId).listen((list) {
      _plans = list;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addPlan({
    required BuildContext context,
    required DietPlanModel plan,
    required VoidCallback onSuccess,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await DietPlanRepository.addPlan(plan);
      _isSaving = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to save diet plan');
      }
    }
  }

  Future<void> updatePlan({
    required BuildContext context,
    required DietPlanModel plan,
    required VoidCallback onSuccess,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await DietPlanRepository.updatePlan(plan);
      _isSaving = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to update diet plan');
      }
    }
  }

  Future<void> deletePlan({
    required BuildContext context,
    required String planId,
  }) async {
    try {
      await DietPlanRepository.deletePlan(planId);
    } catch (_) {
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to remove diet plan');
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}