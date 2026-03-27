import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/shared/app_text.dart';
import 'package:lifelinker/core/utils/size_utils.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MEDICATION LIST VIEW
// ─────────────────────────────────────────────────────────────────────────────

class MedicationView extends StatefulWidget {
  const MedicationView({super.key});

  @override
  State<MedicationView> createState() => _MedicationViewState();
}

class _MedicationViewState extends State<MedicationView> {
  final List<_MedItem> _medications = [
    _MedItem(
      name: 'Agpin Doe',
      time: '1:00 PM',
      color: AppColors.success,
      icon: Icons.medication_rounded,
      status: MedStatus.none,
    ),
    _MedItem(
      name: 'Vitamin D',
      time: '12:00 PM',
      color: AppColors.primary,
      icon: Icons.sunny_snowing,
      status: MedStatus.taken,
    ),
    _MedItem(
      name: 'Atorvastatin',
      time: '8:00 PM',
      color: AppColors.primary,
      icon: Icons.water_drop_rounded,
      status: MedStatus.missed,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap.v(8),
                    ..._medications.map((med) => _buildMedCard(med)),
                    Gap.v(20),
                    _buildLastWeekLogs(),
                    Gap.v(24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 12.v),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddMedicationView()),
            ),
            child: Container(
              width: 36.h,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add_rounded,
                  color: AppColors.primary, size: 22.h),
            ),
          ),
          SizedBox(width: 10.h),
          AppText(
            'Medication List',
            size: 20,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  // ─── Med Card ─────────────────────────────────────────────────────────────

  Widget _buildMedCard(_MedItem med) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.v),
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 14.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 46.h,
            height: 46.h,
            decoration: BoxDecoration(
              color: med.color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(med.icon, color: Colors.white, size: 24.h),
          ),
          SizedBox(width: 12.h),

          // Name & time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(med.name,
                    size: 15,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600),
                Gap.v(4),
                AppText(med.time,
                    size: 13, color: AppColors.iconGrey),
              ],
            ),
          ),

          // Status badge
          _buildStatusBadge(med.status),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(MedStatus status) {
    if (status == MedStatus.none) {
      return Icon(Icons.chevron_right_rounded,
          color: AppColors.iconGrey, size: 22.h);
    }

    final bool isTaken = status == MedStatus.taken;
    return Container(
      width: 34.h,
      height: 34.h,
      decoration: BoxDecoration(
        color: isTaken ? AppColors.success : AppColors.alert,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isTaken ? Icons.check_rounded : Icons.close_rounded,
        color: Colors.white,
        size: 18.h,
      ),
    );
  }

  // ─── Last Week Logs ───────────────────────────────────────────────────────

  Widget _buildLastWeekLogs() {
    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText('Last Week Logs',
              size: 15,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600),
          Gap.v(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .asMap()
                .entries
                .map((e) {
              final colors = [
                AppColors.success,
                AppColors.success,
                AppColors.alert,
                AppColors.success,
                AppColors.success,
                AppColors.pending,
                AppColors.border,
              ];
              return Column(
                children: [
                  Container(
                    width: 32.h,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: colors[e.key],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      e.key == 2
                          ? Icons.close_rounded
                          : e.key == 5
                              ? Icons.remove_rounded
                              : e.key == 6
                                  ? Icons.circle_outlined
                                  : Icons.check_rounded,
                      color: Colors.white,
                      size: 16.h,
                    ),
                  ),
                  Gap.v(4),
                  AppText(e.value,
                      size: 11, color: AppColors.iconGrey),
                ],
              );
            }).toList(),
          ),
          Gap.v(12),
          Row(
            children: [
              Icon(Icons.analytics_outlined,
                  color: AppColors.primary, size: 18.h),
              SizedBox(width: 6.h),
              AppText('5 out of 6 — 83% adherence',
                  size: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ADD MEDICATION VIEW
// ─────────────────────────────────────────────────────────────────────────────

class AddMedicationView extends StatefulWidget {
  const AddMedicationView({super.key});

  @override
  State<AddMedicationView> createState() => _AddMedicationViewState();
}

class _AddMedicationViewState extends State<AddMedicationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_ScheduleItem> _scheduleItems = [
    _ScheduleItem(
      name: 'Donepezil',
      time: '8:00 AM',
      color: const Color(0xFF7B61FF),
      icon: Icons.medication_liquid_rounded,
      status: MedStatus.pending,
    ),
    _ScheduleItem(
      name: 'Vitamin D',
      time: '11:00 PM',
      color: AppColors.success,
      icon: Icons.check_circle_rounded,
      status: MedStatus.taken,
    ),
    _ScheduleItem(
      name: 'Atorvastatin',
      time: '8:00 PM',
      color: AppColors.alert,
      icon: Icons.lock_rounded,
      status: MedStatus.missed,
    ),
  ];

  // Add form controllers
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  String _selectedFrequency = 'Daily';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTodayTab(),
                  _buildScheduleTab(),
                  _buildHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _showAddMedBottomSheet,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
    );
  }

  // ─── Header ──────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 8.v),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.h,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add_rounded,
                  color: AppColors.primary, size: 22.h),
            ),
          ),
          SizedBox(width: 10.h),
          AppText(
            'Add Medication',
            size: 20,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  // ─── Tab Bar ──────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      padding: EdgeInsets.all(4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 4),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        onTap: (_) => setState(() {}),
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.iconGrey,
        labelStyle: TextStyle(
          fontSize: 13.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'Today'),
          Tab(text: 'Schedule'),
          Tab(text: 'History'),
        ],
      ),
    );
  }

  // ─── Today Tab ────────────────────────────────────────────────────────────

  Widget _buildTodayTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      children: [
        _buildDateStrip(),
        Gap.v(14),
        ..._scheduleItems.map((item) => _buildScheduleCard(item)),
        Gap.v(80),
      ],
    );
  }

  Widget _buildDateStrip() {
    final now = DateTime.now();
    return SizedBox(
      height: 70.v,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, i) {
          final day = now.subtract(Duration(days: 3 - i));
          final isToday = i == 3;
          final days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
          final dayLabel = days[day.weekday - 1];

          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 44.h,
              margin: EdgeInsets.only(right: 8.h),
              decoration: BoxDecoration(
                color: isToday ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: AppColors.shadow, blurRadius: 4),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    dayLabel,
                    size: 11,
                    color: isToday ? Colors.white70 : AppColors.iconGrey,
                  ),
                  Gap.v(4),
                  AppText(
                    '${day.day}',
                    size: 15,
                    fontWeight: FontWeight.w700,
                    color: isToday ? Colors.white : AppColors.textDark,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleCard(_ScheduleItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.v),
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 14.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46.h,
            height: 46.h,
            decoration: BoxDecoration(
              color: item.color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: Colors.white, size: 24.h),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(item.name,
                    size: 15,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600),
                Gap.v(4),
                AppText(item.time,
                    size: 13, color: AppColors.iconGrey),
              ],
            ),
          ),
          _buildStatusChip(item.status),
        ],
      ),
    );
  }

  Widget _buildStatusChip(MedStatus status) {
    Color bg;
    Color text;
    String label;
    IconData? icon;

    switch (status) {
      case MedStatus.pending:
        bg = AppColors.pending.withOpacity(0.12);
        text = AppColors.pending;
        label = 'Pending';
        break;
      case MedStatus.taken:
        bg = AppColors.success.withOpacity(0.12);
        text = AppColors.success;
        label = 'Taken';
        break;
      case MedStatus.missed:
        bg = AppColors.alert.withOpacity(0.12);
        text = AppColors.alert;
        label = '';
        icon = Icons.info_rounded;
        break;
      default:
        bg = AppColors.border;
        text = AppColors.iconGrey;
        label = '';
    }

    if (icon != null) {
      return Icon(icon, color: text, size: 24.h);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 5.v),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(label,
          size: 12, color: text, fontWeight: FontWeight.w600),
    );
  }

  // ─── Schedule Tab ─────────────────────────────────────────────────────────

  Widget _buildScheduleTab() {
    final List<Map<String, dynamic>> scheduled = [
      {'time': '8:00 AM', 'meds': ['Donepezil 5mg']},
      {'time': '12:00 PM', 'meds': ['Vitamin D 1000IU', 'Omega-3']},
      {'time': '8:00 PM', 'meds': ['Atorvastatin 20mg']},
      {'time': '10:00 PM', 'meds': ['Melatonin 5mg']},
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      children: scheduled.map((slot) {
        return _buildTimeSlot(slot['time'], slot['meds'] as List<String>);
      }).toList(),
    );
  }

  Widget _buildTimeSlot(String time, List<String> meds) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time column
        SizedBox(
          width: 66.h,
          child: Padding(
            padding: EdgeInsets.only(top: 12.v),
            child: AppText(time,
                size: 12,
                color: AppColors.iconGrey,
                fontWeight: FontWeight.w500),
          ),
        ),

        // Timeline dot & line
        Column(
          children: [
            Container(
              width: 12.h,
              height: 12.h,
              margin: EdgeInsets.only(top: 14.v),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: ((meds.length * 56) + 10).v,
              color: AppColors.primary.withOpacity(0.2),
            ),
          ],
        ),

        SizedBox(width: 12.h),

        // Med cards
        Expanded(
          child: Column(
            children: meds
                .map((med) => Container(
                      margin: EdgeInsets.only(bottom: 8.v),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.h, vertical: 12.v),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.shadow, blurRadius: 4),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.medication_rounded,
                              color: AppColors.primary, size: 18.h),
                          SizedBox(width: 8.h),
                          Expanded(
                            child: AppText(med,
                                size: 13,
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.notifications_outlined,
                              color: AppColors.iconGrey, size: 18.h),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  // ─── History Tab ──────────────────────────────────────────────────────────

  Widget _buildHistoryTab() {
    final List<Map<String, dynamic>> history = [
      {
        'date': 'Today',
        'items': [
          {'name': 'Donepezil', 'time': '8:00 AM', 'status': MedStatus.taken},
          {'name': 'Vitamin D', 'time': '11:00 AM', 'status': MedStatus.taken},
          {'name': 'Atorvastatin', 'time': '8:00 PM', 'status': MedStatus.missed},
        ]
      },
      {
        'date': 'Yesterday',
        'items': [
          {'name': 'Donepezil', 'time': '8:00 AM', 'status': MedStatus.taken},
          {'name': 'Vitamin D', 'time': '11:00 AM', 'status': MedStatus.taken},
          {'name': 'Atorvastatin', 'time': '8:00 PM', 'status': MedStatus.taken},
        ]
      },
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
      children: history.map((group) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.v),
              child: AppText(group['date'],
                  size: 13,
                  color: AppColors.iconGrey,
                  fontWeight: FontWeight.w600),
            ),
            ...(group['items'] as List<Map<String, dynamic>>)
                .map((item) => _buildHistoryItem(item)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final bool taken = item['status'] == MedStatus.taken;
    return Container(
      margin: EdgeInsets.only(bottom: 8.v),
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: AppColors.shadow, blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36.h,
            height: 36.h,
            decoration: BoxDecoration(
              color: taken
                  ? AppColors.success.withOpacity(0.12)
                  : AppColors.alert.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              taken ? Icons.check_rounded : Icons.close_rounded,
              color: taken ? AppColors.success : AppColors.alert,
              size: 18.h,
            ),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(item['name'],
                    size: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500),
                AppText(item['time'],
                    size: 12, color: AppColors.iconGrey),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.v),
            decoration: BoxDecoration(
              color: taken
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.alert.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AppText(
              taken ? 'Taken' : 'Missed',
              size: 11,
              color: taken ? AppColors.success : AppColors.alert,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Add Med Bottom Sheet ─────────────────────────────────────────────────

  void _showAddMedBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddMedSheet(
        nameController: _nameController,
        dosageController: _dosageController,
        selectedFrequency: _selectedFrequency,
        selectedTime: _selectedTime,
        onFrequencyChanged: (v) => setState(() => _selectedFrequency = v),
        onTimeChanged: (v) => setState(() => _selectedTime = v),
        onSave: () {
          Navigator.pop(context);
          // TODO: save medication
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ADD MED BOTTOM SHEET
// ─────────────────────────────────────────────────────────────────────────────

class _AddMedSheet extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController dosageController;
  final String selectedFrequency;
  final TimeOfDay selectedTime;
  final ValueChanged<String> onFrequencyChanged;
  final ValueChanged<TimeOfDay> onTimeChanged;
  final VoidCallback onSave;

  const _AddMedSheet({
    required this.nameController,
    required this.dosageController,
    required this.selectedFrequency,
    required this.selectedTime,
    required this.onFrequencyChanged,
    required this.onTimeChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.h,
                height: 4.v,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Gap.v(16),
            AppText('Add Medication',
                size: 18,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700),
            Gap.v(16),
            _buildInput('Medication Name', nameController,
                Icons.medication_rounded),
            Gap.v(12),
            _buildInput(
                'Dosage (e.g. 10mg)', dosageController, Icons.scale_rounded),
            Gap.v(12),
            _buildFrequencySelector(context),
            Gap.v(12),
            _buildTimePicker(context),
            Gap.v(20),
            SizedBox(
              width: double.infinity,
              height: 52.v,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: AppText('Save Medication',
                    size: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Gap.v(8),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
      String hint, TextEditingController ctrl, IconData icon) {
    return Container(
      height: 50.v,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: ctrl,
        style: TextStyle(
            fontSize: 14.fSize,
            fontFamily: 'Poppins',
            color: AppColors.textDark),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
              color: AppColors.iconGrey),
          prefixIcon: Icon(icon, color: AppColors.iconGrey, size: 20.h),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.v),
        ),
      ),
    );
  }

  Widget _buildFrequencySelector(BuildContext context) {
    final options = ['Daily', 'Weekly', 'As needed'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Frequency',
            size: 13,
            color: AppColors.iconGrey,
            fontWeight: FontWeight.w500),
        Gap.v(8),
        Row(
          children: options
              .map((o) => GestureDetector(
                    onTap: () => onFrequencyChanged(o),
                    child: Container(
                      margin: EdgeInsets.only(right: 8.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.h, vertical: 8.v),
                      decoration: BoxDecoration(
                        color: selectedFrequency == o
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selectedFrequency == o
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                      child: AppText(o,
                          size: 12,
                          color: selectedFrequency == o
                              ? Colors.white
                              : AppColors.textDark,
                          fontWeight: selectedFrequency == o
                              ? FontWeight.w600
                              : FontWeight.w400),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );
        if (picked != null) onTimeChanged(picked);
      },
      child: Container(
        height: 50.v,
        padding: EdgeInsets.symmetric(horizontal: 14.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded,
                color: AppColors.iconGrey, size: 20.h),
            SizedBox(width: 10.h),
            Expanded(
              child: AppText(
                selectedTime.format(context),
                size: 14,
                color: AppColors.textDark,
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.iconGrey, size: 20.h),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────────────────────

enum MedStatus { none, pending, taken, missed }

class _MedItem {
  final String name;
  final String time;
  final Color color;
  final IconData icon;
  final MedStatus status;

  const _MedItem({
    required this.name,
    required this.time,
    required this.color,
    required this.icon,
    required this.status,
  });
}

class _ScheduleItem {
  final String name;
  final String time;
  final Color color;
  final IconData icon;
  final MedStatus status;

  const _ScheduleItem({
    required this.name,
    required this.time,
    required this.color,
    required this.icon,
    required this.status,
  });
}