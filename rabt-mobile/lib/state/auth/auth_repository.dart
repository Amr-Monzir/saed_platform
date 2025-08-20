import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../../models/user.dart';

class AuthRepository {
  AuthRepository(this._ref);
  final Ref _ref;
  final ApiService _api = ApiService.instance;

  Future<Token> login({required String email, required String password}) async {
    final resp = await _api.postForm('/api/v1/auth/login', {
      'username': email,
      'password': password,
    });
    return Token.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref));


