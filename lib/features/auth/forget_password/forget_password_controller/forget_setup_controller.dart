import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  /// 🔐 sessionId passed from OTP verification screen
  var sessionId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get sessionId passed via Get.toNamed() or Get.arguments
    sessionId.value = Get.arguments ?? '';
    print("✅ Session ID received: ${sessionId.value}");
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // /// ✅ Reset Password API Call
  // Future<void> resetPassword() async {
  //   final newPassword = newPasswordController.text.trim();
  //   final confirmPassword = confirmPasswordController.text.trim();
  //
  //   if (newPassword.isEmpty || confirmPassword.isEmpty) {
  //     Get.snackbar("Error", "Please fill in all fields",
  //         snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
  //     return;
  //   }
  //
  //   if (newPassword != confirmPassword) {
  //     Get.snackbar("Error", "Passwords do not match",
  //         snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
  //     return;
  //   }
  //
  //   if (sessionId.value.isEmpty) {
  //     Get.snackbar("Error", "Missing session ID. Please try again.",
  //         snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
  //     return;
  //   }
  //
  //   try {
  //     final url = Uri.parse("https://the_goldensociety.com/auth/reset-password");
  //
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "sessionId": sessionId.value,
  //         "newPassword": newPassword,
  //       }),
  //     );
  //
  //     final json = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && json['code'] == 200) {
  //       Get.snackbar("Success", json['message'] ?? "Password reset successfully",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.green,
  //           colorText: Colors.white);
  //
  //       // Clear input fields
  //       newPasswordController.clear();
  //       confirmPasswordController.clear();
  //
  //       // Navigate to login screen
  //       Future.delayed(const Duration(seconds: 1), () {
  //         Get.offAll(() => const LoginScreen());
  //       });
  //     } else {
  //       Get.snackbar("Error", json['message'] ?? "Failed to reset password",
  //           snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Something went wrong. Please try again.",
  //         snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
  //   }
  // }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}