import 'package:flutter/material.dart';
import 'package:freshbite/features/auth/forget_password/forget_password_Screen/forget_otp_screen.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  /// Controller for the email input
  final emailController = TextEditingController();

  /// Dispose the controller when the screen is closed
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  /// Placeholder function for "Get OTP" button
  void forgetPass() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.to (()=> ForgotPasswordOtpScreen());

      Get.snackbar(
        'Success',
        'OTP request triggered for $email',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    // For now, just show a snackbar
    Get.snackbar(
      'Success',
      'OTP request triggered for $email',
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.to (()=> ForgotPasswordOtpScreen());
  }
}
