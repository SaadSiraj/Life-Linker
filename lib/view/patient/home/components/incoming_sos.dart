import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/sos.dart';
import 'package:provider/provider.dart';

class IncomingCaregiverSosOverlay extends StatelessWidget {
  const IncomingCaregiverSosOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SosProvider>(
      builder: (context, provider, _) {
        if (!provider.hasActiveAlert) return const SizedBox.shrink();

        return Positioned.fill(
          child: Container(
            color: AppColors.primary.withOpacity(0.95),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_active_rounded,
                    color: Colors.white,
                    size: SizeConfig.widthMultiplier * 22,
                  ),
                  Spacing.y(3),
                  AppText(
                    'CAREGIVER ALERT',
                    size: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    align: TextAlign.center,
                  ),
                  Spacing.y(1.5),
                  AppText(
                    'Your caregiver is trying to reach you!',
                    size: 15,
                    color: Colors.white.withOpacity(0.9),
                    align: TextAlign.center,
                  ),
                  Spacing.y(5),
                  GestureDetector(
                    onTap: provider.acknowledgeAlert,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.widthMultiplier * 8,
                        vertical: SizeConfig.heightMultiplier * 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: AppText(
                        'I am OK',
                        size: 16,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
