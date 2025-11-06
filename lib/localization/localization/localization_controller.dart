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

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    _isLtr = _locale.languageCode == 'en';
    saveLanguage(_locale);
    update();
  }

  void loadCurrentLanguage() {
    String languageCode = sharedPreferences.getString(LanguageSelect.LANGUAGE_CODE) ?? 'en';
    String countryCode = sharedPreferences.getString(LanguageSelect.COUNTRY_CODE) ?? 'US';
    _locale = Locale(languageCode, countryCode);
    _isLtr = _locale.languageCode == 'en';
    update();
  }

  void saveLanguage(Locale locale) async {
    await sharedPreferences.setString(LanguageSelect.LANGUAGE_CODE, locale.languageCode);
    await sharedPreferences.setString(LanguageSelect.COUNTRY_CODE, locale.countryCode ?? "");
  }
}