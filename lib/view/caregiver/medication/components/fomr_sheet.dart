import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/model/medication_scheduled.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/medication.dart';
import 'package:provider/provider.dart';

class MedFormSheet extends StatefulWidget {
  final UserModel patient;
  final MedicationScheduleModel? existing;

  const MedFormSheet({super.key, required this.patient, this.existing});

  @override
  State<MedFormSheet> createState() => _MedFormSheetState();
}

class _MedFormSheetState extends State<MedFormSheet> {
  final _nameCtrl = TextEditingController();
  final _dosageCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  MedicationFrequency _frequency = MedicationFrequency.daily;
  final List<String> _times = [];

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final med = widget.existing!;
      _nameCtrl.text = med.name;
      _dosageCtrl.text = med.dosage;
      _notesCtrl.text = med.notes ?? '';
      _frequency = med.frequency;
      _times.addAll(med.times);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Consumer<MedicationProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.widthMultiplier * 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: SizeConfig.widthMultiplier * 10,
                    height: SizeConfig.heightMultiplier * 0.5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                AppText(
                  isEdit ? 'Edit Medication' : 'Add Medication',
                  size: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                CustomTextField(
                  controller: _nameCtrl,
                  hint: 'Medication name (e.g. Donepezil)',
                  prefixIcon: Icons.medication_rounded,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                CustomTextField(
                  controller: _dosageCtrl,
                  hint: 'Dosage (e.g. 10mg)',
                  prefixIcon: Icons.scale_rounded,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                AppText(
                  'Frequency',
                  size: 13,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                _FrequencySelector(
                  selected: _frequency,
                  onSelect: (f) => setState(() => _frequency = f),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'Schedule Times',
                      size: 13,
                      color: AppColors.textMedium,
                      fontWeight: FontWeight.w600,
                    ),
                    GestureDetector(
                      onTap: () => _pickTime(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 3,
                          vertical: SizeConfig.heightMultiplier * 0.6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              color: AppColors.primary,
                              size: SizeConfig.widthMultiplier * 4,
                            ),
                            SizedBox(width: SizeConfig.widthMultiplier * 1),
                            AppText(
                              'Add Time',
                              size: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                if (_times.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.heightMultiplier * 1),
                    child: AppText(
                      'No times added yet',
                      size: 12,
                      color: AppColors.iconGrey,
                    ),
                  )
                else
                  Wrap(
                    spacing: SizeConfig.widthMultiplier * 2,
                    runSpacing: SizeConfig.heightMultiplier * 0.8,
                    children: _times
                        .map((t) => _TimeTag(
                              time: t,
                              onRemove: () =>
                                  setState(() => _times.remove(t)),
                            ))
                        .toList(),
                  ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                CustomTextField(
                  controller: _notesCtrl,
                  hint: 'Notes (optional)',
                  prefixIcon: Icons.notes_rounded,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 3),
                CustomButton(
                  text: isEdit ? 'Update Medication' : 'Save Medication',
                  isLoading: provider.isSaving,
                  onTap: () => _save(context, provider, isEdit),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final formatted = picked.format(context);
      if (!_times.contains(formatted)) {
        setState(() => _times.add(formatted));
      }
    }
  }

  void _save(
      BuildContext context, MedicationProvider provider, bool isEdit) {
    if (_nameCtrl.text.trim().isEmpty || _dosageCtrl.text.trim().isEmpty) {
      return;
    }
    final caregiverId = SharedPrefsService.getUID() ?? '';
    if (isEdit) {
      final updated = widget.existing!.copyWith(
        name: _nameCtrl.text.trim(),
        dosage: _dosageCtrl.text.trim(),
        frequency: _frequency,
        times: _times,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      provider.updateMedication(
        context: context,
        medication: updated,
        onSuccess: () => Navigator.pop(context),
      );
    } else {
      provider.addMedication(
        context: context,
        patientId: widget.patient.uid,
        caregiverId: caregiverId,
        name: _nameCtrl.text.trim(),
        dosage: _dosageCtrl.text.trim(),
        frequency: _frequency,
        times: _times,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        onSuccess: () => Navigator.pop(context),
      );
    }
  }
}

class _FrequencySelector extends StatelessWidget {
  final MedicationFrequency selected;
  final ValueChanged<MedicationFrequency> onSelect;

  const _FrequencySelector(
      {required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = [
      (MedicationFrequency.daily, 'Daily'),
      (MedicationFrequency.weekly, 'Weekly'),
      (MedicationFrequency.asNeeded, 'As Needed'),
    ];
    return Row(
      children: options.map((o) {
        final isSelected = selected == o.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(o.$1),
            child: Container(
              margin: EdgeInsets.only(right: o.$1 != MedicationFrequency.asNeeded
                  ? SizeConfig.widthMultiplier * 2
                  : 0),
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.heightMultiplier * 1.2),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: AppText(
                o.$2,
                size: 12,
                color: isSelected ? Colors.white : AppColors.textDark,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                align: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _TimeTag extends StatelessWidget {
  final String time;
  final VoidCallback onRemove;

  const _TimeTag({required this.time, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 3,
        vertical: SizeConfig.heightMultiplier * 0.6,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            time,
            size: 12,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 1.5),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: SizeConfig.widthMultiplier * 3.5,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}