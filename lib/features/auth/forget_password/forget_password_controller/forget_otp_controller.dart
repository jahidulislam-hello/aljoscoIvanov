import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/features/auth/forget_password/forget_password_Screen/forget_setup_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordOtpController extends GetxController {
  var otpDigits = List<String>.filled(6, '').obs;
  var secondsRemaining = 30.obs;
  var email = ''.obs;
  var verificationToken = '';
  var isLoading = false.obs;
  Timer? _timer;

  // Constructor to accept email and token
  ForgotPasswordOtpController({String? userEmail, String? token}) {
    if (userEmail != null) email.value = userEmail;
    if (token != null) verificationToken = token;
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  /// Start countdown timer for OTP resend
  void startTimer() {
    secondsRemaining.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  /// Check if all 6 OTP digits are entered
  bool isOtpComplete() {
    return otpDigits.every((digit) => digit.isNotEmpty);
  }

  /// Update OTP digit
  void updateDigit(int index, String value) {
    otpDigits[index] = value;
    print("OTP so far: ${otpDigits.join()}");
  }

  /// Get OTP as integer
  String get otp => otpDigits.join();

  /// Verify OTP API
  Future<void> verifyOtp() async {
    if (!isOtpComplete()) {
      print("❌ Please enter complete OTP");
      return;
    }

    isLoading.value = true;

    try {
      final otpCode = int.parse(otp);

      final body = {
        "otpCode": otpCode,
      };

      print("📤 Sending verify OTP request: $body");
      print("📤 Verification Token: $verificationToken");

      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/auth/verify-otp"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $verificationToken',
        },
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);
      print("📥 Verify OTP response: ${response.body}");

      if (response.statusCode == 200 && responseData["success"] == true) {
        print("✅ OTP verified successfully");

        // Extract userId from response
        final userId = responseData["data"]?["userId"] ?? responseData["userId"] ?? "";
        print("✅ User ID: $userId");

        // Navigate to password reset screen
        Get.to(() => ResetPasswordScreen(
          verificationToken: verificationToken,
          userId: userId,
        ));
      } else {
        final errorMessage = responseData["message"] ?? "Invalid OTP.";
        print("❌ OTP verification failed: $errorMessage");
      }
    } catch (e) {
      print("❌ Verify OTP error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Resend OTP by calling forget-password API again
  Future<void> resendCode() async {
    if (email.value.isEmpty) {
      print("❌ Email not found");
      return;
    }

    isLoading.value = true;

    try {
      final body = {
        "email": email.value,
      };

      print("📤 Resending OTP to: ${email.value}");

      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/auth/forget-password"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);
      print("📥 Resend OTP response: ${response.body}");

      if (response.statusCode == 200 && responseData["success"] == true) {
        verificationToken = responseData["verificationToken"];
        otpDigits.value = List<String>.filled(6, '');
        startTimer();

        print("✅ OTP resent to ${email.value}");
        print("✅ New Verification Token: $verificationToken");
      } else {
        final errorMessage = responseData["message"] ?? "Failed to resend OTP.";
        print("❌ Resend OTP failed: $errorMessage");
      }
    } catch (e) {
      print("❌ Resend OTP error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
