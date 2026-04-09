import 'package:flutter/material.dart';
import 'package:freshbite/features/auth/sign_up/signUp_screen/signUp_screen.dart';
import 'package:get/get.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccountPromptPage extends StatelessWidget {
  const CreateAccountPromptPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320.w,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 120,
              child: Image.asset(
                "assets/images/clipboard.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "To access this feature,\nplease sign up.".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "To enjoy the full functionality of the app, create an account here.".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            /// 🔥 BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.offAll(() => SignUpScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F3D0A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Create Account".tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper method to check if user is guest and show create account prompt
Future<bool> checkGuestAndShowPrompt() async {
  bool isGuest = await SharedPreferencesHelper.isGuest();
  
  if (isGuest) {
    Get.dialog(
      const CreateAccountPromptPage(),
      barrierDismissible: true,
    );
    return true; // Is guest, showed prompt
  }
  
  return false; // Not guest, can continue
}