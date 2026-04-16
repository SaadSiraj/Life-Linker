import 'package:flutter/material.dart';
import 'package:lifelinker/model/location.dart';

class LocationProvider extends ChangeNotifier {
  LocationModel? _data;
  bool _isLoading = false;
  bool _hasError = false;

  LocationModel? get data => _data;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  LocationProvider() {
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _data = const LocationModel(
        patientName: 'John Doe',
        patientStatus: 'SAFE',
        lastSeen: '0 min ago',
        isInSafeZone: false,
        steps: 1482,
        heartRate: 76,
        calories: 320,
      );
    } catch (_) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void refresh() => fetchLocation();
}
