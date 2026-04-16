import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/model/med_history.dart';
import 'package:lifelinker/model/medication.dart';
import 'package:lifelinker/model/scheduled_medication.dart';
import 'package:lifelinker/model/time_slot.dart';
import 'package:lifelinker/model/week_log.dart';

class MedicationProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();

  String _selectedFrequency = 'Daily';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  int _currentTabIndex = 0;

  String get selectedFrequency => _selectedFrequency;
  TimeOfDay get selectedTime => _selectedTime;
  int get currentTabIndex => _currentTabIndex;

  // ─── Medication List ────────────────────────────────────────────────────────

  List<MedicationModel> get medications => [
    MedicationModel(
      name: 'Agpin Doe',
      time: '1:00 PM',
      color: AppColors.success,
      icon: Icons.medication_rounded,
      status: MedStatus.none,
    ),
    MedicationModel(
      name: 'Vitamin D',
      time: '12:00 PM',
      color: AppColors.primary,
      icon: Icons.sunny_snowing,
      status: MedStatus.taken,
    ),
    MedicationModel(
      name: 'Atorvastatin',
      time: '8:00 PM',
      color: AppColors.primary,
      icon: Icons.water_drop_rounded,
      status: MedStatus.missed,
    ),
  ];

  // ─── Weekly Log ─────────────────────────────────────────────────────────────

  List<WeekLogModel> get weekLogs => [
    WeekLogModel(
      dayLabel: 'M',
      color: AppColors.success,
      icon: Icons.check_rounded,
    ),
    WeekLogModel(
      dayLabel: 'T',
      color: AppColors.success,
      icon: Icons.check_rounded,
    ),
    WeekLogModel(
      dayLabel: 'W',
      color: AppColors.alert,
      icon: Icons.close_rounded,
    ),
    WeekLogModel(
      dayLabel: 'T',
      color: AppColors.success,
      icon: Icons.check_rounded,
    ),
    WeekLogModel(
      dayLabel: 'F',
      color: AppColors.success,
      icon: Icons.check_rounded,
    ),
    WeekLogModel(
      dayLabel: 'S',
      color: AppColors.pending,
      icon: Icons.remove_rounded,
    ),
    WeekLogModel(
      dayLabel: 'S',
      color: AppColors.border,
      icon: Icons.circle_outlined,
    ),
  ];

  String get adherenceLabel => '5 out of 6 — 83% adherence';

  // ─── Scheduled Medications ──────────────────────────────────────────────────

  List<ScheduledMedicationModel> get scheduledMedications => [
    ScheduledMedicationModel(
      name: 'Donepezil',
      time: '8:00 AM',
      color: AppColors.purple,
      icon: Icons.medication_liquid_rounded,
      status: MedStatus.pending,
    ),
    ScheduledMedicationModel(
      name: 'Vitamin D',
      time: '11:00 PM',
      color: AppColors.success,
      icon: Icons.check_circle_rounded,
      status: MedStatus.taken,
    ),
    ScheduledMedicationModel(
      name: 'Atorvastatin',
      time: '8:00 PM',
      color: AppColors.alert,
      icon: Icons.lock_rounded,
      status: MedStatus.missed,
    ),
  ];

  // ─── Time Slots ─────────────────────────────────────────────────────────────

  List<TimeSlotModel> get timeSlots => const [
    TimeSlotModel(time: '8:00 AM', medications: ['Donepezil 5mg']),
    TimeSlotModel(
      time: '12:00 PM',
      medications: ['Vitamin D 1000IU', 'Omega-3'],
    ),
    TimeSlotModel(time: '8:00 PM', medications: ['Atorvastatin 20mg']),
    TimeSlotModel(time: '10:00 PM', medications: ['Melatonin 5mg']),
  ];

  // ─── History ────────────────────────────────────────────────────────────────

  List<MedHistoryGroupModel> get historyGroups => [
    MedHistoryGroupModel(
      dateLabel: 'Today',
      items: [
        const MedHistoryItemModel(
          name: 'Donepezil',
          time: '8:00 AM',
          status: MedStatus.taken,
        ),
        const MedHistoryItemModel(
          name: 'Vitamin D',
          time: '11:00 AM',
          status: MedStatus.taken,
        ),
        const MedHistoryItemModel(
          name: 'Atorvastatin',
          time: '8:00 PM',
          status: MedStatus.missed,
        ),
      ],
    ),
    MedHistoryGroupModel(
      dateLabel: 'Yesterday',
      items: [
        const MedHistoryItemModel(
          name: 'Donepezil',
          time: '8:00 AM',
          status: MedStatus.taken,
        ),
        const MedHistoryItemModel(
          name: 'Vitamin D',
          time: '11:00 AM',
          status: MedStatus.taken,
        ),
        const MedHistoryItemModel(
          name: 'Atorvastatin',
          time: '8:00 PM',
          status: MedStatus.taken,
        ),
      ],
    ),
  ];

  // ─── Actions ────────────────────────────────────────────────────────────────

  void setFrequency(String value) {
    _selectedFrequency = value;
    notifyListeners();
  }

  void setTime(TimeOfDay value) {
    _selectedTime = value;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void saveMedication() {
    // TODO: Persist medication to backend
    nameController.clear();
    dosageController.clear();
    _selectedFrequency = 'Daily';
    _selectedTime = const TimeOfDay(hour: 8, minute: 0);
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    super.dispose();
  }
}
