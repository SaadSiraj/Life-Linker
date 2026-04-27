import 'package:flutter/material.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/repository/patient_repo.dart';

class CaregiverPatientsProvider extends ChangeNotifier {
  List<UserModel> _patients = [];
  bool _isLoading = false;
  bool _hasError = false;

  List<UserModel> get patients => _patients;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> loadPatients() async {
    final caregiverId = SharedPrefsService.getUID();
    if (caregiverId == null) return;

    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      _patients = await PatientRepository.fetchCaregiverPatients(caregiverId);
    } catch (_) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => loadPatients();

  void removePatientLocally(String patientId) {
    _patients.removeWhere((p) => p.uid == patientId);
    notifyListeners();
  }

  void updatePatientLocally(UserModel updated) {
    final idx = _patients.indexWhere((p) => p.uid == updated.uid);
    if (idx != -1) {
      _patients[idx] = updated;
      notifyListeners();
    }
  }

  void addPatientLocally(UserModel patient) {
    _patients.add(patient);
    notifyListeners();
  }
}
