import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/patient_stream.dart';
import 'package:provider/provider.dart';

class StreamStatusBadge extends StatelessWidget {
  const StreamStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientStreamProvider>(
      builder: (context, provider, _) {
        final isLive = provider.isStreaming;
        final isConnecting = provider.isInitializing;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 3,
            vertical: SizeConfig.heightMultiplier * 0.5,
          ),
          decoration: BoxDecoration(
            color: isLive
                ? AppColors.successLight
                : isConnecting
                ? AppColors.amberLight
                : AppColors.alertLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isConnecting)
                SizedBox(
                  width: SizeConfig.widthMultiplier * 2.5,
                  height: SizeConfig.widthMultiplier * 2.5,
                  child: const CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.amber,
                  ),
                )
              else
                Container(
                  width: SizeConfig.widthMultiplier * 2,
                  height: SizeConfig.widthMultiplier * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLive ? AppColors.successDark : AppColors.alert,
                  ),
                ),
              Spacing.x(1.5),
              AppText(
                isLive
                    ? 'Live'
                    : isConnecting
                    ? 'Connecting'
                    : 'Offline',
                size: 11,
                color: isLive
                    ? AppColors.successDark
                    : isConnecting
                    ? AppColors.amber
                    : AppColors.alert,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        );
      },
    );
  }
}
