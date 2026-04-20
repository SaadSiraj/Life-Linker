import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/health_data.dart';
import 'package:lifelinker/view/health_monitoring/components/activity_card.dart';
import 'package:lifelinker/view/health_monitoring/components/app_bar.dart';
import 'package:lifelinker/view/health_monitoring/components/heart_rate_card.dart';
import 'package:lifelinker/view/health_monitoring/components/sleep_card.dart';
import 'package:lifelinker/view/health_monitoring/components/steps_card.dart';
import 'package:lifelinker/view/health_monitoring/components/weekly_overview.dart';
import 'package:provider/provider.dart';

class HealthDataView extends StatelessWidget {
  const HealthDataView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const HealthAppBar(),
          Expanded(
            child: Consumer<HealthDataProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (provider.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_off_rounded,
                          size: 48.h,
                          color: AppColors.iconGrey,
                        ),
                        Gap.v(12),
                        AppText(
                          'Could not load health data',
                          size: 15,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                        Gap.v(12),
                        ElevatedButton(
                          onPressed: provider.refresh,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: AppText(
                            'Retry',
                            size: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final data = provider.data!;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    children: [
                      StepsCard(steps: data.steps),
                      Gap.v(14),
                      HeartRateCard(heartRate: data.heartRate),
                      Gap.v(14),
                      SleepCard(sleep: data.sleep),
                      Gap.v(14),
                      ActivityCard(activity: data.activity),
                      Gap.v(14),
                      WeeklyOverviewCard(weeklyData: data.weeklyData),
                      Gap.v(24),
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
}
