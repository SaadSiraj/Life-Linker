import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/known_person.dart';
import 'package:lifelinker/repository/person_repo.dart';

class AddPersonProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  PersonRelationship _relationship = PersonRelationship.family;
  File? _pickedPhoto;
  bool _isSaving = false;

  PersonRelationship get relationship => _relationship;
  File? get pickedPhoto => _pickedPhoto;
  bool get isSaving => _isSaving;

  void setRelationship(PersonRelationship rel) {
    _relationship = rel;
    notifyListeners();
  }

  void setPickedPhoto(File file) {
    _pickedPhoto = file;
    notifyListeners();
  }

  Future<void> pickPhoto(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(source: source, imageQuality: 85);
    if (xfile != null) {
      setPickedPhoto(File(xfile.path));
    }
  }

  Future<void> save(BuildContext context, VoidCallback onSuccess) async {
    if (!formKey.currentState!.validate()) return;

    _isSaving = true;
    notifyListeners();

    final newPerson = KnownPerson(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      relationship: _relationship,
      phoneNumber: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
      localPhotoPath: _pickedPhoto?.path,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      final saved = await PersonsRepository.addPerson(newPerson);
      _isSaving = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to save. Please try again.');
      }
    }
  }

  void reset() {
    nameController.clear();
    phoneController.clear();
    notesController.clear();
    _relationship = PersonRelationship.family;
    _pickedPhoto = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
