import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/user.dart';
import 'package:rabt_mobile/services/api_service.dart';

class AuthRepository {
  AuthRepository(this.ref);
  final Ref ref;

  Future<Token> login({required String email, required String password}) async {
    final resp = await ref.read(apiServiceProvider).postForm('/api/v1/auth/login', {'username': email, 'password': password});
    return Token.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<Token> refreshToken({required String refreshToken}) async {
    final resp = await ref.read(apiServiceProvider).postForm('/api/v1/auth/refresh', {
      'refresh_token': refreshToken,
    }, isAuthenticated: false);
    return Token.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository(ref));
