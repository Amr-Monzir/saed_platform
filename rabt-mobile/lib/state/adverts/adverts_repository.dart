import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/advert.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/state/auth/auth_providers.dart';
import 'package:rabt_mobile/util/parse_helpers.dart';
import 'paginated_adverts.dart';

class AdvertsRepository {
  AdvertsRepository(this.ref);
  final Ref ref;

  Future<PaginatedAdverts> fetchAll({Map<String, String>? query}) async {
    final token = ref.read(authControllerProvider).value?.token;
    final uri = Uri.parse('${ref.read(apiServiceProvider).baseUrl}/api/v1/adverts').replace(queryParameters: query);
    final resp = await http.get(uri, headers: ref.read(apiServiceProvider).authHeaders(token));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    List<Advert> data;
    int totalPages;
    data = (json['items'] as List<dynamic>).map((e) => Advert.fromJson(e as Map<String, dynamic>)).toList();
    totalPages = (json['total_pages'] as num).toInt();
    return PaginatedAdverts(items: data, totalPages: totalPages);
  }

  Future<PaginatedAdverts> fetchMine() async {
    final token = ref.read(authControllerProvider).value?.token ?? '';
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/adverts?owner=me', headers: ref.read(apiServiceProvider).authHeaders(token));
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    List<Advert> data;
    int totalPages;
    data = (json['items'] as List<dynamic>).map((e) => Advert.fromJson(e as Map<String, dynamic>)).toList();
    totalPages = (json['total_pages'] as num).toInt();
    return PaginatedAdverts(items: data, totalPages: totalPages);
  }

  Future<Advert?> getById(int id) async {
    final token = ref.read(authControllerProvider).value?.token;
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/adverts/$id', headers: ref.read(apiServiceProvider).authHeaders(token));
    return parseObject(resp, (e) => Advert.fromJson(e));
  }

  Future<Advert?> create(Advert advert, {File? imageFile}) async {
    final token = ref.read(authControllerProvider).value?.token;
    final advertData = advert.toJson();

    final resp = await ref
        .read(apiServiceProvider)
        .postMultipart(
          '/api/v1/adverts',
          {"advert_data_json": jsonEncode(advertData)},
          files: {if (imageFile != null) "image_file": imageFile},
          headers: ref.read(apiServiceProvider).authHeaders(token),
          contentType: 'image/${imageFile?.path.split('.').last}',
        );
    return parseObject(resp, (e) => Advert.fromJson(e));
  }

  Future<void> close(int id) async {
    final token = ref.read(authControllerProvider).value?.token;
    await ref
        .read(apiServiceProvider)
        .post('/api/v1/adverts/$id/close', {}, headers: ref.read(apiServiceProvider).authHeaders(token));
  }
}

final advertsRepositoryProvider = Provider<AdvertsRepository>((ref) => AdvertsRepository(ref));
