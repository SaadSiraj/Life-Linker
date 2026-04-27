import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/voice_message.dart';
import 'package:lifelinker/provider/voice_message.dart';
import 'package:provider/provider.dart';

class CaregiverVoiceButton extends StatelessWidget {
  final String patientId;
  final String caregiverId;

  const CaregiverVoiceButton({
    super.key,
    required this.patientId,
    required this.caregiverId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<VoiceMessageProvider>(
      builder: (context, provider, _) {
        final isRecording = provider.isRecording;
        final isSending = provider.isSending;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 5,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTapDown: (_) => provider.startRecording(),
                onTapUp: (_) => provider.stopAndSendVoice(
                  patientId: patientId,
                  caregiverId: caregiverId,
                  sender: VoiceMessageSender.caregiver,
                ),
                onTapCancel: () => provider.cancelRecording(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: SizeConfig.widthMultiplier * 20,
                  height: SizeConfig.widthMultiplier * 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording
                        ? AppColors.successDark
                        : AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isRecording
                                    ? AppColors.successDark
                                    : AppColors.primary)
                                .withOpacity(0.35),
                        blurRadius: isRecording ? 20 : 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isSending
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Icon(
                          isRecording ? Icons.mic : Icons.mic_none_rounded,
                          color: Colors.white,
                          size: SizeConfig.widthMultiplier * 9,
                        ),
                ),
              ),
              Spacing.y(1.5),
              AppText(
                isRecording
                    ? 'Release to send'
                    : isSending
                    ? 'Sending...'
                    : 'Hold to speak to patient',
                size: 12,
                color: isRecording ? AppColors.successDark : AppColors.iconGrey,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        );
      },
    );
  }
}
