import 'package:flutter/material.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/core/widgets/custom_text_field.dart';
import 'package:freshbite/features/auth/forget_password/forget_password_controller/forget_setup_controller.dart';
import 'package:get/get.dart';






class ResetPasswordScreen extends StatelessWidget {
  final String verificationToken;
  final String userId;

  ResetPasswordScreen({
    super.key,
    required this.verificationToken,
    this.userId = '',
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // Initialize controller with verificationToken and userId
    final controller = Get.put(
      ResetPasswordController(token: verificationToken, uid: userId),
    );

    return Scaffold(
       backgroundColor: AppColors.background,
       body: SafeArea(
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
           child: Column(
             children: [
               /// AppBar
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
                     "Reset Password",
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

               /// New Password Field
               Obx(() => CustomTextField(
                 controller: controller.newPasswordController,
                 hintText: "Set New Password",
                 keyboardType: "visiblePassword",
                 prefixSvg: AppImages.imageIcon,
                 suffixSvg: controller.isNewPasswordHidden.value
                     ? AppImages.passwordOff
                     : AppImages.passwordOff,
                 onTapSuffix: controller.toggleNewPasswordVisibility,
                 errorText: controller.newPasswordError.value,
               )),

               SizedBox(height: size.height * 0.025), // ✅ fixed

               /// Confirm Password Field
               Obx(() => CustomTextField(
                 controller: controller.confirmPasswordController,
                 hintText: "Confirm New Password",
                 keyboardType: "visiblePassword",
                 prefixSvg: AppImages.imageIcon,
                 suffixSvg: controller.isConfirmPasswordHidden.value
                     ? AppImages.passwordOff
                     : AppImages.passwordOff,
                 onTapSuffix: controller.toggleConfirmPasswordVisibility,
                 errorText: controller.confirmPasswordError.value,
               )),

               const Spacer(),

               /// Submit Button
               Obx(() => CustomTextButton(
                 text: controller.isLoading.value ? "Resetting..." : "Submit Now",
                 onTap: () {
                   if (!controller.isLoading.value) {
                     controller.resetPassword();
                   }
                 },
               )),

               SizedBox(height: size.height * 0.03),
             ],
           ),
         ),
       ),
     );
   }

}