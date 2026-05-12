import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifelinker/core/constants/app_colors.dart';
import 'package:lifelinker/core/services/shared_prefs_service.dart';
import 'package:lifelinker/core/utils/size_config.dart';
import 'package:lifelinker/core/utils/spacing.dart';
import 'package:lifelinker/core/widgets/app_text.dart';
import 'package:lifelinker/model/sos_alert.dart';
import 'package:lifelinker/model/voice_message.dart';
import 'package:lifelinker/provider/patient_stream.dart';
import 'package:lifelinker/provider/profile.dart';
import 'package:lifelinker/provider/sos.dart';
import 'package:lifelinker/provider/voice_message.dart';
import 'package:lifelinker/view/patient/home/components/camera_preview.dart';
import 'package:lifelinker/view/patient/home/components/incoming_sos.dart';
import 'package:lifelinker/view/patient/home/components/sos_button.dart';
import 'package:lifelinker/view/patient/home/components/stream_status_badge.dart';
import 'package:lifelinker/view/patient/home/components/voice_button.dart';
import 'package:provider/provider.dart';

class PatientHomeView extends StatefulWidget {
  const PatientHomeView({super.key});

  @override
  State<PatientHomeView> createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView>
    with WidgetsBindingObserver {
  String? _patientId;
  String? _caregiverId;
  bool _initialized = false;
  late PatientStreamProvider _streamProvider;
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
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _streamProvider = context.read<PatientStreamProvider>();
    _voiceProvider = context.read<VoiceMessageProvider>();
    _sosProvider = context.read<SosProvider>();
  }

  Future<void> _initialize() async {
    if (_initialized && _patientId != null && _caregiverId != null) {
      _ensureStreaming();
      return;
    }

    _patientId = SharedPrefsService.getUID();
    if (_patientId == null) return;

    try {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.loadProfile();
      _caregiverId = profileProvider.user?.caregiverId;
    } catch (_) {
      return;
    }

    if (_caregiverId == null || _caregiverId!.isEmpty) return;
    if (!mounted) return;

    _initialized = true;
    setState(() {});
    _startAllProviders();
  }

  void _startAllProviders() {
    if (_patientId == null || _caregiverId == null) return;

    if (!_streamProvider.isStreaming && !_streamProvider.isPaused) {
      _streamProvider.startStreaming(
        patientId: _patientId!,
        caregiverId: _caregiverId!,
      );
    }
    _voiceProvider.startListeningForIncomingVoice(
      patientId: _patientId!,
      caregiverId: _caregiverId!,
      targetSender: VoiceMessageSender.caregiver,
    );
    _sosProvider.startListeningForSos(
      patientId: _patientId!,
      caregiverId: _caregiverId!,
      targetType: SosAlertType.caregiverToPatient,
    );
  }

  void _ensureStreaming() {
    if (_streamProvider.isPaused) return;
    if (!_streamProvider.isStreaming && !_streamProvider.isInitializing) {
      _streamProvider.stopStreaming().then((_) {
        if (mounted && _patientId != null && _caregiverId != null) {
          _streamProvider.startStreaming(
            patientId: _patientId!,
            caregiverId: _caregiverId!,
          );
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {
      if (_patientId == null || _caregiverId == null) return;
      await _streamProvider.stopStreaming();
      _streamProvider.startStreaming(
        patientId: _patientId!,
        caregiverId: _caregiverId!,
      );
      _voiceProvider.startListeningForIncomingVoice(
        patientId: _patientId!,
        caregiverId: _caregiverId!,
        targetSender: VoiceMessageSender.caregiver,
      );
      _sosProvider.startListeningForSos(
        patientId: _patientId!,
        caregiverId: _caregiverId!,
        targetType: SosAlertType.caregiverToPatient,
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _streamProvider.stopStreaming();
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
                _buildHeader(),
                Spacing.y(2),
                Expanded(
                  child: PatientCameraPreview(
                    patientId: _patientId ?? '',
                    caregiverId: _caregiverId ?? '',
                  ),
                ),
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
          const IncomingCaregiverSosOverlay(),
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
            width: SizeConfig.widthMultiplier * 10,
            height: SizeConfig.widthMultiplier * 10,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.health_and_safety_rounded,
              color: Colors.white,
              size: SizeConfig.widthMultiplier * 5,
            ),
          ),
          Spacing.x(3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  'LifeLinker',
                  size: 18,
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
          ),
          const StreamStatusBadge(),
        ],
      ),
    );
  }
}
