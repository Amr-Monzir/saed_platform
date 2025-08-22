import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/advert.dart';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import '../../services/image_upload_service.dart';
import '../auth/auth_providers.dart';
import 'paginated_adverts.dart';

class AdvertsRepository {
  AdvertsRepository(this._ref);

  final Ref _ref;
  final ApiService _api = ApiService.instance;
  final ImageUploadService _imageService = ImageUploadService();

  Future<PaginatedAdverts> fetchAll({Map<String, String>? query}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final uri = Uri.parse('${_api.baseUrl}/api/v1/adverts').replace(queryParameters: query);
    final resp = await http.get(uri, headers: _api.authHeaders(token));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    List<Advert> data;
    int totalPages;
    data = (json['items'] as List<dynamic>).map((e) => Advert.fromJson(e as Map<String, dynamic>)).toList();
    totalPages = (json['total_pages'] as num).toInt();
    return PaginatedAdverts(items: data, totalPages: totalPages);
  }

  Future<PaginatedAdverts> fetchMine() async {
    final token = _ref.read(authControllerProvider).session?.token ?? '';
    final resp = await _api.get('/api/v1/adverts?owner=me', headers: _api.authHeaders(token));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    List<Advert> data;
    int totalPages;
    data = (json['items'] as List<dynamic>).map((e) => Advert.fromJson(e as Map<String, dynamic>)).toList();
    totalPages = (json['total_pages'] as num).toInt();
    return PaginatedAdverts(items: data, totalPages: totalPages);
  }

  Future<Advert?> getById(int id) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.get('/api/v1/adverts/$id', headers: _api.authHeaders(token));
    return Advert.fromJson(jsonDecode(resp.body));
  }

  Future<Advert?> create(Advert advert, {File? imageFile}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    
    if (imageFile != null) {
      // Use generic image upload endpoint for advert images
      final imageUrl = await _imageService.uploadImageWithCategory(
        imageFile,
        category: 'adverts',
        token: token,
      );
      
      if (imageUrl != null) {
        // Add image URL to advert data
        final advertData = advert.toJson();
        advertData['advert_image_url'] = imageUrl;
        
        // Create advert with image URL
        final resp = await _api.post('/api/v1/adverts', advertData, headers: _api.authHeaders(token));
        return Advert.fromJson(jsonDecode(resp.body));
      } else {
        // Image upload failed, create advert without image
        final resp = await _api.post('/api/v1/adverts', advert.toJson(), headers: _api.authHeaders(token));
        return Advert.fromJson(jsonDecode(resp.body));
      }
    } else {
      // Use regular JSON endpoint for advert without image
      final resp = await _api.post('/api/v1/adverts', advert.toJson(), headers: _api.authHeaders(token));
      return Advert.fromJson(jsonDecode(resp.body));
    }
  }

  Future<void> close(int id) async {
    final token = _ref.read(authControllerProvider).session?.token;
    await _api.post('/api/v1/adverts/$id/close', {}, headers: _api.authHeaders(token));
  }
}

final advertsRepositoryProvider = Provider((ref) => AdvertsRepository(ref));
