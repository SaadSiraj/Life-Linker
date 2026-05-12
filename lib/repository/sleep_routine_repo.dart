import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifelinker/model/sleep_log.dart';
import 'package:lifelinker/model/sleep_routine.dart';

class SleepRepository {
  static final _db = FirebaseFirestore.instance;
  static const String _routines = 'sleep_routines';
  static const String _logs = 'sleep_logs';

  // ── Routines ──────────────────────────────────────────────────────────────

  static Future<SleepRoutineModel> addRoutine(SleepRoutineModel routine) async {
    final ref = _db.collection(_routines).doc();
    final newRoutine = SleepRoutineModel(
      id: ref.id,
      patientId: routine.patientId,
      caregiverId: routine.caregiverId,
      title: routine.title,
      bedtime: routine.bedtime,
      wakeTime: routine.wakeTime,
      targetHours: routine.targetHours,
      sleepTips: routine.sleepTips,
      isActive: true,
      createdAt: DateTime.now(),
    );
    await ref.set(newRoutine.toMap());
    return newRoutine;
  }

  static Future<void> updateRoutine(SleepRoutineModel routine) async {
    await _db.collection(_routines).doc(routine.id).update({
      'title': routine.title,
      'bedtime': routine.bedtime,
      'wakeTime': routine.wakeTime,
      'targetHours': routine.targetHours,
      'sleepTips': routine.sleepTips,
    });
  }

  static Future<void> deleteRoutine(String routineId) async {
    await _db.collection(_routines).doc(routineId).update({'isActive': false});
  }

  static Stream<List<SleepRoutineModel>> listenToRoutines(String patientId) {
    return _db
        .collection(_routines)
        .where('patientId', isEqualTo: patientId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => SleepRoutineModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  // ── Logs ──────────────────────────────────────────────────────────────────

  static Future<void> addLog(SleepLogModel log) async {
    final dateKey = '${log.date.year}-${log.date.month}-${log.date.day}';
    final docId = '${log.patientId}_${log.routineId}_$dateKey';
    await _db.collection(_logs).doc(docId).set(log.toMap());
  }

  static Stream<List<SleepLogModel>> listenToLogs(String patientId) {
    final from = DateTime.now().subtract(const Duration(days: 7));
    return _db
        .collection(_logs)
        .where('patientId', isEqualTo: patientId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(from))
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => SleepLogModel.fromMap(d.data(), d.id)).toList(),
        );
  }

  static Future<SleepLogModel?> fetchTodayLog(
    String patientId,
    String routineId,
  ) async {
    final now = DateTime.now();
    final dateKey = '${now.year}-${now.month}-${now.day}';
    final docId = '${patientId}_${routineId}_$dateKey';
    final doc = await _db.collection(_logs).doc(docId).get();
    if (!doc.exists || doc.data() == null) return null;
    return SleepLogModel.fromMap(doc.data()!, doc.id);
  }
}
