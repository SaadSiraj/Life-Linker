import 'package:flutter/material.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/repository/auth_repo.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  UserModel? _currentUser;

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;
  UserModel? get currentUser => _currentUser;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool _validateInputs(BuildContext context) {
    if (emailController.text.trim().isEmpty) {
      showCustomSnackbar(context, true, 'Please enter your email');
      return false;
    }
    if (!RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(emailController.text.trim())) {
      showCustomSnackbar(context, true, 'Please enter a valid email');
      return false;
    }
    if (passwordController.text.isEmpty) {
      showCustomSnackbar(context, true, 'Please enter your password');
      return false;
    }
    return true;
  }

  Future<void> handleLogin(BuildContext context, VoidCallback onSuccess) async {
    if (!_validateInputs(context)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final user = await AuthRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      _currentUser = user;
      await SharedPrefsService.setLoggedInStatus(true);
      await SharedPrefsService.saveUID(user.uid);
      await SharedPrefsService.saveUserRole(
        user.role == UserRole.caregiver ? 'caregiver' : 'patient',
      );

      _isLoading = false;
      notifyListeners();
      onSuccess();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, AuthRepository.parseError(e));
      }
    }
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
