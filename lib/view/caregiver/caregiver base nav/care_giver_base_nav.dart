import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/widgets/custom_snackbar.dart';
import 'package:lifelinker/core/widgets/exit_dialog.dart';
import 'package:lifelinker/provider/caregiver_base_nav.dart';
import 'package:lifelinker/view/caregiver/caregiver%20base%20nav/components/nave_bar.dart';
import 'package:lifelinker/view/caregiver/dashboard/dashboard_view.dart';
import 'package:lifelinker/view/caregiver/pateints%20list/pateints_list.dart';
import 'package:lifelinker/view/caregiver/profile/caregiver_profile.dart';
import 'package:lifelinker/view/common/location/location_view.dart';
import 'package:provider/provider.dart';

class CaregiverBaseView extends StatelessWidget {
  const CaregiverBaseView({super.key});

  // Index: 0=Home, 1=Location, 2=Patients, 3=Profile
  // Center button (index 2 in navbar) maps to Patients
  static const List<Widget> _screens = [
    PatientsListView(),  // index 2 — center button

    // DashboardView(),     // index 0
    LocationView(),      // index 1
    CaregiverProfileView(), // index 3 — but navbar shows as index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CareGiverBaseNavProvider>(
      builder: (context, provider, _) {
     
        final screenIndex = provider.screenIndex;

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
            body: _screens[screenIndex],
            bottomNavigationBar: const CaregiverNavBar(),
          ),
        );
      },
    );
  }
}