import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/sleep_provider.dart';
import 'package:lifelinker/view/patient/sleep%20routine/components/empty.dart';
import 'package:lifelinker/view/patient/sleep%20routine/components/header_banner.dart';
import 'package:lifelinker/view/patient/sleep%20routine/components/sleep_log_form.dart';
import 'package:lifelinker/view/patient/sleep%20routine/components/sleep_tile.dart';
import 'package:lifelinker/view/patient/sleep%20routine/components/week_chart.dart';
import 'package:provider/provider.dart';

class PatientSleepView extends StatefulWidget {
  const PatientSleepView({super.key});

  @override
  State<PatientSleepView> createState() => _PatientSleepViewState();
}

class _PatientSleepViewState extends State<PatientSleepView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientId = SharedPrefsService.getUID();
      if (patientId != null) {
        context.read<SleepProvider>().initialize(patientId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Consumer<SleepProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (provider.routines.isEmpty) {
                  return const PatientSleepEmpty();
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
                  child: Column(
                    children: [
                      PatientSleepHeaderBanner(
                        routine: provider.activeRoutine!,
                        avgHours: provider.weeklyAvgHours,
                      ),
                      SizedBox(height: SizeConfig.heightMultiplier * 2),
                      if (provider.logs.isNotEmpty) ...[
                        PatientSleepWeekChart(logs: provider.logs),
                        SizedBox(height: SizeConfig.heightMultiplier * 2),
                      ],
                      ...provider.routines.map((routine) {
                        final todayLog = provider.getTodayLog(routine.id);
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: SizeConfig.heightMultiplier * 1.5,
                          ),
                          child: PatientSleepRoutineTile(
                            routine: routine,
                            todayLog: todayLog,
                            onLogSleep: () =>
                                _showLogForm(context, provider, routine.id),
                          ),
                        );
                      }),
                      SizedBox(height: SizeConfig.heightMultiplier * 3),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 4,
            vertical: SizeConfig.heightMultiplier * 2,
          ),
          child: Row(
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 10,
                height: SizeConfig.widthMultiplier * 10,
                decoration: BoxDecoration(
                  color: AppColors.medicationViolet.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.bedtime_rounded,
                  color: AppColors.medicationViolet,
                  size: SizeConfig.widthMultiplier * 5.5,
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Sleep Routine',
                    size: 18,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                  AppText(
                    'Track your sleep daily',
                    size: 12,
                    color: AppColors.iconGrey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogForm(
    BuildContext context,
    SleepProvider provider,
    String routineId,
  ) {
    final patientId = SharedPrefsService.getUID() ?? '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          PatientSleepLogForm(patientId: patientId, routineId: routineId),
    );
  }
}
