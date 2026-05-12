// ─────────────────────────────────────────────────────────────────────────────
// patient_base_nav.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/core/widgets/exit_dialog.dart';
import 'package:lifelinker/provider/health.dart';
import 'package:lifelinker/provider/medication.dart';
import 'package:lifelinker/provider/patient_base_nave.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:lifelinker/view/patient/dite%20and%20sleep/dite_and_sleep_view.dart';
import 'package:lifelinker/view/patient/home/patient_home.dart';
import 'package:lifelinker/view/patient/medicaion_and_health/medication_and_helth.dart';
import 'package:lifelinker/view/patient/patient%20base%20nav/components/nave_bar.dart';
import 'package:lifelinker/view/patient/patient%20profile/patien_profile.dart';
import 'package:provider/provider.dart';

class PatientBaseView extends StatefulWidget {
  const PatientBaseView({super.key});

  @override
  State<PatientBaseView> createState() => _PatientBaseViewState();
}

class _PatientBaseViewState extends State<PatientBaseView> {
  // index 0 → Home
  // index 1 → Medications + Health (combined)
  // index 2 → Diet + Sleep (combined)
  // index 3 → Profile
  static const List<Widget> _screens = [
    PatientHomeView(),
    PatientMedHealthView(),
    PatientDietSleepView(),
    PatientProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initProviders());
  }

  Future<void> _initProviders() async {
    final profileProvider = context.read<ProfileProvider>();
    if (profileProvider.user == null) {
      await profileProvider.loadProfile();
    }
    final patientId = SharedPrefsService.getUID();
    if (patientId != null && mounted) {
      context.read<MedicationProvider>().initialize(patientId);
      context.read<HealthProvider>().initialize(patientId);
      // DietPlanProvider & SleepProvider PatientDietSleepView ke initState mein initialize hote hain
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientNavProvider>(
      builder: (context, provider, _) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            final shouldShowDialog = await provider.handleBackPress(context);
            if (!context.mounted) return;
            if (!shouldShowDialog) {
              showCustomSnackbar(context, false, 'Press back again to exit');
            } else {
              final shouldExit = await ExitDialog.show(context);
              if (shouldExit == true && context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: _screens[provider.currentIndex],
            bottomNavigationBar:  PatientNavBar(),
          ),
        );
      },
    );
  }
}

