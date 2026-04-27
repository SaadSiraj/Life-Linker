import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/camera.dart';
import 'package:provider/provider.dart';

class PatientCameraView extends StatelessWidget {
  const PatientCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CameraProvider>(
      builder: (context, provider, _) {
        if (provider.isInitializing) {
          return _buildLoading();
        }

        if (provider.errorMessage != null) {
          return _buildError(provider.errorMessage!);
        }

        if (provider.currentFrame == null) {
          return _buildWaiting();
        }

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
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.videocam_off_rounded,
            color: AppColors.iconGrey,
            size: SizeConfig.widthMultiplier * 14,
          ),
          AppText(
            message,
            size: 13,
            color: AppColors.iconGrey,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWaiting() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.videocam_rounded,
            color: AppColors.primary.withOpacity(0.4),
            size: SizeConfig.widthMultiplier * 14,
          ),
          AppText('Starting camera...', size: 13, color: AppColors.iconGrey),
        ],
      ),
    );
  }
}
