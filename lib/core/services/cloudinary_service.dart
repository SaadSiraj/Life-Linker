import 'dart:io';

import 'package:cloudinary/cloudinary.dart';

class CloudinaryService {
  static final cloudinary = Cloudinary.signedConfig(
    apiKey: "361287153134522",
    apiSecret: "1iTLiUk9zFQEeKC4CZC3SD79Bhk",
    cloudName: 'dx2np2u8j',
  );

  static Future<String?> uploadImage(String path) async {
    try {
      final fileName = path.split('/').last;

      final response = await cloudinary.upload(
        file: path,
        fileBytes: File(path).readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: 'lifelinker/images',
        fileName: fileName,
        progressCallback: (count, total) {
          print('Uploading: $count/$total');
        },
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      }
      return null;
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  static Future<String?> uploadImageToFolder({
    required String path,
    required List<int> fileBytes,
    required String folder,
    required String fileName,
  }) async {
    try {
      final response = await cloudinary.upload(
        file: path,
        fileBytes: fileBytes,
        resourceType: CloudinaryResourceType.image,
        folder: folder,
        fileName: fileName,
        progressCallback: (count, total) {
          print('Uploading: $count/$total');
        },
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      }
      return null;
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  static Future<List<String>> uploadMultipleImages(List<File> files) async {
    List<String> urls = [];
    for (var file in files) {
      final url = await uploadImage(file.path);
      if (url != null) {
        urls.add(url);
      }
    }
    return urls;
  }

  static Future<String?> uploadAudio(String path) async {
    try {
      final fileName = path.split('/').last;

      final response = await cloudinary.upload(
        file: path,
        fileBytes: File(path).readAsBytesSync(),
        resourceType: CloudinaryResourceType.video, // Audio uses video resourceType in Cloudinary API usually, or auto. Using auto is safer.
        folder: 'lifelinker/audio',
        fileName: fileName,
        progressCallback: (count, total) {
          print('Uploading Audio: $count/$total');
        },
      );

      if (response.isSuccessful) {
        return response.secureUrl;
      }
      return null;
    } catch (e) {
      print('Cloudinary audio upload error: $e');
      return null;
    }
  }
}
