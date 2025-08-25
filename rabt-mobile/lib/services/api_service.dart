import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rabt_mobile/state/auth/auth_providers.dart';

enum ApiEnvironment { local, production }

class TokenExpiredException implements Exception {
  final String message;
  TokenExpiredException(this.message);
  
  @override
  String toString() => message;
}

class ApiService {
  ApiService(this.ref);
  final Ref ref;

  String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000';
  ApiEnvironment get env => (dotenv.env['ENV'] == 'local') ? ApiEnvironment.local : ApiEnvironment.production;

  Future<http.Response> post(String path, Map<String, dynamic> data, {Map<String, String>? headers, Map<String, String>? query}) async {
    return _makeAuthenticatedRequest(() async {
      final uri = Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json', ...?headers},
        body: jsonEncode(data),
      );
      _throwOnError(resp);
      return resp;
    });
  }

  Future<http.Response> postForm(String path, Map<String, String> fields, {Map<String, String>? headers, Map<String, String>? query}) async {
    return _makeAuthenticatedRequest(() async {
      final uri = Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}');
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded', ...?headers},
        body: fields,
      );
      _throwOnError(resp);
      return resp;
    });
  }

  Future<http.Response> get(String path, {Map<String, String>? headers, Map<String, String>? query}) async {
    return _makeAuthenticatedRequest(() async {
      final uri = Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}');
      final resp = await http.get(uri, headers: headers);
      _throwOnError(resp);
      return resp;
    });
  }

  Future<http.Response> put(String path, Map<String, dynamic> data, {Map<String, String>? headers, Map<String, String>? query}) async {
    return _makeAuthenticatedRequest(() async {
      final uri = Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}');
      final resp = await http.put(
        uri,
        headers: {'Content-Type': 'application/json', ...?headers},
        body: jsonEncode(data),
      );
      _throwOnError(resp);
      return resp;
    });
  }

  Future<http.Response> delete(String path, {Map<String, String>? headers, Map<String, String>? query}) async {
    return _makeAuthenticatedRequest(() async {
      final uri = Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}');
      final resp = await http.delete(uri, headers: headers);
      _throwOnError(resp);
      return resp;
    });
  }

  Future<http.Response> _makeAuthenticatedRequest(Future<http.Response> Function() request) async {
    try {
      return await request();
    } catch (e) {
      if (e is TokenExpiredException) {
        // Try to refresh the token
        final refreshed = await ref.read(authControllerProvider.notifier).refreshToken();
        if (refreshed) {
          // Retry the original request with new token
          return await request();
        } else {
          // Refresh failed, rethrow the original exception
          rethrow;
        }
      }
      rethrow;
    }
  }

  void _throwOnError(http.Response resp) {
    if (resp.statusCode == 401 || resp.statusCode == 403) {
      throw TokenExpiredException('Token has expired or is invalid');
    }
    if (resp.statusCode >= 400) {
      throw Exception('API error ${resp.statusCode}: ${resp.body}');
    }
  }

  Map<String, String> authHeaders(String? token, {Map<String, String>? extra}) {
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      ...?extra,
    };
  }
}

final apiServiceProvider = Provider((ref) => ApiService(ref));
