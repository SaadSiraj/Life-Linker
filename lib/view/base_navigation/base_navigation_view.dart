import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/provider/base_navigation.dart';
import 'package:lifelinker/view/base_navigation/components/exit_dialog.dart';
import 'package:lifelinker/view/base_navigation/components/nave_bar.dart';
import 'package:lifelinker/view/dashboard/dashboard_view.dart';
import 'package:lifelinker/view/location/location_view.dart';
import 'package:lifelinker/view/medication/medication.dart';
import 'package:lifelinker/view/people_list/people_list_view.dart';
import 'package:lifelinker/view/profile/profile_view.dart';
import 'package:provider/provider.dart';

class BaseNavigationView extends StatelessWidget {
  const BaseNavigationView({super.key});

  static const List<Widget> _screens = [
    DashboardView(),
    LocationView(),
    MedicationView(),
    PeopleListView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BaseNavProvider>(
      builder: (context, provider, _) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            final shouldShowDialog = await provider.handleBackPress(context);
            if (!context.mounted) return;
            if (!shouldShowDialog) {
              _showExitSnackBar(context);
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
            bottomNavigationBar: const BaseNavBar(),
          ),
        );
      },
    );
  }

  void _showExitSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: AppColors.primary,
              size: SizeConfig.widthMultiplier * 5,
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 3),
            const Expanded(
              child: Text(
                'Press back again to exit',
                style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.textDark,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(SizeConfig.widthMultiplier * 4),
      ),
    );
  }
}
