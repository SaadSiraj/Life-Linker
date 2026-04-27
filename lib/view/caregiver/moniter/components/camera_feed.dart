import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/camera.dart';
import 'package:provider/provider.dart';

class CaregiverCameraFeed extends StatelessWidget {
  final String patientId;

  const CaregiverCameraFeed({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, provider, _) {
        if (provider.currentFrame != null) {
          return Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.widthMultiplier * 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.memory(
              provider.currentFrame!,
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.black800,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.videocam_off_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: SizeConfig.widthMultiplier * 14,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 1.5),
                AppText(
                  'Patient camera is offline',
                  size: 13,
                  color: Colors.white.withOpacity(0.7),
                  align: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.heightMultiplier * 0.8),
                AppText(
                  'Waiting for patient to open the app',
                  size: 11,
                  color: Colors.white.withOpacity(0.4),
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
