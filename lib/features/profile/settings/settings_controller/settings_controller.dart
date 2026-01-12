import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freshbite/features/profile/profile_settings/profile_settings_screen/profile_settings_screen.dart';
import 'package:freshbite/features/profile/settings/settings_screen/settings_screen.dart';
import 'package:freshbite/features/profile/profile/profile_service/profile_service.dart';
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
    fetchProfile();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.onClose();
  }



  // Fetch profile data from API
  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await ProfileService.getMyProfile();

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        // Update observables
        profileImage.value = data['profileImage'] ?? '';
        email.value = data['email'] ?? '';
        phone.value = data['phoneNumber']?.toString() ?? '';

        // Parse full name
        String fullName = data['fullName'] ?? '';
        List<String> nameParts = fullName.split(' ');
        firstName.value = nameParts.isNotEmpty ? nameParts[0] : '';
        lastName.value = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        // Update text controllers
        fullNameController.text = fullName;
        emailController.text = email.value;
        phoneController.text = phone.value;

        debugPrint("✅ Profile loaded: $fullName");
      }
    } catch (e) {
      debugPrint("❌ Error fetching profile: $e");
      Get.snackbar(
        "Error",
        "Failed to load profile data",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
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
  Future<void> updateProfile() async {
    try {
      // Validate inputs
      if (fullNameController.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Full name is required",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (phoneController.text.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Phone number is required",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      isLoading.value = true;

      // Determine if profileImage is a local path or URL
      String? imagePath;
      if (profileImage.value.isNotEmpty &&
          !profileImage.value.startsWith('http://') &&
          !profileImage.value.startsWith('https://')) {
        imagePath = profileImage.value; // Local path
      }

      // Call API
      final response = await ProfileService.updateProfile(
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        profileImagePath: imagePath,
      );

      if (response['success'] == true) {
        // Update local values
        List<String> nameParts = fullNameController.text.trim().split(" ");
        firstName.value = nameParts.isNotEmpty ? nameParts[0] : "";
        lastName.value = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "";
        phone.value = phoneController.text.trim();

        Get.snackbar(
          "Success",
          response['message'] ?? "Profile updated successfully!",
          colorText: Colors.white,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );

        debugPrint("✅ Profile updated successfully");
        debugPrint("✅ New JWT token received and saved");

        // Refresh profile to get updated data including new profile image
        await fetchProfile();

        // Exit edit mode after successful update
        isEditing.value = false;
      }
    } catch (e) {
      debugPrint("❌ Error updating profile: $e");
      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle edit mode
  void toggleEditMode() {
    isEditing.toggle();
  }


  void openSettings() {
    // Navigate to settings screen
    // Get.toNamed('/settings');
    Get.to(()=> ProfileSettingsScreen());

  }



}