import 'dart:io';

import 'package:lifelinker/model/face_recongnition.dart';
import 'package:lifelinker/model/known_person.dart';

class PersonsRepository {
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
    // TODO: POST /api/people
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

  static Future<String> registerFace({
    required String personId,
    required File imageFile,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    // TODO: POST /api/people/:id/faces
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

  static Future<FaceRecognitionResult> recognizeFace({
    required File imageFile,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    // TODO: POST /api/recognize
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
        faceEmbeddingIds: _store[idx].faceEmbeddingIds
            .where((e) => e != embeddingId)
            .toList(),
      );
      _store[idx] = updated;
    }
  }
}
