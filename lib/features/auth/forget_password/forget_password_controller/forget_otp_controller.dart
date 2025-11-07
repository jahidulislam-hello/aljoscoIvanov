import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;



class ForgotPasswordOtpController extends GetxController {
  var otpDigits = List<String>.filled(6, '').obs;
  var secondsRemaining = 30.obs;
  final otpController = TextEditingController();
  var sessionId = ''.obs;
  Timer? _timer;

  var email = ''.obs;

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
    print("OTP entered so far: ${otpDigits.join()}");
  }

  /// Get combined OTP
  String getOtp() => otpDigits.join();

  /// ✅ Verify OTP API
  // Future<void> verifyOtp() async {
  //   final otp = getOtp();
  //
  //   if (otp.isEmpty || otp.length < 6) {
  //     Get.snackbar("Error", "Please enter a valid 6-digit OTP.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     return;
  //   }
  //
  //   try {
  //     final body = jsonEncode({
  //       "sessionId": sessionId.value,
  //       "otp": otp,
  //     });
  //
  //     print("📤 Sending OTP verify request: $body");
  //
  //     final response = await http.post(
  //       Uri.parse("${Urls.baseUrl}/auth/verify-otp"),
  //       headers: {'Content-Type': 'application/json'},
  //       body: body,
  //     );
  //
  //     final data = jsonDecode(response.body);
  //     print("📥 OTP Verify Response: $data");
  //
  //     if (response.statusCode == 200 && data["code"] == 200) {
  //       Get.snackbar("Success", "Verification successful!",
  //           backgroundColor: Colors.green, colorText: Colors.white);
  //
  //       // Save login state or tokens
  //       await SharedPreferencesHelper.saveToken(sessionId.value);
  //
  //       // ✅ Navigate to Home or Bottom Navbar
  //       Get.offAll(() => ResetPasswordScreen());
  //     } else {
  //       Get.snackbar("Error", data["message"] ?? "Invalid OTP.",
  //           backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to verify OTP.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     print("❌ OTP verification error: $e");
  //   }
  // }
  //
  // /// 🔁 Resend OTP API
  // Future<void> resendCode() async {
  //   if (sessionId.value.isEmpty) {
  //     Get.snackbar("Error", "Missing session ID. Please register again.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     return;
  //   }
  //
  //   startTimer();
  //
  //   try {
  //     final body = jsonEncode({"sessionId": sessionId.value});
  //
  //     print("📤 Resending OTP with body: $body");
  //
  //     final response = await http.post(
  //       Uri.parse("${Urls.baseUrl}/auth/resend-otp"),
  //       headers: {'Content-Type': 'application/json'},
  //       body: body,
  //     );
  //
  //     final data = jsonDecode(response.body);
  //     print("📥 Resend OTP Response: $data");
  //
  //     if (response.statusCode == 200 && data["code"] == 200) {
  //       Get.snackbar("Success", "OTP resent successfully!",
  //           backgroundColor: Colors.green, colorText: Colors.white);
  //     } else {
  //       Get.snackbar("Error", data["message"] ?? "Failed to resend OTP.",
  //           backgroundColor: Colors.redAccent, colorText: Colors.white);
  //     }
  //   } catch (e) {
  //     print("❌ Error during resend OTP: $e");
  //     Get.snackbar("Error", "An error occurred while resending OTP.",
  //         backgroundColor: Colors.redAccent, colorText: Colors.white);
  //   }
  // }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}