
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/core/widgets/custom_text_field.dart';
import 'package:freshbite/features/profile/change_password/chnage_password_controller.dart';
import 'package:get/get.dart';
import '../../../../core/appbar/custom_appbar.dart';



class ChangePasswordScreen extends StatelessWidget {
  final controller = Get.put(ChangePasswordController());

  ChangePasswordScreen({super.key});

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: SafeArea(
          top: true,
          child: CustomAppBar(
            title: "Change Password".tr,
            titleStyle: AppTextStyles.heading2,
            showShadow: false,
            actionButtons: [
              AppBarAction(
                icon: Icons.settings_outlined,
                onPressed: () => controller.openSettings(),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [



                SizedBox(height: 24),


                Text("Current password".tr,
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
                SizedBox(height: 6),

                CustomTextField(
                  controller: controller.fullNameController,
                  hintText: "Current password".tr,
                  keyboardType: "visiblePassword",
                  isEnabled: controller.isEditing.value,
                ),


                SizedBox(height: 16),


                Text("New password".tr,
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
                SizedBox(height: 6),

                CustomTextField(
                  controller: controller.phoneController,
                  hintText: "New password".tr,
                  keyboardType: "visiblePassword",
                  isEnabled: controller.isEditing.value,
                ),

                SizedBox(height: 16),


                Text("Re-type new password".tr,
                    style: TextStyle(color: Colors.black45, fontSize: 14)),
                SizedBox(height: 6),

                CustomTextField(
                  controller: controller.emailController,
                  hintText: "Re-type new password".tr,
                  keyboardType: "visiblePassword",
                  isEnabled: false,
                  readOnly: true,
                ),

                SizedBox(height: 100),


                Obx(() => CustomTextButton(
                  text: controller.isEditing.value
                      ? "Change Password".tr
                      : "Change Password".tr,
                  onTap: () {
                    if (controller.isEditing.value) {
                      controller.updateProfile();
                    }
                    controller.isEditing.toggle();
                  },
                )),
              ],
            ),
          );
        }),
      ),
    );
  }
}
