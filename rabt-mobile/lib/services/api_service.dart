import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
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

  Future<http.Response> post(
    String path,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
    Map<String, String>? query,
    bool isAuthenticated = true,
  }) async {
    return isAuthenticated
        ? _makeAuthenticatedRequest(() async {
          final uri = Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}');
          final resp = await http.post(uri, headers: {'Content-Type': 'application/json', ...?headers}, body: jsonEncode(data));
          _throwOnError(resp);
          return resp;
        })
        : await http.post(
          Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}'),
          headers: {'Content-Type': 'application/json', ...?headers},
          body: jsonEncode(data),
        );
  }

  Future<http.Response> postForm(
    String path,
    Map<String, dynamic> fields, {
    Map<String, String>? headers,
    Map<String, String>? query,
    bool isAuthenticated = true,
  }) async {
    return isAuthenticated
        ? _makeAuthenticatedRequest(() async {
          final uri = Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}');
          final resp = await http.post(
            uri,
            headers: {'Content-Type': 'application/x-www-form-urlencoded', ...?headers},
            body: fields,
          );
          _throwOnError(resp);
          return resp;
        })
        : await http.post(
          Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded', ...?headers},
          body: fields,
        );
  }

  Future<http.Response> get(String path, {Map<String, String>? headers, Map<String, String>? query}) async {
    return _makeAuthenticatedRequest(() async {
      final uri = Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}');
      final resp = await http.get(uri, headers: headers);
      _throwOnError(resp);
      return resp;
    });
  }

  Future<http.Response> put(
    String path,
    Map<String, dynamic> data, {
    Map<String, String>? headers,
    Map<String, String>? query,
  }) async {
    return _makeAuthenticatedRequest(() async {
      final uri = Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}');
      final resp = await http.put(uri, headers: {'Content-Type': 'application/json', ...?headers}, body: jsonEncode(data));
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

  Future<http.Response> postMultipart(
    String path,
    Map<String, String> fields, {
    Map<String, File>? files,
    Map<String, String>? headers,
    Map<String, String>? query,
    bool isAuthenticated = true,
    String? contentType,
  }) async {
    makeRequest() async {
      final uri = Uri.parse('$baseUrl$path${query != null ? '?${Uri(queryParameters: query).query}' : ''}');
      final request = http.MultipartRequest('POST', uri);

      request.fields.addAll(fields);

      if (files != null) {
        for (final entry in files.entries) {
          final file = entry.value;
          final stream = http.ByteStream(file.openRead());
          final length = await file.length();
          final multipartFile = http.MultipartFile(
            entry.key,
            stream,
            length,
            filename: file.path.split('/').last,
            contentType: contentType != null ? MediaType.parse(contentType) : null,
          );
          request.files.add(multipartFile);
        }
      }

      if (headers != null) {
        request.headers.addAll(headers);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      _throwOnError(response);
      return response;
    }

    return isAuthenticated ? _makeAuthenticatedRequest(makeRequest) : await makeRequest();
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
