import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/dite_plan.dart';
import 'package:lifelinker/view/patient/dite/components/dite_card.dart';
import 'package:lifelinker/view/patient/dite/components/dite_summary.dart';
import 'package:lifelinker/view/patient/dite/components/empty.dart';
import 'package:provider/provider.dart';

class PatientDietView extends StatefulWidget {
  const PatientDietView({super.key});

  @override
  State<PatientDietView> createState() => _PatientDietViewState();
}

class _PatientDietViewState extends State<PatientDietView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final patientId = SharedPrefsService.getUID();
      if (patientId != null) {
        context.read<DietPlanProvider>().initialize(patientId);
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
            child: Consumer<DietPlanProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (provider.plans.isEmpty) {
                  return const PatientDietEmpty();
                }
                return SingleChildScrollView(
                  padding:
                      EdgeInsets.all(SizeConfig.widthMultiplier * 4),
                  child: Column(
                    children: [
                      PatientDietSummary(plan: provider.activePlan!),
                      SizedBox(height: SizeConfig.heightMultiplier * 2),
                      ...provider.plans.map(
                        (plan) => Padding(
                          padding: EdgeInsets.only(
                              bottom: SizeConfig.heightMultiplier * 1.5),
                          child: PatientDietCard(plan: plan),
                        ),
                      ),
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
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppColors.successDark,
                  size: SizeConfig.widthMultiplier * 5.5,
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'My Diet Plan',
                    size: 18,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                  AppText(
                    "Assigned by your caregiver",
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
}