import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lifelinker/core/config/face_recognition_config.dart';
import 'package:lifelinker/core/services/face_api_service.dart';
import 'package:lifelinker/model/face_match_resesult.dart';

class _KnownUser {
  final String uid;
  final String name;
  final String imageUrl;
  final int
  priority; // Lower = higher priority (caregiver = 0, patient = 1, others = 2)

  const _KnownUser({
    required this.uid,
    required this.name,
    required this.imageUrl,
    required this.priority,
  });
}

class FaceRecognitionRepository {
  static final FaceRecognitionRepository _instance =
      FaceRecognitionRepository._internal();
  factory FaceRecognitionRepository() => _instance;
  FaceRecognitionRepository._internal();

  static final _db = FirebaseFirestore.instance;
  final _apiService = FaceApiService();

  final List<_KnownUser> _knownUsers = [];
  bool get hasKnownUsers => _knownUsers.isNotEmpty;
  int get userCount => _knownUsers.length;

  // ── Load Users — Priority: caregiver first, then linked, then others ──────
  Future<void> loadKnownUsers({
    required String patientId,
    required String? caregiverId,
  }) async {
    _knownUsers.clear();
    final loadedUids = <String>{};

    debugPrint('\n══════════════════════════════════════');
    debugPrint('[FaceRepo] 🔄 Loading known users...');
    debugPrint('[FaceRepo] Patient ID: $patientId');
    debugPrint('[FaceRepo] Caregiver ID: $caregiverId');
    debugPrint('══════════════════════════════════════\n');

    // PRIORITY 0 — Caregiver (sabse pehle)
    if (caregiverId != null && caregiverId.isNotEmpty) {
      final user = await _fetchUser(caregiverId, priority: 0);
      if (user != null) {
        _knownUsers.add(user);
        loadedUids.add(caregiverId);
        debugPrint('[FaceRepo] ✅ P0 (Caregiver): ${user.name}');
      }
    }

    // PRIORITY 1 — Patient khud
    final patientUser = await _fetchUser(patientId, priority: 1);
    if (patientUser != null) {
      _knownUsers.add(patientUser);
      loadedUids.add(patientId);
      debugPrint('[FaceRepo] ✅ P1 (Patient): ${patientUser.name}');
    }

    // PRIORITY 2 — Caregiver ke linked patients (relatives/family)
    if (caregiverId != null && caregiverId.isNotEmpty) {
      try {
        final cgDoc = await _db.collection('users').doc(caregiverId).get();
        if (cgDoc.exists) {
          final patientIds = List<String>.from(
            cgDoc.data()?['patientIds'] ?? [],
          );
          debugPrint(
            '[FaceRepo] Caregiver ke linked patients: ${patientIds.length}',
          );

          for (final pid in patientIds) {
            if (loadedUids.contains(pid)) continue;
            if (_knownUsers.length >= FaceRecognitionConfig.maxUsersToFetch) {
              break;
            }
            final u = await _fetchUser(pid, priority: 2);
            if (u != null) {
              _knownUsers.add(u);
              loadedUids.add(pid);
              debugPrint('[FaceRepo] ✅ P2 (Linked): ${u.name}');
            }
          }
        }
      } catch (e) {
        debugPrint('[FaceRepo] Linked patients fetch error: $e');
      }
    }

    // PRIORITY 3 — Baaki registered users (limit tak)
    final remaining =
        FaceRecognitionConfig.maxUsersToFetch - _knownUsers.length;
    if (remaining > 0) {
      debugPrint(
        '[FaceRepo] Fetching $remaining more users from collection...',
      );
      try {
        final snap = await _db
            .collection('users')
            .where('profileImageUrl', isNull: false)
            .limit(remaining + loadedUids.length)
            .get();

        for (final doc in snap.docs) {
          if (loadedUids.contains(doc.id)) continue;
          if (_knownUsers.length >= FaceRecognitionConfig.maxUsersToFetch) {
            break;
          }

          final data = doc.data();
          final name = data['name'] as String? ?? 'Unknown';
          final imageUrl = data['profileImageUrl'] as String?;
          if (imageUrl == null || imageUrl.isEmpty) continue;

          _knownUsers.add(
            _KnownUser(
              uid: doc.id,
              name: name,
              imageUrl: imageUrl,
              priority: 3,
            ),
          );
          loadedUids.add(doc.id);
          debugPrint('[FaceRepo] ✅ P3 (Other): $name');
        }
      } catch (e) {
        debugPrint('[FaceRepo] Other users fetch error: $e');
      }
    }

    // Sort by priority
    _knownUsers.sort((a, b) => a.priority.compareTo(b.priority));

    debugPrint('\n══════════════════════════════════════');
    debugPrint('[FaceRepo] 🎯 Total loaded: ${_knownUsers.length} users');
    for (final u in _knownUsers) {
      debugPrint('[FaceRepo]   P${u.priority} → ${u.name} (${u.uid})');
    }
    debugPrint('══════════════════════════════════════\n');
  }

  Future<_KnownUser?> _fetchUser(String uid, {required int priority}) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;

      final data = doc.data()!;
      final name = data['name'] as String? ?? 'Unknown';
      final imageUrl = data['profileImageUrl'] as String?;

      if (imageUrl == null || imageUrl.isEmpty) {
        debugPrint('[FaceRepo] ⚠️ No profile image for: $name');
        return null;
      }

      return _KnownUser(
        uid: uid,
        name: name,
        imageUrl: imageUrl,
        priority: priority,
      );
    } catch (e) {
      debugPrint('[FaceRepo] _fetchUser error for $uid: $e');
      return null;
    }
  }

  Future<FaceMatchResult> findBestMatch(String capturedImagePath) async {
    if (_knownUsers.isEmpty) {
      debugPrint('[FaceRepo] ⚠️ No known users loaded!');
      return FaceMatchResult.noMatch();
    }

    debugPrint('\n──────────────────────────────────────');
    debugPrint('[FaceRepo] 🔍 Starting face matching...');
    debugPrint('[FaceRepo] Comparing against ${_knownUsers.length} users');
    debugPrint('──────────────────────────────────────');

    FaceMatchResult bestResult = FaceMatchResult.noMatch();

    for (int i = 0; i < _knownUsers.length; i++) {
      final user = _knownUsers[i];
      debugPrint(
        '[FaceRepo] [${i + 1}/${_knownUsers.length}] Checking: ${user.name}...',
      );

      final confidence = await _apiService.compareUrlWithFile(
        profileImageUrl: user.imageUrl,
        capturedImagePath: capturedImagePath,
      );

      if (confidence == -2.0) {
        debugPrint('[FaceRepo] 📷 No face in camera frame — stopping early');
        debugPrint('──────────────────────────────────────\n');
        return FaceMatchResult.noFaceInFrame(); // ← naya factory
      }

      if (confidence < 0) {
        debugPrint('[FaceRepo]   → Profile image error, skip');
        continue;
      }

      debugPrint(
        '[FaceRepo]   → ${user.name}: ${confidence.toStringAsFixed(1)}%'
        '${confidence >= FaceRecognitionConfig.matchThreshold ? " ✅ MATCH!" : ""}',
      );

      if (confidence > bestResult.confidence) {
        bestResult = FaceMatchResult(
          userId: user.uid,
          userName: user.name,
          confidence: confidence,
        );

        // High confidence — early exit
        if (confidence >= 85.0) {
          debugPrint('[FaceRepo] 🎯 High confidence! Stopping early.');
          break;
        }
      }
    }

    debugPrint('──────────────────────────────────────');
    if (bestResult.isMatch) {
      debugPrint(
        '[FaceRepo] 🏆 BEST MATCH: ${bestResult.userName} (${bestResult.confidenceLabel})',
      );
    } else {
      debugPrint('[FaceRepo] ❌ NO MATCH (best: ${bestResult.confidenceLabel})');
    }
    debugPrint('──────────────────────────────────────\n');

    return bestResult;
  }

  void clear() => _knownUsers.clear();
}
