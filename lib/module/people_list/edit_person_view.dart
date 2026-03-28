// edit_person_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/shared/app_text.dart';
import 'package:lifelinker/model/people_model.dart';

class EditPersonView extends StatefulWidget {
  final KnownPerson person;

  const EditPersonView({super.key, required this.person});

  @override
  State<EditPersonView> createState() => _EditPersonViewState();
}

class _EditPersonViewState extends State<EditPersonView>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late KnownPerson _person;

  // Form controllers
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _notesCtrl;
  late PersonRelationship _relationship;

  File? _newPhoto;
  bool _saving = false;
  bool _formDirty = false;

  @override
  void initState() {
    super.initState();
    _person = widget.person;
    _tabCtrl = TabController(length: 2, vsync: this);
    _nameCtrl = TextEditingController(text: _person.name);
    _phoneCtrl = TextEditingController(text: _person.phoneNumber ?? '');
    _notesCtrl = TextEditingController(text: _person.notes ?? '');
    _relationship = _person.relationship;

    _nameCtrl.addListener(_markDirty);
    _phoneCtrl.addListener(_markDirty);
    _notesCtrl.addListener(_markDirty);
  }

  void _markDirty() => setState(() => _formDirty = true);

  @override
  void dispose() {
    _tabCtrl.dispose();
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
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _buildInfoTab(),
                _buildFaceTab(),
              ],
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
          padding: EdgeInsets.fromLTRB(20.h, 12.v, 20.h, 0),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context, _formDirty),
                    child: Container(
                      width: 40.h,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18.h, color: AppColors.textDark),
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(_person.name,
                            size: 17,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700),
                        AppText(
                            '${_person.relationship.emoji}  ${_person.relationship.label}',
                            size: 11,
                            color: AppColors.iconGrey),
                      ],
                    ),
                  ),
                  // Face status badge
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.h, vertical: 5.v),
                    decoration: BoxDecoration(
                      color: _person.hasFaceRegistered
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _person.hasFaceRegistered
                              ? Icons.face_retouching_natural
                              : Icons.face_retouching_off,
                          size: 13.h,
                          color: _person.hasFaceRegistered
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                        SizedBox(width: 4.h),
                        AppText(
                          _person.hasFaceRegistered
                              ? '${_person.faceEmbeddingIds.length} face(s)'
                              : 'No face',
                          size: 11,
                          color: _person.hasFaceRegistered
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.v),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Tab Bar ──────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20.h, 0, 20.h, 12.v),
      child: Container(
        height: 42.v,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabCtrl,
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          indicatorPadding: EdgeInsets.all(3.h),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.iconGrey,
          labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Default'),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Info & Profile'),
            Tab(text: 'Face Recognition'),
          ],
        ),
      ),
    );
  }

  // ─── Info Tab ─────────────────────────────────────────────────────────────

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 32.v),
      child: Column(
        children: [
          // Photo
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickPhoto,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 90.h,
                        height: 90.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.08),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 2.5),
                        ),
                        child: _newPhoto != null
                            ? ClipOval(
                                child: Image.file(_newPhoto!, fit: BoxFit.cover))
                            : _person.photoUrl != null
                                ? ClipOval(
                                    child: Image.network(_person.photoUrl!,
                                        fit: BoxFit.cover))
                                : Center(
                                    child: AppText(
                                      _person.name.isNotEmpty
                                          ? _person.name[0].toUpperCase()
                                          : '?',
                                      size: 32,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                      ),
                      Container(
                        width: 30.h,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                        child: Icon(Icons.camera_alt_rounded,
                            size: 14.h, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.v),
                AppText('Tap photo to change',
                    size: 11, color: AppColors.iconGrey),
              ],
            ),
          ),

          SizedBox(height: 20.v),

          // Form
          _infoCard(),

          SizedBox(height: 16.v),

          // Relationship
          _relCard(),

          SizedBox(height: 28.v),

          // Save
          SizedBox(
            width: double.infinity,
            height: 54.v,
            child: ElevatedButton(
              onPressed: _saving ? null : _saveInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
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
                        Icon(Icons.save_rounded,
                            color: Colors.white, size: 20.h),
                        SizedBox(width: 8.h),
                        AppText('Save Changes',
                            size: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return _card(
      title: 'Personal Info',
      icon: Icons.person_outline_rounded,
      iconColor: AppColors.primary,
      iconBg: AppColors.primary.withOpacity(0.1),
      child: Column(
        children: [
          _field(_nameCtrl, 'Full Name', Icons.badge_outlined),
          SizedBox(height: 12.v),
          _field(_phoneCtrl, 'Phone Number', Icons.phone_outlined,
              keyboardType: TextInputType.phone),
          SizedBox(height: 12.v),
          _field(_notesCtrl, 'Notes', Icons.notes_rounded, maxLines: 3),
        ],
      ),
    );
  }

  Widget _relCard() {
    return _card(
      title: 'Relationship',
      icon: Icons.people_alt_rounded,
      iconColor: const Color(0xFFF59E0B),
      iconBg: const Color(0xFFFFFBEB),
      child: Wrap(
        spacing: 8.h,
        runSpacing: 8.v,
        children: PersonRelationship.values.map((r) {
          final selected = _relationship == r;
          return GestureDetector(
            onTap: () => setState(() {
              _relationship = r;
              _formDirty = true;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
                  EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.v),
              decoration: BoxDecoration(
                color:
                    selected ? AppColors.primary : const Color(0xFFF5F7FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? AppColors.primary
                      : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(r.emoji, size: 14),
                  SizedBox(width: 6.h),
                  AppText(r.label,
                      size: 12,
                      color: selected ? Colors.white : AppColors.textDark,
                      fontWeight: FontWeight.w600),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Face Recognition Tab ─────────────────────────────────────────────────

  Widget _buildFaceTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 32.v),
      child: Column(
        children: [
          _buildFaceInfoBanner(),
          SizedBox(height: 16.v),
          _buildRegisterFaceCard(),
          SizedBox(height: 16.v),
          if (_person.faceEmbeddingIds.isNotEmpty) _buildRegisteredFacesCard(),
          if (_person.faceEmbeddingIds.isNotEmpty) SizedBox(height: 16.v),
          _buildTestRecognitionCard(),
        ],
      ),
    );
  }

  Widget _buildFaceInfoBanner() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.primary.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.primary.withOpacity(0.15), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.h,
            height: 38.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome_rounded,
                size: 18.h, color: AppColors.primary),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText('AI Face Recognition',
                    size: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700),
                SizedBox(height: 4.v),
                AppText(
                  'Register multiple photos for better accuracy. The AI will identify ${_person.name.split(' ').first} and announce who they are to the patient.',
                  size: 11,
                  color: AppColors.textDark.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterFaceCard() {
    return _card(
      title: 'Register Face Photos',
      icon: Icons.add_a_photo_rounded,
      iconColor: const Color(0xFF3B82F6),
      iconBg: const Color(0xFFEFF6FF),
      child: Column(
        children: [
          AppText(
            'Add 3–5 clear photos for the best recognition results. Use different lighting and angles.',
            size: 12,
            color: AppColors.iconGrey,
          ),
          SizedBox(height: 16.v),
          Row(
            children: [
              Expanded(
                child: _sourceButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Camera',
                  color: const Color(0xFF3B82F6),
                  onTap: () => _registerFaceFromSource(ImageSource.camera),
                ),
              ),
              SizedBox(width: 10.h),
              Expanded(
                child: _sourceButton(
                  icon: Icons.photo_library_rounded,
                  label: 'Gallery',
                  color: const Color(0xFF8B5CF6),
                  onTap: () => _registerFaceFromSource(ImageSource.gallery),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.v),
          _faceRegistrationTips(),
        ],
      ),
    );
  }

  Widget _sourceButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.v,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20.h),
            SizedBox(width: 8.h),
            AppText(label,
                size: 13, color: color, fontWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }

  Widget _faceRegistrationTips() {
    final tips = [
      '📸  Face must be clearly visible',
      '💡  Good, even lighting',
      '🔄  Try different angles',
      '🚫  Avoid sunglasses or hats',
    ];
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: tips
            .map((t) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.v),
                  child: Row(
                    children: [
                      AppText(t, size: 11, color: AppColors.iconGrey),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildRegisteredFacesCard() {
    return _card(
      title: 'Registered Faces  (${_person.faceEmbeddingIds.length})',
      icon: Icons.face_retouching_natural,
      iconColor: const Color(0xFF10B981),
      iconBg: const Color(0xFFECFDF5),
      child: Column(
        children: _person.faceEmbeddingIds.asMap().entries.map((entry) {
          final idx = entry.key;
          final embId = entry.value;
          return Column(
            children: [
              if (idx > 0)
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.v),
                child: Row(
                  children: [
                    Container(
                      width: 40.h,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.face_retouching_natural,
                          size: 20.h, color: const Color(0xFF10B981)),
                    ),
                    SizedBox(width: 12.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText('Face Sample ${idx + 1}',
                              size: 13,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w600),
                          AppText(
                              'ID: ${embId.length > 10 ? '${embId.substring(0, 10)}…' : embId}',
                              size: 10, color: AppColors.iconGrey),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _deleteEmbedding(embId),
                      child: Container(
                        width: 32.h,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: AppColors.alert.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.delete_outline_rounded,
                            size: 16.h, color: AppColors.alert),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTestRecognitionCard() {
    return _card(
      title: 'Test Recognition',
      icon: Icons.search_rounded,
      iconColor: const Color(0xFFF59E0B),
      iconBg: const Color(0xFFFFFBEB),
      child: Column(
        children: [
          AppText(
            'Capture a live photo to verify that the AI correctly identifies ${_person.name.split(' ').first}.',
            size: 12,
            color: AppColors.iconGrey,
          ),
          SizedBox(height: 14.v),
          SizedBox(
            width: double.infinity,
            height: 48.v,
            child: ElevatedButton(
              onPressed: _person.hasFaceRegistered ? _testRecognition : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_enhance_rounded,
                      color: Colors.white, size: 20.h),
                  SizedBox(width: 8.h),
                  AppText(
                    _person.hasFaceRegistered
                        ? 'Run Recognition Test'
                        : 'Register a face first',
                    size: 13,
                    color: _person.hasFaceRegistered
                        ? Colors.white
                        : AppColors.iconGrey,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
        ],
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
              color: Color(0x09000000),
              blurRadius: 10,
              offset: Offset(0, 3))
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
          SizedBox(height: 14.v),
          child,
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String hint,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
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
      ),
    );
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> _pickPhoto() async {
    final src = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PhotoSourceSheet(),
    );
    if (src == null) return;
    final xfile =
        await ImagePicker().pickImage(source: src, imageQuality: 85);
    if (xfile != null) {
      setState(() {
        _newPhoto = File(xfile.path);
        _formDirty = true;
      });
    }
  }

  Future<void> _saveInfo() async {
    setState(() => _saving = true);
    final updated = _person.copyWith(
      name: _nameCtrl.text.trim(),
      relationship: _relationship,
      phoneNumber:
          _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      localPhotoPath: _newPhoto?.path,
    );
    try {
      final saved = await PeopleApiService.updatePerson(updated);
      setState(() {
        _person = saved;
        _saving = false;
        _formDirty = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText('Changes saved successfully.',
                size: 13, color: Colors.white),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (_) {
      setState(() => _saving = false);
    }
  }

  Future<void> _registerFaceFromSource(ImageSource src) async {
    final xfile =
        await ImagePicker().pickImage(source: src, imageQuality: 90);
    if (xfile == null) return;

    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ProcessingDialog(
        message: 'Analysing face…\nThis may take a moment.',
      ),
    );

    try {
      final embId = await PeopleApiService.registerFace(
        personId: _person.id,
        imageFile: File(xfile.path),
      );

      // Refresh person from in-memory store
      final people = await PeopleApiService.fetchPeople();
      final refreshed =
          people.firstWhere((p) => p.id == _person.id, orElse: () => _person);

      if (mounted) {
        Navigator.pop(context); // close dialog
        setState(() {
          _person = refreshed;
          _formDirty = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(
                'Face registered successfully! (ID: ${embId.length > 8 ? '${embId.substring(0, 8)}…' : embId})',
                size: 13, color: Colors.white),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText('Could not detect a face. Try again.',
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

  Future<void> _deleteEmbedding(String embId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText('Remove Face Sample',
            size: 15,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700),
        content: AppText(
          'This face sample will be removed from the recognition model.',
          size: 13,
          color: AppColors.iconGrey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText('Cancel',
                size: 13,
                color: AppColors.iconGrey,
                fontWeight: FontWeight.w500),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alert,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: AppText('Remove',
                size: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await PeopleApiService.deleteFaceEmbedding(
        personId: _person.id, embeddingId: embId);

    final people = await PeopleApiService.fetchPeople();
    final refreshed =
        people.firstWhere((p) => p.id == _person.id, orElse: () => _person);
    setState(() {
      _person = refreshed;
      _formDirty = true;
    });
  }

  Future<void> _testRecognition() async {
    final xfile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 90);
    if (xfile == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ProcessingDialog(
          message: 'Running AI recognition…\nComparing face vectors.'),
    );

    try {
      final result = await PeopleApiService.recognizeFace(
          imageFile: File(xfile.path));
      if (mounted) Navigator.pop(context);
      _showRecognitionResult(result);
    } catch (_) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText('Recognition failed. Try again.',
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

  void _showRecognitionResult(FaceRecognitionResult result) {
    final success = result.matched && result.matchedPersonId == _person.id;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.all(24.h),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.h,
              height: 64.h,
              decoration: BoxDecoration(
                color: success
                    ? const Color(0xFFECFDF5)
                    : const Color(0xFFFEF2F2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                success
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 36.h,
                color: success
                    ? const Color(0xFF10B981)
                    : AppColors.alert,
              ),
            ),
            SizedBox(height: 16.v),
            AppText(
              success ? 'Match Found! ✓' : 'No Match',
              size: 18,
              color: success ? const Color(0xFF10B981) : AppColors.alert,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 8.v),
            if (!result.faceDetected)
              AppText('No face detected in image.',
                  size: 13, color: AppColors.iconGrey, align: TextAlign.center)
            else if (success)
              Column(
                children: [
                  AppText(
                    'Identified as ${_person.name}',
                    size: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    align: TextAlign.center,
                  ),
                  SizedBox(height: 6.v),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.h, vertical: 6.v),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AppText(
                      'Confidence: ${((result.confidence ?? 0) * 100).toStringAsFixed(1)}%',
                      size: 13,
                      color: const Color(0xFF059669),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            else
              AppText(
                'The face did not match ${_person.name}. Try adding more photos.',
                size: 13,
                color: AppColors.iconGrey,
                align: TextAlign.center,
              ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    success ? const Color(0xFF10B981) : AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                minimumSize: Size(140.h, 44.v),
              ),
              child: AppText('Done',
                  size: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 4.v),
        ],
      ),
    );
  }
}

// ─── Processing Dialog ─────────────────────────────────────────────────────

class _ProcessingDialog extends StatelessWidget {
  final String message;
  const _ProcessingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48.h,
              height: 48.h,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 20.v),
            AppText(
              message,
              size: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
          AppText('Choose Photo',
              size: 14,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700),
          SizedBox(height: 12.v),
          _row(context, Icons.camera_alt_rounded, 'Take a Photo',
              ImageSource.camera),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          _row(context, Icons.photo_library_rounded, 'Choose from Gallery',
              ImageSource.gallery),
          SizedBox(height: 16.v),
        ],
      ),
    );
  }

  Widget _row(BuildContext ctx, IconData icon, String label,
      ImageSource source) {
    return GestureDetector(
      onTap: () => Navigator.pop(ctx, source),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.v),
        child: Row(
          children: [
            Container(
              width: 40.h,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20.h),
            ),
            SizedBox(width: 14.h),
            AppText(label,
                size: 13,
                color: AppColors.textDark,
                fontWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }
}