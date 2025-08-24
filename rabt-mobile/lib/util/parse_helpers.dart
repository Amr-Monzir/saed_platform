import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  ApiException(this.message, this.statusCode);
  final String message;
  final int statusCode;
  @override String toString() => 'ApiException($statusCode): $message';
}

T _parseObject<T>(http.Response resp, T Function(Map<String,dynamic>) fromJson) {
  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    final m = jsonDecode(resp.body);
    throw ApiException(m['detail']?.toString() ?? 'API error', resp.statusCode);
  }
  final map = jsonDecode(resp.body) as Map<String, dynamic>;
  return fromJson(map);
}

List<T> _parseList<T>(http.Response resp, T Function(Map<String,dynamic>) fromJson) {
  if (resp.statusCode < 200 || resp.statusCode >= 300) {
    final m = jsonDecode(resp.body);
    throw ApiException(m['detail']?.toString() ?? 'API error', resp.statusCode);
  }
  final list = jsonDecode(resp.body) as List;
  return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
}