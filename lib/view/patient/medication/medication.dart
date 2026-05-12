import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/medication_scheduled.dart';
import 'package:lifelinker/provider/medication.dart';
import 'package:lifelinker/view/patient/medication/components/med_slot_card.dart';
import 'package:lifelinker/view/patient/medication/components/med_summary.dart';
import 'package:provider/provider.dart';

/// Standalone screen (direct route use ke liye)
class PatientMedicationView extends StatelessWidget {
  const PatientMedicationView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _MedicationHeader(),
          const Expanded(child: PatientMedicationBody()),
        ],
      ),
    );
  }
}

class _MedicationHeader extends StatelessWidget {
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
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: AppColors.primary,
                  size: SizeConfig.widthMultiplier * 5.5,
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'My Medications',
                    size: 18,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                  ),
                  AppText(
                    "Today's Schedule",
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

class PatientMedicationBody extends StatelessWidget {
  const PatientMedicationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicationProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (provider.medications.isEmpty) {
          return _buildEmpty();
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
          child: Column(
            children: [
              PatientMedSummaryBar(
                adherenceRate: provider.todayAdherenceRate,
                totalMeds: provider.medications.length,
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 2),
              ...provider.medications.map(
                (med) => _buildMedSection(context, provider, med),
              ),
              SizedBox(height: SizeConfig.heightMultiplier * 3),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMedSection(
    BuildContext context,
    MedicationProvider provider,
    MedicationScheduleModel med,
  ) {
    if (med.times.isEmpty) {
      return PatientMedSlotCard(
        medication: med,
        time: '',
        log: provider.getLogForSlot(med.id, ''),
        onMark: (status) => provider.markMedication(
          context: context,
          medication: med,
          time: '',
          status: status,
        ),
      );
    }
    return Column(
      children: med.times
          .map(
            (t) => Padding(
              padding: EdgeInsets.only(
                bottom: SizeConfig.heightMultiplier * 1.5,
              ),
              child: PatientMedSlotCard(
                medication: med,
                time: t,
                log: provider.getLogForSlot(med.id, t),
                onMark: (status) => provider.markMedication(
                  context: context,
                  medication: med,
                  time: t,
                  status: status,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medication_outlined,
            size: SizeConfig.widthMultiplier * 18,
            color: AppColors.iconGrey,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 2),
          AppText(
            'No Medications Assigned',
            size: 16,
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          AppText(
            'Your caregiver will add your\nmedications here.',
            size: 13,
            color: AppColors.iconGrey,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}