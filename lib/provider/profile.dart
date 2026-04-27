import 'package:flutter/material.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/repository/auth_repo.dart';
import 'package:lifelinker/repository/profile_repo.dart';

class ProfileProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isLoggingOut = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  bool get isLoggingOut => _isLoggingOut;

  Future<void> loadProfile() async {
    final uid = SharedPrefsService.getUID();
    if (uid == null) return;

    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      _user = await ProfileRepository.fetchProfile(uid);
    } catch (_) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateLocally(UserModel updated) {
    _user = updated;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggingOut = true;
    notifyListeners();

    try {
      await AuthRepository.logout();
      await SharedPrefsService.clearSession();
    } catch (_) {
      await SharedPrefsService.clearSession();
    }

    _isLoggingOut = false;
    _user = null;
    notifyListeners();
  }
}
