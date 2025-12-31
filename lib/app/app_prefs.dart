import 'package:shared_preferences/shared_preferences.dart';

import '../domain/enum/settings_enum.dart';
import 'secure_storage.dart';

const String prefsKeyPlanType = 'PREFS_KEY_PLAN_TYPE';
const String prefsKeyLanguage = 'PREFS_KEY_LANG';
const String prefsKeyCountry = 'PREFS_KEY_COUNTRY'; // Corrigido typo

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  final SecureStorage _secureStorage;

  AppPreferences(this._sharedPreferences, this._secureStorage);

  Future<void> setAppLanguage(LanguageType lang) async {
    await _sharedPreferences.setString(prefsKeyLanguage, lang.name);
  }

  Future<LanguageType?> getAppLanguage() async {
    final lang = _sharedPreferences.getString(prefsKeyLanguage);
    return lang != null ? LanguageType.values.byName(lang) : null;
  }

  Future<void> setAppCountry(CountryType country) async {
    await _sharedPreferences.setString(prefsKeyLanguage, country.name);
  }

  Future<CountryType?> getAppCountry() async {
    final country = _sharedPreferences.getString(prefsKeyCountry);
    return country != null ? CountryType.values.byName(country) : null;
  }

  // ============================================================================
  // Dados Sensíveis (SecureStorage)
  // ============================================================================

  /// Salva tipo de plano do Spotify (sensível - usa SecureStorage)
  Future<void> setAppPlanType(PlanType plan) async {
    await _secureStorage.savePlanType(plan.name);

    // Migração: Remove do SharedPreferences se existir
    if (_sharedPreferences.containsKey(prefsKeyPlanType)) {
      await _sharedPreferences.remove(prefsKeyPlanType);
    }
  }

  /// Recupera tipo de plano do Spotify (sensível - usa SecureStorage)
  Future<PlanType?> getAppPlanType() async {
    // Tenta ler do SecureStorage primeiro
    String? plan = await _secureStorage.getPlanType();

    // Migração: Se não existir no SecureStorage, tenta SharedPreferences
    if (plan == null) {
      plan = _sharedPreferences.getString(prefsKeyPlanType);
      if (plan != null) {
        // Migra para SecureStorage
        await _secureStorage.savePlanType(plan);
        await _sharedPreferences.remove(prefsKeyPlanType);
      }
    }

    return plan != null ? PlanType.values.byName(plan) : null;
  }

  /// Remove tipo de plano do Spotify
  Future<void> clearAppPlanType() async {
    await _secureStorage.deletePlanType();
    await _sharedPreferences.remove(prefsKeyPlanType);
  }
}
