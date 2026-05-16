import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/repository/patient_repo.dart';

class AddEditPatientProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController emergencyContactController =
      TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  UserModel? _existingPatient;
  File? _profileImage;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  UserModel? get existingPatient => _existingPatient;
  File? get profileImage => _profileImage;
  bool get isLoading => _isLoading;
  bool get isEditMode => _existingPatient != null;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirm => _obscureConfirm;

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirm() {
    _obscureConfirm = !_obscureConfirm;
    notifyListeners();
  }

  void initForAdd() {
    _existingPatient = null;
    _profileImage = null;
    nameController.clear();
    dobController.clear();
    phoneController.clear();
    conditionController.clear();
    bloodGroupController.clear();
    emergencyContactController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _obscurePassword = true;
    _obscureConfirm = true;
    notifyListeners();
  }

  void initForEdit(UserModel patient) {
    _existingPatient = patient;
    _profileImage = null;
    nameController.text = patient.name;
    dobController.text = patient.dob ?? '';
    phoneController.text = patient.phone ?? '';
    conditionController.text = patient.condition ?? '';
    bloodGroupController.text = patient.bloodGroup ?? '';
    emergencyContactController.text = patient.emergencyContact ?? '';
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
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

  Future<void> pickPhoto(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: source, imageQuality: 85);
    if (xfile != null) setProfileImage(File(xfile.path));
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 30),
      firstDate: DateTime(1920),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF2A7FFF)),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dobController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      notifyListeners();
    }
  }

  bool _validate(BuildContext context) {
    if (nameController.text.trim().isEmpty) {
      showCustomSnackbar(context, true, 'Please enter patient name');
      return false;
    }
    if (conditionController.text.trim().isEmpty) {
      showCustomSnackbar(context, true, 'Please select medical condition');
      return false;
    }
    if (bloodGroupController.text.trim().isEmpty) {
      showCustomSnackbar(context, true, 'Please select blood group');
      return false;
    }
    if (emergencyContactController.text.trim().isEmpty) {
      showCustomSnackbar(context, true, 'Please enter emergency contact');
      return false;
    }

    if (!isEditMode) {
      if (emailController.text.trim().isEmpty) {
        showCustomSnackbar(context, true, 'Please enter patient email');
        return false;
      }
      if (!RegExp(
        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(emailController.text.trim())) {
        showCustomSnackbar(context, true, 'Please enter a valid email address');
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
    }

    return true;
  }

  Future<void> save(
    BuildContext context, {
    required void Function(UserModel patient, bool isEdit) onSuccess,
  }) async {
    if (!_validate(context)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final caregiverId = SharedPrefsService.getUID()!;

      if (isEditMode) {
        final updated = _existingPatient!.copyWith(
          name: nameController.text.trim(),
          dob: dobController.text.trim().isEmpty
              ? null
              : dobController.text.trim(),
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
          condition: conditionController.text.trim(),
          bloodGroup: bloodGroupController.text.trim(),
          emergencyContact: emergencyContactController.text.trim(),
        );
        await PatientRepository.updatePatient(
          patient: updated,
          newProfileImage: _profileImage,
        );
        _isLoading = false;
        notifyListeners();
        onSuccess(updated, true);
      } else {
        final newPatient = await PatientRepository.addPatient(
          caregiverId: caregiverId,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          dob: dobController.text.trim().isEmpty
              ? null
              : dobController.text.trim(),
          phone: phoneController.text.trim().isEmpty
              ? null
              : phoneController.text.trim(),
          condition: conditionController.text.trim(),
          bloodGroup: bloodGroupController.text.trim(),
          emergencyContact: emergencyContactController.text.trim(),
          profileImage: _profileImage,
        );
        _isLoading = false;
        notifyListeners();
        onSuccess(newPatient, false);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, PatientRepository.parseAuthError(e));
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    conditionController.dispose();
    bloodGroupController.dispose();
    emergencyContactController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
