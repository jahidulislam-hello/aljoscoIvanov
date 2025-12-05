import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordOtpController extends GetxController {
  var otpDigits = List<String>.filled(6, '').obs;
  var secondsRemaining = 30.obs;
  var email = 'example@email.com'.obs; // Dummy email for testing
  Timer? _timer;

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

  /// Resend OTP (dummy)
  void resendCode() {
    otpDigits.value = List<String>.filled(6, '');
    startTimer();
    Get.snackbar('Info', 'OTP resent', snackPosition: SnackPosition.BOTTOM);
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
