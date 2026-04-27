import 'package:flutter/material.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/sos_alert.dart';
import 'package:lifelinker/provider/sos.dart';
import 'package:provider/provider.dart';

class PatientSosButton extends StatelessWidget {
  final String patientId;
  final String caregiverId;

  const PatientSosButton({
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
                : () => provider.sendSos(
                    type: SosAlertType.patientToCaregiver,
                    patientId: patientId,
                    caregiverId: caregiverId,
                  ),
            child: Container(
              height: SizeConfig.heightMultiplier * 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.alert,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.alert.withOpacity(0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
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
                          size: SizeConfig.widthMultiplier * 7,
                        ),
                        SizedBox(width: SizeConfig.widthMultiplier * 3),
                        AppText(
                          'SEND SOS',
                          size: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
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
