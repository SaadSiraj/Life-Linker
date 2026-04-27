import 'package:cloud_firestore/cloud_firestore.dart';

enum VoiceMessageSender { caregiver, patient }

class VoiceMessageModel {
  final String id;
  final String audioUrl;
  final VoiceMessageSender sender;
  final bool isPlayed;
  final DateTime createdAt;
  final String patientId;
  final String caregiverId;

  const VoiceMessageModel({
    required this.id,
    required this.audioUrl,
    required this.sender,
    required this.isPlayed,
    required this.createdAt,
    required this.patientId,
    required this.caregiverId,
  });

  factory VoiceMessageModel.fromMap(Map<String, dynamic> map, String id) {
    return VoiceMessageModel(
      id: id,
      audioUrl: map['audioUrl'] ?? '',
      sender: map['sender'] == 'caregiver'
          ? VoiceMessageSender.caregiver
          : VoiceMessageSender.patient,
      isPlayed: map['isPlayed'] ?? false,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      patientId: map['patientId'] ?? '',
      caregiverId: map['caregiverId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'audioUrl': audioUrl,
      'sender': sender == VoiceMessageSender.caregiver
          ? 'caregiver'
          : 'patient',
      'isPlayed': isPlayed,
      'createdAt': FieldValue.serverTimestamp(),
      'patientId': patientId,
      'caregiverId': caregiverId,
    };
  }

  VoiceMessageModel copyWith({bool? isPlayed}) {
    return VoiceMessageModel(
      id: id,
      audioUrl: audioUrl,
      sender: sender,
      isPlayed: isPlayed ?? this.isPlayed,
      createdAt: createdAt,
      patientId: patientId,
      caregiverId: caregiverId,
    );
  }
}
