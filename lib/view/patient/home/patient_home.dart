import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/sos_alert.dart';
import 'package:lifelinker/model/voice_message.dart';
import 'package:lifelinker/provider/camera.dart';
import 'package:lifelinker/provider/sos.dart';
import 'package:lifelinker/provider/voice_message.dart';
import 'package:lifelinker/view/patient/home/components/camera.dart';
import 'package:lifelinker/view/patient/home/components/sos_button.dart';
import 'package:lifelinker/view/patient/home/components/sos_overlay.dart';
import 'package:lifelinker/view/patient/home/components/voice_button.dart';
import 'package:provider/provider.dart';

class PatientHomeView extends StatefulWidget {
  const PatientHomeView({super.key});

  @override
  State<PatientHomeView> createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView> {
  String? _patientId;
  String? _caregiverId;

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

  Future<void> _initialize() async {
    _patientId = SharedPrefsService.getUID();
    if (_patientId == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_patientId)
          .get();
      if (doc.exists && doc.data() != null) {
        _caregiverId = doc.data()!['caregiverId'] as String?;
      }
    } catch (_) {
      _caregiverId = null;
    }

    if (_caregiverId == null || _caregiverId!.isEmpty) return;

    context.read<CameraProvider>().startCamera(_patientId!);

    context.read<VoiceMessageProvider>().startListeningForIncomingVoice(
      patientId: _patientId!,
      caregiverId: _caregiverId!,
      targetSender: VoiceMessageSender.caregiver,
    );

    context.read<SosProvider>().startListeningForSos(
      patientId: _patientId!,
      caregiverId: _caregiverId!,
      targetType: SosAlertType.caregiverToPatient,
    );
  }

  @override
  void dispose() {
    if (_patientId != null) {
      context.read<CameraProvider>().stopCamera(_patientId!);
    }
    context.read<VoiceMessageProvider>().stopListening();
    context.read<SosProvider>().stopListening();
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
                _buildHeader(),
                Spacing.y(2),
                const Expanded(child: PatientCameraView()),
                Spacing.y(2),
                PatientSosButton(
                  patientId: _patientId ?? '',
                  caregiverId: _caregiverId ?? '',
                ),
                Spacing.y(2),
                PatientVoiceButton(
                  patientId: _patientId ?? '',
                  caregiverId: _caregiverId ?? '',
                ),
                Spacing.y(3),
              ],
            ),
          ),
          const IncomingSosOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.widthMultiplier * 5,
        vertical: SizeConfig.heightMultiplier * 2,
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
          Container(
            padding: EdgeInsets.all(SizeConfig.widthMultiplier * 2),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.health_and_safety_rounded,
              color: AppColors.primary,
              size: SizeConfig.widthMultiplier * 6,
            ),
          ),
          Spacing.x(3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                'LifeLinker',
                size: 16,
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
              ),
              AppText(
                'You are being monitored',
                size: 11,
                color: AppColors.iconGrey,
              ),
            ],
          ),
          const Spacer(),
          Consumer<CameraProvider>(
            builder: (context, provider, _) => Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier * 3,
                vertical: SizeConfig.heightMultiplier * 0.5,
              ),
              decoration: BoxDecoration(
                color: provider.isCameraActive
                    ? AppColors.successLight
                    : AppColors.alertLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: SizeConfig.widthMultiplier * 2,
                    height: SizeConfig.widthMultiplier * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: provider.isCameraActive
                          ? AppColors.successDark
                          : AppColors.alert,
                    ),
                  ),
                  Spacing.x(1.5),
                  AppText(
                    provider.isCameraActive ? 'Live' : 'Offline',
                    size: 11,
                    color: provider.isCameraActive
                        ? AppColors.successDark
                        : AppColors.alert,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
