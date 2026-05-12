import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/provider/health.dart';
import 'package:lifelinker/view/caregiver/health_monitoring/components/form_sheet.dart';
import 'package:lifelinker/view/caregiver/health_monitoring/components/record_card.dart';
import 'package:lifelinker/view/caregiver/health_monitoring/components/state_row.dart';
import 'package:provider/provider.dart';

class CaregiverHealthView extends StatefulWidget {
  final UserModel patient;
  const CaregiverHealthView({super.key, required this.patient});

  @override
  State<CaregiverHealthView> createState() => _CaregiverHealthViewState();
}

class _CaregiverHealthViewState extends State<CaregiverHealthView> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthProvider>().initialize(widget.patient.uid);
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
            child: Consumer<HealthProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary));
                }
                return SingleChildScrollView(
                  padding: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
                  child: Column(
                    children: [
                      if (provider.latest != null) ...[
                        HealthStatsRow(record: provider.latest!),
                        SizedBox(height: SizeConfig.heightMultiplier * 2),
                      ],
                      if (provider.records.isEmpty)
                        _buildEmpty()
                      else
                        ...provider.records.map((r) => Padding(
                              padding: EdgeInsets.only(
                                  bottom: SizeConfig.heightMultiplier * 1.5),
                              child: HealthRecordCard(
                                record: r,
                                onDelete: () =>
                                    provider.deleteRecord(context, r.id),
                              ),
                            )),
                      SizedBox(height: SizeConfig.heightMultiplier * 8),
                    ],
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
        label: AppText('Add Reading', size: 13,
            color: Colors.white, fontWeight: FontWeight.w600),
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
                  child: Icon(Icons.arrow_back_ios_new_rounded,
                      size: SizeConfig.widthMultiplier * 4,
                      color: AppColors.textDark),
                ),
              ),
              SizedBox(width: SizeConfig.widthMultiplier * 3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText('Health Records', size: 18,
                        color: AppColors.textDark, fontWeight: FontWeight.w700),
                    AppText(widget.patient.name, size: 12,
                        color: AppColors.iconGrey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: SizeConfig.heightMultiplier * 5),
          Icon(Icons.monitor_heart_outlined,
              size: SizeConfig.widthMultiplier * 18,
              color: AppColors.iconGrey),
          SizedBox(height: SizeConfig.heightMultiplier * 2),
          AppText('No Health Records', size: 16,
              color: AppColors.textDark, fontWeight: FontWeight.w600),
          SizedBox(height: SizeConfig.heightMultiplier * 1),
          AppText('Tap + to add the first reading', size: 13,
              color: AppColors.iconGrey, align: TextAlign.center),
        ],
      ),
    );
  }

  void _showForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecordFormSheet(patient: widget.patient),
    );
  }
}