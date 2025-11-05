import 'package:shared_preferences/shared_preferences.dart';

import '../domain/enum/settings_enum.dart';

const String prefsKeyPlanType = 'PREFS_KEY_PLAN_TYPE';
const String prefsKeyLanguage = 'PREFS_KEY_LANG';
const String prefsKeyCountry = 'PREFS_KEY_CONTRY';

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
    await _sharedPreferences.setString(prefsKeyLanguage, country.name);
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
}
