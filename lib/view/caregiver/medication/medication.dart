import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_utils.dart';
import 'package:lifelinker/provider/medication.dart';
import 'package:lifelinker/view/caregiver/add%20medication/add_medication.dart';
import 'package:lifelinker/view/caregiver/medication/components/card.dart';
import 'package:lifelinker/view/caregiver/medication/components/header.dart';
import 'package:lifelinker/view/caregiver/medication/components/last_week_logs.dart';
import 'package:provider/provider.dart';

class MedicationView extends StatelessWidget {
  const MedicationView({super.key});

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
      body: SafeArea(
        child: Column(
          children: [
            const MedicationHeader(),
            Expanded(
              child: Consumer<MedicationProvider>(
                builder: (context, provider, _) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap.v(8),
                        ...provider.medications.map(
                          (med) => MedCard(medication: med),
                        ),
                        Gap.v(20),
                        LastWeekLogs(
                          logs: provider.weekLogs,
                          adherenceLabel: provider.adherenceLabel,
                        ),
                        Gap.v(24),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMedicationView()),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }
}
