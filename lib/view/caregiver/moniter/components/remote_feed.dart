import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/caregiver_stream.dart';
import 'package:provider/provider.dart';

class CaregiverRemoteFeed extends StatelessWidget {
  final String patientId;
  final String caregiverId;

  const CaregiverRemoteFeed({
    super.key,
    required this.patientId,
    required this.caregiverId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CaregiverStreamProvider>(
      builder: (context, provider, _) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.black800,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (provider.hasRemoteStream)
                RTCVideoView(
                  provider.renderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )
              else
                _buildOfflineState(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfflineState(
    BuildContext context,
    CaregiverStreamProvider provider,
  ) {
    if (provider.isConnecting) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            Spacing.y(2),
            AppText(
              'Waiting for patient...',
              size: 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.videocam_off_rounded,
            color: Colors.white.withOpacity(0.5),
            size: SizeConfig.widthMultiplier * 14,
          ),
          Spacing.y(1.5),
          AppText(
            'Patient camera is offline',
            size: 13,
            color: Colors.white.withOpacity(0.7),
            align: TextAlign.center,
          ),
          Spacing.y(0.8),
          AppText(
            'Waiting for patient to open the app',
            size: 11,
            color: Colors.white.withOpacity(0.4),
            align: TextAlign.center,
          ),
          Spacing.y(2.5),
          GestureDetector(
            onTap: () => provider.isPaused
                ? provider.resumeWatching(
                    patientId: patientId,
                    caregiverId: caregiverId,
                  )
                : provider.startWatching(
                    patientId: patientId,
                    caregiverId: caregiverId,
                  ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 5,
                vertical: SizeConfig.heightMultiplier * 1.2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: AppText(
                provider.isPaused ? 'Resume' : 'Reconnect',
                size: 13,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
