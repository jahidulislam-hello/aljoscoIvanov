
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/terms_condition/about_freshbite.dart';
import 'package:freshbite/features/home/terms_condition/frequently_ask_question.dart';
import 'package:freshbite/features/home/terms_condition/terms_conditions.dart';
import 'package:freshbite/features/profile/change_password/change_password_screen.dart';
import 'package:freshbite/features/profile/delete_account/delete_account_screen/delete_account_screen.dart';
import 'package:freshbite/features/profile/family_members/family_member_screen/family_members_screen.dart';
import 'package:freshbite/features/profile/language_select/language_select/language_select_screen.dart';
import 'package:freshbite/features/profile/profile_settings/profile_settings_controller/profile_settings_controller.dart';
import 'package:freshbite/features/profile/settings/settings_controller/settings_controller.dart';
import 'package:freshbite/features/profile/settings/settings_screen/settings_screen.dart';
import 'package:get/get.dart';

class ProfileSettingsScreen extends StatelessWidget {
  final controller = Get.put(ProfileSettingsController());

  ProfileSettingsScreen({super.key});

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
            title: 'Account Settings',
            titleStyle: AppTextStyles.heading2,
            showShadow: false,

          ),
        ),
      ),

      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                SizedBox(height: 20.h),

                // Settings List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.profile,
                          width: 24,
                          height: 24,
                        ),
                        title: "My Profile",
                        trailingIcon: SvgPicture.asset(
                          AppImages.arrow,
                          width: 24,
                          height: 24,
                        ),
                         onTap: () { Get.to (()=> SettingsScreen());},

                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.profile,
                          width: 24,
                          height: 24,
                        ),
                        title: "Family Members",
                        trailingIcon: SvgPicture.asset(
                          AppImages.arrow,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () { Get.to (()=> FamilyMemberScreen());},

                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.language,
                          width: 24,
                          height: 24,
                        ),
                        title: "Language",
                        trailingIcon: SvgPicture.asset(
                          AppImages.arrow,
                          width: 24,
                          height: 24,
                        ),
                         onTap: () {Get.to (()=> LanguageScreen());},
                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.faq,
                          width: 24,
                          height: 24,
                        ),
                        title: "FAQ",
                        trailingIcon: SvgPicture.asset(
                          AppImages.arrow,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () { Get.to (()=> FrequentlyAskQuestion());},
                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.privacy,
                          width: 24,
                          height: 24,
                        ),
                        title: "Privacy Policy",
                        trailingIcon: SvgPicture.asset(
                          AppImages.arrow,
                          width: 24,
                          height: 24,
                        ),
                         onTap: () {Get.to (()=> AboutUs());},
                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.terms,
                          width: 24,
                          height: 24,
                        ),
                        title: "Terms & Conditions",
                        trailingIcon: SvgPicture.asset(
                          AppImages.arrow,
                          width: 24,
                          height: 24,
                        ),
                         onTap: () { Get.to (()=> TermsConditions());},
                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.change_pass,
                          width: 24,
                          height: 24,
                        ),
                        title: "Change Password",
                        trailingIcon: SvgPicture.asset(
                          AppImages.arrow,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () { Get.to (()=> ChangePasswordScreen());},

                      ),
                      const SizedBox(height: 24),
                      SettingTile(
                        iconWidget: SvgPicture.asset(
                          AppImages.delete,
                          width: 24,
                          height: 24,
                        ),
                        title: "Delete Account",
                        trailingIcon: SvgPicture.asset(
                          AppImages.arrow,
                          width: 24,
                          height: 24,
                        ),
                        onTap: () { Get.to (()=> DeleteAccountScreen());},

                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                const SizedBox(height: 20), // Changed from Spacer() to fixed size

              ],
            ),
          );
        }),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final Widget? iconWidget;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailingIcon;

  const SettingTile({
    super.key,
    this.iconWidget,
    required this.title,
    this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.pureWhite,          // ⭐ Full white box background
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.pureWhite,        // Border also white (optional)
          ),
        ),
        child: Row(
          children: [
            iconWidget ?? const SizedBox.shrink(),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailingIcon ??
                const Icon(Icons.arrow_forward_ios, size: 24),
          ],
        ),
      ),
    );
  }
}
