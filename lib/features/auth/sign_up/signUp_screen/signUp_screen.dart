import 'package:flutter/material.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/core/widgets/custom_text_field.dart';
import 'package:freshbite/features/auth/sign_in/signin_screen/signin_screen.dart';
import 'package:get/get.dart';
import '../../../../core/themes/app_colors.dart';

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
                  Obx(() => CustomTextField(
                    controller: controller.nameController,
                    hintText: "Name",
                    errorText: controller.nameError.value,
                  )),
                  const SizedBox(height: 16),

                  /// Email
                  Obx(() => CustomTextField(
                    controller: controller.emailController,
                    hintText: "Email",
                    keyboardType: "email",
                    errorText: controller.emailError.value,
                  )),
                  const SizedBox(height: 16),

                  /// Phone
                  Obx(() => CustomTextField(
                    controller: controller.phoneController,
                    hintText: "Phone Number",
                    keyboardType: "phone",
                    errorText: controller.phoneError.value,
                  )),
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
                      errorText: controller.passwordError.value,
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
                      errorText: controller.confirmPasswordError.value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Terms checkbox
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.black, // border visible on black bg
                    ),
                    child: Obx(
                          () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
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
                          if (controller.termsError.value.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                controller.termsError.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Sign Up button
                  CustomTextButton(
                    text: "Sign Up",
                    onTap: () {
                      controller.registerUser();

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