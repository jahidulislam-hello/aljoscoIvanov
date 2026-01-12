import 'package:flutter/material.dart';
import 'package:freshbite/features/auth/sign_in/signin_screen/signin_screen.dart';
import 'package:freshbite/features/profile/delete_account/delete_account_screen/delete_account_screen.dart';
import 'package:freshbite/features/profile/profile_settings/profile_settings_screen/profile_settings_screen.dart';
import 'package:get/get.dart';

class DeleteAccountController extends GetxController {
  // Text controllers
  final passwordController = TextEditingController();

  // Observables
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isEditing = false.obs;

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  /// Show delete account confirmation popup
  void showDeletePopup() {
    // Validate password first
    if (passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your password to confirm",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Show confirmation popup
    Get.dialog(
      DeleteAccountPopUp(
        onDeleteConfirmed: () {
          deleteAccount();
        },
      ),
      barrierDismissible: false,
    );
  }

  /// Delete account after confirmation
  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      final password = passwordController.text.trim();

      // TODO: Call your delete account API here

      await Future.delayed(Duration(seconds: 1));

      // Close the popup
      Get.back();

      // Show success message
      Get.snackbar(
        "Success",
        "Your account has been deleted successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to login screen
      await Future.delayed(Duration(seconds: 1));
      Get.offAll(() => LoginScreen());

    } catch (e) {
      debugPrint("❌ Error deleting account: $e");

      // Close popup if open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void openSettings() {
    Get.to(() => ProfileSettingsScreen());
  }
}
