import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/core/widgets/custom_textfield.dart';
import 'package:lifelinker/model/sleep_routine.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/sleep_provider.dart';
import 'package:provider/provider.dart';

class SleepRoutineFormSheet extends StatefulWidget {
  final UserModel patient;
  final SleepRoutineModel? existing;

  const SleepRoutineFormSheet({
    super.key,
    required this.patient,
    this.existing,
  });

  @override
  State<SleepRoutineFormSheet> createState() => _SleepRoutineFormSheetState();
}

class _SleepRoutineFormSheetState extends State<SleepRoutineFormSheet> {
  final _titleCtrl = TextEditingController();
  final _tipCtrl = TextEditingController();
  String _bedtime = '10:00 PM';
  String _wakeTime = '6:00 AM';
  int _targetHours = 8;
  final List<String> _tips = [];

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final r = widget.existing!;
      _titleCtrl.text = r.title;
      _bedtime = r.bedtime;
      _wakeTime = r.wakeTime;
      _targetHours = r.targetHours;
      _tips.addAll(r.sleepTips);
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _tipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Consumer<SleepProvider>(
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
                  isEdit ? 'Edit Sleep Routine' : 'Create Sleep Routine',
                  size: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                CustomTextField(
                  controller: _titleCtrl,
                  hint: 'Routine title (e.g. Nighttime Routine)',
                  prefixIcon: Icons.bedtime_rounded,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                AppText(
                  'Schedule',
                  size: 13,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Row(
                  children: [
                    Expanded(
                      child: _TimePickerTile(
                        label: 'Bedtime',
                        time: _bedtime,
                        icon: Icons.bedtime_outlined,
                        color: AppColors.medicationViolet,
                        onPick: () => _pickTime(context, true),
                      ),
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 3),
                    Expanded(
                      child: _TimePickerTile(
                        label: 'Wake Up',
                        time: _wakeTime,
                        icon: Icons.wb_sunny_outlined,
                        color: AppColors.amber,
                        onPick: () => _pickTime(context, false),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                AppText(
                  'Target Sleep Hours',
                  size: 13,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                _TargetHoursSelector(
                  value: _targetHours,
                  onChanged: (v) => setState(() => _targetHours = v),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      'Sleep Tips',
                      size: 13,
                      color: AppColors.textMedium,
                      fontWeight: FontWeight.w600,
                    ),
                    GestureDetector(
                      onTap: _addTip,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 3,
                          vertical: SizeConfig.heightMultiplier * 0.6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.medicationViolet.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_rounded,
                              color: AppColors.medicationViolet,
                              size: SizeConfig.widthMultiplier * 4,
                            ),
                            SizedBox(width: SizeConfig.widthMultiplier * 1),
                            AppText(
                              'Add Tip',
                              size: 12,
                              color: AppColors.medicationViolet,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: SizeConfig.heightMultiplier * 6,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TextField(
                          controller: _tipCtrl,
                          style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 1.5,
                            fontFamily: 'Poppins',
                            color: AppColors.textDark,
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. Avoid screens 1hr before bed',
                            hintStyle: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 1.4,
                              fontFamily: 'Poppins',
                              color: AppColors.iconGrey,
                            ),
                            prefixIcon: Icon(
                              Icons.lightbulb_outline_rounded,
                              color: AppColors.iconGrey,
                              size: SizeConfig.widthMultiplier * 4.5,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: SizeConfig.heightMultiplier * 1.7,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_tips.isNotEmpty) ...[
                  SizedBox(height: SizeConfig.heightMultiplier * 1),
                  ..._tips.asMap().entries.map(
                    (e) => Container(
                      margin: EdgeInsets.only(
                        bottom: SizeConfig.heightMultiplier * 0.6,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 3,
                        vertical: SizeConfig.heightMultiplier * 0.8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.medicationViolet.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.medicationViolet.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: SizeConfig.widthMultiplier * 4,
                            color: AppColors.medicationViolet,
                          ),
                          SizedBox(width: SizeConfig.widthMultiplier * 2),
                          Expanded(
                            child: AppText(
                              e.value,
                              size: 12,
                              color: AppColors.textMedium,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _tips.removeAt(e.key)),
                            child: Icon(
                              Icons.close_rounded,
                              size: SizeConfig.widthMultiplier * 4,
                              color: AppColors.alert,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: SizeConfig.heightMultiplier * 3),
                CustomButton(
                  text: isEdit ? 'Update Routine' : 'Save Routine',
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

  Future<void> _pickTime(BuildContext context, bool isBedtime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.medicationViolet,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      final formatted = picked.format(context);
      setState(() {
        if (isBedtime) {
          _bedtime = formatted;
        } else {
          _wakeTime = formatted;
        }
      });
    }
  }

  void _addTip() {
    if (_tipCtrl.text.trim().isEmpty) return;
    setState(() {
      _tips.add(_tipCtrl.text.trim());
      _tipCtrl.clear();
    });
  }

  void _save(BuildContext context, SleepProvider provider, bool isEdit) {
    if (_titleCtrl.text.trim().isEmpty) return;
    final caregiverId = SharedPrefsService.getUID() ?? '';

    if (isEdit) {
      final updated = widget.existing!.copyWith(
        title: _titleCtrl.text.trim(),
        bedtime: _bedtime,
        wakeTime: _wakeTime,
        targetHours: _targetHours,
        sleepTips: _tips,
      );
      provider.updateRoutine(
        context: context,
        routine: updated,
        onSuccess: () => Navigator.pop(context),
      );
    } else {
      final routine = SleepRoutineModel(
        id: '',
        patientId: widget.patient.uid,
        caregiverId: caregiverId,
        title: _titleCtrl.text.trim(),
        bedtime: _bedtime,
        wakeTime: _wakeTime,
        targetHours: _targetHours,
        sleepTips: _tips,
        isActive: true,
        createdAt: DateTime.now(),
      );
      provider.addRoutine(
        context: context,
        routine: routine,
        onSuccess: () => Navigator.pop(context),
      );
    }
  }
}

class _TimePickerTile extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final Color color;
  final VoidCallback onPick;

  const _TimePickerTile({
    required this.label,
    required this.time,
    required this.icon,
    required this.color,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.widthMultiplier * 3.5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: SizeConfig.widthMultiplier * 4, color: color),
                SizedBox(width: SizeConfig.widthMultiplier * 1.5),
                AppText(label, size: 11, color: AppColors.iconGrey),
              ],
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 0.6),
            AppText(
              time,
              size: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetHoursSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _TargetHoursSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final hours = i + 5;
        final isSelected = value == hours;
        return GestureDetector(
          onTap: () => onChanged(hours),
          child: Container(
            margin: EdgeInsets.only(
              right: i < 6 ? SizeConfig.widthMultiplier * 1.5 : 0,
            ),
            width: SizeConfig.widthMultiplier * 11,
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.heightMultiplier * 1.1,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.medicationViolet
                  : AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppColors.medicationViolet
                    : AppColors.border,
              ),
            ),
            child: AppText(
              '${hours}h',
              size: 12,
              color: isSelected ? Colors.white : AppColors.textDark,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              align: TextAlign.center,
            ),
          ),
        );
      }),
    );
  }
}
