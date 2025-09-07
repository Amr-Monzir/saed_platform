import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rabt_mobile/models/enums.dart';
import 'package:rabt_mobile/models/organizer.dart';
import 'package:rabt_mobile/models/session.dart';
import 'package:rabt_mobile/models/user.dart';
import 'package:rabt_mobile/models/volunteer.dart';
import 'package:rabt_mobile/state/organizer/organizer_repository.dart';
import 'package:rabt_mobile/state/volunteer/volunteer_repository.dart';
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

  /// Saves a token to storage and updates the current session
  Future<void> saveTokenToStorage({
    required Token token,
    required UserType userType,
    String? pendingAdvertId,
    OrganizerProfile? organizerProfile,
    VolunteerProfile? volunteerProfile,
  }) async {
    var session = SessionData(
      token: token.accessToken,
      userType: userType,
      refreshToken: token.refreshToken,
      pendingAdvertId: pendingAdvertId,
    );

    session = SessionData(
      token: token.accessToken,
      userType: userType,
      organizerProfile: organizerProfile,
      volunteerProfile: volunteerProfile,
      refreshToken: token.refreshToken,
      pendingAdvertId: pendingAdvertId,
    );

    await _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
  }

  Future<bool> loginWithBackend({required String email, required String password, required UserType type}) async {
    final token = await ref.read(authRepositoryProvider).login(email: email, password: password);

    OrganizerProfile? organizerProfile;
    VolunteerProfile? volunteerProfile;

    if (type == UserType.organizer) {
      organizerProfile = await ref.read(organizerRepositoryProvider).fetchOrganizerProfile(token.accessToken);
    } else if (type == UserType.volunteer) {
      volunteerProfile = await ref.read(volunteerRepositoryProvider).fetchVolunteerProfile(token.accessToken);
    }

    final session = SessionData(
      token: token.accessToken,
      userType: type,
      organizerProfile: organizerProfile,
      volunteerProfile: volunteerProfile,
      refreshToken: token.refreshToken,
    );
    
    await saveTokenToStorage(
      token: token,
      userType: type,
      organizerProfile: organizerProfile,
      volunteerProfile: volunteerProfile,
    );
    state = AsyncData(session);
    return true;
  }

  Future<bool> signupVolunteer({
    required String email,
    required String password,
    required List<int> skillIds,
    required String name,
    required String phoneNumber,
  }) async {
    await ref
        .read(authRepositoryProvider)
        .signupVolunteer(email: email, password: password, skillIds: skillIds, name: name, phoneNumber: phoneNumber);
    return true;
  }

  /// Updates the volunteer profile in the current session
  Future<void> updateVolunteerProfileInSession(VolunteerProfile volunteerProfile) async {
    final session = state.value;
    if (session == null || session.userType != UserType.volunteer) return;

    final token = Token(accessToken: session.token, tokenType: 'Bearer', refreshToken: session.refreshToken);

    await saveTokenToStorage(
      token: token,
      userType: session.userType,
      pendingAdvertId: session.pendingAdvertId,
      volunteerProfile: volunteerProfile,
    );
  }

  Future<bool> signupOrganizer({
    required String email,
    required String password,
    required OrganizerProfileSignup organizerProfile,
  }) async {
    await ref.read(authRepositoryProvider).signupOrganizer(email: email, password: password, organizerProfile: organizerProfile);
    return true;
  }

  Future<bool> refreshToken() async {
    try {
      final currentSession = state.value;
      if (currentSession?.refreshToken == null) throw Exception('No refresh token found');

      final newToken = await ref.read(authRepositoryProvider).refreshToken(refreshToken: currentSession!.refreshToken!);

      OrganizerProfile? organizerProfile;
      VolunteerProfile? volunteerProfile;

      if (currentSession.userType == UserType.organizer) {
        organizerProfile = await ref.read(organizerRepositoryProvider).fetchOrganizerProfile(newToken.accessToken);
      } else if (currentSession.userType == UserType.volunteer) {
        volunteerProfile = await ref.read(volunteerRepositoryProvider).fetchVolunteerProfile(newToken.accessToken);
      }

      await saveTokenToStorage(
        token: newToken,
        userType: currentSession.userType,
        pendingAdvertId: currentSession.pendingAdvertId,
        organizerProfile: organizerProfile,
        volunteerProfile: volunteerProfile,
      );
      return true;
    } catch (e) {
      // Refresh failed, clear session
      await logout();
      return false;
    }
  }

  //for when guest is redirected to signup on clicking apply on advert detail screen
  Future<void> setPendingAdvert(String? advertId) async {
    final session = state.value;
    if (session == null) return;

    final token = Token(accessToken: session.token, tokenType: 'Bearer', refreshToken: session.refreshToken);

    await saveTokenToStorage(
      token: token,
      userType: session.userType,
      pendingAdvertId: advertId,
      organizerProfile: session.organizerProfile,
      volunteerProfile: session.volunteerProfile,
    );
  }

  Future<void> logout() async {
    await _storage.delete(key: _sessionKey);
    state = const AsyncData(null);
  }
}

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());
