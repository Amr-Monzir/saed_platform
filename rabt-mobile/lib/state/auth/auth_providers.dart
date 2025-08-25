import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/models/session.dart';
import 'package:rabt_mobile/state/organizer/organizer_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'auth_repository.dart';

part 'auth_providers.g.dart';

@riverpod
class AuthController extends _$AuthController {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<SessionData?> build() async => await restoreSession();

  static const String _sessionKey = 'session';

  Future<SessionData?> restoreSession() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final session = SessionData.fromJson(map);
    state = AsyncData(session);
    return session;
  }

  Future<bool> signup({required String email, required String password, required UserType type}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final fakeToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
    final session = SessionData(token: fakeToken, userType: type);
    await _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
    state = AsyncData(session);
    return true;
  }

  Future<bool> loginWithBackend({required String email, required String password, required UserType type}) async {
    final token = await ref.read(authRepositoryProvider).login(email: email, password: password);

    var session = SessionData(token: token.accessToken, userType: type, refreshToken: token.refreshToken);
    if (type == UserType.organizer) {
      final profile = await ref.read(organizerRepositoryProvider).fetchOrganizerProfile(token.accessToken);
      session = SessionData(
        token: token.accessToken, 
        userType: UserType.organizer, 
        organizerProfile: profile,
        refreshToken: token.refreshToken,
      );
    }

    await _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
    state = AsyncData(session);
    return true;
  }

  Future<bool> refreshToken() async {
    final currentSession = state.value;
    if (currentSession?.refreshToken == null) return false;

    try {
      final newToken = await ref.read(authRepositoryProvider).refreshToken(
        refreshToken: currentSession!.refreshToken!,
      );

      // Create new session with refreshed token
      var newSession = SessionData(
        token: newToken.accessToken,
        userType: currentSession.userType,
        refreshToken: newToken.refreshToken ?? currentSession.refreshToken,
        pendingAdvertId: currentSession.pendingAdvertId,
      );

      // If organizer, fetch profile again
      if (currentSession.userType == UserType.organizer) {
        final profile = await ref.read(organizerRepositoryProvider).fetchOrganizerProfile(newToken.accessToken);
        newSession = SessionData(
          token: newToken.accessToken,
          userType: UserType.organizer,
          organizerProfile: profile,
          refreshToken: newToken.refreshToken ?? currentSession.refreshToken,
          pendingAdvertId: currentSession.pendingAdvertId,
        );
      }

      await _storage.write(key: _sessionKey, value: jsonEncode(newSession.toJson()));
      state = AsyncData(newSession);
      return true;
    } catch (e) {
      // Refresh failed, clear session
      await logout();
      return false;
    }
  }

  Future<void> setPendingAdvert(String? advertId) async {
    final session = state.value;
    if (session == null) return;
    final updated = SessionData(token: session.token, userType: session.userType, pendingAdvertId: advertId);
    await _storage.write(key: _sessionKey, value: jsonEncode(updated.toJson()));
    state = AsyncData(updated);
  }

  Future<void> logout() async {
    await _storage.delete(key: _sessionKey);
    state = const AsyncData(null);
  }
}

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());
