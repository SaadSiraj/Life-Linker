import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/medication.dart';
import 'package:lifelinker/view/add%20medication/components/add_med_bs.dart';
import 'package:lifelinker/view/add%20medication/components/add_med_header.dart';
import 'package:lifelinker/view/add%20medication/components/date_strip.dart';
import 'package:lifelinker/view/add%20medication/components/history_item.dart';
import 'package:lifelinker/view/add%20medication/components/med_tab_bar.dart';
import 'package:lifelinker/view/add%20medication/components/schedule_card.dart';
import 'package:lifelinker/view/add%20medication/components/time_slot_row.dart';
import 'package:provider/provider.dart';

class AddMedicationView extends StatefulWidget {
  const AddMedicationView({super.key});

  @override
  State<AddMedicationView> createState() => _AddMedicationViewState();
}

class _AddMedicationViewState extends State<AddMedicationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddMedBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddMedBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                const AddMedicationHeader(),
                MedTabBar(
                  tabController: _tabController,
                  onTap: (index) => provider.setTabIndex(index),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _TodayTab(provider: provider),
                      _ScheduleTab(provider: provider),
                      _HistoryTab(provider: provider),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: provider.currentTabIndex == 0
              ? FloatingActionButton(
                  onPressed: _showAddMedBottomSheet,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.add_rounded, color: Colors.white),
                )
              : null,
        );
      },
    );
  }
}

// ─── Today Tab ────────────────────────────────────────────────────────────────

class _TodayTab extends StatelessWidget {
  final MedicationProvider provider;

  const _TodayTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      children: [
        const DateStrip(),
        Gap.v(14),
        ...provider.scheduledMedications.map(
          (item) => ScheduleCard(item: item),
        ),
        Gap.v(80),
      ],
    );
  }
}

// ─── Schedule Tab ─────────────────────────────────────────────────────────────

class _ScheduleTab extends StatelessWidget {
  final MedicationProvider provider;

  const _ScheduleTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      children: provider.timeSlots.map((slot) => TimeSlotRow(slot: slot)).toList(),
    );
  }
}

// ─── History Tab ──────────────────────────────────────────────────────────────

class _HistoryTab extends StatelessWidget {
  final MedicationProvider provider;

  const _HistoryTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      children: provider.historyGroups.map((group) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.v),
              child: AppText(
                group.dateLabel,
                size: 13,
                color: AppColors.iconGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            ...group.items.map((item) => HistoryItem(item: item)),
          ],
        );
      }).toList(),
    );
  }
}