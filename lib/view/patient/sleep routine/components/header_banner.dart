import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/sleep_routine.dart';

class PatientSleepHeaderBanner extends StatelessWidget {
  final SleepRoutineModel routine;
  final double avgHours;

  const PatientSleepHeaderBanner({
    super.key,
    required this.routine,
    required this.avgHours,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (avgHours / routine.targetHours).clamp(0.0, 1.0);
    final isOnTrack = avgHours >= routine.targetHours * 0.8;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOnTrack
              ? [
                  AppColors.medicationViolet,
                  AppColors.medicationViolet.withOpacity(0.7),
                ]
              : [const Color(0xFF5B4FCF), const Color(0xFF7B61FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isOnTrack ? Icons.check_circle_rounded : Icons.info_rounded,
                color: Colors.white,
                size: SizeConfig.widthMultiplier * 5.5,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
              Expanded(
                child: AppText(
                  isOnTrack ? 'Great Sleep Pattern!' : 'Needs Improvement',
                  size: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stat(
                label: 'Bedtime',
                value: routine.bedtime,
                icon: Icons.bedtime_outlined,
              ),
              _Stat(
                label: 'Wake Up',
                value: routine.wakeTime,
                icon: Icons.wb_sunny_outlined,
              ),
              _Stat(
                label: 'Target',
                value: '${routine.targetHours}h',
                icon: Icons.timer_outlined,
              ),
              _Stat(
                label: 'Avg',
                value: '${avgHours.toStringAsFixed(1)}h',
                icon: Icons.bar_chart_rounded,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: SizeConfig.heightMultiplier * 0.8,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 0.5),
          AppText(
            '${(progress * 100).toInt()}% of target achieved this week',
            size: 10,
            color: Colors.white.withOpacity(0.85),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _Stat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: SizeConfig.widthMultiplier * 4,
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 0.3),
        AppText(
          value,
          size: 13,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        AppText(label, size: 9, color: Colors.white.withOpacity(0.75)),
      ],
    );
  }
}
