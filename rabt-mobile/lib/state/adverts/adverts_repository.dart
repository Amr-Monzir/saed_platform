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
    final resp = await ref.read(apiServiceProvider).get('/api/v1/adverts', query: query);
    try {
      final paginated = parsePaginated(resp, (json) => Advert.fromJson(json));
      return PaginatedAdverts(items: paginated.items, totalPages: paginated.totalPages);
    } on ApiException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<Advert>> fetchMine() async {
    final resp = await ref.read(apiServiceProvider).get('/api/v1/adverts/my-adverts');
    return parseList(resp, (e) => Advert.fromJson(e));
  }

  Future<Advert?> getById(int id) async {
    // ApiService automatically handles optional auth - uses token if available
    final resp = await ref.read(apiServiceProvider).get('/api/v1/adverts/$id');
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
    await ref.read(apiServiceProvider).putMultipart('/api/v1/adverts/$id', {
      'advert_data_json': jsonEncode({'is_active': false}),
    });
  }

  Future<void> publish(int id) async {
    await ref.read(apiServiceProvider).putMultipart('/api/v1/adverts/$id', {
      'advert_data_json': jsonEncode({'is_active': true}),
    });
  }
}

final advertsRepositoryProvider = Provider<AdvertsRepository>((ref) => AdvertsRepository(ref));
