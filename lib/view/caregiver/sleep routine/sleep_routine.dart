import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/sleep_provider.dart';
import 'package:lifelinker/view/caregiver/sleep%20routine/component/card.dart';
import 'package:lifelinker/view/caregiver/sleep%20routine/component/empty.dart';
import 'package:lifelinker/view/caregiver/sleep%20routine/component/form_sheet.dart';
import 'package:lifelinker/view/caregiver/sleep%20routine/component/sleep_log_section.dart';
import 'package:provider/provider.dart';

class CaregiverSleepView extends StatefulWidget {
  final UserModel patient;

  const CaregiverSleepView({super.key, required this.patient});

  @override
  State<CaregiverSleepView> createState() => _CaregiverSleepViewState();
}

class _CaregiverSleepViewState extends State<CaregiverSleepView> {
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
      context.read<SleepProvider>().initialize(widget.patient.uid);
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
            child: Consumer<SleepProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (provider.routines.isEmpty) {
                  return const CaregiverSleepEmpty();
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async =>
                      provider.initialize(widget.patient.uid),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...provider.routines.map(
                          (routine) => Padding(
                            padding: EdgeInsets.only(
                              bottom: SizeConfig.heightMultiplier * 1.5,
                            ),
                            child: CaregiverSleepRoutineCard(
                              routine: routine,
                              onEdit: () =>
                                  _showForm(context, existing: routine),
                              onDelete: () =>
                                  _confirmDelete(context, provider, routine.id),
                            ),
                          ),
                        ),
                        if (provider.logs.isNotEmpty) ...[
                          SizedBox(height: SizeConfig.heightMultiplier * 1),
                          CaregiverSleepLogsSection(logs: provider.logs),
                        ],
                        SizedBox(height: SizeConfig.heightMultiplier * 8),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(context),
        backgroundColor: AppColors.medicationViolet,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: AppText(
          'Add Routine',
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
                      'Sleep Routine',
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

  void _showForm(BuildContext context, {dynamic existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          SleepRoutineFormSheet(patient: widget.patient, existing: existing),
    );
  }

  void _confirmDelete(
    BuildContext context,
    SleepProvider provider,
    String routineId,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppText(
          'Remove Routine',
          size: 16,
          color: AppColors.textDark,
          fontWeight: FontWeight.w700,
        ),
        content: AppText(
          'Are you sure you want to remove this sleep routine?',
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
              provider.deleteRoutine(context: context, routineId: routineId);
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
