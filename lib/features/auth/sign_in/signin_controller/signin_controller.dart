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


  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
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
        final errorMessage =
            responseData["message"] ?? "Invalid email or password.";
        print("❌ Login failed: $errorMessage");
      }
    } catch (e) {
      print("❌ Login error: $e");

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