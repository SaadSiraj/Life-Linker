// people_models.dart
// Shared data models and API service for the People module.

import 'dart:io';

// ─── Model ─────────────────────────────────────────────────────────────────

enum PersonRelationship {
  family,
  friend,
  caregiver,
  doctor,
  neighbour,
  other;

  String get label {
    switch (this) {
      case PersonRelationship.family:
        return 'Family';
      case PersonRelationship.friend:
        return 'Friend';
      case PersonRelationship.caregiver:
        return 'Caregiver';
      case PersonRelationship.doctor:
        return 'Doctor';
      case PersonRelationship.neighbour:
        return 'Neighbour';
      case PersonRelationship.other:
        return 'Other';
    }
  }

  String get emoji {
    switch (this) {
      case PersonRelationship.family:
        return '👨‍👩‍👧';
      case PersonRelationship.friend:
        return '🤝';
      case PersonRelationship.caregiver:
        return '🩺';
      case PersonRelationship.doctor:
        return '👨‍⚕️';
      case PersonRelationship.neighbour:
        return '🏠';
      case PersonRelationship.other:
        return '👤';
    }
  }
}

class KnownPerson {
  final String id;
  final String name;
  final PersonRelationship relationship;
  final String? phoneNumber;
  final String? notes;
  final String? photoUrl;      // remote URL (from backend)
  final String? localPhotoPath; // local file path (newly picked, not yet uploaded)
  final List<String> faceEmbeddingIds; // IDs of registered face vectors
  final DateTime createdAt;
  final DateTime updatedAt;

  const KnownPerson({
    required this.id,
    required this.name,
    required this.relationship,
    this.phoneNumber,
    this.notes,
    this.photoUrl,
    this.localPhotoPath,
    this.faceEmbeddingIds = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasFaceRegistered => faceEmbeddingIds.isNotEmpty;

  KnownPerson copyWith({
    String? name,
    PersonRelationship? relationship,
    String? phoneNumber,
    String? notes,
    String? photoUrl,
    String? localPhotoPath,
    List<String>? faceEmbeddingIds,
  }) {
    return KnownPerson(
      id: id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
      faceEmbeddingIds: faceEmbeddingIds ?? this.faceEmbeddingIds,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

// ─── Face Recognition Result ───────────────────────────────────────────────

class FaceRecognitionResult {
  final bool faceDetected;
  final bool matched;
  final String? matchedPersonId;
  final double? confidence; // 0.0 – 1.0
  final String? errorMessage;

  const FaceRecognitionResult({
    required this.faceDetected,
    this.matched = false,
    this.matchedPersonId,
    this.confidence,
    this.errorMessage,
  });
}

// ─── Mock API Service ──────────────────────────────────────────────────────
// Replace all methods with real HTTP calls to your backend.

class PeopleApiService {
  // In-memory store for demo
  static final List<KnownPerson> _store = [
    KnownPerson(
      id: '1',
      name: 'Sarah Adeola',
      relationship: PersonRelationship.family,
      phoneNumber: '+234 801 234 5678',
      notes: 'Daughter. Visits every Sunday.',
      faceEmbeddingIds: ['emb_001', 'emb_002'],
      createdAt: DateTime(2024, 1, 10),
      updatedAt: DateTime(2024, 6, 1),
    ),
    KnownPerson(
      id: '2',
      name: 'Dr. Chidi Okafor',
      relationship: PersonRelationship.doctor,
      phoneNumber: '+234 802 987 6543',
      notes: 'Neurologist. Appointments on Thursdays.',
      faceEmbeddingIds: ['emb_003'],
      createdAt: DateTime(2024, 2, 5),
      updatedAt: DateTime(2024, 5, 20),
    ),
    KnownPerson(
      id: '3',
      name: 'Emeka Nwosu',
      relationship: PersonRelationship.friend,
      phoneNumber: '+234 803 456 7890',
      notes: 'Old colleague. Plays chess together.',
      faceEmbeddingIds: [],
      createdAt: DateTime(2024, 3, 15),
      updatedAt: DateTime(2024, 3, 15),
    ),
    KnownPerson(
      id: '4',
      name: 'Nurse Amaka',
      relationship: PersonRelationship.caregiver,
      phoneNumber: '+234 804 321 0987',
      notes: 'Morning caregiver shift.',
      faceEmbeddingIds: ['emb_004'],
      createdAt: DateTime(2024, 4, 1),
      updatedAt: DateTime(2024, 4, 1),
    ),
  ];

  static Future<List<KnownPerson>> fetchPeople() async {
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO: GET /api/people
    return List.unmodifiable(_store);
  }

  static Future<KnownPerson> addPerson(KnownPerson person) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // TODO: POST /api/people  { name, relationship, phone, notes, photo }
    _store.add(person);
    return person;
  }

  static Future<KnownPerson> updatePerson(KnownPerson person) async {
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO: PUT /api/people/:id
    final idx = _store.indexWhere((p) => p.id == person.id);
    if (idx != -1) _store[idx] = person;
    return person;
  }

  static Future<void> deletePerson(String id) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: DELETE /api/people/:id
    _store.removeWhere((p) => p.id == id);
  }

  /// Upload a face photo and register face embeddings.
  /// Returns the embedding ID on success.
  static Future<String> registerFace({
    required String personId,
    required File imageFile,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    // TODO: POST /api/people/:id/faces  multipart/form-data { image }
    // Returns { embeddingId: "emb_xxx" }
    final embId = 'emb_${DateTime.now().millisecondsSinceEpoch}';
    final idx = _store.indexWhere((p) => p.id == personId);
    if (idx != -1) {
      final updated = _store[idx].copyWith(
        faceEmbeddingIds: [..._store[idx].faceEmbeddingIds, embId],
      );
      _store[idx] = updated;
    }
    return embId;
  }

  /// Run face recognition on a captured frame.
  static Future<FaceRecognitionResult> recognizeFace({
    required File imageFile,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    // TODO: POST /api/recognize  multipart/form-data { image }
    // Returns { faceDetected, matched, matchedPersonId, confidence }
    return const FaceRecognitionResult(
      faceDetected: true,
      matched: true,
      matchedPersonId: '1',
      confidence: 0.94,
    );
  }

  static Future<void> deleteFaceEmbedding({
    required String personId,
    required String embeddingId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: DELETE /api/people/:personId/faces/:embeddingId
    final idx = _store.indexWhere((p) => p.id == personId);
    if (idx != -1) {
      final updated = _store[idx].copyWith(
        faceEmbeddingIds: _store[idx]
            .faceEmbeddingIds
            .where((e) => e != embeddingId)
            .toList(),
      );
      _store[idx] = updated;
    }
  }
}