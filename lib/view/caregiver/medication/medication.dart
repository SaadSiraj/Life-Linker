import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/medication_scheduled.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/medication.dart';
import 'package:lifelinker/view/caregiver/medication/components/card.dart';
import 'package:lifelinker/view/caregiver/medication/components/empty.dart';
import 'package:lifelinker/view/caregiver/medication/components/fomr_sheet.dart';
import 'package:provider/provider.dart';

class CaregiverMedicationView extends StatefulWidget {
  final UserModel patient;

  const CaregiverMedicationView({super.key, required this.patient});

  @override
  State<CaregiverMedicationView> createState() =>
      _CaregiverMedicationViewState();
}

class _CaregiverMedicationViewState extends State<CaregiverMedicationView> {
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
      context.read<MedicationProvider>().initialize(widget.patient.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Consumer<MedicationProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (provider.medications.isEmpty) {
                  return const CaregiverMedEmpty();
                }
                return RefreshIndicator(
                  onRefresh: () async =>
                      provider.initialize(widget.patient.uid),
                  color: AppColors.primary,
                  child: ListView.separated(
                    padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
                    itemCount: provider.medications.length,
                    separatorBuilder: (_, _) =>
                        SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                    itemBuilder: (context, index) {
                      final med = provider.medications[index];
                      return CaregiverMedCard(
                        medication: med,
                        onEdit: () => _showForm(context, existing: med),
                        onDelete: () => _confirmDelete(context, provider, med),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: AppText(
          'Add Medication',
          size: 13,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 4,
            vertical: SizeConfig.heightMultiplier * 1.5,
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: SizeConfig.widthMultiplier * 10,
                  height: SizeConfig.widthMultiplier * 10,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: SizeConfig.widthMultiplier * 4,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'Medications',
                      size: 18,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                    AppText(
                      widget.patient.name,
                      size: 12,
                      color: AppColors.iconGrey,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showForm(BuildContext context, {MedicationScheduleModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MedFormSheet(patient: widget.patient, existing: existing),
    );
  }

  void _confirmDelete(
    BuildContext context,
    MedicationProvider provider,
    MedicationScheduleModel med,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText(
          'Remove Medication',
          size: 16,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        content: AppText(
          'Are you sure you want to remove "${med.name}"?',
          size: 13,
          color: AppColors.iconGrey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText('Cancel', size: 13, color: AppColors.iconGrey),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteMedication(context: context, medicationId: med.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alert,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: AppText(
              'Remove',
              size: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
