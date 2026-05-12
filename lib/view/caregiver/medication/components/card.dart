import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/medication_scheduled.dart';

class CaregiverMedCard extends StatelessWidget {
  final MedicationScheduleModel medication;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CaregiverMedCard({
    super.key,
    required this.medication,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 11,
                height: SizeConfig.widthMultiplier * 11,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: AppColors.primary,
                  size: SizeConfig.widthMultiplier * 6,
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      medication.name,
                      size: 15,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: SizeConfig.heightMultiplier * 0.3),
                    AppText(
                      medication.dosage,
                      size: 12,
                      color: AppColors.iconGrey,
                    ),
                  ],
                ),
              ),
              _FrequencyChip(frequency: medication.frequency),
            ],
          ),
          if (medication.times.isNotEmpty) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 1.5),
            Divider(color: AppColors.divider, height: 1),
            SizedBox(height: SizeConfig.heightMultiplier * 1.5),
            Wrap(
              spacing: SizeConfig.widthMultiplier * 2,
              runSpacing: SizeConfig.heightMultiplier * 0.8,
              children: medication.times
                  .map((t) => _TimeChip(time: t))
                  .toList(),
            ),
          ],
          if (medication.notes != null && medication.notes!.isNotEmpty) ...[
            SizedBox(height: SizeConfig.heightMultiplier * 1),
            Row(
              children: [
                Icon(
                  Icons.notes_rounded,
                  size: SizeConfig.widthMultiplier * 4,
                  color: AppColors.iconGrey,
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 1.5),
                Expanded(
                  child: AppText(
                    medication.notes!,
                    size: 11,
                    color: AppColors.iconGrey,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _ActionBtn(
                icon: Icons.edit_rounded,
                label: 'Edit',
                color: AppColors.primary,
                onTap: onEdit,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              _ActionBtn(
                icon: Icons.delete_outline_rounded,
                label: 'Remove',
                color: AppColors.alert,
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FrequencyChip extends StatelessWidget {
  final MedicationFrequency frequency;

  const _FrequencyChip({required this.frequency});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (frequency) {
      case MedicationFrequency.daily:
        color = AppColors.primary;
        break;
      case MedicationFrequency.weekly:
        color = AppColors.purple;
        break;
      case MedicationFrequency.asNeeded:
        color = AppColors.amber;
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 2.5,
        vertical: SizeConfig.heightMultiplier * 0.4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        frequency == MedicationFrequency.daily
            ? 'Daily'
            : frequency == MedicationFrequency.weekly
                ? 'Weekly'
                : 'As Needed',
        size: 10,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String time;

  const _TimeChip({required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 2.5,
        vertical: SizeConfig.heightMultiplier * 0.4,
      ),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.successDark.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: SizeConfig.widthMultiplier * 3,
            color: AppColors.successDark,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 1),
          AppText(
            time,
            size: 11,
            color: AppColors.successDark,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.widthMultiplier * 3,
          vertical: SizeConfig.heightMultiplier * 0.7,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: SizeConfig.widthMultiplier * 3.5, color: color),
            SizedBox(width: SizeConfig.widthMultiplier * 1),
            AppText(label, size: 11, color: color, fontWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }
}