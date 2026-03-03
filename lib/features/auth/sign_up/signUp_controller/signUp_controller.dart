import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/features/subscription/subscription_screen.dart';
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

  // Error message observables for user-friendly feedback
  RxString nameError = ''.obs;
  RxString emailError = ''.obs;
  RxString phoneError = ''.obs;
  RxString passwordError = ''.obs;
  RxString confirmPasswordError = ''.obs;
  RxString termsError = ''.obs;

  // Clear all errors
  void clearErrors() {
    nameError.value = '';
    emailError.value = '';
    phoneError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    termsError.value = '';
  }

  // Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  // Validate phone number (allows + prefix and 8-15 digits)
  bool _isValidPhone(String phone) {
    // Remove + prefix for length check
    final digitsOnly = phone.replaceAll('+', '');
    if (digitsOnly.length < 8 || digitsOnly.length > 15) return false;
    return RegExp(r"^\+?[0-9]{8,15}$").hasMatch(phone);
  }

  void toggleTerms(bool? value) {
    isTermsAccepted.value = value ?? false;
    if (isTermsAccepted.value) {
      termsError.value = '';
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  /// 🚀 Register API
  Future<void> registerUser() async {
    clearErrors();

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    bool hasError = false;

    // Validate name
    if (name.isEmpty) {
      nameError.value = 'Please enter your full name';
      hasError = true;
    } else if (name.length < 2) {
      nameError.value = 'Name must be at least 2 characters';
      hasError = true;
    }

    // Validate email
    if (email.isEmpty) {
      emailError.value = 'Please enter your email address';
      hasError = true;
    } else if (!_isValidEmail(email)) {
      emailError.value = 'Please enter a valid email address';
      hasError = true;
    }

    // Validate phone
    if (phone.isEmpty) {
      phoneError.value = 'Please enter your phone number';
      hasError = true;
    } else if (!_isValidPhone(phone)) {
      phoneError.value = 'Phone number must be 8-15 digits';
      hasError = true;
    }

    // Validate password
    if (password.isEmpty) {
      passwordError.value = 'Please create a password';
      hasError = true;
    } else if (password.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      hasError = true;
    }

    // Validate confirm password
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      hasError = true;
    } else if (password != confirmPassword) {
      confirmPasswordError.value = 'Passwords do not match. Please try again.';
      hasError = true;
    }

    // Validate terms acceptance
    if (!isTermsAccepted.value) {
      termsError.value = 'Please accept Terms & Conditions to continue';
      hasError = true;
    }

    if (hasError) return;

    isLoading.value = true;

    try {
      // Prepare request body
      final body = {
        "fullName": name,
        "email": email,
        "phoneNumber": phone,
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

        Get.offAll(() => SubscriptionScreen());
      } else {
        final errorMessage = responseData["message"] ?? "Registration failed.";
        print("❌ Registration failed: $errorMessage");

        // Handle validation errors from backend
        if (responseData["errorSource"] != null && responseData["errorSource"] is List) {
          final errorSource = responseData["errorSource"] as List;
          for (var error in errorSource) {
            final path = error["path"]?.toString().toLowerCase() ?? '';
            final message = error["message"]?.toString() ?? 'Invalid input';

            if (path.contains('phone')) {
              phoneError.value = 'Phone number must be 8-15 digits';
            } else if (path.contains('email')) {
              emailError.value = message;
            } else if (path.contains('password')) {
              passwordError.value = message;
            } else if (path.contains('name')) {
              nameError.value = message;
            }
          }
        }
        // Show user-friendly error based on backend response
        else if (errorMessage.toLowerCase().contains('email') &&
            (errorMessage.toLowerCase().contains('exist') ||
             errorMessage.toLowerCase().contains('already') ||
             errorMessage.toLowerCase().contains('taken'))) {
          emailError.value = 'This email is already registered. Please use a different email or login.';
        } else if (errorMessage.toLowerCase().contains('phone') &&
                   (errorMessage.toLowerCase().contains('exist') ||
                    errorMessage.toLowerCase().contains('already'))) {
          phoneError.value = 'This phone number is already registered.';
        } else if (errorMessage.toLowerCase().contains('password')) {
          passwordError.value = errorMessage;
        } else {
          emailError.value = 'Registration failed. Please try again later.';
        }
      }
    } catch (e) {
      print("❌ Register error: $e");
      emailError.value = 'Unable to connect. Please check your internet connection.';
    } finally {
      isLoading.value = false;
    }
  }
}
