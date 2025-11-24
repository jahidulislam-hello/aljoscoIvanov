import 'package:flutter/material.dart';
import 'package:freshbite/core/navbar/navbar/navbar_screen.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/core/widgets/custom_text_field.dart';
import 'package:freshbite/features/auth/sign_in/signin_screen/signin_screen.dart';
import 'package:freshbite/routes/routes.dart';
import 'package:get/get.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/button.dart';

import '../signUp_controller/signUp_controller.dart';

class SignUpScreen extends StatelessWidget {

  final SignUpController controller = Get.put(SignUpController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,


      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),


              /// Title
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 24, color: AppColors.text, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text(
                "Create your account to get started",
                style: TextStyle(fontSize: 16, color: AppColors.mainTextColor, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 60),

              /// Form container
              Column(
                children: [
                  /// Name
                  CustomTextField(
                    controller: controller.nameController,
                    hintText: "Name",
                  ),
                  const SizedBox(height: 16),

                  /// Email
                  CustomTextField(
                    controller: controller.emailController,
                    hintText: "Email",
                    keyboardType: "email",
                  ),
                  const SizedBox(height: 16),

                  /// Phone
                  CustomTextField(
                    controller: controller.phoneController,
                    hintText: "Phone Number",
                    keyboardType: "phone",

                  ),
                  const SizedBox(height: 16),


                  /// Password
                  Obx(
                        () => CustomTextField(
                      controller: controller.passwordController,
                      hintText: "Password",
                      keyboardType: "visiblePassword",

                      suffixSvg: controller.isPasswordHidden.value
                          ? AppImages.passwordOn
                          : AppImages.passwordOff,
                      readOnly: false,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Confirm Password
                  Obx(
                        () => CustomTextField(
                      controller: controller.confirmPasswordController,
                      hintText: "Confirm Password",
                      keyboardType: "visiblePassword",

                      suffixSvg: controller.isPasswordHidden.value
                          ? AppImages.passwordOn
                          : AppImages.passwordOff,
                      readOnly: false,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Terms checkbox
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.black, // border visible on black bg
                    ),
                    child: Obx(
                          () => CheckboxListTile(
                        value: controller.isTermsAccepted.value,
                        onChanged: controller.toggleTerms,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: const EdgeInsets.all(0),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: AppColors.borderSecondary,
                        checkColor: Colors.white,
                        title: RichText(
                          text: const TextSpan(
                            style: TextStyle(color: AppColors.defaultTextColor, fontSize: 14),
                            children: [
                              TextSpan(text: "By creating an account, I accept the", ),
                              TextSpan(
                                text: "Terms & Conditions and Privacy Policy.",
                                style: TextStyle(color: AppColors.mainTextColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Sign Up button
                  CustomTextButton(
                    text: "Sign Up",
                    onTap: () {
                      Get.offAllNamed(AppRoute.bottomNavbar);

                    },
                  ),

                  const SizedBox(height: 24),

                  /// Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 16, color: AppColors.defaultTextColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => LoginScreen());
                        },
                        child:  Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.buttonColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}