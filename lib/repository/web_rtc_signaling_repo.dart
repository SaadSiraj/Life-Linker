import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lifelinker/model/ice_candidate.dart';
import 'package:lifelinker/model/web_rtc_session.dart';

class WebRtcSignalingRepository {
  static final _db = FirebaseFirestore.instance;

  // Collection names
  static const String _sessions = 'webrtc_sessions';
  static const String _callerCandidates = 'callerCandidates';
  static const String _calleeCandidates = 'calleeCandidates';

  // ── Session ID ────────────────────────────────────────────────────────────
  static String _sessionId(String patientId, String caregiverId) =>
      '${patientId}_$caregiverId';

  // ── Create / reset session ────────────────────────────────────────────────
  static Future<String> createSession({
    required String patientId,
    required String caregiverId,
  }) async {
    final sessionId = _sessionId(patientId, caregiverId);
    final ref = _db.collection(_sessions).doc(sessionId);

    await _clearCandidates(sessionId);

    final session = WebRtcSessionModel(
      sessionId: sessionId,
      patientId: patientId,
      caregiverId: caregiverId,
      status: WebRtcSessionStatus.waiting,
      createdAt: DateTime.now(),
    );

    await ref.set(session.toMap());
    return sessionId;
  }

  // Change saveOffer to use set+merge so it never fails on missing doc
  static Future<void> saveOffer({
    required String sessionId,
    required Map<String, dynamic> offer,
  }) async {
    await _db.collection(_sessions).doc(sessionId).set({
      'offer': offer,
      'status': 'waiting',
    }, SetOptions(merge: true));
  }

  // New method — patient resets session before reconnecting
  static Future<void> resetSessionByPatient({
    required String patientId,
    required String caregiverId,
  }) async {
    final sessionId = _sessionId(patientId, caregiverId);
    await _clearCandidates(sessionId);
    await _db.collection(_sessions).doc(sessionId).set({
      'patientId': patientId,
      'caregiverId': caregiverId,
      'status': 'waiting',
      'offer': null,
      'answer': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
    debugPrint('[Signaling] Session reset by patient: $sessionId');
  }

  static Future<void> saveAnswer({
    required String sessionId,
    required Map<String, dynamic> answer,
  }) async {
    await _db.collection(_sessions).doc(sessionId).update({
      'answer': answer,
      'status': 'active',
    });
  }

  static Future<void> addCallerCandidate({
    required String sessionId,
    required IceCandidateModel candidate,
  }) async {
    await _db
        .collection(_sessions)
        .doc(sessionId)
        .collection(_callerCandidates)
        .add(candidate.toMap());
  }

  static Future<void> addCalleeCandidate({
    required String sessionId,
    required IceCandidateModel candidate,
  }) async {
    await _db
        .collection(_sessions)
        .doc(sessionId)
        .collection(_calleeCandidates)
        .add(candidate.toMap());
  }

  static Stream<WebRtcSessionModel?> listenToSession(String sessionId) {
    return _db.collection(_sessions).doc(sessionId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return WebRtcSessionModel.fromMap(snap.data()!, snap.id);
    });
  }

  static Stream<List<IceCandidateModel>> listenToCallerCandidates(
    String sessionId,
  ) {
    return _db
        .collection(_sessions)
        .doc(sessionId)
        .collection(_callerCandidates)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => IceCandidateModel.fromMap(d.data()))
              .toList(),
        );
  }

  static Stream<List<IceCandidateModel>> listenToCalleeCandidates(
    String sessionId,
  ) {
    return _db
        .collection(_sessions)
        .doc(sessionId)
        .collection(_calleeCandidates)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => IceCandidateModel.fromMap(d.data()))
              .toList(),
        );
  }

  static Future<void> endSession(String sessionId) async {
    await _db.collection(_sessions).doc(sessionId).update({
      'status': 'ended',
      'answer': null,
      'offer': null,
    });
    await _clearCandidates(sessionId);
  }

  // ── Cleanup ───────────────────────────────────────────────────────────────
  static Future<void> _clearCandidates(String sessionId) async {
    final ref = _db.collection(_sessions).doc(sessionId);

    // Delete caller candidates subcollection
    final callerSnap = await ref.collection(_callerCandidates).get();
    for (final doc in callerSnap.docs) {
      await doc.reference.delete();
    }

    // Delete callee candidates subcollection
    final calleeSnap = await ref.collection(_calleeCandidates).get();
    for (final doc in calleeSnap.docs) {
      await doc.reference.delete();
    }
  }

  // ── Fetch session once ────────────────────────────────────────────────────
  static Future<WebRtcSessionModel?> fetchSession(String sessionId) async {
    final snap = await _db.collection(_sessions).doc(sessionId).get();
    if (!snap.exists || snap.data() == null) return null;
    return WebRtcSessionModel.fromMap(snap.data()!, snap.id);
  }
}
