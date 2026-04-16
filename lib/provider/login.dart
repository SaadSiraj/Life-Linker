import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  bool _validateInputs(BuildContext context) {
    if (emailController.text.trim().isEmpty) {
      showCustomSnackbar(context, true, 'Please enter your email');
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

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();

    onSuccess();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
