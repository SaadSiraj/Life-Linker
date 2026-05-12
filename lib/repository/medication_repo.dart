import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifelinker/model/medication_log.dart';
import 'package:lifelinker/model/medication_scheduled.dart';

class MedicationRepository {
  static final _db = FirebaseFirestore.instance;
  static const String _schedules = 'medication_schedules';
  static const String _logs = 'medication_logs';

  static Future<MedicationScheduleModel> addMedication(
    MedicationScheduleModel medication,
  ) async {
    final ref = _db.collection(_schedules).doc();
    final med = MedicationScheduleModel(
      id: ref.id,
      patientId: medication.patientId,
      caregiverId: medication.caregiverId,
      name: medication.name,
      dosage: medication.dosage,
      frequency: medication.frequency,
      times: medication.times,
      notes: medication.notes,
      isActive: true,
      createdAt: DateTime.now(),
    );
    await ref.set(med.toMap());
    return med;
  }

  static Future<void> updateMedication(
    MedicationScheduleModel medication,
  ) async {
    await _db.collection(_schedules).doc(medication.id).update({
      'name': medication.name,
      'dosage': medication.dosage,
      'frequency': medication.frequencyLabel.toLowerCase(),
      'times': medication.times,
      'notes': medication.notes,
      'isActive': medication.isActive,
    });
  }

  static Future<void> deleteMedication(String medicationId) async {
    await _db.collection(_schedules).doc(medicationId).update({
      'isActive': false,
    });
  }

  static Stream<List<MedicationScheduleModel>> listenToMedications(
    String patientId,
  ) {
    return _db
        .collection(_schedules)
        .where('patientId', isEqualTo: patientId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => MedicationScheduleModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  static Future<void> logMedicationStatus({
    required String medicationId,
    required String patientId,
    required String medicationName,
    required String dosage,
    required String scheduledTime,
    required MedicationStatus status,
    required DateTime scheduledDate,
    String? note,
  }) async {
    final dateKey =
        '${scheduledDate.year}-${scheduledDate.month}-${scheduledDate.day}';
    final docId = '${medicationId}_${dateKey}_$scheduledTime';

    final log = MedicationLogModel(
      id: docId,
      medicationId: medicationId,
      patientId: patientId,
      medicationName: medicationName,
      dosage: dosage,
      scheduledTime: scheduledTime,
      status: status,
      scheduledDate: scheduledDate,
      takenAt: status == MedicationStatus.taken ? DateTime.now() : null,
      note: note,
    );

    await _db.collection(_logs).doc(docId).set(log.toMap());
  }

  static Stream<List<MedicationLogModel>> listenToTodayLogs(String patientId) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));

    return _db
        .collection(_logs)
        .where('patientId', isEqualTo: patientId)
        .where(
          'scheduledDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(start),
        )
        .where('scheduledDate', isLessThan: Timestamp.fromDate(end))
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => MedicationLogModel.fromMap(d.data(), d.id))
              .toList(),
        );
  }

  static Future<List<MedicationLogModel>> fetchLogsForDateRange({
    required String patientId,
    required DateTime from,
    required DateTime to,
  }) async {
    final snap = await _db
        .collection(_logs)
        .where('patientId', isEqualTo: patientId)
        .where(
          'scheduledDate',
          isGreaterThanOrEqualTo: Timestamp.fromDate(from),
        )
        .where('scheduledDate', isLessThan: Timestamp.fromDate(to))
        .orderBy('scheduledDate', descending: true)
        .get();
    return snap.docs
        .map((d) => MedicationLogModel.fromMap(d.data(), d.id))
        .toList();
  }

  static Future<MedicationLogModel?> fetchLogForSlot({
    required String medicationId,
    required DateTime date,
    required String time,
  }) async {
    final dateKey = '${date.year}-${date.month}-${date.day}';
    final docId = '${medicationId}_${dateKey}_$time';
    final doc = await _db.collection(_logs).doc(docId).get();
    if (!doc.exists || doc.data() == null) return null;
    return MedicationLogModel.fromMap(doc.data()!, doc.id);
  }
}
