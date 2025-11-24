import 'dart:async';
import 'package:freshbite/features/splash/onboarding/onboarding_screen/onboarding_screen.dart';
import 'package:freshbite/routes/routes.dart';
import 'package:get/get.dart';


class SplashController extends GetxController {
  var currentSplash = 1.obs;

  @override
  void onInit() {
    super.onInit();
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
    Get.offAllNamed(AppRoute.onboardingScreen);
  }
}