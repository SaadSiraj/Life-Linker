import 'package:cloud_firestore/cloud_firestore.dart';

class CameraFrameRepository {
  static final _db = FirebaseFirestore.instance;
  static const String _collection = 'camera_frames';

  static Future<void> pushFrame({
    required String patientId,
    required String base64Frame,
  }) async {
    await _db.collection(_collection).doc(patientId).set({
      'patientId': patientId,
      'frame': base64Frame,
      'isActive': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> setInactive(String patientId) async {
    await _db.collection(_collection).doc(patientId).set({
      'patientId': patientId,
      'frame': null,
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<Map<String, dynamic>?> listenToFrame(String patientId) {
    return _db.collection(_collection).doc(patientId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return snap.data();
    });
  }
}
