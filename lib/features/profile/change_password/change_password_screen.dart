
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
            title: "Change Password",
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


                const Text("Old Password",
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
                SizedBox(height: 6),

                CustomTextField(
                  controller: controller.fullNameController,
                  hintText: "Enter your Old Password",
                  isEnabled: controller.isEditing.value,
                ),


                SizedBox(height: 16),


                const Text("New Password",
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
                SizedBox(height: 6),

                CustomTextField(
                  controller: controller.phoneController,
                  hintText: "Enter your New Password",
                  isEnabled: controller.isEditing.value,
                ),

                SizedBox(height: 16),


                const Text(" Confirm New Password",
                    style: TextStyle(color: Colors.black45, fontSize: 14)),
                SizedBox(height: 6),

                CustomTextField(
                  controller: controller.emailController,
                  hintText: "Enter your Confirm New Password",
                  isEnabled: false,
                  readOnly: true,
                ),

                SizedBox(height: 100),


                Obx(() => CustomTextButton(
                  text: controller.isEditing.value
                      ? "Update Password"
                      : "Edit Password",
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
