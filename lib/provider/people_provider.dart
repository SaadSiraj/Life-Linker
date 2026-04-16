import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/model/people_model.dart';

class PeopleProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  List<KnownPerson> _people = [];
  String _searchQuery = '';
  PersonRelationship? _filterRelationship;
  PersonRelationship _selectedRelationship = PersonRelationship.family;
  File? _pickedPhoto;
  bool _isSaving = false;
  bool _isLoading = false;
  bool _hasError = false;

  List<KnownPerson> get people => _people;
  String get searchQuery => _searchQuery;
  PersonRelationship? get filterRelationship => _filterRelationship;
  PersonRelationship get selectedRelationship => _selectedRelationship;
  File? get pickedPhoto => _pickedPhoto;
  bool get isSaving => _isSaving;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  List<KnownPerson> get filteredPeople {
    return _people.where((p) {
      final matchSearch =
          _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (p.notes?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
      final matchFilter =
          _filterRelationship == null || p.relationship == _filterRelationship;
      return matchSearch && matchFilter;
    }).toList();
  }

  PeopleProvider() {
    fetchPeople();
  }

  Future<void> fetchPeople() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final result = await PeopleApiService.fetchPeople();
      _people = List.from(result);
    } catch (_) {
      _hasError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    nameController.clear();
    notifyListeners();
  }

  void setFilterRelationship(PersonRelationship? rel) {
    _filterRelationship = rel;
    notifyListeners();
  }

  void setSelectedRelationship(PersonRelationship rel) {
    _selectedRelationship = rel;
    notifyListeners();
  }

  void setPickedPhoto(File file) {
    _pickedPhoto = file;
    notifyListeners();
  }

  bool _validateAddForm(BuildContext context) {
    if (nameController.text.trim().isEmpty) {
      showCustomSnackbar(context, true, 'Name is required');
      return false;
    }
    return true;
  }

  Future<void> savePerson(BuildContext context, VoidCallback onSuccess) async {
    if (!_validateAddForm(context)) return;

    _isSaving = true;
    notifyListeners();

    final newPerson = KnownPerson(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      relationship: _selectedRelationship,
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
      final saved = await PeopleApiService.addPerson(newPerson);
      _people.add(saved);
      _isSaving = false;
      notifyListeners();
      onSuccess();
    } catch (_) {
      _isSaving = false;
      notifyListeners();
      showCustomSnackbar(context, true, 'Failed to save. Please try again.');
    }
  }

  Future<void> deletePerson(String id) async {
    await PeopleApiService.deletePerson(id);
    _people.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void resetAddForm() {
    nameController.clear();
    phoneController.clear();
    notesController.clear();
    _selectedRelationship = PersonRelationship.family;
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
