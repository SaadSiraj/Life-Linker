import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FaceApiService {
  static final FaceApiService _instance = FaceApiService._internal();
  factory FaceApiService() => _instance;
  FaceApiService._internal();

  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<bool> _ensureFreshToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('[FaceAPI] ❌ currentUser is NULL');
        return false;
      }
      await user.getIdToken(true);
      debugPrint('[FaceAPI] ✅ Token refreshed: uid=${user.uid}');
      return true;
    } catch (e) {
      debugPrint('[FaceAPI] ❌ Token refresh failed: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> matchFaceWithAws(
    String capturedImagePath,
  ) async {
    try {
      final imageBytes = await File(capturedImagePath).readAsBytes();
      debugPrint('[FaceAPI] Image size: ${imageBytes.length} bytes');
      final base64Image = base64Encode(imageBytes);

      final callable = _functions.httpsCallable(
        'matchFace',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );
      final result = await callable.call({'imageBase64': base64Image});
      final data = Map<String, dynamic>.from(result.data as Map);
      debugPrint('[FaceAPI] matchFace response: $data');
      return data;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('[FaceAPI] matchFace error: ${e.code} — ${e.message}');
      return {'matched': false, 'noFace': false, 'error': e.message};
    } catch (e) {
      debugPrint('[FaceAPI] matchFace exception: $e');
      return {'matched': false, 'noFace': false, 'error': e.toString()};
    }
  }

  Future<bool> indexUserFace({
    required String userId,
    required String imageUrl,
  }) async {
    debugPrint('[FaceAPI] indexFace called for: $userId');

    await _ensureFreshToken();
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final callable = _functions.httpsCallable(
        'indexFace',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 30)),
      );
      final result = await callable.call({
        'userId': userId,
        'imageUrl': imageUrl,
      });
      final data = Map<String, dynamic>.from(result.data as Map);
      debugPrint('[FaceAPI] indexFace response: $data');
      return data['success'] == true;
    } on FirebaseFunctionsException catch (e) {
      debugPrint('[FaceAPI] ❌ indexFace error: ${e.code} — ${e.message}');
      return false;
    } catch (e) {
      debugPrint('[FaceAPI] ❌ indexFace exception: $e');
      return false;
    }
  }

  Future<void> debugCheckCollection() async {
    debugPrint('[FaceAPI] 🔍 Checking AWS collection status...');
    await _ensureFreshToken();
    try {
      final callable = _functions.httpsCallable(
        'debugCollectionStatus',
        options: HttpsCallableOptions(timeout: const Duration(seconds: 15)),
      );
      final result = await callable.call({});
      final data = Map<String, dynamic>.from(result.data as Map);
      debugPrint('[FaceAPI] 📊 Collection Status: $data');
    } on FirebaseFunctionsException catch (e) {
      debugPrint('[FaceAPI] ❌ debugCheckCollection: ${e.code} — ${e.message}');
    } catch (e) {
      debugPrint('[FaceAPI] ❌ debugCheckCollection: $e');
    }
  }
}

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:lifelinker/core/config/face_recognition_config.dart';

// class FaceApiService {
//   static final FaceApiService _instance = FaceApiService._internal();
//   factory FaceApiService() => _instance;
//   FaceApiService._internal();

//   Future<double> compareUrlWithFile({
//     required String profileImageUrl,
//     required String capturedImagePath,
//   }) async {
//     try {
//       final resizedUrl = _resizeCloudinaryUrl(profileImageUrl);
//       final capturedBytes = await File(capturedImagePath).readAsBytes();
//       final capturedBase64 = base64Encode(capturedBytes);

//       debugPrint('[FaceAPI] Comparing: ${resizedUrl.substring(0, 50)}...');

//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse(FaceRecognitionConfig.compareEndpoint),
//       );
//       request.fields['api_key'] = FaceRecognitionConfig.apiKey;
//       request.fields['api_secret'] = FaceRecognitionConfig.apiSecret;
//       request.fields['image_url1'] = resizedUrl;
//       request.fields['image_base64_2'] = capturedBase64;

//       final streamed = await request.send().timeout(
//         const Duration(seconds: 15),
//       );
//       final body = await streamed.stream.bytesToString();
//       final json = jsonDecode(body) as Map<String, dynamic>;

//       debugPrint('[FaceAPI] Response: $body');

//       // ✅ Case 1: Confidence mila — proper comparison
//       if (json.containsKey('confidence')) {
//         final c = (json['confidence'] as num).toDouble();
//         debugPrint('[FaceAPI] ✅ Confidence: $c');
//         return c;
//       }

//       // ❌ Case 2: faces2 empty — camera mein koi face nahi
//       // Yeh SABSE important check hai
//       final faces2 = json['faces2'];
//       if (faces2 is List && faces2.isEmpty) {
//         debugPrint('[FaceAPI] 📷 Camera frame mein koi face nahi (faces2:[])');
//         return -2.0; // STOP signal
//       }

//       // ⚠️ Case 3: Profile image ka error
//       if (json.containsKey('error_message')) {
//         final err = json['error_message'] as String;
//         debugPrint('[FaceAPI] ⚠️ Error: $err');
//         // Profile image issue — sirf is user ko skip karo
//         return -1.0;
//       }

//       return -1.0;
//     } on SocketException {
//       debugPrint('[FaceAPI] Network error');
//       return -1.0;
//     } catch (e) {
//       debugPrint('[FaceAPI] Exception: $e');
//       return -1.0;
//     }
//   }

//   // Cloudinary URL mein resize transform inject karo
//   String _resizeCloudinaryUrl(String url) {
//     if (!url.contains('cloudinary.com')) return url;
//     if (url.contains('/upload/w_')) return url; // already resized
//     return url.replaceFirst(
//       '/image/upload/',
//       '/image/upload/w_300,h_300,c_fill,f_jpg,q_70/',
//     );
//   }
// }
