import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lifelinker/core/services/face_api_service.dart';

class FaceIndexService {
  static Future<void> indexAllUsers() async {
    debugPrint('\n[FaceIndex] ══════════════════════════════════');
    debugPrint('[FaceIndex] 🚀 indexAllUsers START');
    debugPrint('[FaceIndex] ══════════════════════════════════');

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      debugPrint('[FaceIndex] ❌ Not authenticated — currentUser is NULL');
      return;
    }

    debugPrint('[FaceIndex] User: ${currentUser.uid}');
    debugPrint('[FaceIndex] Email: ${currentUser.email}');
    debugPrint('[FaceIndex] isAnonymous: ${currentUser.isAnonymous}');

    try {
      final token = await currentUser.getIdToken(true);
      debugPrint('[FaceIndex] ✅ Auth token refreshed');
      debugPrint('[FaceIndex] Token preview: ${token?.substring(0, 30)}...');
    } catch (e) {
      debugPrint('[FaceIndex] ❌ Token refresh failed: $e');
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    debugPrint('\n[FaceIndex] 🔍 Checking AWS collection status...');
    await FaceApiService().debugCheckCollection();

    await Future.delayed(const Duration(seconds: 1));

    final db = FirebaseFirestore.instance;
    final snap = await db.collection('users').get();

    final usersWithImage = snap.docs.where((doc) {
      final imageUrl = doc.data()['profileImageUrl'] as String?;
      return imageUrl != null && imageUrl.isNotEmpty;
    }).toList();

    debugPrint('\n[FaceIndex] Total users: ${snap.docs.length}');
    debugPrint('[FaceIndex] Users with image: ${usersWithImage.length}');

    int successCount = 0;
    int failCount = 0;
    int skippedCount = 0;

    for (int i = 0; i < usersWithImage.length; i++) {
      final doc = usersWithImage[i];
      final data = doc.data();
      final userId = doc.id;
      final name = data['name'] ?? 'Unknown';
      final imageUrl = data['profileImageUrl'] as String;
      final alreadyIndexed = data['faceIndexed'] as bool? ?? false;

      debugPrint(
        '\n[FaceIndex] [${i + 1}/${usersWithImage.length}] $name ($userId)',
      );
      debugPrint('[FaceIndex]   imageUrl: ${imageUrl.substring(0, 60)}...');
      debugPrint('[FaceIndex]   alreadyIndexed: $alreadyIndexed');

      if (alreadyIndexed) {
        debugPrint('[FaceIndex]   ✅ Already indexed — SKIP');
        skippedCount++;
        continue;
      }

      debugPrint('[FaceIndex]   🔄 Indexing...');

      final success = await FaceApiService().indexUserFace(
        userId: userId,
        imageUrl: imageUrl,
      );

      if (success) {
        debugPrint('[FaceIndex]   ✅ Done: $name');
        successCount++;
      } else {
        debugPrint('[FaceIndex]   ❌ Failed: $name');
        failCount++;
      }

      await Future.delayed(const Duration(seconds: 2));
    }

    debugPrint('\n[FaceIndex] ══════════════════════════════════');
    debugPrint('[FaceIndex] 🏁 DONE');
    debugPrint('[FaceIndex]   ✅ Success: $successCount');
    debugPrint('[FaceIndex]   ❌ Failed: $failCount');
    debugPrint('[FaceIndex]   ⏭️ Skipped: $skippedCount');
    debugPrint('[FaceIndex] ══════════════════════════════════\n');

    if (successCount > 0) {
      debugPrint('[FaceIndex] 🔍 Post-indexing collection check:');
      await FaceApiService().debugCheckCollection();
    }
  }

  static Future<void> forceReIndexAllUsers() async {
    debugPrint('\n[FaceIndex] 🔥 FORCE RE-INDEX ALL USERS');

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      debugPrint('[FaceIndex] ❌ Not authenticated');
      return;
    }

    final db = FirebaseFirestore.instance;
    final snap = await db.collection('users').get();

    final batch = db.batch();
    for (final doc in snap.docs) {
      if (doc.data()['profileImageUrl'] != null) {
        batch.update(doc.reference, {'faceIndexed': false});
      }
    }
    await batch.commit();
    debugPrint('[FaceIndex] ✅ Reset all faceIndexed flags');

    await indexAllUsers();
  }
}
