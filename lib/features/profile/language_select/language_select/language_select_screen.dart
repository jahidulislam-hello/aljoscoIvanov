import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/profile/language_select/language_select_controller/language_select_controller.dart';
import 'package:freshbite/features/profile/language_select/language_tile.dart';
import 'package:get/get.dart';


class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final controller = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5EF),
      appBar: CustomAppBar(
        title: 'Language',
        showBackButton: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            /// Subtitle
            Text(
              'Select your preferred language for the app interface:',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black.withOpacity(0.6),
              ),
            ),

            SizedBox(height: 24.h),

            /// German
            Obx(() => LanguageTile(
              flag: '🇩🇪',
              title: 'German',
              isSelected: controller.selectedLanguage.value == 'de',
              onTap: () => controller.selectLanguage('de'),
            )),

            SizedBox(height: 12.h),

            /// English
            Obx(() => LanguageTile(
              flag: '🇺🇸',
              title: 'English',
              isSelected: controller.selectedLanguage.value == 'en',
              onTap: () => controller.selectLanguage('en'),
            )),

            SizedBox(height: 24.h),

            /// Info text
            Text(
              'This will change the default app language. '
                  'Please note, that recipes are only available in german.',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black.withOpacity(0.5),
              ),
            ),

            const Spacer(),

            /// Confirm Button
            CustomTextButton(
              text: 'CONFIRM',
              onTap: controller.confirmLanguage,
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
