import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/advert.dart';
import 'package:rabt_mobile/services/api_service.dart';
import 'package:rabt_mobile/util/parse_helpers.dart';
import 'paginated_adverts.dart';

class AdvertsRepository {
  AdvertsRepository(this.ref);
  final Ref ref;

  Future<PaginatedAdverts> fetchAll({Map<String, String>? query}) async {
    // ApiService automatically handles optional auth - uses token if available
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/adverts', query: query);
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    List<Advert> data;
    int totalPages;
    data = (json['items'] as List<dynamic>).map((e) => Advert.fromJson(e as Map<String, dynamic>)).toList();
    totalPages = (json['total_pages'] as num).toInt();
    return PaginatedAdverts(items: data, totalPages: totalPages);
  }

  Future<List<Advert>> fetchMine() async {
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/adverts/my-adverts');
    return parseList(resp, (e) => Advert.fromJson(e));
  }

  Future<Advert?> getById(int id) async {
    // ApiService automatically handles optional auth - uses token if available
    final resp = await ref
        .read(apiServiceProvider)
        .get('/api/v1/adverts/$id');
    return parseObject(resp, (e) => Advert.fromJson(e));
  }

  Future<Advert?> create(Advert advert, {File? imageFile}) async {
    final advertData = advert.toJson();

    final resp = await ref
        .read(apiServiceProvider)
        .postMultipart(
          '/api/v1/adverts',
          {"advert_data_json": jsonEncode(advertData)},
          files: {if (imageFile != null) "image_file": imageFile},
          contentType: 'image/${imageFile?.path.split('.').last}',
        );
    return parseObject(resp, (e) => Advert.fromJson(e));
  }

  Future<void> close(int id) async {
    await ref
        .read(apiServiceProvider)
        .post('/api/v1/adverts/$id/close', {});
  }
}

final advertsRepositoryProvider = Provider<AdvertsRepository>((ref) => AdvertsRepository(ref));
