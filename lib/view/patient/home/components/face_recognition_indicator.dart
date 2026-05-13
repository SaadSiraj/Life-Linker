import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/face_match_resesult.dart';
import 'package:lifelinker/provider/face_recognition.dart';
import 'package:provider/provider.dart';

class FaceRecognitionIndicator extends StatelessWidget {
  const FaceRecognitionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FaceRecognitionProvider>(
      builder: (context, provider, _) {
        return GestureDetector(
          onTap: () => _showDebugDialog(context, provider),
          child: _buildBadge(provider),
        );
      },
    );
  }

  Widget _buildBadge(FaceRecognitionProvider provider) {
    switch (provider.status) {
      case FaceRecognitionStatus.idle:
        return _badge(
          icon: Icons.face_outlined,
          label: 'Face ID',
          color: AppColors.iconGrey,
          bg: AppColors.grey100,
        );
      case FaceRecognitionStatus.noFace:
        return _badge(
          icon: Icons.no_photography_outlined,
          label: 'No Face',
          color: AppColors.iconGrey,
          bg: AppColors.grey100,
        );

      case FaceRecognitionStatus.scanning:
        return _animatedBadge(
          label: 'Scanning...',
          color: AppColors.primary,
          bg: AppColors.blueLight,
        );

      case FaceRecognitionStatus.detected:
        return _animatedBadge(
          label: 'Matching...',
          color: AppColors.amber,
          bg: AppColors.amberLight,
        );

      case FaceRecognitionStatus.matched:
        final name = provider.lastResult?.userName ?? '';
        final confidence = provider.lastResult?.confidenceLabel ?? '';
        return _badge(
          icon: Icons.face_retouching_natural,
          label: '$name $confidence',
          color: AppColors.successDark,
          bg: AppColors.successLight,
        );

      case FaceRecognitionStatus.noMatch:
        return _badge(
          icon: Icons.face_outlined,
          label: 'No Match',
          color: AppColors.iconGrey,
          bg: AppColors.grey100,
        );

      case FaceRecognitionStatus.error:
        return _badge(
          icon: Icons.warning_amber_rounded,
          label: 'FR Error',
          color: AppColors.alert,
          bg: AppColors.alertLight,
        );
    }
  }

  Widget _badge({
    required IconData icon,
    required String label,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 2.5,
        vertical: SizeConfig.heightMultiplier * 0.5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: SizeConfig.widthMultiplier * 3.5),
          SizedBox(width: SizeConfig.widthMultiplier * 1),
          AppText(label, size: 9, color: color, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _animatedBadge({
    required String label,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 2.5,
        vertical: SizeConfig.heightMultiplier * 0.5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: SizeConfig.widthMultiplier * 3,
            height: SizeConfig.widthMultiplier * 3,
            child: CircularProgressIndicator(strokeWidth: 1.5, color: color),
          ),
          SizedBox(width: SizeConfig.widthMultiplier * 1.5),
          AppText(label, size: 9, color: color, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  // ── Debug Dialog — tap karo badge pe test ke liye ─────────────────────────
  void _showDebugDialog(
    BuildContext context,
    FaceRecognitionProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.face_retouching_natural,
              color: AppColors.primary,
              size: SizeConfig.widthMultiplier * 6,
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 2),
            AppText(
              'Face Recognition',
              size: 15,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _debugRow('Status', _statusLabel(provider.status)),
            _debugRow('Users Loaded', '${provider.loadedUsersCount}'),
            _debugRow('Total Scans', '${provider.totalScans}'),
            _debugRow('Total Matches', '${provider.totalMatches}'),
            if (provider.lastResult != null) ...[
              const Divider(),
              _debugRow('Last Match', provider.lastResult!.userName),
              _debugRow('Confidence', provider.lastResult!.confidenceLabel),
              _debugRow(
                'Is Match',
                provider.lastResult!.isMatch ? '✅ YES' : '❌ NO',
              ),
            ],
            if (provider.errorMessage != null) ...[
              const Divider(),
              _debugRow('Error', provider.errorMessage!, isError: true),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(
              'Close',
              size: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _debugRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.heightMultiplier * 0.4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            label,
            size: 12,
            color: AppColors.iconGrey,
            fontWeight: FontWeight.w500,
          ),
          AppText(
            value,
            size: 12,
            color: isError ? AppColors.alert : AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  String _statusLabel(FaceRecognitionStatus status) {
    switch (status) {
      case FaceRecognitionStatus.idle:
        return '⚪ Idle';

      case FaceRecognitionStatus.scanning:
        return '🔵 Scanning';
      case FaceRecognitionStatus.detected:
        return '🟡 Matching...';
      case FaceRecognitionStatus.matched:
        return '🟢 Match Found';
      case FaceRecognitionStatus.noFace:
        return '⚫ No Face';
      case FaceRecognitionStatus.noMatch:
        return '⚫ No Match';
      case FaceRecognitionStatus.error:
        return '🔴 Error';
    }
  }
}
