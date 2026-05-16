import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifelinker/core/services/cloudinary_service.dart';
import 'package:lifelinker/core/services/face_api_service.dart';
import 'package:lifelinker/model/user.dart';

class ProfileRepository {
  static final _db = FirebaseFirestore.instance;

  static Future<UserModel> fetchProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) throw Exception('Profile not found');
    return UserModel.fromMap(doc.data()!, uid);
  }

  static Future<UserModel> updateProfile({
    required UserModel user,
    File? newProfileImage,
  }) async {
    String? imageUrl = user.profileImageUrl;

    if (newProfileImage != null) {
      try {
        final bytes = await newProfileImage.readAsBytes();
        imageUrl = await CloudinaryService.uploadImageToFolder(
          path: newProfileImage.path,
          fileBytes: bytes,
          folder: 'lifelinker/profiles',
          fileName: 'profile_${user.uid}',
        );

        if (imageUrl != null) {
          await FaceApiService().indexUserFace(
            userId: user.uid,
            imageUrl: imageUrl,
          );
        }
      } catch (_) {}
    }

    final updated = user.copyWith(profileImageUrl: imageUrl);

    await _db.collection('users').doc(user.uid).update({
      'name': updated.name,
      'phone': updated.phone,
      'dob': updated.dob,
      'condition': updated.condition,
      'bloodGroup': updated.bloodGroup,
      'emergencyContact': updated.emergencyContact,
      'relation': updated.relation,
      'profileImageUrl': updated.profileImageUrl,
    });

    return updated;
  }
}
