import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/sos_alert.dart';
import 'package:lifelinker/provider/sos.dart';
import 'package:provider/provider.dart';

class CaregiverSosButton extends StatelessWidget {
  final String patientId;
  final String caregiverId;

  const CaregiverSosButton({
    super.key,
    required this.patientId,
    required this.caregiverId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SosProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 5,
          ),
          child: GestureDetector(
            onTap: provider.isSendingSos
                ? null
                : () => _confirmSos(context, provider),
            child: Container(
              height: SizeConfig.heightMultiplier * 7,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.alert,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.alert.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: provider.isSendingSos
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning_rounded,
                          color: Colors.white,
                          size: SizeConfig.widthMultiplier * 6,
                        ),
                        SizedBox(width: SizeConfig.widthMultiplier * 2.5),
                        AppText(
                          'SOS ALERT',
                          size: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  void _confirmSos(BuildContext context, SosProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              Icons.warning_rounded,
              color: AppColors.alert,
              size: SizeConfig.widthMultiplier * 6,
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 2),
            AppText(
              'Send SOS',
              size: 16,
              color: AppColors.textDark,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        content: AppText(
          'This will send an emergency alert to the patient immediately.',
          size: 13,
          color: AppColors.iconGrey,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(
              'Cancel',
              size: 13,
              color: AppColors.iconGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.sendSos(
                type: SosAlertType.caregiverToPatient,
                patientId: patientId,
                caregiverId: caregiverId,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.alert,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: AppText(
              'Send',
              size: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
