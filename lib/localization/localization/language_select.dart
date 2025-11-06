import 'package:freshbite/localization/language_model.dart';

class LanguageSelect {
  static const String LANGUAGE_CODE = 'language_code';
  static const String COUNTRY_CODE = 'country_code';

  static List<LanguageModel> languages = [
    LanguageModel(
        languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(
        languageName: 'Deutsch', countryCode: 'DE', languageCode: 'de'),
  ];
}