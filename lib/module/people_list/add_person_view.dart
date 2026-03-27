// add_person_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/shared/app_text.dart';
import 'package:lifelinker/model/people_model.dart';

class AddPersonView extends StatefulWidget {
  const AddPersonView({super.key});

  @override
  State<AddPersonView> createState() => _AddPersonViewState();
}

class _AddPersonViewState extends State<AddPersonView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  PersonRelationship _relationship = PersonRelationship.family;
  File? _pickedPhoto;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.h, 20.v, 16.h, 32.v),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPhotoSection(),
                    SizedBox(height: 24.v),
                    _buildFormCard(),
                    SizedBox(height: 16.v),
                    _buildRelationshipCard(),
                    SizedBox(height: 28.v),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 3))
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.h, 12.v, 20.h, 16.v),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40.h,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.close_rounded,
                      size: 20.h, color: AppColors.textDark),
                ),
              ),
              SizedBox(width: 12.h),
              AppText('Add Person',
                  size: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Photo Section ────────────────────────────────────────────────────────

  Widget _buildPhotoSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickPhoto,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100.h,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.08),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3), width: 2.5),
                  ),
                  child: _pickedPhoto != null
                      ? ClipOval(
                          child: Image.file(_pickedPhoto!, fit: BoxFit.cover))
                      : Icon(Icons.person_rounded,
                          size: 48.h,
                          color: AppColors.primary.withOpacity(0.4)),
                ),
                Container(
                  width: 32.h,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8)
                    ],
                  ),
                  child:
                      Icon(Icons.camera_alt_rounded, size: 15.h, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.v),
          AppText('Tap to add a photo',
              size: 12,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w500),
          SizedBox(height: 4.v),
          AppText('Used for face recognition training',
              size: 11, color: AppColors.iconGrey),
        ],
      ),
    );
  }

  // ─── Form Card ────────────────────────────────────────────────────────────

  Widget _buildFormCard() {
    return _card(
      title: 'Personal Info',
      icon: Icons.person_outline_rounded,
      iconColor: AppColors.primary,
      iconBg: AppColors.primary.withOpacity(0.1),
      child: Column(
        children: [
          _field(
            controller: _nameCtrl,
            hint: 'Full Name',
            icon: Icons.badge_outlined,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Name is required' : null,
          ),
          SizedBox(height: 12.v),
          _field(
            controller: _phoneCtrl,
            hint: 'Phone Number (optional)',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 12.v),
          _field(
            controller: _notesCtrl,
            hint: 'Notes (e.g. "visits every Sunday")',
            icon: Icons.notes_rounded,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // ─── Relationship Card ────────────────────────────────────────────────────

  Widget _buildRelationshipCard() {
    return _card(
      title: 'Relationship',
      icon: Icons.people_alt_rounded,
      iconColor: const Color(0xFFF59E0B),
      iconBg: const Color(0xFFFFFBEB),
      child: Wrap(
        spacing: 8.h,
        runSpacing: 8.v,
        children: PersonRelationship.values
            .map((r) => _relChip(r))
            .toList(),
      ),
    );
  }

  Widget _relChip(PersonRelationship r) {
    final selected = _relationship == r;
    return GestureDetector(
      onTap: () => setState(() => _relationship = r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 8.v),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(r.emoji, size: 15),
            SizedBox(width: 6.h),
            AppText(r.label,
                size: 12,
                color: selected ? Colors.white : AppColors.textDark,
                fontWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }

  // ─── Save Button ──────────────────────────────────────────────────────────

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54.v,
      child: ElevatedButton(
        onPressed: _saving ? null : _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          shadowColor: AppColors.primary.withOpacity(0.3),
        ),
        child: _saving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_rounded,
                      color: Colors.white, size: 20.h),
                  SizedBox(width: 8.h),
                  AppText('Save Person',
                      size: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                ],
              ),
      ),
    );
  }

  // ─── Shared Widgets ───────────────────────────────────────────────────────

  Widget _card({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x09000000), blurRadius: 10, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.h,
                height: 32.h,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: iconColor, size: 16.h),
              ),
              SizedBox(width: 10.h),
              AppText(title,
                  size: 13,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700),
            ],
          ),
          SizedBox(height: 16.v),
          child,
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(
          fontSize: 13,
          color: AppColors.textDark,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 13, color: AppColors.iconGrey),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 12.h, right: 8.h),
          child: Icon(icon, size: 18.h, color: AppColors.iconGrey),
        ),
        prefixIconConstraints: const BoxConstraints(),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding:
            EdgeInsets.symmetric(horizontal: 14.h, vertical: 13.v),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.alert, width: 1.5),
        ),
      ),
    );
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final src = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PhotoSourceSheet(),
    );
    if (src == null) return;
    final xfile = await picker.pickImage(source: src, imageQuality: 85);
    if (xfile != null) {
      setState(() => _pickedPhoto = File(xfile.path));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final newPerson = KnownPerson(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      relationship: _relationship,
      phoneNumber:
          _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      localPhotoPath: _pickedPhoto?.path,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      final saved = await PeopleApiService.addPerson(newPerson);
      if (mounted) Navigator.pop(context, saved);
    } catch (_) {
      setState(() => _saving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText('Failed to save. Please try again.',
                size: 13, color: Colors.white),
            backgroundColor: AppColors.alert,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }
}

// ─── Photo Source Sheet ────────────────────────────────────────────────────

class _PhotoSourceSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.v),
          Container(
            width: 36.h,
            height: 4.v,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16.v),
          AppText('Choose Photo Source',
              size: 14,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700),
          SizedBox(height: 16.v),
          _sourceRow(context, Icons.camera_alt_rounded, 'Take a Photo',
              'Best for face recognition', ImageSource.camera),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _sourceRow(context, Icons.photo_library_rounded, 'Choose from Gallery',
              'Select an existing photo', ImageSource.gallery),
          SizedBox(height: 16.v),
        ],
      ),
    );
  }

  Widget _sourceRow(BuildContext context, IconData icon, String label,
      String subtitle, ImageSource source) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, source),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.v),
        child: Row(
          children: [
            Container(
              width: 42.h,
              height: 42.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22.h),
            ),
            SizedBox(width: 14.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(label,
                    size: 13,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600),
                AppText(subtitle, size: 11, color: AppColors.iconGrey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}