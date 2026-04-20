import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/face_recongnition.dart';
import 'package:lifelinker/model/known_person.dart';
import 'package:lifelinker/repository/person_repo.dart';

class EditPersonProvider extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  late KnownPerson _person;

  PersonRelationship _relationship = PersonRelationship.family;
  File? _newPhoto;
  bool _isSaving = false;
  bool _isFormDirty = false;
  int _currentTabIndex = 0;
  bool _isProcessingFace = false;
  FaceRecognitionResult? _lastRecognitionResult;

  // ── Getters ──────────────────────────────────────────────────────────────

  KnownPerson get person => _person;
  PersonRelationship get relationship => _relationship;
  File? get newPhoto => _newPhoto;
  bool get isSaving => _isSaving;
  bool get isFormDirty => _isFormDirty;
  int get currentTabIndex => _currentTabIndex;
  bool get isProcessingFace => _isProcessingFace;
  FaceRecognitionResult? get lastRecognitionResult => _lastRecognitionResult;

  // ── Init ─────────────────────────────────────────────────────────────────

  /// Call this from the screen's initState (or ChangeNotifierProvider.create)
  /// to load the person and populate all controllers.
  void initPerson(KnownPerson person) {
    _person = person;
    _relationship = person.relationship;

    _removeListeners();

    nameController.text = person.name;
    phoneController.text = person.phoneNumber ?? '';
    notesController.text = person.notes ?? '';

    _addListeners();

    _newPhoto = null;
    _isFormDirty = false;
    notifyListeners();
  }

  // ── Listeners ─────────────────────────────────────────────────────────────

  void _addListeners() {
    nameController.addListener(_markDirty);
    phoneController.addListener(_markDirty);
    notesController.addListener(_markDirty);
  }

  void _removeListeners() {
    nameController.removeListener(_markDirty);
    phoneController.removeListener(_markDirty);
    notesController.removeListener(_markDirty);
  }

  void _markDirty() {
    _isFormDirty = true;
    notifyListeners();
  }

  // ── Setters ───────────────────────────────────────────────────────────────

  void setRelationship(PersonRelationship rel) {
    _relationship = rel;
    _isFormDirty = true;
    notifyListeners();
  }

  void setNewPhoto(File file) {
    _newPhoto = file;
    _isFormDirty = true;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // ── Photo ─────────────────────────────────────────────────────────────────

  Future<void> pickPhoto(BuildContext context, ImageSource source) async {
    final xfile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );
    if (xfile != null) {
      setNewPhoto(File(xfile.path));
    }
  }

  // ── Save Info ─────────────────────────────────────────────────────────────

  Future<void> saveInfo(BuildContext context, VoidCallback onSuccess) async {
    _isSaving = true;
    notifyListeners();

    final updated = _person.copyWith(
      name: nameController.text.trim(),
      relationship: _relationship,
      phoneNumber: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
      localPhotoPath: _newPhoto?.path,
    );

    try {
      final saved = await PersonsRepository.updatePerson(updated);
      _person = saved;
      _isSaving = false;
      _isFormDirty = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      if (context.mounted) {
        showCustomSnackbar(context, true, 'Failed to save changes.');
      }
    }
  }

  // ── Face Registration ─────────────────────────────────────────────────────

  Future<void> registerFaceFromSource(
    BuildContext context,
    ImageSource source, {
    required VoidCallback onProcessingStart,
    required VoidCallback onProcessingEnd,
    required Function(String embId) onSuccess,
    required VoidCallback onError,
  }) async {
    final xfile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 90,
    );
    if (xfile == null) return;

    _isProcessingFace = true;
    notifyListeners();
    onProcessingStart();

    try {
      final embId = await PersonsRepository.registerFace(
        personId: _person.id,
        imageFile: File(xfile.path),
      );

      final people = await PersonsRepository.fetchPeople();
      final refreshed = people.firstWhere(
        (p) => p.id == _person.id,
        orElse: () => _person,
      );

      _person = refreshed;
      _isFormDirty = true;
      _isProcessingFace = false;
      notifyListeners();
      onProcessingEnd();
      onSuccess(embId);
    } catch (_) {
      _isProcessingFace = false;
      notifyListeners();
      onProcessingEnd();
      onError();
    }
  }

  // ── Delete Embedding ──────────────────────────────────────────────────────

  Future<void> deleteFaceEmbedding({
    required String embeddingId,
    required VoidCallback onSuccess,
    required VoidCallback onError,
  }) async {
    try {
      await PersonsRepository.deleteFaceEmbedding(
        personId: _person.id,
        embeddingId: embeddingId,
      );

      final people = await PersonsRepository.fetchPeople();
      final refreshed = people.firstWhere(
        (p) => p.id == _person.id,
        orElse: () => _person,
      );

      _person = refreshed;
      _isFormDirty = true;
      notifyListeners();
      onSuccess();
    } catch (_) {
      onError();
    }
  }

  // ── Test Recognition ──────────────────────────────────────────────────────

  Future<void> testRecognition(
    BuildContext context, {
    required VoidCallback onProcessingStart,
    required VoidCallback onProcessingEnd,
    required Function(FaceRecognitionResult result) onResult,
    required VoidCallback onError,
  }) async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (xfile == null) return;

    _isProcessingFace = true;
    notifyListeners();
    onProcessingStart();

    try {
      final result = await PersonsRepository.recognizeFace(
        imageFile: File(xfile.path),
      );
      _lastRecognitionResult = result;
      _isProcessingFace = false;
      notifyListeners();
      onProcessingEnd();
      onResult(result);
    } catch (_) {
      _isProcessingFace = false;
      notifyListeners();
      onProcessingEnd();
      onError();
    }
  }

  // ── Dispose ───────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _removeListeners();
    nameController.dispose();
    phoneController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
