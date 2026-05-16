import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifelinker/core/services/cloudinary_service.dart';
import 'package:lifelinker/core/services/face_api_service.dart';
import 'package:lifelinker/model/user.dart';

class AuthRepository {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Current user ──────────────────────────────────────────────────────────
  static User? get firebaseUser => _auth.currentUser;
  static bool get isLoggedIn => _auth.currentUser != null;
  static String? get currentUid => _auth.currentUser?.uid;

  // ── Sign Up ───────────────────────────────────────────────────────────────
  static Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
    required String? dob,
    required String? phone,
    required UserRole role,
    File? profileImage,
    // Patient fields
    String? condition,
    String? bloodGroup,
    String? emergencyContact,
    // Caregiver fields
    String? relation,
  }) async {
    // 1. Create Firebase Auth user
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = cred.user!.uid;

    // 2. Upload profile image to Cloudinary if provided
    String? imageUrl;
    if (profileImage != null) {
      try {
        final bytes = await profileImage.readAsBytes();
        imageUrl = await CloudinaryService.uploadImageToFolder(
          path: profileImage.path,
          fileBytes: bytes,
          folder: 'lifelinker/profiles',
          fileName: 'profile_$uid',
        );
      } catch (_) {
        // Image upload failure is non-fatal
      }
    }

    // 3. Build UserModel
    final user = UserModel(
      uid: uid,
      name: name.trim(),
      email: email.trim(),
      phone: phone?.trim().isEmpty == true ? null : phone?.trim(),
      profileImageUrl: imageUrl,
      dob: dob?.trim(),
      role: role,
      condition: condition?.trim(),
      bloodGroup: bloodGroup?.trim(),
      emergencyContact: emergencyContact?.trim(),
      relation: relation?.trim(),
      patientIds: const [],
    );

    // 4. Save to Firestore
    await _db.collection('users').doc(uid).set(user.toMap());
    if (user.profileImageUrl != null) {
      await FaceApiService().indexUserFace(
        userId: user.uid,
        imageUrl: user.profileImageUrl ?? "",
      );
    }
    return user;
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return fetchUser(cred.user!.uid);
  }

  // ── Fetch User ────────────────────────────────────────────────────────────
  static Future<UserModel> fetchUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception('User profile not found');
    }
    return UserModel.fromMap(doc.data()!, uid);
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // ── Update Profile ────────────────────────────────────────────────────────
  static Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toMap());
  }

  // ── Password Reset ────────────────────────────────────────────────────────
  static Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ── Link Caregiver to Patient ─────────────────────────────────────────────
  static Future<void> linkCaregiverToPatient({
    required String patientId,
    required String caregiverId,
  }) async {
    final batch = _db.batch();
    // Set caregiverId on patient
    batch.update(_db.collection('users').doc(patientId), {
      'caregiverId': caregiverId,
    });
    // Add patientId to caregiver's list
    batch.update(_db.collection('users').doc(caregiverId), {
      'patientIds': FieldValue.arrayUnion([patientId]),
    });
    await batch.commit();
  }

  // ── Fetch Caregiver patients ──────────────────────────────────────────────
  static Future<List<UserModel>> fetchPatients(List<String> ids) async {
    if (ids.isEmpty) return [];
    final snaps = await Future.wait(
      ids.map((id) => _db.collection('users').doc(id).get()),
    );
    return snaps
        .where((d) => d.exists)
        .map((d) => UserModel.fromMap(d.data()!, d.id))
        .toList();
  }

  // ── Parse Firebase error messages ─────────────────────────────────────────
  static String parseError(dynamic e) {
    final msg = e.toString();
    if (msg.contains('email-already-in-use')) {
      return 'This email is already registered';
    }
    if (msg.contains('invalid-email')) {
      return 'Please enter a valid email address';
    }
    if (msg.contains('wrong-password') || msg.contains('invalid-credential')) {
      return 'Incorrect email or password';
    }
    if (msg.contains('user-not-found')) {
      return 'No account found with this email';
    }
    if (msg.contains('weak-password')) {
      return 'Password is too weak. Use at least 6 characters';
    }
    if (msg.contains('network-request-failed')) return 'No internet connection';
    if (msg.contains('too-many-requests')) {
      return 'Too many attempts. Please try later';
    }
    return 'Something went wrong. Please try again';
  }
}
