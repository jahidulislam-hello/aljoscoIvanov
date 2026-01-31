import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshbite/core/navbar/navbar/navbar_screen.dart';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isEmailValid = false.obs;
  RxBool isLoading = false.obs;

  // Error message observables for user-friendly feedback
  RxString emailError = ''.obs;
  RxString passwordError = ''.obs;

  // Clear all errors
  void clearErrors() {
    emailError.value = '';
    passwordError.value = '';
  }

  // Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  Future<void> login() async {
    clearErrors();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validate email
    if (email.isEmpty) {
      emailError.value = 'Please enter your email address';
      return;
    }
    if (!_isValidEmail(email)) {
      emailError.value = 'Please enter a valid email address';
      return;
    }

    // Validate password
    if (password.isEmpty) {
      passwordError.value = 'Please enter your password';
      return;
    }
    if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      return;
    }

    isLoading.value = true;

    final body = {
      "email": email,
      "password": password,
    };

    try {
      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/auth/sign-in"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("📤 Login request: $body");
      print("📥 Login response: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["success"] == true) {
        final token = responseData["token"];

        // ✅ Save to SharedPreferences
        await SharedPreferencesHelper.saveUserData(
          token: token,
          userId: email,
          email: email,
          phone: "",
          firstName: "",
          lastName: "",
          fcmToken: "",
        );

        print("✅ Login Success for $email");
        print("✅ Token: $token");

        // ✅ Navigate to home
        Get.offAll(() => BottomNavbar());
      } else {
        final errorMessage = responseData["message"] ?? "Invalid email or password.";
        print("❌ Login failed: $errorMessage");

        // Show user-friendly error based on backend response
        if (errorMessage.toLowerCase().contains('email') ||
            errorMessage.toLowerCase().contains('user not found') ||
            errorMessage.toLowerCase().contains('not exist')) {
          emailError.value = 'No account found with this email. Please check or sign up.';
        } else if (errorMessage.toLowerCase().contains('password') ||
                   errorMessage.toLowerCase().contains('incorrect') ||
                   errorMessage.toLowerCase().contains('invalid')) {
          passwordError.value = 'Incorrect password. Please try again.';
        } else {
          passwordError.value = 'Login failed. Please check your credentials and try again.';
        }
      }
    } catch (e) {
      print("❌ Login error: $e");
      passwordError.value = 'Unable to connect. Please check your internet connection.';
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔁 FORGOT PASSWORD
  Future<void> forgetPass() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {

      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/auth/forgot-password"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      print("📤 Forgot password request: $email");
      print("📥 Forgot password response: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData["code"] == 200) {
        final sessionId = responseData["data"]["sessionId"];
        final expiresAt = responseData["data"]["expiresAt"];


        // ✅ Navigate to OTP Verification Screen (if you have one)
        // Get.to(() => ForgetPasswordVerificationScreen(
        //   sessionId: sessionId,
        //   expiresAt: expiresAt,
        //   email: email,
        // ));
      } else {
        final errorMessage =
            responseData["message"] ?? "Failed to send reset OTP.";

      }
    } catch (e) {
      print("❌ Forgot password error: $e");

    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}