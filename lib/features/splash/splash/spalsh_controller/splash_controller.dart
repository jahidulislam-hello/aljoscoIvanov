import 'dart:async';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/localization/localization/localization_controller.dart';
import 'package:freshbite/routes/routes.dart';
import 'package:get/get.dart';


class SplashController extends GetxController {
  var currentSplash = 1.obs;

  @override
  void onInit() {
    super.onInit();
    // Apply saved language when app starts
    Get.find<LocalizationController>().applyLocale();
    startSplashSequence();
  }

  void startSplashSequence() {
    Timer(const Duration(seconds: 2), () {
      currentSplash.value = 2; // Switch to second splash
      Timer(const Duration(seconds: 2), () {
        checkIsLogin(); // Final step: Navigate based on login status
      });
    });
  }

  void checkIsLogin() async {
    // Check if user is already logged in
    bool isLoggedIn = await SharedPreferencesHelper.isLoggedIn();
    String? token = await SharedPreferencesHelper.getAccessToken();

    print("🔍 Checking login status...");
    print("   Is Logged In: $isLoggedIn");
    print("   Token exists: ${token != null}");

    if (isLoggedIn && token != null && token.isNotEmpty) {
      // User is logged in and has a valid token
      print("✅ User is logged in. Navigating to BottomNavbar...");
      Get.offAllNamed(AppRoute.bottomNavbar);
    } else {
      // User is not logged in or token is missing
      print("❌ User is not logged in. Navigating to OnboardingScreen...");
      Get.offAllNamed(AppRoute.onboardingScreen);
    }
  }
}