import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabt_mobile/models/organizer.dart';
import 'package:rabt_mobile/models/user.dart';
import 'package:rabt_mobile/services/api_service.dart';

class AuthRepository {
  AuthRepository(this.ref);
  final Ref ref;

  Future<Token> login({required String email, required String password}) async {
    final resp = await ref.read(apiServiceProvider).postForm('/api/v1/auth/login', {
      'username': email,
      'password': password,
    }, isAuthenticated: false);
    print('login response: ${resp.body}');
    return Token.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }

  Future<bool?> signupVolunteer({
    required String email,
    required String password,
    required List<int> skillIds,
    required String name,
    required String phoneNumber,
  }) async {
    final resp = await ref.read(apiServiceProvider).post('/api/v1/volunteers/register', {
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'password': password,
      'skill_ids': skillIds,
    }, isAuthenticated: false);
    return resp.statusCode == 201;
  }

  Future<bool?> signupOrganizer({
    required String email,
    required String password,
    required OrganizerProfileSignup organizerProfile,
  }) async {
    final resp = await ref.read(apiServiceProvider).post('/api/v1/organizers/register', {
      'email': email,
      'password': password,
      ...organizerProfile.toJson(),
    }, isAuthenticated: false);
    return resp.statusCode == 201;
  }

  Future<Token> refreshToken({required String refreshToken}) async {
    final resp = await ref.read(apiServiceProvider).postForm('/api/v1/auth/refresh', {
      'refresh_token': refreshToken,
    }, isAuthenticated: false);
    return Token.fromJson(jsonDecode(resp.body) as Map<String, dynamic>);
  }
}

final authRepositoryProvider = Provider((ref) => AuthRepository(ref));
