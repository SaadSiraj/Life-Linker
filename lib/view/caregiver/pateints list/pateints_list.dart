import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/caregiver_patient.dart';
import 'package:lifelinker/view/caregiver/add%20edit%20patient/add_edit_patient.dart';
import 'package:lifelinker/view/caregiver/patient%20details/patient_details.dart';
import 'package:provider/provider.dart';

class PatientsListView extends StatefulWidget {
  const PatientsListView({super.key});

  @override
  State<PatientsListView> createState() => _PatientsListViewState();
}

class _PatientsListViewState extends State<PatientsListView> {
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
      context.read<CaregiverPatientsProvider>().loadPatients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<CaregiverPatientsProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                _buildHeader(context),
                Expanded(child: _buildBody(context, provider)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        SizeConfig.widthMultiplier * 5,
        SizeConfig.heightMultiplier * 2,
        SizeConfig.widthMultiplier * 5,
        SizeConfig.heightMultiplier * 2,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'My Patients',
                  size: 22,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.3),
                AppText(
                  'Monitor and manage your patients',
                  size: 12,
                  color: AppColors.iconGrey,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(SizeConfig.widthMultiplier * 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.supervised_user_circle_rounded,
              color: AppColors.primary,
              size: SizeConfig.widthMultiplier * 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, CaregiverPatientsProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (provider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.iconGrey,
              size: SizeConfig.widthMultiplier * 15,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 2),
            AppText(
              'Failed to load patients',
              size: 14,
              color: AppColors.iconGrey,
            ),
            SizedBox(height: SizeConfig.heightMultiplier * 1.5),
            GestureDetector(
              onTap: provider.refresh,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 5,
                  vertical: SizeConfig.heightMultiplier * 1.2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AppText(
                  'Retry',
                  size: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (provider.patients.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: provider.refresh,
      color: AppColors.primary,
      child: ListView.separated(
        padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
        itemCount: provider.patients.length,
        separatorBuilder: (_, _) =>
            SizedBox(height: SizeConfig.heightMultiplier * 1.5),
        itemBuilder: (context, index) {
          final patient = provider.patients[index];
          return _PatientTile(
            patient: patient,
            onTap: () => _openPatientDetails(context, patient),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.widthMultiplier * 28,
            height: SizeConfig.widthMultiplier * 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add_alt_1_rounded,
              color: AppColors.primary,
              size: SizeConfig.widthMultiplier * 14,
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 2.5),
          AppText(
            'No Patients Yet',
            size: 18,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          AppText(
            'Add your first patient to start\nmonitoring their health',
            size: 13,
            color: AppColors.iconGrey,
            align: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 3),
          GestureDetector(
            onTap: () => _openAddPatient(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 8,
                vertical: SizeConfig.heightMultiplier * 1.8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_add_rounded,
                    color: Colors.white,
                    size: SizeConfig.widthMultiplier * 5,
                  ),
                  SizedBox(width: SizeConfig.widthMultiplier * 2),
                  AppText(
                    'Add Patient',
                    size: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _openAddPatient(context),
      backgroundColor: AppColors.primary,
      elevation: 4,
      icon: const Icon(Icons.person_add_rounded, color: Colors.white),
      label: AppText(
        'Add Patient',
        size: 14,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _openAddPatient(BuildContext context) async {
    final result = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddEditPatientView()),
    );
    if (result != null && context.mounted) {
      context.read<CaregiverPatientsProvider>().addPatientLocally(result);
    }
  }

  void _openPatientDetails(BuildContext context, UserModel patient) async {
    final updated = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(builder: (_) => PatientDetailsView(patient: patient)),
    );
    if (updated != null && context.mounted) {
      context.read<CaregiverPatientsProvider>().updatePatientLocally(updated);
    }
  }
}

class _PatientTile extends StatelessWidget {
  final UserModel patient;
  final VoidCallback onTap;

  const _PatientTile({required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            _buildAvatar(),
            SizedBox(width: SizeConfig.widthMultiplier * 3.5),
            Expanded(child: _buildInfo()),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.iconGrey,
              size: SizeConfig.widthMultiplier * 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: SizeConfig.widthMultiplier * 14,
      height: SizeConfig.widthMultiplier * 14,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.1),
        image: patient.profileImageUrl != null
            ? DecorationImage(
                image: NetworkImage(patient.profileImageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: patient.profileImageUrl == null
          ? Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: SizeConfig.widthMultiplier * 7,
            )
          : null,
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          patient.name,
          size: 15,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: SizeConfig.heightMultiplier * 0.4),
        if (patient.condition != null)
          AppText(
            patient.condition!,
            size: 12,
            color: AppColors.iconGrey,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        SizedBox(height: SizeConfig.heightMultiplier * 0.4),
        Row(
          children: [
            if (patient.bloodGroup != null) ...[
              _InfoChip(
                label: patient.bloodGroup!,
                color: AppColors.alertLight,
                textColor: AppColors.alert,
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2),
            ],
            if (patient.dob != null)
              _InfoChip(
                label: patient.dob!,
                color: AppColors.blueLight,
                textColor: AppColors.blue,
              ),
          ],
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _InfoChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 2,
        vertical: SizeConfig.heightMultiplier * 0.3,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: AppText(
        label,
        size: 10,
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
