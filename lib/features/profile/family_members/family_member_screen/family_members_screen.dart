import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/features/profile/family_members/Add_member_screen.dart';
import 'package:freshbite/features/profile/family_members/family_members_controller/family_members_controller.dart';
import 'package:get/get.dart';

import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FamilyMemberScreen extends StatelessWidget {
  final controller = Get.put(FamilyMemberController());

  FamilyMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Family Members',
            titleStyle: AppTextStyles.heading2,
            showShadow: false,

          ),
        ),
      ),

      body: Obx(() {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Title
              Text(
                "Manage Linked Accounts",
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 20.h),

              /// Member List
              ...controller.members.map((m) {
                return Container(
                  margin: EdgeInsets.only(bottom: 15.h),
                  child: Row(
                    children: [
                      Container(
                        width: 52.w,
                        height: 52.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(width: 1, color: Colors.grey),
                          image: DecorationImage(
                            image: AssetImage(m.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(width: 12.w),

                      Expanded(
                        child: Text(
                          m.name,
                          style: TextStyle(
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),

                      Icon(Icons.more_vert, size: 24.sp),
                    ],
                  ),
                );
              }).toList(),

              SizedBox(height: 10.h),

              /// Add Member Button Tile
              GestureDetector(
                onTap: () => Get.to(() => AddMemberScreen()),
                child: Container(
                  width: 150.w,
                  height: 44.h,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,   // 🟢 FIXES OVERFLOW
                      children: [
                        Icon(Icons.add, size: 20.sp),
                        SizedBox(width: 6.w),
                        Text(
                          "Add Member",
                          style: TextStyle(
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              SizedBox(height: 35.h),
            ],
          ),
        );
      }),
    );
  }
}
