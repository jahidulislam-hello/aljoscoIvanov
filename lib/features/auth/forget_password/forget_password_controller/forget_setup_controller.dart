import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  /// Dummy sessionId
  var sessionId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    sessionId.value = Get.arguments ?? '';
    print("✅ Session ID received: ${sessionId.value}");
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  /// Dummy reset password logic
  void resetPassword() {
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (newPass != confirmPass) {
      Get.snackbar("Error", "Passwords do not match", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // ✅ Password reset successful (dummy)
    Get.snackbar("Success", "Password reset successful", snackPosition: SnackPosition.BOTTOM);

    // Navigate to LoginScreen
    Get.offAllNamed('/login'); // Make sure your LoginScreen route is '/login'
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

}
