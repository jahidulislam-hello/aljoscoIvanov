import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshbite/core/navbar/navbar/navbar_screen.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network_celler/endpoints.dart';


class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordHidden = true.obs;
  var isTermsAccepted = false.obs;
  var isLoading = false.obs;

  void toggleTerms(bool? value) {
    isTermsAccepted.value = value ?? false;
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }




  /// 🚀 Register API
  Future<void> registerUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validate all fields
    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      print("❌ All fields are required");
      return;
    }

    // Validate password match
    if (password != confirmPassword) {
      print("❌ Password and Confirm Password do not match");
      return;
    }

    // Validate terms acceptance
    if (!isTermsAccepted.value) {
      print("❌ Please accept terms and conditions");
      return;
    }

    isLoading.value = true;

    try {
      // Prepare request body
      final body = {
        "fullName": name,
        "email": email,
        "phoneNumber": int.parse(phone),
        "password": password,
      };

      print("📤 Sending signup data: $body");

      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/user/create-user"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);
      print("📥 Response: ${response.body}");

      // Check if registration was successful
      if (response.statusCode == 200 && responseData["success"] == true) {
        final token = responseData["token"];

        await SharedPreferencesHelper.saveUserData(
          token: token,
          userId: email,
          email: email,
          phone: phone,
          firstName: name,
          lastName: "",
          fcmToken: "",
        );

        print("✅ Registration Success for $email");
        print("✅ Token: $token");

        // Navigate to BottomNavbar
        Get.offAll(() => BottomNavbar());
      } else {
        final errorMessage = responseData["message"] ?? "Registration failed.";
        print("❌ Registration failed: $errorMessage");
      }
    } catch (e) {
      print("❌ Register error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
