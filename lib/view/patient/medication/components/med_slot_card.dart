import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/medication_log.dart';
import 'package:lifelinker/model/medication_scheduled.dart';

class PatientMedSlotCard extends StatelessWidget {
  final MedicationScheduleModel medication;
  final String time;
  final MedicationLogModel? log;
  final ValueChanged<MedicationStatus> onMark;

  const PatientMedSlotCard({
    super.key,
    required this.medication,
    required this.time,
    required this.log,
    required this.onMark,
  });

  @override
  Widget build(BuildContext context) {
    final status = log?.status ?? MedicationStatus.pending;
    final isTaken = status == MedicationStatus.taken;
    final isMissed = status == MedicationStatus.missed;
    final isSkipped = status == MedicationStatus.skipped;

    Color borderColor = AppColors.border;
    Color bgColor = Colors.white;
    if (isTaken) {
      borderColor = AppColors.successDark.withOpacity(0.3);
      bgColor = AppColors.successLight;
    } else if (isMissed) {
      borderColor = AppColors.alert.withOpacity(0.3);
      bgColor = AppColors.alertLight;
    }

    return Container(
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatusIcon(status: status),
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
                AppText(medication.dosage, size: 12, color: AppColors.iconGrey),
                if (time.isNotEmpty) ...[
                  SizedBox(height: SizeConfig.heightMultiplier * 0.5),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: SizeConfig.widthMultiplier * 3.5,
                        color: AppColors.iconGrey,
                      ),
                      SizedBox(width: SizeConfig.widthMultiplier * 1),
                      AppText(time, size: 12, color: AppColors.iconGrey),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (status == MedicationStatus.pending)
            _ActionButtons(onMark: onMark)
          else
            _StatusLabel(status: status),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final MedicationStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (status) {
      case MedicationStatus.taken:
        icon = Icons.check_circle_rounded;
        color = AppColors.successDark;
        break;
      case MedicationStatus.missed:
        icon = Icons.cancel_rounded;
        color = AppColors.alert;
        break;
      case MedicationStatus.skipped:
        icon = Icons.remove_circle_rounded;
        color = AppColors.amber;
        break;
      default:
        icon = Icons.radio_button_unchecked_rounded;
        color = AppColors.iconGrey;
    }
    return Icon(icon, size: SizeConfig.widthMultiplier * 8, color: color);
  }
}

class _ActionButtons extends StatelessWidget {
  final ValueChanged<MedicationStatus> onMark;

  const _ActionButtons({required this.onMark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ActionBtn(
          icon: Icons.check_rounded,
          color: AppColors.successDark,
          onTap: () => onMark(MedicationStatus.taken),
        ),
        SizedBox(width: SizeConfig.widthMultiplier * 1.5),
        _ActionBtn(
          icon: Icons.close_rounded,
          color: AppColors.alert,
          onTap: () => onMark(MedicationStatus.missed),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeConfig.widthMultiplier * 9,
        height: SizeConfig.widthMultiplier * 9,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: SizeConfig.widthMultiplier * 5),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final MedicationStatus status;

  const _StatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    switch (status) {
      case MedicationStatus.taken:
        label = 'Taken';
        color = AppColors.successDark;
        break;
      case MedicationStatus.missed:
        label = 'Missed';
        color = AppColors.alert;
        break;
      case MedicationStatus.skipped:
        label = 'Skipped';
        color = AppColors.amber;
        break;
      default:
        label = 'Pending';
        color = AppColors.iconGrey;
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
        label,
        size: 11,
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
