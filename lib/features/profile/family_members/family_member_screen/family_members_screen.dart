import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/features/profile/family_members/Add_member_screen.dart';
import 'package:freshbite/features/profile/family_members/family_members_controller/family_members_controller.dart';
import 'package:get/get.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';


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
            title: 'Family Members'.tr,
            titleStyle: AppTextStyles.heading2,
            showShadow: false,

          ),
        ),
      ),

      body: Obx(() {
        // Show loading indicator
        if (controller.isLoading.value && controller.members.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                "Manage Linked Accounts".tr,
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 20.h),

              /// Member List
              if (controller.members.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: Text(
                      "No family members added yet",
                      style: TextStyle(
                        fontFamily: "Rubik",
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                ...controller.members.map((m) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 15.h),
                    child: Row(
                      children: [
                        // Profile Image
                        Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(width: 1, color: Colors.grey),
                            color: Colors.grey.shade200,
                          ),
                          child: m.image != null && m.image!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    m.image!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size: 30.sp,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 30.sp,
                                  color: Colors.grey,
                                ),
                        ),

                        SizedBox(width: 12.w),

                        // Member Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.name ?? m.email ?? 'Unknown',
                                style: TextStyle(
                                  fontFamily: "Rubik",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.sp,
                                ),
                              ),
                              if (m.name != null && m.email != null)
                                Text(
                                  m.email!,
                                  style: TextStyle(
                                    fontFamily: "Rubik",
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                            ],
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 20.sp),
                        SizedBox(width: 6.w),
                        Text(
                          "Add Member ".tr,
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
