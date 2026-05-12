import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/dite_plan.dart';
import 'package:lifelinker/provider/sleep_provider.dart';
import 'package:lifelinker/view/patient/dite/components/dite_card.dart';
import 'package:lifelinker/view/patient/dite/components/dite_summary.dart';
import 'package:lifelinker/view/patient/dite/components/empty.dart';
import 'package:lifelinker/view/patient/sleep%20routine/components/empty.dart';
import 'package:lifelinker/view/patient/sleep%20routine/components/header_banner.dart';
import 'package:lifelinker/view/patient/sleep%20routine/components/sleep_log_form.dart';
import 'package:lifelinker/view/patient/sleep%20routine/components/sleep_tile.dart';
import 'package:lifelinker/view/patient/sleep%20routine/components/week_chart.dart';
import 'package:provider/provider.dart';

class PatientDietSleepView extends StatefulWidget {
  const PatientDietSleepView({super.key});

  @override
  State<PatientDietSleepView> createState() => _PatientDietSleepViewState();
}

class _PatientDietSleepViewState extends State<PatientDietSleepView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });

    // Dono providers initialize karo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientId = SharedPrefsService.getUID();
      if (patientId != null) {
        context.read<DietPlanProvider>().initialize(patientId);
        context.read<SleepProvider>().initialize(patientId);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const _DietBody(),
                _SleepBody(onLogSleep: _showLogForm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isDiet = _tabController.index == 0;

    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Title row
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.widthMultiplier * 4,
                right: SizeConfig.widthMultiplier * 4,
                top: SizeConfig.heightMultiplier * 1.8,
                bottom: SizeConfig.heightMultiplier * 0.5,
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: SizeConfig.widthMultiplier * 10,
                    height: SizeConfig.widthMultiplier * 10,
                    decoration: BoxDecoration(
                      color: isDiet
                          ? AppColors.successLight
                          : AppColors.medicationViolet.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        isDiet
                            ? Icons.restaurant_menu_rounded
                            : Icons.bedtime_rounded,
                        key: ValueKey(isDiet),
                        color: isDiet
                            ? AppColors.successDark
                            : AppColors.medicationViolet,
                        size: SizeConfig.widthMultiplier * 5.5,
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.widthMultiplier * 3),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Column(
                      key: ValueKey(isDiet),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          isDiet ? 'My Diet Plan' : 'Sleep Routine',
                          size: 18,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w700,
                        ),
                        AppText(
                          isDiet
                              ? 'Assigned by your caregiver'
                              : 'Track your sleep daily',
                          size: 12,
                          color: AppColors.iconGrey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab selector
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 4,
                vertical: SizeConfig.heightMultiplier * 1,
              ),
              child: Container(
                height: SizeConfig.heightMultiplier * 5.5,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  tabs: [
                    _TabItem(
                      icon: Icons.restaurant_menu_rounded,
                      label: 'Diet',
                      activeColor: AppColors.successDark,
                      isActive: _tabController.index == 0,
                    ),
                    _TabItem(
                      icon: Icons.bedtime_rounded,
                      label: 'Sleep',
                      activeColor: AppColors.medicationViolet,
                      isActive: _tabController.index == 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogForm(BuildContext ctx, String routineId) {
    final patientId = SharedPrefsService.getUID() ?? '';
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          PatientSleepLogForm(patientId: patientId, routineId: routineId),
    );
  }
}

// ── Tab Item ─────────────────────────────────────────────────────────────────

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color activeColor;
  final bool isActive;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.activeColor,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: SizeConfig.heightMultiplier * 5.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: SizeConfig.widthMultiplier * 4.5,
            color: isActive ? activeColor : AppColors.iconGrey,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 1.5),
          AppText(
            label,
            size: 13,
            color: isActive ? activeColor : AppColors.iconGrey,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ],
      ),
    );
  }
}

// ── Diet Body ─────────────────────────────────────────────────────────────────

class _DietBody extends StatelessWidget {
  const _DietBody();

  @override
  Widget build(BuildContext context) {
    return Consumer<DietPlanProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (provider.plans.isEmpty) {
          return const PatientDietEmpty();
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
          child: Column(
            children: [
              PatientDietSummary(plan: provider.activePlan!),
              SizedBox(height: SizeConfig.heightMultiplier * 2),
              ...provider.plans.map(
                (plan) => Padding(
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.heightMultiplier * 1.5,
                  ),
                  child: PatientDietCard(plan: plan),
                ),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 3),
            ],
          ),
        );
      },
    );
  }
}

// ── Sleep Body ────────────────────────────────────────────────────────────────

class _SleepBody extends StatelessWidget {
  final void Function(BuildContext ctx, String routineId) onLogSleep;

  const _SleepBody({required this.onLogSleep});

  @override
  Widget build(BuildContext context) {
    return Consumer<SleepProvider>(
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
                    onLogSleep: () => onLogSleep(context, routine.id),
                  ),
                );
              }),
              SizedBox(height: SizeConfig.heightMultiplier * 3),
            ],
          ),
        );
      },
    );
  }
}
