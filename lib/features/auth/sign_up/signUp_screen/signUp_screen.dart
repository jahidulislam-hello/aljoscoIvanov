import 'package:flutter/material.dart';
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
              Text(
                "Sign Up".tr,
                style: const TextStyle(fontSize: 24, color: AppColors.text, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                "Create your account to get started".tr,
                style: const TextStyle(fontSize: 16, color: AppColors.mainTextColor, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 60),

              /// Form container
              Column(
                children: [
                  /// Name
                  Obx(() => CustomTextField(
                    controller: controller.nameController,
                    hintText: "Name".tr,
                    errorText: controller.nameError.value,
                  )),
                  const SizedBox(height: 16),

                  /// Email
                  Obx(() => CustomTextField(
                    controller: controller.emailController,
                    hintText: "Email".tr,
                    keyboardType: "email",
                    errorText: controller.emailError.value,
                  )),
                  const SizedBox(height: 16),

                  /// Phone
                  Obx(() => CustomTextField(
                    controller: controller.phoneController,
                    hintText: "Phone Number".tr,
                    keyboardType: "phone",
                    errorText: controller.phoneError.value,
                  )),
                  const SizedBox(height: 16),


                  /// Password
                  Obx(
                        () => CustomTextField(
                      controller: controller.passwordController,
                      hintText: "Password".tr,
                      keyboardType: "visiblePassword",
                      errorText: controller.passwordError.value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Confirm Password
                  Obx(
                        () => CustomTextField(
                      controller: controller.confirmPasswordController,
                      hintText: "Confirm Password".tr,
                      keyboardType: "visiblePassword",
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
                              text: TextSpan(
                                style: const TextStyle(color: AppColors.defaultTextColor, fontSize: 14),
                                children: [
                                  TextSpan(text: "By creating an account, I accept the".tr),
                                  TextSpan(
                                    text: "Terms & Conditions and Privacy Policy.".tr,
                                    style: const TextStyle(color: AppColors.mainTextColor),
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
                    text: "Sign Up".tr,
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
                        "Already have an account?".tr,
                        style: TextStyle(fontSize: 16, color: AppColors.defaultTextColor),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => LoginScreen());
                        },
                        child:  Text(
                          "Login".tr,
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