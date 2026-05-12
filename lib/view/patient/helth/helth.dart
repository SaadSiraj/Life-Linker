import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/health.dart';
import 'package:lifelinker/view/patient/helth/component/helth_card.dart';
import 'package:lifelinker/view/patient/helth/component/vital_banner.dart';
import 'package:provider/provider.dart';

class PatientHealthView extends StatelessWidget {
  const PatientHealthView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _HealthHeader(),
          const Expanded(child: PatientHealthBody()),
        ],
      ),
    );
  }
}

class _HealthHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.alert.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.favorite_rounded,
                    color: AppColors.alert,
                    size: SizeConfig.widthMultiplier * 5.5),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              AppText('My Health',
                  size: 18,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientHealthBody extends StatelessWidget {
  const PatientHealthBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (provider.records.isEmpty) {
          return _buildEmpty();
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
          child: Column(
            children: [
              if (provider.latest != null)
                PatientVitalsBanner(record: provider.latest!),
              SizedBox(height: SizeConfig.heightMultiplier * 2),
              ...provider.records.map((r) => Padding(
                    padding: EdgeInsets.only(
                        bottom: SizeConfig.heightMultiplier * 1.5),
                    child: PatientHealthCard(record: r),
                  )),
              SizedBox(height: SizeConfig.heightMultiplier * 3),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.monitor_heart_outlined,
              size: SizeConfig.widthMultiplier * 18,
              color: AppColors.iconGrey),
          SizedBox(height: SizeConfig.heightMultiplier * 2),
          AppText('No Health Records Yet',
              size: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          AppText('Your caregiver will log\nyour health readings here.',
              size: 13, color: AppColors.iconGrey, align: TextAlign.center),
        ],
      ),
    );
  }
}