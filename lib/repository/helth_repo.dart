import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifelinker/model/health_record.dart';

class HealthRepository {
  static final _db = FirebaseFirestore.instance;
  static const String _col = 'health_records';

  static Future<void> addRecord(HealthRecordModel record) async {
    final ref = _db.collection(_col).doc();
    final data = record.toMap();
    await ref.set({...data, 'id': ref.id});
  }

  static Stream<List<HealthRecordModel>> listenToRecords(String patientId) {
    return _db
        .collection(_col)
        .where('patientId', isEqualTo: patientId)
        .orderBy('recordedAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => HealthRecordModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  static Future<void> deleteRecord(String id) async {
    await _db.collection(_col).doc(id).delete();
  }
}
