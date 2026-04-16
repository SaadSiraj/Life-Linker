import 'package:flutter/material.dart';
import 'package:lifelinker/model/dashboard.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardModel? _data;
  bool _isLoading = false;
  bool _hasError = false;

  DashboardModel? get data => _data;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  DashboardProvider() {
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 900));

      _data = const DashboardModel(
        patientName: 'John Adeola',
        isSafe: true,
        locationLabel: 'Home – Living Room',
        locationSub: 'Last seen 2 min ago',
        medicationLabel: 'Donepezil · 10mg',
        medicationSub: 'Next dose at 8:00 PM',
        knownPeopleCount: 12,
        knownPeopleSub: 'Family & caregivers',
        healthLabel: 'Heart rate 72 bpm',
        healthSub: 'All vitals normal',
      );
    } catch (_) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void refresh() => fetchDashboard();
}
