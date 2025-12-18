import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;

  /// Verification token from OTP verification
  var verificationToken = '';
  var userId = '';

  // Constructor to accept token and userId
  ResetPasswordController({String? token, String? uid}) {
    if (token != null) verificationToken = token;
    if (uid != null) userId = uid;
  }

  @override
  void onInit() {
    super.onInit();
    print("✅ Verification Token received: $verificationToken");
    print("✅ User ID received: $userId");
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  /// Reset password API
  Future<void> resetPassword() async {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      print("❌ Please fill all fields");
      return;
    }

    if (newPass != confirmPass) {
      print("❌ Passwords do not match");
      return;
    }

    if (userId.isEmpty) {
      print("❌ User ID not found");
      return;
    }

    isLoading.value = true;

    try {
      final body = {
        "userId": userId,
        "newPassword": newPass,
      };

      print("📤 Reset password request: $body");
      print("📤 Authorization Token: $verificationToken");

      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/auth/reset-password"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $verificationToken',
        },
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);
      print("📥 Reset password response: ${response.body}");

      if (response.statusCode == 200 && responseData["success"] == true) {
        print("✅ Password reset successful");

        // Navigate to LoginScreen
        Get.offAllNamed('/login');
      } else {
        final errorMessage = responseData["message"] ?? "Failed to reset password.";
        print("❌ Reset password failed: $errorMessage");
      }
    } catch (e) {
      print("❌ Reset password error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
