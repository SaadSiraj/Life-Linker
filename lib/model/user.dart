import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { patient, caregiver }

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String? profileImageUrl;
  final String? dob;
  final UserRole role;

  // ── Patient-specific ──────────────────────────────────────────────────────
  final String? condition;
  final String? bloodGroup;
  final String? emergencyContact;
  final String? caregiverId; 

  // ── Caregiver-specific ────────────────────────────────────────────────────
  final List<String> patientIds; // linked patients' uids
  final String? relation; 

  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.profileImageUrl,
    this.dob,
    required this.role,
    this.condition,
    this.bloodGroup,
    this.emergencyContact,
    this.caregiverId,
    this.patientIds = const [],
    this.relation,
    this.createdAt,
  });

  // ── fromMap ───────────────────────────────────────────────────────────────
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      profileImageUrl: map['profileImageUrl'],
      dob: map['dob'],
      role: map['role'] == 'caregiver' ? UserRole.caregiver : UserRole.patient,
      condition: map['condition'],
      bloodGroup: map['bloodGroup'],
      emergencyContact: map['emergencyContact'],
      caregiverId: map['caregiverId'],
      patientIds: List<String>.from(map['patientIds'] ?? []),
      relation: map['relation'],
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  // ── toMap ─────────────────────────────────────────────────────────────────
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'dob': dob,
      'role': role == UserRole.caregiver ? 'caregiver' : 'patient',
      'condition': condition,
      'bloodGroup': bloodGroup,
      'emergencyContact': emergencyContact,
      'caregiverId': caregiverId,
      'patientIds': patientIds,
      'relation': relation,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // ── copyWith ──────────────────────────────────────────────────────────────
  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? dob,
    UserRole? role,
    String? condition,
    String? bloodGroup,
    String? emergencyContact,
    String? caregiverId,
    List<String>? patientIds,
    String? relation,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dob: dob ?? this.dob,
      role: role ?? this.role,
      condition: condition ?? this.condition,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      caregiverId: caregiverId ?? this.caregiverId,
      patientIds: patientIds ?? this.patientIds,
      relation: relation ?? this.relation,
      createdAt: createdAt,
    );
  }

  bool get isPatient => role == UserRole.patient;
  bool get isCaregiver => role == UserRole.caregiver;

  String get roleLabel => role == UserRole.caregiver ? 'Caregiver' : 'Patient';
}