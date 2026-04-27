import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lifelinker/model/sos_alert.dart';
import 'package:lifelinker/repository/sos_repo.dart';

class SosProvider extends ChangeNotifier {
  StreamSubscription<SosAlertModel?>? _subscription;

  bool _isSendingSos = false;
  SosAlertModel? _incomingAlert;
  bool _hasActiveAlert = false;

  bool get isSendingSos => _isSendingSos;
  SosAlertModel? get incomingAlert => _incomingAlert;
  bool get hasActiveAlert => _hasActiveAlert;

  void startListeningForSos({
    required String patientId,
    required String caregiverId,
    required SosAlertType targetType,
  }) {
    _subscription?.cancel();
    _subscription =
        SosRepository.listenForIncomingSos(
          patientId: patientId,
          caregiverId: caregiverId,
          targetType: targetType,
        ).listen((alert) {
          if (alert != null && !alert.isAcknowledged) {
            _incomingAlert = alert;
            _hasActiveAlert = true;
            notifyListeners();
          }
        });
  }

  Future<void> sendSos({
    required SosAlertType type,
    required String patientId,
    required String caregiverId,
  }) async {
    _isSendingSos = true;
    notifyListeners();

    try {
      await SosRepository.sendSosAlert(
        type: type,
        patientId: patientId,
        caregiverId: caregiverId,
      );
    } catch (_) {
    } finally {
      _isSendingSos = false;
      notifyListeners();
    }
  }

  Future<void> acknowledgeAlert() async {
    if (_incomingAlert == null) return;
    await SosRepository.acknowledgeSos(_incomingAlert!.id);
    _incomingAlert = null;
    _hasActiveAlert = false;
    notifyListeners();
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
