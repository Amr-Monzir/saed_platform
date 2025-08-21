import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/advert.dart';
import '../../models/organizer.dart';
import '../../models/skill.dart';
import '../../models/enums.dart';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../auth/auth_providers.dart';
import 'paginated_adverts.dart';

abstract class AdvertsDataSource {
  Future<PaginatedAdverts> listAll({Map<String, String>? query});
  Future<List<AdvertResponse>> listMine(String ownerToken);
  Future<AdvertResponse?> getById(int id);
  Future<AdvertResponse> create(AdvertResponse advert);
  Future<void> close(int id);
}

class AdvertsApiDataSource implements AdvertsDataSource {
  final ApiService _api;
  final Ref _ref;
  AdvertsApiDataSource(this._ref, this._api);

  @override
  Future<AdvertResponse> create(AdvertResponse advert) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.post('/api/v1/adverts', advert.toJson(), headers: _api.authHeaders(token));
    return AdvertResponse.fromJson(jsonDecode(resp.body));
  }

  @override
  Future<void> close(int id) async {
    final token = _ref.read(authControllerProvider).session?.token;
    await _api.post('/api/v1/adverts/$id/close', {}, headers: _api.authHeaders(token));
  }

  @override
  Future<AdvertResponse?> getById(int id) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final resp = await _api.get('/api/v1/adverts/$id', headers: _api.authHeaders(token));
    return AdvertResponse.fromJson(jsonDecode(resp.body));
  }

  @override
  Future<PaginatedAdverts> listAll({Map<String, String>? query}) async {
    final token = _ref.read(authControllerProvider).session?.token;
    final uri = Uri.parse('${_api.baseUrl}/api/v1/adverts').replace(queryParameters: query);
    final resp = await http.get(uri, headers: _api.authHeaders(token));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    final data = (json['items'] as List<dynamic>).map((e) => AdvertResponse.fromJson(e as Map<String, dynamic>)).toList();
    final totalPages = (json['total_pages'] as num?)?.toInt() ?? 1;
    return PaginatedAdverts(items: data, totalPages: totalPages);
  }

  @override
  Future<List<AdvertResponse>> listMine(String ownerToken) async {
    final resp = await _api.get('/api/v1/adverts?owner=me', headers: _api.authHeaders(ownerToken));
    final data = jsonDecode(resp.body) as List<dynamic>;
    return data.map((e) => AdvertResponse.fromJson(e as Map<String, dynamic>)).toList();
  }
}

class AdvertsRepository {
  AdvertsRepository(this._ref) : _ds = AdvertsApiDataSource(_ref, ApiService.instance);

  final Ref _ref;
  final AdvertsDataSource _ds;

  Future<PaginatedAdverts> fetchAll({Map<String, String>? query}) => _ds.listAll(query: query);
  Future<List<AdvertResponse>> fetchMine() async {
    final token = _ref.read(authControllerProvider).session?.token ?? '';
    return _ds.listMine(token);
  }

  Future<AdvertResponse?> getById(int id) => _ds.getById(id);
  Future<AdvertResponse> create(AdvertResponse advert) => _ds.create(advert);
  Future<void> close(int id) => _ds.close(id);
}

final advertsRepositoryProvider = Provider<AdvertsRepository>((ref) => AdvertsRepository(ref));
