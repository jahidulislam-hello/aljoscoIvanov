import 'dart:async';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxString profileImage = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString joinedDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));

    } finally {
      isLoading.value = false;
    }
  }
}