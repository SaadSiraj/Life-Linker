// people_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/shared/app_text.dart';
import 'package:lifelinker/model/people_model.dart';
import 'package:lifelinker/module/people_list/add_person_view.dart';
import 'package:lifelinker/module/people_list/edit_person_view.dart';

class PeopleListView extends StatefulWidget {
  const PeopleListView({super.key});

  @override
  State<PeopleListView> createState() => _PeopleListViewState();
}

  class _PeopleListViewState extends State<PeopleListView> {
  late Future<List<KnownPerson>> _peopleFuture;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  PersonRelationship? _filterRelationship;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _peopleFuture = PeopleApiService.fetchPeople();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _reload() => setState(() {
        _peopleFuture = PeopleApiService.fetchPeople();
      });

  List<KnownPerson> _filtered(List<KnownPerson> all) {
    return all.where((p) {
      final matchSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (p.notes?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
      final matchFilter =
          _filterRelationship == null || p.relationship == _filterRelationship;
      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchAndFilter(),
          Expanded(
            child: FutureBuilder<List<KnownPerson>>(
              future: _peopleFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLoader();
                }
                if (snapshot.hasError) {
                  return _buildError();
                }
                final filtered = _filtered(snapshot.requireData);
                if (filtered.isEmpty) return _buildEmpty();
                return _buildList(filtered);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ─── Header ─────────────────────────────────────────────────────────────

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
              // GestureDetector(
              //   onTap: () => Navigator.pop(context),
              //   child: Container(
              //     width: 40.h,
              //     height: 40.h,
              //     decoration: BoxDecoration(
              //       color: const Color(0xFFF5F7FB),
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: Icon(Icons.arrow_back_ios_new_rounded,
              //         size: 18.h, color: AppColors.textDark),
              //   ),
              // ),
              SizedBox(width: 12.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText('Known People',
                      size: 18,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700),
                  AppText('Familiar faces for the patient',
                      size: 11, color: AppColors.iconGrey),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: _reload,
                child: Container(
                  width: 40.h,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.refresh_rounded,
                      size: 20.h, color: AppColors.iconGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Search & Filter ─────────────────────────────────────────────────────

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 0),
      child: Column(
        children: [
          // Search bar
          Container(
            height: 46.v,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 8,
                    offset: Offset(0, 2))
              ],
            ),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'Search by name or notes…',
                hintStyle:
                    TextStyle(fontSize: 13, color: AppColors.iconGrey),
                prefixIcon: Icon(Icons.search_rounded,
                    size: 20.h, color: AppColors.iconGrey),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () => setState(() {
                          _searchCtrl.clear();
                          _searchQuery = '';
                        }),
                        child: Icon(Icons.close_rounded,
                            size: 18.h, color: AppColors.iconGrey),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.v),
              ),
            ),
          ),
          SizedBox(height: 12.v),

          // Relationship filter chips
          SizedBox(
            height: 34.v,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _filterChip(null, 'All'),
                ...PersonRelationship.values
                    .map((r) => _filterChip(r, r.label)),
              ],
            ),
          ),
          SizedBox(height: 12.v),
        ],
      ),
    );
  }

  Widget _filterChip(PersonRelationship? rel, String label) {
    final selected = _filterRelationship == rel;
    return GestureDetector(
      onTap: () => setState(() => _filterRelationship = rel),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.v),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFE2E8F0),
              width: 1.5),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),
        child: AppText(
          rel != null ? '${rel.emoji}  $label' : '✦  $label',
          size: 12,
          color: selected ? Colors.white : AppColors.textDark,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ─── List ────────────────────────────────────────────────────────────────

  Widget _buildList(List<KnownPerson> people) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.h, 0, 16.h, 100.v),
      itemCount: people.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.v),
      itemBuilder: (_, i) => _PersonCard(
        person: people[i],
        onTap: () => _openEdit(people[i]),
        onDelete: () => _confirmDelete(people[i]),
      ),
    );
  }

  // ─── FAB ─────────────────────────────────────────────────────────────────

  Widget _buildFAB() {
    return GestureDetector(
      onTap: _openAdd,
      child: Container(
        height: 56.v,
        padding: EdgeInsets.symmetric(horizontal: 22.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_add_rounded, color: Colors.white, size: 20.h),
            SizedBox(width: 8.h),
            AppText('Add Person',
                size: 14, color: Colors.white, fontWeight: FontWeight.w700),
          ],
        ),
      ),
    );
  }

  // ─── Empty / Error / Loader ───────────────────────────────────────────────

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline_rounded,
              size: 60.h, color: AppColors.iconGrey.withOpacity(0.4)),
          SizedBox(height: 14.v),
          AppText('No people found',
              size: 15,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600),
          SizedBox(height: 6.v),
          AppText('Add familiar people so the patient recognises them.',
              size: 12,
              color: AppColors.iconGrey,
              align: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildLoader() => Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );

  Widget _buildError() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 48.h, color: AppColors.iconGrey),
            SizedBox(height: 12.v),
            AppText('Could not load people',
                size: 14,
                color: AppColors.textDark,
                fontWeight: FontWeight.w600),
            SizedBox(height: 8.v),
            TextButton(
              onPressed: _reload,
              child: AppText('Retry',
                  size: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );

  // ─── Navigation ───────────────────────────────────────────────────────────

  Future<void> _openAdd() async {
    final added = await Navigator.push<KnownPerson>(
      context,
      MaterialPageRoute(builder: (_) => const AddPersonView()),
    );
    if (added != null) _reload();
  }

  Future<void> _openEdit(KnownPerson person) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditPersonView(person: person)),
    );
    if (changed == true) _reload();
  }

  void _confirmDelete(KnownPerson person) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText('Remove Person',
            size: 16,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700),
        content: AppText(
          'Remove ${person.name} from the known people list? This will also delete all registered face data.',
          size: 13,
          color: AppColors.iconGrey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText('Cancel',
                size: 13,
                color: AppColors.iconGrey,
                fontWeight: FontWeight.w500),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await PeopleApiService.deletePerson(person.id);
              _reload();
            },
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
  }
}

// ─── Person Card ────────────────────────────────────────────────────────────

class _PersonCard extends StatelessWidget {
  final KnownPerson person;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _PersonCard({
    required this.person,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: Color(0x09000000),
                blurRadius: 10,
                offset: Offset(0, 3)),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(14.h),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 56.h,
                    height: 56.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _relationshipColor(person.relationship)
                          .withOpacity(0.12),
                    ),
                    child: person.photoUrl != null
                        ? ClipOval(
                            child: Image.network(person.photoUrl!,
                                fit: BoxFit.cover))
                        : Center(
                            child: AppText(
                              person.name.isNotEmpty
                                  ? person.name[0].toUpperCase()
                                  : '?',
                              size: 22,
                              color: _relationshipColor(person.relationship),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                  // Face badge
                  if (person.hasFaceRegistered)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20.h,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(Icons.face_retouching_natural,
                            size: 10.h, color: Colors.white),
                      ),
                    ),
                ],
              ),

              SizedBox(width: 14.h),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(person.name,
                        size: 14,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700),
                    SizedBox(height: 3.v),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.h, vertical: 3.v),
                          decoration: BoxDecoration(
                            color: _relationshipColor(person.relationship)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: AppText(
                            '${person.relationship.emoji}  ${person.relationship.label}',
                            size: 10,
                            color: _relationshipColor(person.relationship),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (person.notes != null && person.notes!.isNotEmpty) ...[
                      SizedBox(height: 5.v),
                      AppText(person.notes!,
                          size: 11,
                          color: AppColors.iconGrey,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ],
                ),
              ),

              SizedBox(width: 8.h),

              // Actions
              Column(
                children: [
                  GestureDetector(
                    onTap: onDelete,
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
                  SizedBox(height: 6.v),
                  Container(
                    width: 32.h,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.chevron_right_rounded,
                        size: 18.h, color: AppColors.iconGrey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _relationshipColor(PersonRelationship r) {
    switch (r) {
      case PersonRelationship.family:
        return const Color(0xFF8B5CF6);
      case PersonRelationship.friend:
        return const Color(0xFFF59E0B);
      case PersonRelationship.caregiver:
        return const Color(0xFF10B981);
      case PersonRelationship.doctor:
        return const Color(0xFF3B82F6);
      case PersonRelationship.neighbour:
        return const Color(0xFFF97316);
      case PersonRelationship.other:
        return AppColors.iconGrey;
    }
  }
}