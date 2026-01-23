
import 'package:flutter/material.dart';
import 'package:freshbite/features/profile/profile_settings/profile_settings_service/profile_settings_service.dart';
import 'package:freshbite/features/profile/settings/settings_screen/settings_screen.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsController extends GetxController {
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

    // Fetch profile data on initialization
    fetchProfile();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final response = await ProfileSettingsService.getMyProfile();

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        // Set profile data
        fullNameController.text = data['fullName'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phoneNumber']?.toString() ?? '';
        profileImage.value = data['profileImage'] ?? '';

        // Split name into first and last
        List<String> nameParts = (data['fullName'] ?? '').trim().split(" ");
        firstName.value = nameParts.isNotEmpty ? nameParts[0] : "";
        lastName.value = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";

        email.value = data['email'] ?? '';
        phone.value = data['phoneNumber']?.toString() ?? '';
      }
    } catch (e) {
      print('Error fetching profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile data',
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
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 80,
      );
      if (image != null) {
        profileImage.value = image.path;
        debugPrint("Picked image: ${image.path}");
      }
    } catch (e) {
      debugPrint("Image pick error: $e");
      Get.snackbar(
        'Error',
        'Failed to pick image',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      // Validate inputs
      if (fullNameController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter your name',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (phoneController.text.trim().isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter your phone number',
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Call API to update profile
      final response = await ProfileSettingsService.updateProfile(
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        profileImagePath: profileImage.value.isNotEmpty && !profileImage.value.startsWith('http')
            ? profileImage.value
            : null,
      );

      if (response['success'] == true) {
        // Update local values
        List<String> nameParts = fullNameController.text.trim().split(" ");
        firstName.value = nameParts.isNotEmpty ? nameParts[0] : "";
        lastName.value = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
        phone.value = phoneController.text.trim();

        Get.snackbar(
          "Success",
          response['message'] ?? "Profile updated successfully!",
          colorText: Colors.white,
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Exit editing mode
        isEditing.value = false;

        // Refresh profile data
        await fetchProfile();
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void openSettings() {
    Get.to(() => SettingsScreen());
  }
}
