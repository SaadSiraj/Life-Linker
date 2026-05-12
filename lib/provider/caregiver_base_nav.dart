import 'package:flutter/material.dart';

class CareGiverBaseNavProvider extends ChangeNotifier {
  int _navIndex = 0;
  DateTime? _lastPressed;

  int get currentIndex => _navIndex;

  int get screenIndex {
    switch (_navIndex) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 2;
      case 4:
        return 3;
      default:
        return 0;
    }
  }

  void setIndex(int index) {
    _navIndex = index;
    notifyListeners();
  }

  Future<bool> handleBackPress(BuildContext context) async {
    final now = DateTime.now();
    if (_lastPressed == null ||
        now.difference(_lastPressed!) > const Duration(seconds: 2)) {
      _lastPressed = now;
      return false;
    }
    return true;
  }
  
}
