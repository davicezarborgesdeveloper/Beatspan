import 'package:shared_preferences/shared_preferences.dart';

import '../domain/enum/settings_enum.dart';

const String prefsKeyPlanType = 'PREFS_KEY_PLAN_TYPE';
const String prefsKeyLanguage = 'PREFS_KEY_LANG';
const String prefsKeyCountry = 'PREFS_KEY_CONTRY';
const String prefsKeyTurnPhoneEnabled = 'PREFS_KEY_TURN_PHONE_ENABLED';
const String prefsKeyTurnPhoneMode = 'PREFS_KEY_TURN_PHONE_MODE';
const String prefsKeyGameMode = 'PREFS_KEY_GAME_MODE';

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<void> setAppLanguage(LanguageType lang) async {
    await _sharedPreferences.setString(prefsKeyLanguage, lang.name);
  }

  Future<LanguageType?> getAppLanguage() async {
    final lang = _sharedPreferences.getString(prefsKeyLanguage);
    return lang != null ? LanguageType.values.byName(lang) : null;
  }

  Future<void> setAppCountry(CountryType country) async {
    await _sharedPreferences.setString(prefsKeyCountry, country.name);
  }

  Future<CountryType?> getAppCountry() async {
    final country = _sharedPreferences.getString(prefsKeyCountry);
    return country != null ? CountryType.values.byName(country) : null;
  }

  Future<void> setAppPlanType(PlanType plan) async {
    await _sharedPreferences.setString(prefsKeyPlanType, plan.name);
  }

  Future<PlanType?> getAppPlanType() async {
    final plan = _sharedPreferences.getString(prefsKeyPlanType);
    return plan != null ? PlanType.values.byName(plan) : null;
  }

  Future<void> setTurnPhoneEnabled(bool enabled) async {
    await _sharedPreferences.setBool(prefsKeyTurnPhoneEnabled, enabled);
  }

  bool getTurnPhoneEnabled() {
    return _sharedPreferences.getBool(prefsKeyTurnPhoneEnabled) ?? false;
  }

  Future<void> setTurnPhoneMode(TurnPhoneMode mode) async {
    await _sharedPreferences.setString(prefsKeyTurnPhoneMode, mode.name);
  }

  TurnPhoneMode getTurnPhoneMode() {
    final mode = _sharedPreferences.getString(prefsKeyTurnPhoneMode);
    return mode != null
        ? TurnPhoneMode.values.byName(mode)
        : TurnPhoneMode.gyroscope;
  }

  Future<void> setGameMode(GameModeType mode) async {
    await _sharedPreferences.setString(prefsKeyGameMode, mode.name);
  }

  GameModeType getGameMode() {
    final mode = _sharedPreferences.getString(prefsKeyGameMode);
    return mode != null
        ? GameModeType.values.byName(mode)
        : GameModeType.preview;
  }
}
