import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lifelinker/core/config/face_recognition_config.dart';

class FaceApiService {
  static final FaceApiService _instance = FaceApiService._internal();
  factory FaceApiService() => _instance;
  FaceApiService._internal();
  // face_api_service.dart

  Future<double> compareUrlWithFile({
    required String profileImageUrl,
    required String capturedImagePath,
  }) async {
    try {
      final capturedBytes = await File(capturedImagePath).readAsBytes();
      final capturedBase64 = base64Encode(capturedBytes);

      final resizedUrl = _resizeCloudinaryUrl(profileImageUrl);

      debugPrint('[FaceAPI] Comparing: ${resizedUrl.substring(0, 50)}...');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(FaceRecognitionConfig.compareEndpoint),
      );

      request.fields['api_key'] = FaceRecognitionConfig.apiKey;
      request.fields['api_secret'] = FaceRecognitionConfig.apiSecret;
      request.fields['image_url1'] = resizedUrl;
      request.fields['image_base64_2'] = capturedBase64;

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 12),
      );

      final responseBody = await streamedResponse.stream.bytesToString();
      final json = jsonDecode(responseBody) as Map<String, dynamic>;

      debugPrint('[FaceAPI] Raw: $responseBody');

      // ✅ Confidence mila — proper match
      if (json.containsKey('confidence')) {
        final confidence = (json['confidence'] as num).toDouble();
        debugPrint('[FaceAPI] Confidence: $confidence');
        return confidence;
      }

      // ❌ faces2 empty — camera frame mein face nahi hai
      // Yeh SPECIAL case hai — -2.0 return karo taaki repo samjhe
      final faces2 = json['faces2'] as List?;
      if (faces2 != null && faces2.isEmpty) {
        debugPrint('[FaceAPI] ⚠️ No face in camera frame — stop comparing');
        return -2.0; // Special: camera mein face nahi
      }

      if (json.containsKey('error_message')) {
        final error = json['error_message'] as String;
        debugPrint('[FaceAPI] API Error: $error');
        if (error.contains('FACE_NOT_FOUND') ||
            error.contains('NO_FACE_FOUND')) {
          return 0.0;
        }
      }

      return -1.0;
    } on SocketException {
      debugPrint('[FaceAPI] Network error');
      return -1.0;
    } catch (e) {
      debugPrint('[FaceAPI] Error: $e');
      return -1.0;
    }
  }

  // Cloudinary image resize — IMAGE_FILE_TOO_LARGE fix
  String _resizeCloudinaryUrl(String url) {
    if (!url.contains('cloudinary.com')) return url;
    if (url.contains('/upload/w_')) return url; // already resized
    return url.replaceFirst(
      '/image/upload/',
      '/image/upload/w_300,h_300,c_fill,f_jpg,q_70/',
    );
  }
}
