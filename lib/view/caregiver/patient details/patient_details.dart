import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/routes/app_router.dart';
import 'package:lifelinker/core/routes/routes_name.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/core/widgets/custom_button.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/view/caregiver/add%20edit%20patient/add_edit_patient.dart';

class PatientDetailsView extends StatefulWidget {
  final UserModel patient;
  const PatientDetailsView({super.key, required this.patient});

  @override
  State<PatientDetailsView> createState() => _PatientDetailsViewState();
}

class _PatientDetailsViewState extends State<PatientDetailsView> {
  late UserModel _patient;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
              child: Column(
                children: [
                  _buildProfileCard(),
                  SizedBox(height: SizeConfig.heightMultiplier * 2),
                  _buildDetailCard(
                    'Medical Information',
                    Icons.medical_information_outlined,
                    AppColors.purple,
                    AppColors.purpleLight,
                    [
                      _DetailRow(
                        icon: Icons.sick_outlined,
                        label: 'Condition',
                        value: _patient.condition ?? 'Not specified',
                      ),
                      _DetailRow(
                        icon: Icons.bloodtype_outlined,
                        label: 'Blood Group',
                        value: _patient.bloodGroup ?? 'Not specified',
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 2),
                  _buildDetailCard(
                    'Contact Information',
                    Icons.contact_phone_outlined,
                    AppColors.successDark,
                    AppColors.successLight,
                    [
                      _DetailRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: _patient.phone ?? 'Not specified',
                      ),
                      _DetailRow(
                        icon: Icons.emergency_outlined,
                        label: 'Emergency',
                        value: _patient.emergencyContact ?? 'Not specified',
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 2),
                  _buildDetailCard(
                    'Personal Details',
                    Icons.person_outline_rounded,
                    AppColors.blue,
                    AppColors.blueLight,
                    [
                      _DetailRow(
                        icon: Icons.cake_outlined,
                        label: 'Date of Birth',
                        value: _patient.dob ?? 'Not specified',
                      ),
                      _DetailRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: _patient.email.isEmpty
                            ? 'Not specified'
                            : _patient.email,
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 3),
                  CustomButton(
                    text: 'Edit Patient Details',
                    prefixIcon: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: SizeConfig.widthMultiplier * 5,
                    ),
                    onTap: _openEdit,
                  ),
                  SizedBox(height: SizeConfig.heightMultiplier * 2),
                ],
              ),
            ),
          ),
          // Monitor button - CaregiverMonitorView navigate karne ke liye
          CustomButton(
            text: 'Monitor Live',
            backgroundColor: AppColors.successDark,
            prefixIcon: Icon(
              Icons.videocam_rounded,
              color: Colors.white,
              size: SizeConfig.widthMultiplier * 5,
            ),
            onTap: () => AppRouter.push(
              context,
              RouteNames.caregiverMonitor,
              arguments: {
                'patient': _patient,
                'caregiverId': SharedPrefsService.getUID() ?? '',
              },
            ),
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 2),
        ],
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
                onTap: () => Navigator.pop(context, _patient),
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
              AppText(
                'Patient Details',
                size: 18,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.widthMultiplier * 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: SizeConfig.widthMultiplier * 22,
            height: SizeConfig.widthMultiplier * 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.1),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
              image: _patient.profileImageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(_patient.profileImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _patient.profileImageUrl == null
                ? Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                    size: SizeConfig.widthMultiplier * 12,
                  )
                : null,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          AppText(
            _patient.name,
            size: 20,
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 0.5),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.widthMultiplier * 3,
              vertical: SizeConfig.heightMultiplier * 0.4,
            ),
            decoration: BoxDecoration(
              color: AppColors.purpleLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: AppText(
              'Patient',
              size: 12,
              color: AppColors.purple,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    String title,
    IconData icon,
    Color iconColor,
    Color iconBg,
    List<Widget> rows,
  ) {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: SizeConfig.widthMultiplier * 8,
                height: SizeConfig.widthMultiplier * 8,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: SizeConfig.widthMultiplier * 4.5,
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 2.5),
              AppText(
                title,
                size: 13,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          SizedBox(height: SizeConfig.heightMultiplier * 1.5),
          ...rows,
        ],
      ),
    );
  }

  void _openEdit() async {
    final updated = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditPatientView(existingPatient: _patient),
      ),
    );
    if (updated != null) {
      setState(() => _patient = updated);
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 1.2),
      child: Row(
        children: [
          Icon(
            icon,
            size: SizeConfig.widthMultiplier * 4.5,
            color: AppColors.iconGrey,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 3),
          AppText(
            '$label:',
            size: 12,
            color: AppColors.iconGrey,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 2),
          Expanded(
            child: AppText(
              value,
              size: 13,
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
