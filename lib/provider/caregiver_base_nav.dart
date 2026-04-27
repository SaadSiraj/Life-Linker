import 'package:flutter/material.dart';

class CareGiverBaseNavProvider extends ChangeNotifier {
  int _currentIndex = 0;
  DateTime? _lastPressed;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  /// Returns true if the app should close, false to stay open.
  Future<bool> handleBackPress(BuildContext context) async {
    final now = DateTime.now();
    if (_lastPressed == null ||
        now.difference(_lastPressed!) > const Duration(seconds: 2)) {
      _lastPressed = now;
      return false; // signal to show snackbar
    }
    return true; // signal to show exit dialog
  }
}
