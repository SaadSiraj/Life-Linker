import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifelinker/model/sos_alert.dart';

class SosRepository {
  static final _db = FirebaseFirestore.instance;
  static const String _collection = 'sos_alerts';

  static Future<void> sendSosAlert({
    required SosAlertType type,
    required String patientId,
    required String caregiverId,
  }) async {
    final alert = SosAlertModel(
      id: '',
      type: type,
      isAcknowledged: false,
      createdAt: DateTime.now(),
      patientId: patientId,
      caregiverId: caregiverId,
    );
    await _db.collection(_collection).add(alert.toMap());
  }

  static Stream<SosAlertModel?> listenForIncomingSos({
    required String patientId,
    required String caregiverId,
    required SosAlertType targetType,
  }) {
    return _db
        .collection(_collection)
        .where('patientId', isEqualTo: patientId)
        .where('caregiverId', isEqualTo: caregiverId)
        .where(
          'type',
          isEqualTo: targetType == SosAlertType.caregiverToPatient
              ? 'caregiverToPatient'
              : 'patientToCaregiver',
        )
        .where('isAcknowledged', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) {
          if (snap.docs.isEmpty) return null;
          return SosAlertModel.fromMap(
            snap.docs.first.data(),
            snap.docs.first.id,
          );
        });
  }

  static Future<void> acknowledgeSos(String alertId) async {
    await _db.collection(_collection).doc(alertId).update({
      'isAcknowledged': true,
    });
  }
}
