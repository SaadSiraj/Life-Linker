import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/repository/auth_repo.dart';

enum SignupStep { basicInfo, roleData, profileImage, credentials }

class SignupProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Patient fields
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController emergencyContactController =
      TextEditingController();

  // Caregiver fields
  final TextEditingController relationController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();

  UserRole _role = UserRole.patient;
  SignupStep _currentStep = SignupStep.basicInfo;
  File? _profileImage;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  UserRole get role => _role;
  SignupStep get currentStep => _currentStep;
  File? get profileImage => _profileImage;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirm => _obscureConfirm;

  int get currentStepIndex => SignupStep.values.indexOf(_currentStep);
  int get totalSteps => SignupStep.values.length;
  bool get isLastStep => _currentStep == SignupStep.credentials;
  bool get isFirstStep => _currentStep == SignupStep.basicInfo;

  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
  }

  void setProfileImage(File file) {
    _profileImage = file;
    notifyListeners();
  }

  void clearProfileImage() {
    _profileImage = null;
    notifyListeners();
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirm() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  bool _validateCurrentStep(BuildContext context) {
    switch (_currentStep) {
      case SignupStep.basicInfo:
        if (nameController.text.trim().isEmpty) {
          showCustomSnackbar(context, true, 'Please enter your full name');
          return false;
        }
        if (dobController.text.trim().isEmpty) {
          showCustomSnackbar(context, true, 'Please select your date of birth');
          return false;
        }
        return true;

      case SignupStep.roleData:
        if (_role == UserRole.patient) {
          if (conditionController.text.trim().isEmpty) {
            showCustomSnackbar(
              context,
              true,
              'Please enter your medical condition',
            );
            return false;
          }
          if (bloodGroupController.text.trim().isEmpty) {
            showCustomSnackbar(context, true, 'Please enter your blood group');
            return false;
          }
          if (emergencyContactController.text.trim().isEmpty) {
            showCustomSnackbar(
              context,
              true,
              'Please enter an emergency contact number',
            );
            return false;
          }
        } else {
          if (relationController.text.trim().isEmpty) {
            showCustomSnackbar(
              context,
              true,
              'Please enter your relation to patient',
            );
            return false;
          }
        }
        return true;

      case SignupStep.profileImage:
        return true;

      case SignupStep.credentials:
        if (emailController.text.trim().isEmpty) {
          showCustomSnackbar(context, true, 'Please enter your email');
          return false;
        }
        if (!RegExp(
          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(emailController.text.trim())) {
          showCustomSnackbar(
            context,
            true,
            'Please enter a valid email address',
          );
          return false;
        }
        if (passwordController.text.isEmpty) {
          showCustomSnackbar(context, true, 'Please enter a password');
          return false;
        }
        if (passwordController.text.length < 6) {
          showCustomSnackbar(
            context,
            true,
            'Password must be at least 6 characters',
          );
          return false;
        }
        if (passwordController.text != confirmPasswordController.text) {
          showCustomSnackbar(context, true, 'Passwords do not match');
          return false;
        }
        return true;
    }
  }

  void nextStep(BuildContext context) {
    if (!_validateCurrentStep(context)) return;
    final steps = SignupStep.values;
    final idx = steps.indexOf(_currentStep);
    if (idx < steps.length - 1) {
      _currentStep = steps[idx + 1];
      notifyListeners();
    }
  }

  void previousStep() {
    final steps = SignupStep.values;
    final idx = steps.indexOf(_currentStep);
    if (idx > 0) {
      _currentStep = steps[idx - 1];
      notifyListeners();
    }
  }

  Future<void> signup(BuildContext context, VoidCallback onSuccess) async {
    if (!_validateCurrentStep(context)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final user = await AuthRepository.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
        dob: dobController.text.trim(),
        phone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        role: _role,
        profileImage: _profileImage,
        condition: _role == UserRole.patient
            ? conditionController.text.trim()
            : null,
        bloodGroup: _role == UserRole.patient
            ? bloodGroupController.text.trim()
            : null,
        emergencyContact: _role == UserRole.patient
            ? emergencyContactController.text.trim()
            : null,
        relation: _role == UserRole.caregiver
            ? relationController.text.trim()
            : null,
      );

      await SharedPrefsService.setLoggedInStatus(true);
      await SharedPrefsService.saveUID(user.uid);
      await SharedPrefsService.saveUserRole(
        _role == UserRole.caregiver ? 'caregiver' : 'patient',
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

  Future<void> pickDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF2A7FFF)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dobController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      notifyListeners();
    }
  }

  Future<void> pickPhoto(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: source, imageQuality: 85);
    if (xfile != null) {
      setProfileImage(File(xfile.path));
    }
  }

  void reset() {
    nameController.clear();
    dobController.clear();
    phoneController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    conditionController.clear();
    bloodGroupController.clear();
    emergencyContactController.clear();
    relationController.clear();
    organizationController.clear();
    _profileImage = null;
    _currentStep = SignupStep.basicInfo;
    _role = UserRole.patient;
    _isLoading = false;
    _obscurePassword = true;
    _obscureConfirm = true;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    conditionController.dispose();
    bloodGroupController.dispose();
    emergencyContactController.dispose();
    relationController.dispose();
    organizationController.dispose();
    super.dispose();
  }
}
