import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_providers.dart';
import '../../theme/theme_providers.dart';

class VolunteerProfileController {
  VolunteerProfileController(this._prefs);
  final SharedPreferences _prefs;

  String _key(String token) => 'profile_${token}_completed';

  bool isCompleted(String token) => _prefs.getBool(_key(token)) ?? false;

  Future<void> saveCompleted(String token) async {
    await _prefs.setBool(_key(token), true);
  }
}

final volunteerProfileControllerProvider = Provider<VolunteerProfileController>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return VolunteerProfileController(prefs);
});

final volunteerProfileCompletedProvider = Provider<bool>((ref) {
  final session = ref.watch(authControllerProvider).session;
  if (session == null) return false;
  final prefs = ref.watch(sharedPrefsProvider);
  final key = 'profile_${session.token}_completed';
  return prefs.getBool(key) ?? false;
});


