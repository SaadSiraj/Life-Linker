import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/provider/location.dart';
import 'package:lifelinker/view/common/location/components/activity_health.dart';
import 'package:lifelinker/view/common/location/components/app_bar.dart';
import 'package:lifelinker/view/common/location/components/call_row.dart';
import 'package:lifelinker/view/common/location/components/map_section.dart';
import 'package:lifelinker/view/common/location/components/patient_card.dart';
import 'package:lifelinker/view/common/location/components/quick_action.dart';
import 'package:lifelinker/view/common/location/components/safe_zone.dart';
import 'package:provider/provider.dart';

class LocationView extends StatelessWidget {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const LocationAppBar(),
          Expanded(
            child: Consumer<LocationProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2.5,
                    ),
                  );
                }
                if (provider.hasError || provider.data == null) {
                  return Center(
                    child: TextButton(
                      onPressed: provider.refresh,
                      child: const Text('Retry'),
                    ),
                  );
                }
                final data = provider.data!;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      LocationPatientCard(data: data),
                      const LocationQuickActions(),
                      if (!data.isInSafeZone)
                        LocationSafeZoneAlert(patientName: data.patientName),
                      const LocationNavigateCallRow(),
                      const LocationMapSection(),
                      LocationActivityHealth(data: data),
                      SizedBox(height: SizeConfig.heightMultiplier * 3),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
