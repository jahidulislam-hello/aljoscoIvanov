import 'package:flutter/material.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/profile/family_members/family_members_controller/family_members_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/core/widgets/custom_text_field.dart';

class AddMemberScreen extends StatelessWidget {
  AddMemberScreen({super.key});

  final controller = Get.find<FamilyMemberController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar:  CustomAppBar(
      title: 'Add Member',
      titleStyle: AppTextStyles.heading2,
      showShadow: false,

      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Description Text
            Text(
              "Please enter your email and password to add a family member.",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),

            SizedBox(height: 24.h),

            /// Email Field
            CustomTextField(
              controller: emailController,
              hintText: "Email",
              keyboardType: "email",

            ),
            const SizedBox(height: 16),

            /// Password Field
            CustomTextField(
              controller:passwordController,
              hintText: "Password",
              keyboardType: "visiblePassword",

            ),
            const SizedBox(height: 16),

            SizedBox(height: 20.h),

            Text(
              "This will add family member in the system.",
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey.shade600,
              ),
            ),

            SizedBox(height: 30.h),

            /// Add Member Button
            CustomTextButton(
              text: "Add Member",
              onTap: () {
                String email = emailController.text.trim();

                if (email.isEmpty) {
                  Get.snackbar("Error", "Email is required");
                  return;
                }

                /// Add to List
                controller.addMember(email, "assets/images/tomato_soup.png");

                Get.back(); /// Return to Family Members Screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
