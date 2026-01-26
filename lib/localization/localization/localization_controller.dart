import 'package:flutter/material.dart';
import 'package:freshbite/localization/localization/language_select.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  LocalizationController({
    required this.sharedPreferences,
  }) {
    loadCurrentLanguage();
  }

  Locale _locale = const Locale('en', 'US');
  bool _isLtr = true;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;

  Future<void> setLanguage(Locale locale) async {
    _locale = locale;
    _isLtr = _locale.languageCode == 'en';
    await saveLanguage(_locale);
    Get.updateLocale(locale);
    update();
    debugPrint('🌐 Language changed to: ${locale.languageCode}_${locale.countryCode}');
  }

  void loadCurrentLanguage() {
    String? languageCode = sharedPreferences.getString(LanguageSelect.LANGUAGE_CODE);
    String? countryCode = sharedPreferences.getString(LanguageSelect.COUNTRY_CODE);

    debugPrint('🌐 Raw loaded values - languageCode: $languageCode, countryCode: $countryCode');

    _locale = Locale(languageCode ?? 'en', countryCode ?? 'US');
    _isLtr = _locale.languageCode == 'en';
    debugPrint('🌐 Loaded language: ${_locale.languageCode}_${_locale.countryCode}');
    update();
  }

  /// Call this after GetMaterialApp is ready to apply saved locale
  void applyLocale() {
    Get.updateLocale(_locale);
    debugPrint('🌐 Applied locale: ${_locale.languageCode}_${_locale.countryCode}');
  }

  Future<void> saveLanguage(Locale locale) async {
    bool langSaved = await sharedPreferences.setString(LanguageSelect.LANGUAGE_CODE, locale.languageCode);
    bool countrySaved = await sharedPreferences.setString(LanguageSelect.COUNTRY_CODE, locale.countryCode ?? "");
    debugPrint('🌐 Saved language: ${locale.languageCode}_${locale.countryCode} (langSaved: $langSaved, countrySaved: $countrySaved)');
  }
}