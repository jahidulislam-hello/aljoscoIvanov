import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/core/widgets/custom_text_field.dart';
import 'package:freshbite/features/profile/settings/settings_controller/settings_controller.dart';
import 'package:get/get.dart';
import '../../../../core/appbar/custom_appbar.dart';



class SettingsScreen extends StatelessWidget {
  final controller = Get.put(SettingsController());

  SettingsScreen({super.key});

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
            title: 'My Profile'.tr,
            titleStyle: AppTextStyles.heading2,
            showShadow: false,
            showBackButton: true,
            // actionButtons: [
            //   AppBarAction(
            //     icon: Icons.settings_outlined,
            //     onPressed: () => controller.openSettings(),
            //   ),
            // ],
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

                // ============================
                // PROFILE PHOTO
                // ============================
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.purple.shade200,
                        backgroundImage: controller.profileImage.value.isNotEmpty
                            ? (controller.profileImage.value.startsWith('http')
                            ? NetworkImage(controller.profileImage.value)
                            : FileImage(File(controller.profileImage.value))
                        as ImageProvider)
                            : null,
                        child: controller.profileImage.value.isEmpty
                            ? Text(
                          _getInitials(
                              "${controller.firstName.value} ${controller.lastName.value}"),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        )
                            : null,
                      ),

                      if (controller.isEditing.value)
                        Positioned(
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () => controller.pickImage(),
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                // ============================
                // NAME FIELD
                // ============================
                Text("Full Name".tr,
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
                SizedBox(height: 6),

                CustomTextField(
                  controller: controller.fullNameController,
                  hintText: "Full Name".tr,
                  isEnabled: controller.isEditing.value,
                ),


                SizedBox(height: 16),

                // ============================
                // PHONE FIELD
                // ============================
                Text("Phone number".tr,
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
                SizedBox(height: 6),

                CustomTextField(
                  controller: controller.phoneController,
                  hintText: "Phone Number".tr,
                  isEnabled: controller.isEditing.value,
                ),

                SizedBox(height: 16),

                // ============================
                // EMAIL FIELD (READ ONLY)
                // ============================
                Text("Email".tr,
                    style: TextStyle(color: Colors.black45, fontSize: 14)),
                SizedBox(height: 6),

                CustomTextField(
                  controller: controller.emailController,
                  hintText: "Email".tr,
                  isEnabled: false,
                  readOnly: true,
                ),

                SizedBox(height: 100),

                // ============================
                // UPDATE / EDIT BUTTON
                // ============================
                Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.buttonColor,
                      ),
                    );
                  }

                  return CustomTextButton(
                    text: controller.isEditing.value
                        ? "Update".tr
                        : "Edit Profile".tr,
                    onTap: () {
                      if (controller.isEditing.value) {
                        controller.updateProfile();
                      } else {
                        controller.toggleEditMode();
                      }
                    },
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
