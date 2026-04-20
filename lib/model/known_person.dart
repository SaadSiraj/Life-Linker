class KnownPerson {
  final String id;
  final String name;
  final PersonRelationship relationship;
  final String? phoneNumber;
  final String? notes;
  final String? photoUrl;
  final String? localPhotoPath;
  final List<String> faceEmbeddingIds;
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