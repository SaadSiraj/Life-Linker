// ── patient_base_nav.dart ─────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/core/widgets/exit_dialog.dart';
import 'package:lifelinker/provider/patient_base_nave.dart';
import 'package:lifelinker/view/patient/home/patient_home.dart';
import 'package:lifelinker/view/patient/patient%20base%20nav/components/nave_bar.dart';
import 'package:lifelinker/view/patient/patient%20profile/patien_profile.dart';
import 'package:lifelinker/view/patient/settings/patient_settings.dart';
import 'package:provider/provider.dart';

class PatientBaseView extends StatelessWidget {
  const PatientBaseView({super.key});

  static const List<Widget> _screens = [
    PatientHomeView(),
    PatientProfileView(),
    SettingsPlaceholderView(),
  ];

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
            bottomNavigationBar: const PatientNavBar(),
          ),
        );
      },
    );
  }
}
