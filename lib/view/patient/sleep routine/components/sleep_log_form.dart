import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/model/sleep_log.dart';
import 'package:lifelinker/model/sleep_routine.dart';
import 'package:lifelinker/provider/sleep_provider.dart';
import 'package:provider/provider.dart';

class PatientSleepLogForm extends StatefulWidget {
  final String patientId;
  final String routineId;

  const PatientSleepLogForm({
    super.key,
    required this.patientId,
    required this.routineId,
  });

  @override
  State<PatientSleepLogForm> createState() => _PatientSleepLogFormState();
}

class _PatientSleepLogFormState extends State<PatientSleepLogForm> {
  String _bedtime = '10:00 PM';
  String _wakeTime = '6:00 AM';
  double _hours = 7.0;
  SleepQuality _quality = SleepQuality.good;
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Log Today\'s Sleep',
                  size: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                Row(
                  children: [
                    Expanded(
                      child: _TimePickerTile(
                        label: 'I slept at',
                        time: _bedtime,
                        icon: Icons.bedtime_outlined,
                        color: AppColors.medicationViolet,
                        onPick: () => _pickTime(context, true),
                      ),
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 3),
                    Expanded(
                      child: _TimePickerTile(
                        label: 'I woke up at',
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
                  'Total Sleep Hours: ${_hours.toStringAsFixed(1)}h',
                  size: 13,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.5),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.medicationViolet,
                    thumbColor: AppColors.medicationViolet,
                    inactiveTrackColor: AppColors.medicationViolet.withOpacity(
                      0.2,
                    ),
                    overlayColor: AppColors.medicationViolet.withOpacity(0.1),
                  ),
                  child: Slider(
                    value: _hours,
                    min: 1,
                    max: 12,
                    divisions: 22,
                    onChanged: (v) => setState(() => _hours = v),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                AppText(
                  'Sleep Quality',
                  size: 13,
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1),
                _QualitySelector(
                  selected: _quality,
                  onSelect: (q) => setState(() => _quality = q),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 2),
                Container(
                  height: SizeConfig.heightMultiplier * 6.5,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: _notesCtrl,
                    style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.5,
                      fontFamily: 'Poppins',
                      color: AppColors.textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Notes (optional, e.g. felt restless)',
                      hintStyle: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.4,
                        fontFamily: 'Poppins',
                        color: AppColors.iconGrey,
                      ),
                      prefixIcon: Icon(
                        Icons.notes_rounded,
                        color: AppColors.iconGrey,
                        size: SizeConfig.widthMultiplier * 4.5,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: SizeConfig.heightMultiplier * 1.8,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 3),
                CustomButton(
                  text: 'Save Sleep Log',
                  isLoading: provider.isSaving,
                  onTap: () => _save(context, provider),
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

  void _save(BuildContext context, SleepProvider provider) {
    final log = SleepLogModel(
      id: '',
      patientId: widget.patientId,
      routineId: widget.routineId,
      date: DateTime.now(),
      actualBedtime: _bedtime,
      actualWakeTime: _wakeTime,
      actualHours: double.parse(_hours.toStringAsFixed(1)),
      quality: _quality,
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      loggedAt: DateTime.now(),
    );
    provider.logSleep(
      context: context,
      log: log,
      onSuccess: () => Navigator.pop(context),
    );
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
                AppText(label, size: 10, color: AppColors.iconGrey),
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

class _QualitySelector extends StatelessWidget {
  final SleepQuality selected;
  final ValueChanged<SleepQuality> onSelect;

  const _QualitySelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final options = [
      (SleepQuality.excellent, 'Excellent', '😴', AppColors.successDark),
      (SleepQuality.good, 'Good', '🙂', AppColors.primary),
      (SleepQuality.fair, 'Fair', '😐', AppColors.amber),
      (SleepQuality.poor, 'Poor', '😫', AppColors.alert),
    ];
    return Row(
      children: options.map((o) {
        final isSelected = selected == o.$1;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(o.$1),
            child: Container(
              margin: EdgeInsets.only(
                right: o.$1 != SleepQuality.poor
                    ? SizeConfig.widthMultiplier * 1.5
                    : 0,
              ),
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.heightMultiplier * 1.1,
              ),
              decoration: BoxDecoration(
                color: isSelected ? o.$4 : AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isSelected ? o.$4 : AppColors.border),
              ),
              child: Column(
                children: [
                  Text(
                    o.$3,
                    style: TextStyle(fontSize: SizeConfig.widthMultiplier * 5),
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 0.3),
                  AppText(
                    o.$2,
                    size: 9,
                    color: isSelected ? Colors.white : AppColors.iconGrey,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    align: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
