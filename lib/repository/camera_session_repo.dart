import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifelinker/model/camera_session.dart';

class CameraSessionRepository {
  static final _db = FirebaseFirestore.instance;
  static const String _collection = 'camera_sessions';

  static Future<void> setSessionActive({
    required String patientId,
    required bool isActive,
  }) async {
    await _db.collection(_collection).doc(patientId).set({
      'patientId': patientId,
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  static Stream<CameraSessionModel?> listenToSession(String patientId) {
    return _db.collection(_collection).doc(patientId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return CameraSessionModel.fromMap(snap.data()!);
    });
  }
}
