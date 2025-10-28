import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefsState {
  const UserPrefsState({this.city, this.distanceMiles});
  final String? city;
  final int? distanceMiles;

  UserPrefsState copyWith({String? city, int? distanceMiles}) =>
      UserPrefsState(city: city ?? this.city, distanceMiles: distanceMiles ?? this.distanceMiles);
}

class UserPrefsController extends StateNotifier<UserPrefsState> {
  UserPrefsController(this._prefs) : super(const UserPrefsState()) {
    _load();
  }
  final SharedPreferences _prefs;
  static const _cityKey = 'prefs_city';
  static const _distanceKey = 'prefs_distance';

  void _load() {
    final city = _prefs.getString(_cityKey);
    final dist = _prefs.getInt(_distanceKey);
    state = state.copyWith(city: city, distanceMiles: dist);
  }

  Future<void> setCity(String? city) async {
    state = state.copyWith(city: city);
    if (city == null || city.isEmpty) {
      await _prefs.remove(_cityKey);
    } else {
      await _prefs.setString(_cityKey, city);
    }
  }

  Future<void> setDistance(int? miles) async {
    state = state.copyWith(distanceMiles: miles);
    if (miles == null) {
      await _prefs.remove(_distanceKey);
    } else {
      await _prefs.setInt(_distanceKey, miles);
    }
  }
}
