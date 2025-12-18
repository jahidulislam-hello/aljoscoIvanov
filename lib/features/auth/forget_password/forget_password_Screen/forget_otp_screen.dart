import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/auth/forget_password/forget_password_controller/forget_otp_controller.dart';
import 'package:get/get.dart';



class ForgotPasswordOtpScreen extends StatelessWidget {
  final String email;
  final String verificationToken;

  ForgotPasswordOtpScreen({
    super.key,
    required this.email,
    required this.verificationToken,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize controller with email and token
    final controller = Get.put(
      ForgotPasswordOtpController(
        userEmail: email,
        token: verificationToken,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              /// AppBar with back arrow and centered title
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                  ),
                  const Text(
                    "Verify Code",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),


              /// Image
              Center(
                child: Image.asset(
                  AppImages.forgetPass,
                  width: 94,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 36),

              /// Email info
              Center(
                child: Obx(() => Text(
                  "We sent a reset link to ${controller.email.value}\nEnter 6 digit code from email",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                )),
              ),

              const SizedBox(height: 32),

              /// OTP input boxes
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    return Obx(() {
                      final isFilled = controller.otpDigits[index].isNotEmpty;
                      return Container(
                        width: 48.w,
                        height: 57.h,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isFilled ? const Color(0xFF0071E9) : Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: TextField(
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontSize: 22, color: Colors.black),
                            decoration: const InputDecoration(counterText: '', border: InputBorder.none),
                            onChanged: (val) {
                              controller.updateDigit(index, val);
                              if (val.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              } else if (index == 5) {
                                FocusScope.of(context).unfocus();
                              }
                            },
                          ),
                        ),
                      );
                    });
                  }),
                ),
              ),

              const SizedBox(height: 24),

              /// Resend OTP section
              Align(
                alignment: Alignment.centerRight,
                child: Obx(() {
                  if (controller.secondsRemaining.value == 0) {
                    return GestureDetector(
                      onTap: controller.resendCode,
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    );
                  } else {
                    final seconds = controller.secondsRemaining.value;
                    final timerText = "00:${seconds.toString().padLeft(2, '0')}";
                    return RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14),
                        children: [
                          const TextSpan(
                            text: 'Resend OTP ',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: timerText,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
              ),

              const SizedBox(height: 32),

              /// Verify button
              SizedBox(
                width: double.infinity,
                child: CustomTextButton(
                  text: "Verify OTP",
                  onTap: controller.verifyOtp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
