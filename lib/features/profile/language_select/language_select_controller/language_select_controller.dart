import 'package:flutter/material.dart';
import 'package:freshbite/localization/localization/localization_controller.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  final LocalizationController _localizationController = Get.find<LocalizationController>();

  /// Available languages
  final languages = ['de', 'en'];

  /// Selected language (temporary selection before confirm)
  final selectedLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with current app language
    selectedLanguage.value = _localizationController.locale.languageCode;
  }

  void selectLanguage(String langCode) {
    selectedLanguage.value = langCode;
  }

  Future<void> confirmLanguage() async {
    // Apply the language using LocalizationController
    if (selectedLanguage.value == 'en') {
      await _localizationController.setLanguage(const Locale('en', 'US'));
    } else {
      await _localizationController.setLanguage(const Locale('de', 'DE'));
    }

    Get.back();
  }
}
