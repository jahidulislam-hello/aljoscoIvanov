import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/core/widgets/custom_text_field.dart';
import 'package:freshbite/features/auth/forget_password/forget_password_controller/forget_email_controller.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            /// Custom AppBar with back arrow + centered title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// Back arrow on the left
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  /// Centered title
                  const Text(
                    "Forget Pass",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 62),

            /// Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    /// Image
                    Center(
                      child: Image.asset(
                        AppImages.forgetPass,
                        width: 94,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// Description
                    const Center(
                      child: Text(
                        "Enter email address to reset your password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// Email input
                    CustomTextField(
                      controller: controller.emailController,
                      hintText: "Email",
                      keyboardType: 'email',
                      prefixSvg: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          AppImages.imageIcon,
                          width: 20,
                          height: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Button
                    SizedBox(
                      width: double.infinity,
                      child: CustomTextButton(
                        text: "Send Code",
                        onTap: controller.forgetPass,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
