import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
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

  /// 🌍 Convert address → lat/lng
  // Future<Map<String, double>> _getLatLngFromAddress(String address) async {
  //   try {
  //     final url =
  //         "https://nominatim.openstreetmap.org/search?q=$address&format=json&limit=1";
  //     final response = await http.get(Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       final List data = jsonDecode(response.body);
  //       if (data.isNotEmpty) {
  //         return {
  //           "latitude": double.parse(data[0]["lat"]),
  //           "longitude": double.parse(data[0]["lon"]),
  //         };
  //       }
  //     }
  //   } catch (e) {
  //     print("❌ Geocoding error: $e");
  //   }
  //   return {"latitude": 0.0, "longitude": 0.0};
  // }
  //
  // /// 🚀 Register API
  // Future<void> registerUser() async {
  //   final name = nameController.text.trim();
  //   final email = emailController.text.trim();
  //   final phone = phoneController.text.trim();
  //   final address = addressController.text.trim();
  //   final password = passwordController.text.trim();
  //   final confirmPassword = confirmPasswordController.text.trim();
  //
  //   if (name.isEmpty ||
  //       email.isEmpty ||
  //       phone.isEmpty ||
  //       address.isEmpty ||
  //       password.isEmpty ||
  //       confirmPassword.isEmpty) {
  //     Get.snackbar("Error", "All fields are required.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     return;
  //   }
  //
  //   if (password != confirmPassword) {
  //     Get.snackbar("Error", "Passwords do not match.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     return;
  //   }
  //
  //   if (!isTermsAccepted.value) {
  //     Get.snackbar("Error", "You must accept the Terms of Service.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     return;
  //   }
  //
  //   isLoading.value = true;
  //
  //   try {
  //     final latLng = await _getLatLngFromAddress(address);
  //
  //     final body = {
  //       "fullName": name,
  //       "email": email,
  //       "password": password,
  //       "phoneNumber": phone,
  //       "location": {
  //         "latitude": latLng["latitude"],
  //         "longitude": latLng["longitude"],
  //       }
  //     };
  //
  //     print("📤 Sending signup data: $body");
  //
  //     final response = await http.post(
  //       Uri.parse("${Urls.baseUrl}/auth/register"),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(body),
  //     );
  //
  //     final responseData = jsonDecode(response.body);
  //     print("📥 Response: ${response.body}");
  //
  //     if (response.statusCode == 201 && responseData["code"] == 201) {
  //       final sessionId = responseData["data"]["sessionId"];
  //       final expiresAt = responseData["data"]["expiresAt"];
  //
  //       Get.snackbar("Success", responseData["message"],
  //           backgroundColor: Colors.green, colorText: Colors.white);
  //
  //       await SharedPreferencesHelper.saveUserData(
  //         token: sessionId,
  //         userId: email,
  //         email: email,
  //         phone: phone,
  //         firstName: name,
  //         lastName: "",
  //         fcmToken: "",
  //       );
  //
  //       print("✅ Registration Success for $email");
  //
  //       // ✅ Navigate to OTP screen with sessionId
  //       Get.offAll(() => SignupVerificationScreen(
  //         sessionId: sessionId,
  //
  //
  //       ));
  //     } else {
  //       final errorMessage = responseData["message"] ?? "Registration failed.";
  //       Get.snackbar("Error", errorMessage,
  //           backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Something went wrong. Please try again.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     print("❌ Register error: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}