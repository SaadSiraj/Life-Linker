
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/provider/patient_stream.dart';
import 'package:provider/provider.dart';

class PatientCameraPreview extends StatelessWidget {
  final String patientId;
  final String caregiverId;

  const PatientCameraPreview({
    super.key,
    required this.patientId,
    required this.caregiverId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientStreamProvider>(
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
              // WebRTC local video preview
              if (provider.isStreaming || provider.isInitializing)
                RTCVideoView(
                  provider.renderer,
                  mirror: false,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )
              else
                _buildOfflineState(provider, patientId, caregiverId),

              // Connecting overlay
              if (provider.isInitializing)
                _buildConnectingOverlay(),

              // "You are live" badge
              if (provider.isStreaming)
                Positioned(
                  top: SizeConfig.heightMultiplier * 1.5,
                  left: SizeConfig.widthMultiplier * 3,
                  child: _LiveBadge(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOfflineState(
    PatientStreamProvider provider,
    String patientId,
    String caregiverId,
  ) {
    return Builder(
      builder: (context) => Center(
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
              provider.errorMessage != null
                  ? 'Camera error'
                  : 'Camera is off',
              size: 13,
              color: Colors.white.withOpacity(0.7),
              align: TextAlign.center,
            ),
            Spacing.y(2),
            GestureDetector(
              onTap: () => provider.startStreaming(
                patientId: patientId,
                caregiverId: caregiverId,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widthMultiplier * 6,
                  vertical: SizeConfig.heightMultiplier * 1.2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AppText(
                  'Start Camera',
                  size: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.55),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            Spacing.y(2),
            AppText(
              'Connecting to caregiver...',
              size: 13,
              color: Colors.white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 3,
        vertical: SizeConfig.heightMultiplier * 0.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.alert,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: SizeConfig.widthMultiplier * 2,
            height: SizeConfig.widthMultiplier * 2,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 1.5),
          AppText(
            'LIVE',
            size: 10,
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ],
      ),
    );
  }
}
