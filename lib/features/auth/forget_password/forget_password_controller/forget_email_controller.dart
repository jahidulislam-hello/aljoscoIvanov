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

  // Error message observable for user-friendly feedback
  RxString emailError = ''.obs;

  // Clear errors
  void clearErrors() {
    emailError.value = '';
  }

  // Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  /// Dispose the controller when the screen is closed
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  /// Forgot Password API
  Future<void> forgetPass() async {
    clearErrors();

    final email = emailController.text.trim();

    // Validate email
    if (email.isEmpty) {
      emailError.value = 'Please enter your email address';
      return;
    }
    if (!_isValidEmail(email)) {
      emailError.value = 'Please enter a valid email address';
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

        // Show user-friendly error based on backend response
        if (errorMessage.toLowerCase().contains('not found') ||
            errorMessage.toLowerCase().contains('not exist') ||
            errorMessage.toLowerCase().contains('no user')) {
          emailError.value = 'No account found with this email. Please check and try again.';
        } else if (errorMessage.toLowerCase().contains('invalid')) {
          emailError.value = 'Please enter a valid email address';
        } else {
          emailError.value = 'Unable to send reset code. Please try again later.';
        }
      }
    } catch (e) {
      print("❌ Forget password error: $e");
      emailError.value = 'Unable to connect. Please check your internet connection.';
    } finally {
      isLoading.value = false;
    }
  }
}
