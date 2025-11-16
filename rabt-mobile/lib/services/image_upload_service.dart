import 'dart:io';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';

class ImageUploadService {
  ImageUploadService(this.ref);
  final Ref ref;
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery or camera
  Future<File?> pickImage({bool fromCamera = false}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      return image != null ? File(image.path) : null;
    } catch (e) {
      developer.log('Error picking image: $e', name: 'ImageUploadService');
      return null;
    }
  }

  /// Upload image with category and entity_id (new generic endpoint)
  Future<String?> uploadImageWithCategory(File imageFile, {required String category, String? entityId, String? token}) async {
    try {
      final fields = <String, String>{
        'category': category,
        if (entityId != null) 'entity_id': entityId,
      };

      final headers = token != null && token.isNotEmpty
          ? ref.read(apiServiceProvider).authHeaders(token)
          : null;

      final response = await ref.read(apiServiceProvider).postMultipart(
        '/api/v1/upload/image',
        fields,
        files: {'file': imageFile},
        headers: headers,
        isAuthenticated: token != null && token.isNotEmpty,
      );

      // Parse JSON response to get image URL
      // Expected format: {"url": "https://example.com/image.jpg"}
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['url'] as String?;
    } catch (e) {
      developer.log('Error uploading image with category: $e', name: 'ImageUploadService');
      return null;
    }
  }
}

final imageUploadServiceProvider = Provider((ref) => ImageUploadService(ref));
