import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  ApiException(this.message, this.statusCode);
  final String message;
  final int statusCode;
  @override String toString() => 'ApiException($statusCode): $message';
}

T parseObject<T>(http.Response resp, T Function(Map<String,dynamic>) fromJson) {
  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    final m = jsonDecode(resp.body);
    throw ApiException(m['detail']?.toString() ?? 'API error', resp.statusCode);
  }
  final map = jsonDecode(resp.body) as Map<String, dynamic>;
  return fromJson(map);
}

List<T> parseList<T>(http.Response resp, T Function(Map<String,dynamic>) fromJson, {String? key}) {
  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    final m = jsonDecode(resp.body);
    throw ApiException(m['detail']?.toString() ?? 'API error', resp.statusCode);
  }
  final map = jsonDecode(resp.body) as Map<String, dynamic>;
  final list = map[key ?? 'items'] as List<dynamic>;
  return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
}

class PaginatedResponse<T> {
  PaginatedResponse({
    required this.items,
    required this.totalCount,
    required this.totalPages,
  });

  final List<T> items;
  final int totalCount;
  final int totalPages;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PaginatedResponse<T>(
      items: (json['items'] as List<dynamic>)
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['total_count'] as int,
      totalPages: json['total_pages'] as int,
    );
  }
}

PaginatedResponse<T> parsePaginated<T>(http.Response resp, T Function(Map<String,dynamic>) fromJson) {
  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    final m = jsonDecode(resp.body);
    throw ApiException(m['detail']?.toString() ?? 'API error', resp.statusCode);
  }
  final map = jsonDecode(resp.body) as Map<String, dynamic>;
  return PaginatedResponse.fromJson(map, fromJson);
}