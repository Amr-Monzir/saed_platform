import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
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

  /// Upload image to server and return the URL
  Future<String?> uploadImage(File imageFile, {String? token}) async {
    try {
      final uri = Uri.parse('${ref.read(apiServiceProvider).baseUrl}/api/v1/upload/image');

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add authorization header if token provided
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add the image file
      final stream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();
      final multipartFile = http.MultipartFile('file', stream, length, filename: imageFile.path.split('/').last);
      request.files.add(multipartFile);

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Parse JSON response to get image URL
        // Expected format: {"url": "https://example.com/image.jpg"}
        final Map<String, dynamic> data = jsonDecode(responseBody);
        return data['url'] as String?;
      } else {
        developer.log('Upload failed: ${response.statusCode} - $responseBody', name: 'ImageUploadService');
        return null;
      }
    } catch (e) {
      developer.log('Error uploading image: $e', name: 'ImageUploadService');
      return null;
    }
  }

  /// Upload image with category and entity_id (new generic endpoint)
  Future<String?> uploadImageWithCategory(File imageFile, {required String category, String? entityId, String? token}) async {
    try {
      final uri = Uri.parse('${ref.read(apiServiceProvider).baseUrl}/api/v1/upload/image');

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add authorization header if token provided
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add category field
      request.fields['category'] = category;

      // Add entity_id field if provided
      if (entityId != null) {
        request.fields['entity_id'] = entityId;
      }

      // Add the image file
      final stream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();
      final multipartFile = http.MultipartFile('file', stream, length, filename: imageFile.path.split('/').last);
      request.files.add(multipartFile);

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Parse JSON response to get image URL
        // Expected format: {"url": "https://example.com/image.jpg"}
        final Map<String, dynamic> data = jsonDecode(responseBody);
        return data['url'] as String?;
      } else {
        developer.log('Upload failed: ${response.statusCode} - $responseBody', name: 'ImageUploadService');
        return null;
      }
    } catch (e) {
      developer.log('Error uploading image with category: $e', name: 'ImageUploadService');
      return null;
    }
  }

  /// Upload image bytes (useful for in-memory images)
  Future<String?> uploadImageBytes(Uint8List imageBytes, String filename, {String? token}) async {
    try {
      final uri = Uri.parse('${ref.read(apiServiceProvider).baseUrl}/api/v1/upload/image');

      final request = http.MultipartRequest('POST', uri);

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final multipartFile = http.MultipartFile.fromBytes('file', imageBytes, filename: filename);
      request.files.add(multipartFile);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(responseBody);
        return data['url'] as String?;
      } else {
        developer.log('Upload failed: ${response.statusCode} - $responseBody', name: 'ImageUploadService');
        return null;
      }
    } catch (e) {
      developer.log('Error uploading image bytes: $e', name: 'ImageUploadService');
      return null;
    }
  }

  /// Upload image bytes with category and entity_id (new generic endpoint)
  Future<String?> uploadImageBytesWithCategory(
    Uint8List imageBytes,
    String filename, {
    required String category,
    String? entityId,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('${ref.read(apiServiceProvider).baseUrl}/api/v1/upload/image');

      final request = http.MultipartRequest('POST', uri);

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add category field
      request.fields['category'] = category;

      // Add entity_id field if provided
      if (entityId != null) {
        request.fields['entity_id'] = entityId;
      }

      final multipartFile = http.MultipartFile.fromBytes('file', imageBytes, filename: filename);
      request.files.add(multipartFile);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(responseBody);
        return data['url'] as String?;
      } else {
        developer.log('Upload failed: ${response.statusCode} - $responseBody', name: 'ImageUploadService');
        return null;
      }
    } catch (e) {
      developer.log('Error uploading image bytes with category: $e', name: 'ImageUploadService');
      return null;
    }
  }
}

final imageUploadServiceProvider = Provider((ref) => ImageUploadService(ref));
