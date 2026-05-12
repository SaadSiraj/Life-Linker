import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/sos.dart';
import 'package:provider/provider.dart';

class IncomingPatientSosOverlay extends StatelessWidget {
  const IncomingPatientSosOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SosProvider>(
      builder: (context, provider, _) {
        if (!provider.hasActiveAlert) return const SizedBox.shrink();

        return Positioned.fill(
          child: Container(
            color: AppColors.alert.withOpacity(0.93),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: SizeConfig.widthMultiplier * 22,
                  ),
                  Spacing.y(3),
                  AppText(
                    'PATIENT SOS!',
                    size: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                  Spacing.y(1.5),
                  AppText(
                    'Your patient needs urgent help!',
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
                        'Acknowledged',
                        size: 15,
                        color: AppColors.alert,
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
