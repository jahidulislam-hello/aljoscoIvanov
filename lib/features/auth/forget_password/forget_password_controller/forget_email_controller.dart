import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/features/auth/forget_password/forget_password_Screen/forget_otp_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordController extends GetxController {
  /// Controller for the email input
  final emailController = TextEditingController();
  var isLoading = false.obs;

  /// Dispose the controller when the screen is closed
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  /// Forgot Password API
  Future<void> forgetPass() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      print("❌ Email is required");
      return;
    }

    isLoading.value = true;

    try {
      final body = {
        "email": email,
      };

      print("📤 Sending forget password request: $body");

      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/auth/forget-password"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);
      print("📥 Forget password response: ${response.body}");

      if (response.statusCode == 200 && responseData["success"] == true) {
        final verificationToken = responseData["verificationToken"];

        print("✅ OTP sent to $email");
        print("✅ Verification Token: $verificationToken");

        // Navigate to OTP screen with email and token
        Get.to(() => ForgotPasswordOtpScreen(
          email: email,
          verificationToken: verificationToken,
        ));
      } else {
        final errorMessage = responseData["message"] ?? "Failed to send OTP.";
        print("❌ Forget password failed: $errorMessage");
      }
    } catch (e) {
      print("❌ Forget password error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
