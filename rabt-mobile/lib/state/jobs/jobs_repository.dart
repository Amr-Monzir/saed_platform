import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/advert.dart';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import '../auth/auth_providers.dart';
import 'paginated_adverts.dart';

class AdvertsRepository {
  AdvertsRepository(this._ref);

  final Ref _ref;
  final ApiService _api = ApiService.instance;

  Future<PaginatedAdverts> fetchAll({Map<String, String>? query}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final uri = Uri.parse('${_api.baseUrl}/api/v1/adverts').replace(queryParameters: query);
    final resp = await http.get(uri, headers: _api.authHeaders(token));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    List<AdvertResponse> data;
    int totalPages;
    data = (json['items'] as List<dynamic>).map((e) => AdvertResponse.fromJson(e as Map<String, dynamic>)).toList();
    totalPages = (json['total_pages'] as num).toInt();
    return PaginatedAdverts(items: data, totalPages: totalPages);
  }

  Future<List<AdvertResponse>> fetchMine() async {
    final token = _ref.read(authControllerProvider).session?.token ?? '';
    final resp = await _api.get('/api/v1/adverts?owner=me', headers: _api.authHeaders(token));
    final data = jsonDecode(resp.body) as List<dynamic>;
    return data.map((e) => AdvertResponse.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AdvertResponse?> getById(int id) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.get('/api/v1/adverts/$id', headers: _api.authHeaders(token));
    return AdvertResponse.fromJson(jsonDecode(resp.body));
  }

  Future<AdvertResponse> create(AdvertResponse advert) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.post('/api/v1/adverts', advert.toJson(), headers: _api.authHeaders(token));
    return AdvertResponse.fromJson(jsonDecode(resp.body));
  }

  Future<void> close(int id) async {
    final token = _ref.read(authControllerProvider).session?.token;
    await _api.post('/api/v1/adverts/$id/close', {}, headers: _api.authHeaders(token));
  }
}

final advertsRepositoryProvider = Provider<AdvertsRepository>((ref) => AdvertsRepository(ref));
