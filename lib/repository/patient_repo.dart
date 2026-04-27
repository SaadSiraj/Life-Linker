import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lifelinker/core/services/cloudinary_service.dart';
import 'package:lifelinker/firebase_options.dart';
import 'package:lifelinker/model/user.dart';

class PatientRepository {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<UserModel>> fetchCaregiverPatients(
    String caregiverId,
  ) async {
    final snap = await _db
        .collection('users')
        .where('caregiverId', isEqualTo: caregiverId)
        .where('role', isEqualTo: 'patient')
        .get();
    return snap.docs.map((d) => UserModel.fromMap(d.data(), d.id)).toList();
  }

  /// Creates a Firebase Auth account for the patient using a secondary
  /// Firebase App instance so the caregiver's session is NEVER touched.
  static Future<UserModel> addPatient({
    required String caregiverId,
    required String name,
    required String email,
    required String password,
    required String? dob,
    required String? phone,
    required String? condition,
    required String? bloodGroup,
    required String? emergencyContact,
    File? profileImage,
  }) async {
    // 1. Initialize a temporary secondary Firebase App.
    //    This runs completely separately from the main app's auth session.
    FirebaseApp? secondaryApp;
    try {
      secondaryApp = await Firebase.initializeApp(
        name: 'patientCreation',
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } on FirebaseException catch (e) {
      // If secondary app already exists (e.g. previous failed attempt), reuse it
      if (e.code == 'duplicate-app') {
        secondaryApp = Firebase.app('patientCreation');
      } else {
        rethrow;
      }
    }

    String patientUid;
    try {
      // 2. Create the patient's auth account on the secondary app
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);
      final patientCred = await secondaryAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      patientUid = patientCred.user!.uid;

      // Sign out from secondary app — we only needed the UID
      await secondaryAuth.signOut();
    } finally {
      // 3. Always delete the secondary app to clean up
      await secondaryApp.delete();
    }

    // Caregiver is still fully signed in on the main app — untouched.

    // 4. Upload profile image
    String? imageUrl;
    if (profileImage != null) {
      try {
        final bytes = await profileImage.readAsBytes();
        imageUrl = await CloudinaryService.uploadImageToFolder(
          path: profileImage.path,
          fileBytes: bytes,
          folder: 'lifelinker/patients',
          fileName: 'patient_$patientUid',
        );
      } catch (_) {}
    }

    // 5. Build the patient UserModel
    final patient = UserModel(
      uid: patientUid,
      name: name.trim(),
      email: email.trim(),
      dob: dob,
      phone: phone,
      profileImageUrl: imageUrl,
      role: UserRole.patient,
      condition: condition?.trim(),
      bloodGroup: bloodGroup?.trim(),
      emergencyContact: emergencyContact?.trim(),
      caregiverId: caregiverId,
      patientIds: const [],
    );

    // 6. Write patient doc + link to caregiver in a single batch
    final batch = _db.batch();
    batch.set(_db.collection('users').doc(patientUid), patient.toMap());
    batch.update(_db.collection('users').doc(caregiverId), {
      'patientIds': FieldValue.arrayUnion([patientUid]),
    });
    await batch.commit();

    return patient;
  }

  static Future<void> updatePatient({
    required UserModel patient,
    File? newProfileImage,
  }) async {
    String? imageUrl = patient.profileImageUrl;
    if (newProfileImage != null) {
      try {
        final bytes = await newProfileImage.readAsBytes();
        imageUrl = await CloudinaryService.uploadImageToFolder(
          path: newProfileImage.path,
          fileBytes: bytes,
          folder: 'lifelinker/patients',
          fileName: 'patient_${patient.uid}',
        );
      } catch (_) {}
    }

    final updated = patient.copyWith(profileImageUrl: imageUrl);
    await _db.collection('users').doc(patient.uid).update(updated.toMap());
  }

  static Future<void> deletePatient({
    required String patientId,
    required String caregiverId,
  }) async {
    final batch = _db.batch();
    batch.delete(_db.collection('users').doc(patientId));
    batch.update(_db.collection('users').doc(caregiverId), {
      'patientIds': FieldValue.arrayRemove([patientId]),
    });
    await batch.commit();
  }

  static String parseAuthError(dynamic e) {
    final msg = e.toString();
    if (msg.contains('email-already-in-use')) {
      return 'This email is already registered';
    }
    if (msg.contains('invalid-email')) {
      return 'Please enter a valid email address';
    }
    if (msg.contains('weak-password')) {
      return 'Password must be at least 6 characters';
    }
    if (msg.contains('network-request-failed')) {
      return 'No internet connection';
    }
    return 'Failed to create patient account. Try again.';
  }
}
