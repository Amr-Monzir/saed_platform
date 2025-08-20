import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';

enum UserRole { volunteer, organization }

class SessionData {
  SessionData({required this.token, required this.userRole, this.pendingAdvertId});
  final String token;
  final UserRole userRole;
  final String? pendingAdvertId;

  Map<String, dynamic> toJson() => {
        'token': token,
        'userRole': userRole.name,
        if (pendingAdvertId != null) 'pendingAdvertId': pendingAdvertId,
      };

  static SessionData? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final roleName = json['userRole'] as String?;
    final role = roleName == 'organization' ? UserRole.organization : UserRole.volunteer;
    final token = json['token'] as String?;
    final pending = json['pendingAdvertId'] as String?;
    if (token == null) return null;
    return SessionData(token: token, userRole: role, pendingAdvertId: pending);
  }
}

class AuthState {
  const AuthState({this.session, this.isLoading = false});
  final SessionData? session;
  final bool isLoading;

  AuthState copyWith({SessionData? session, bool? isLoading}) =>
      AuthState(session: session ?? this.session, isLoading: isLoading ?? this.isLoading);
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._storage, this._ref) : super(const AuthState());
  final FlutterSecureStorage _storage;
  final Ref _ref;

  static const String _sessionKey = 'session';

  Future<SessionData?> restoreSession() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null) return null;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final s = SessionData.fromJson(map);
    state = state.copyWith(session: s);
    return s;
  }

  Future<bool> signup({required String email, required String password, required UserRole role}) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 400));
    final fakeToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
    final session = SessionData(token: fakeToken, userRole: role);
    await _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
    state = AuthState(session: session, isLoading: false);
    return true;
  }

  Future<bool> loginQuick(UserRole role) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 200));
    final fakeToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
    final session = SessionData(token: fakeToken, userRole: role);
    await _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
    state = AuthState(session: session, isLoading: false);
    return true;
  }

  Future<bool> loginWithBackend({required String email, required String password}) async {
    try {
      state = state.copyWith(isLoading: true);
      final token = await _ref.read(authRepositoryProvider).login(email: email, password: password);
      final session = SessionData(token: token.accessToken, userRole: UserRole.volunteer);
      await _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
      state = AuthState(session: session, isLoading: false);
      return true;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> setPendingAdvert(String? advertId) async {
    final s = state.session;
    if (s == null) return;
    final updated = SessionData(token: s.token, userRole: s.userRole, pendingAdvertId: advertId);
    await _storage.write(key: _sessionKey, value: jsonEncode(updated.toJson()));
    state = state.copyWith(session: updated);
  }

  Future<void> logout() async {
    await _storage.delete(key: _sessionKey);
    state = const AuthState(session: null, isLoading: false);
  }
}

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthController(storage, ref);
});


