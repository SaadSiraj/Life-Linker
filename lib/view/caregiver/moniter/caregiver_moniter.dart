
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/sos_alert.dart';
import 'package:lifelinker/model/user.dart';
import 'package:lifelinker/model/voice_message.dart';
import 'package:lifelinker/provider/caregiver_stream.dart';
import 'package:lifelinker/provider/sos.dart';
import 'package:lifelinker/provider/voice_message.dart';
import 'package:lifelinker/view/caregiver/moniter/components/incomming_sos_overlay.dart';
import 'package:lifelinker/view/caregiver/moniter/components/remote_feed.dart';
import 'package:lifelinker/view/caregiver/moniter/components/sos_btn.dart';
import 'package:lifelinker/view/caregiver/moniter/components/voice_btn.dart';
import 'package:provider/provider.dart';

class CaregiverMonitorView extends StatefulWidget {
  final UserModel patient;
  final String caregiverId;

  const CaregiverMonitorView({
    super.key,
    required this.patient,
    required this.caregiverId,
  });

  @override
  State<CaregiverMonitorView> createState() => _CaregiverMonitorViewState();
}

class _CaregiverMonitorViewState extends State<CaregiverMonitorView> {
  late CaregiverStreamProvider _streamProvider;
  late VoiceMessageProvider _voiceProvider;
  late SosProvider _sosProvider;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _streamProvider = context.read<CaregiverStreamProvider>();
    _voiceProvider = context.read<VoiceMessageProvider>();
    _sosProvider = context.read<SosProvider>();
  }

  void _initialize() {
    _streamProvider.startWatching(
      patientId: widget.patient.uid,
      caregiverId: widget.caregiverId,
    );
    _voiceProvider.startListeningForIncomingVoice(
      patientId: widget.patient.uid,
      caregiverId: widget.caregiverId,
      targetSender: VoiceMessageSender.patient,
    );
    _sosProvider.startListeningForSos(
      patientId: widget.patient.uid,
      caregiverId: widget.caregiverId,
      targetType: SosAlertType.patientToCaregiver,
    );
  }

  @override
  void dispose() {
    _streamProvider.stopWatching();
    _voiceProvider.stopListening();
    _sosProvider.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Spacing.y(2),
                Expanded(
                  child: CaregiverRemoteFeed(
                    patientId: widget.patient.uid,
                    caregiverId: widget.caregiverId,
                  ),
                ),
                Spacing.y(2),
                CaregiverSosButton(
                  patientId: widget.patient.uid,
                  caregiverId: widget.caregiverId,
                ),
                Spacing.y(2),
                CaregiverVoiceButton(
                  patientId: widget.patient.uid,
                  caregiverId: widget.caregiverId,
                ),
                Spacing.y(3),
              ],
            ),
          ),
          const IncomingPatientSosOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 4,
        vertical: SizeConfig.heightMultiplier * 1.5,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: SizeConfig.widthMultiplier * 10,
              height: SizeConfig.widthMultiplier * 10,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: SizeConfig.widthMultiplier * 4,
                color: AppColors.textDark,
              ),
            ),
          ),
          Spacing.x(3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  widget.patient.name,
                  size: 16,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w700,
                ),
                AppText('Live Monitoring', size: 11, color: AppColors.iconGrey),
              ],
            ),
          ),
          _CaregiverStreamStatusBadge(),
        ],
      ),
    );
  }
}

class _CaregiverStreamStatusBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CaregiverStreamProvider>(
      builder: (context, provider, _) {
        final isLive = provider.isWatching && provider.hasRemoteStream;
        final isConnecting = provider.isConnecting;

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
