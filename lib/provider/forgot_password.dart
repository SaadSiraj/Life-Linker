import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';

enum ForgotPasswordStep { email, otp, newPassword, success }

class ForgotPasswordProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  ForgotPasswordStep _currentStep = ForgotPasswordStep.email;
  int _resendTimer = 0;

  bool get obscureNewPassword => _obscureNewPassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isLoading => _isLoading;
  ForgotPasswordStep get currentStep => _currentStep;
  int get resendTimer => _resendTimer;

  void toggleNewPasswordVisibility() {
    _obscureNewPassword = !_obscureNewPassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void transitionToStep(
    ForgotPasswordStep step,
    AnimationController controller,
  ) {
    controller.reverse().then((_) {
      _currentStep = step;
      notifyListeners();
      controller.forward();
    });
  }

  Future<void> handleSendOtp(
    BuildContext context,
    AnimationController controller,
  ) async {
    if (emailController.text.trim().isEmpty) {
      showCustomSnackbar(context, true, 'Please enter your email address');
      return;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController.text.trim())) {
      showCustomSnackbar(context, true, 'Please enter a valid email address');
      return;
    }
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;
    _resendTimer = 60;
    notifyListeners();
    transitionToStep(ForgotPasswordStep.otp, controller);
    _startResendTimer();
  }

  Future<void> handleVerifyOtp(
    BuildContext context,
    AnimationController controller,
  ) async {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      showCustomSnackbar(context, true, 'Please enter the 4-digit OTP');
      return;
    }
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;
    notifyListeners();
    transitionToStep(ForgotPasswordStep.newPassword, controller);
  }

  Future<void> handleResetPassword(
    BuildContext context,
    AnimationController controller,
  ) async {
    if (newPasswordController.text.isEmpty) {
      showCustomSnackbar(context, true, 'Please enter a new password');
      return;
    }
    if (newPasswordController.text.length < 6) {
      showCustomSnackbar(
          context, true, 'Password must be at least 6 characters');
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      showCustomSnackbar(context, true, 'Passwords do not match');
      return;
    }
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;
    notifyListeners();
    transitionToStep(ForgotPasswordStep.success, controller);
  }

  void resendOtp() {
    _resendTimer = 60;
    notifyListeners();
    _startResendTimer();
  }

  void handleOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_resendTimer > 0) {
        _resendTimer--;
        notifyListeners();
        _startResendTimer();
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }
}