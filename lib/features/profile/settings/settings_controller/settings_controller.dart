import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freshbite/features/profile/profile_settings/profile_settings_screen/profile_settings_screen.dart';
import 'package:freshbite/features/profile/settings/settings_screen/settings_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SettingsController extends GetxController {
  var isEditing = false.obs;

  // Observables
  RxBool isLoading = false.obs;
  RxString profileImage = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;


  // TextEditingControllers
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;


  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();


  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.onClose();
  }



  void pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600, // Resize
        maxHeight: 600,
        imageQuality: 80,
      );
      if (image != null) {
        profileImage.value = image.path;
        debugPrint("Picked image: ${image.path}");
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
    }
  }
  void updateProfile() {
    // Split full name
    List<String> nameParts = fullNameController.text.trim().split(" ");
    firstName.value = nameParts.isNotEmpty ? nameParts[0] : "";
    lastName.value = nameParts.length > 1 ? nameParts[1] : "";

    // Update values locally
    phone.value = phoneController.text.trim();
    email.value = emailController.text.trim();


    // Optional snackbar (dummy success)
    Get.snackbar(
      "Success",
      "Profile updated!",
      colorText: Colors.white,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
    );
  }


  void openSettings() {
    // Navigate to settings screen
    // Get.toNamed('/settings');
    Get.to(()=> ProfileSettingsScreen());

  }



}