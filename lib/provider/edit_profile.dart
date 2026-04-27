import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/repository/profile_repo.dart';

class EditProfileProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController emergencyContactController =
      TextEditingController();
  final TextEditingController relationController = TextEditingController();

  UserModel? _originalUser;
  File? _profileImage;
  bool _isLoading = false;

  File? get profileImage => _profileImage;
  bool get isLoading => _isLoading;
  UserModel? get originalUser => _originalUser;

  void initProfile(UserModel user) {
    _originalUser = user;
    _profileImage = null;
    nameController.text = user.name;
    phoneController.text = user.phone ?? '';
    dobController.text = user.dob ?? '';
    conditionController.text = user.condition ?? '';
    bloodGroupController.text = user.bloodGroup ?? '';
    emergencyContactController.text = user.emergencyContact ?? '';
    relationController.text = user.relation ?? '';
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
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: DateTime(now.year - 1),
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
      showCustomSnackbar(context, true, 'Name cannot be empty');
      return false;
    }
    return true;
  }

  Future<void> save(
    BuildContext context, {
    required void Function(UserModel updated) onSuccess,
  }) async {
    if (!_validate(context)) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updated = _originalUser!.copyWith(
        name: nameController.text.trim(),
        phone: phoneController.text.trim().isEmpty
            ? null
            : phoneController.text.trim(),
        dob: dobController.text.trim().isEmpty
            ? null
            : dobController.text.trim(),
        condition: conditionController.text.trim().isEmpty
            ? null
            : conditionController.text.trim(),
        bloodGroup: bloodGroupController.text.trim().isEmpty
            ? null
            : bloodGroupController.text.trim(),
        emergencyContact: emergencyContactController.text.trim().isEmpty
            ? null
            : emergencyContactController.text.trim(),
        relation: relationController.text.trim().isEmpty
            ? null
            : relationController.text.trim(),
      );

      final saved = await ProfileRepository.updateProfile(
        user: updated,
        newProfileImage: _profileImage,
      );

      _isLoading = false;
      notifyListeners();
      onSuccess(saved);
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(
          context,
          true,
          'Failed to update profile. Try again.',
        );
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    conditionController.dispose();
    bloodGroupController.dispose();
    emergencyContactController.dispose();
    relationController.dispose();
    super.dispose();
  }
}
