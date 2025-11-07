import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isEmailValid = false.obs;
  RxBool isLoading = false.obs;

  /// ✅ LOGIN API
  // Future<void> login() async {
  //   final email = emailController.text.trim();
  //   final password = passwordController.text.trim();
  //
  //   if (email.isEmpty || password.isEmpty) {
  //     Get.snackbar("Error", "Please fill in all fields.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     return;
  //   }
  //
  //   isLoading.value = true;
  //
  //   final body = {
  //     "email": email,
  //     "password": password,
  //   };
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse("${Urls.baseUrl}/auth/login"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode(body),
  //     );
  //
  //     print("📤 Login request: $body");
  //     print("📥 Login response: ${response.body}");
  //
  //     final responseData = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && responseData["code"] == 200) {
  //       final data = responseData["data"];
  //       final user = data["user"];
  //       final tokens = data["tokens"];
  //
  //       final accessToken = tokens["accessToken"];
  //       final refreshToken = tokens["refreshToken"];
  //       final fullName = user["profile"]["fullName"];
  //       final phone = user["profile"]["phoneNumber"];
  //       final email = user["email"];
  //       final userId = user["_id"];
  //
  //       // ✅ Save to SharedPreferences
  //       await SharedPreferencesHelper.saveUserData(
  //         token: accessToken,
  //         userId: userId,
  //         email: email,
  //         phone: phone,
  //         firstName: fullName,
  //         lastName: "",
  //         fcmToken: refreshToken,
  //       );
  //
  //       Get.snackbar("Success", "Login successful!",
  //           backgroundColor: Colors.green, colorText: Colors.white);
  //
  //       // ✅ Navigate to home
  //       Get.offAll(() => BottomNavbar());
  //     } else {
  //       final errorMessage =
  //           responseData["message"] ?? "Invalid email or password.";
  //       Get.snackbar("Error", errorMessage,
  //           backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     }
  //   } catch (e) {
  //     print("❌ Login error: $e");
  //     Get.snackbar("Error", "Something went wrong. Please try again.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  // /// 🔁 FORGOT PASSWORD
  // Future<void> forgetPass() async {
  //   final email = emailController.text.trim();
  //
  //   if (email.isEmpty) {
  //     Get.snackbar("Error", "Please enter your email address.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     return;
  //   }
  //
  //   isLoading.value = true;
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse("${Urls.baseUrl}/auth/forgot-password"),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"email": email}),
  //     );
  //
  //     print("📤 Forgot password request: $email");
  //     print("📥 Forgot password response: ${response.body}");
  //
  //     final responseData = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && responseData["code"] == 200) {
  //       final sessionId = responseData["data"]["sessionId"];
  //       final expiresAt = responseData["data"]["expiresAt"];
  //
  //       Get.snackbar("Success", responseData["message"],
  //           backgroundColor: Colors.green, colorText: Colors.white);
  //
  //       // ✅ Navigate to OTP Verification Screen (if you have one)
  //       // Get.to(() => ForgetPasswordVerificationScreen(
  //       //   sessionId: sessionId,
  //       //   expiresAt: expiresAt,
  //       //   email: email,
  //       // ));
  //     } else {
  //       final errorMessage =
  //           responseData["message"] ?? "Failed to send reset OTP.";
  //       Get.snackbar("Error", errorMessage,
  //           backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     }
  //   } catch (e) {
  //     print("❌ Forgot password error: $e");
  //     Get.snackbar("Error", "Something went wrong. Please try again.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}