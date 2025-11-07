import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;




class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();


  // Future<void> forgetPass() async {
  //   final email = emailController.text.trim();
  //
  //   if (email.isEmpty || !GetUtils.isEmail(email)) {
  //     Get.snackbar("Error", "Please enter a valid email.");
  //     return;
  //   }
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse('${Urls.baseUrl}/auth/forgot-password'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'email': email,
  //       }),
  //     );
  //
  //     print("Response Status: ${response.statusCode}");
  //     print("Response Body: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       Get.snackbar("Success", "Password reset link sent to $email.");
  //       Get.to(() => ForgotPasswordOtpScreen()); // Navigate to OTP screen
  //     } else {
  //       final errorMessage = jsonDecode(response.body)['message'] ?? 'Error occurred. Please try again.';
  //       Get.snackbar("Error", errorMessage);
  //     }
  //   } catch (e) {
  //     print("Error during forgot password API call: $e");
  //     Get.snackbar("Error", "An error occurred. Please try again later.");
  //   }
  // }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}