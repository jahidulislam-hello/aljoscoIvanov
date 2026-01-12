import 'package:get/get.dart';

class LanguageController extends GetxController {
  /// Available languages
  final languages = ['de', 'en'];

  /// Selected language
  final selectedLanguage = 'en'.obs;

  void selectLanguage(String langCode) {
    selectedLanguage.value = langCode;
  }

  void confirmLanguage() {
    // TODO: Save to SharedPreferences / API
    // Example:
    // Get.updateLocale(Locale(selectedLanguage.value));

    Get.back(); // or navigate as needed
  }
}
