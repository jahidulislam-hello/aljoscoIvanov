import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/shopping_list/select_prep_list/select_prep_list_controller/select_prep_list_controller.dart';
import 'package:get/get.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';

class SelectPrepListScreen extends StatelessWidget {
  final controller = Get.put(PrepListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Select prep Lists',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(
                imagePath: 'assets/icons/charm_menu.png',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            Text(
              "Select one or more Prep List(s) to include in your Shopping List",
              style: TextStyle(fontSize: 13.sp, color: Colors.black87),
            ),

            SizedBox(height: 16.h),

            // ------------------------------
            // ONE BIG BOX WITH SCROLL INSIDE
            // ------------------------------
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),

                child: Obx(() {
                  // Loading state
                  if (controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.buttonColor,
                      ),
                    );
                  }

                  // Empty state
                  if (controller.prepLists.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list_alt,
                            size: 48.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No prep lists available',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextButton(
                            onPressed: controller.refreshPrepLists,
                            child: Text(
                              'Tap to refresh',
                              style: TextStyle(
                                color: AppColors.buttonColor,
                                fontSize: 13.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // List of prep lists
                  return RefreshIndicator(
                    onRefresh: controller.refreshPrepLists,
                    color: AppColors.buttonColor,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.prepLists.length,
                      itemBuilder: (context, index) {
                        final prepList = controller.prepLists[index];

                        return Obx(() {
                          bool isSelected = controller.selectedIndexes.contains(index);

                          return GestureDetector(
                            onTap: () => controller.toggleSelect(index),
                            child: Container(
                              padding: EdgeInsets.all(14.w),
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: isSelected ? Color(0xFFEFF4EC) : Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // LEFT TEXT
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prepList.getFormattedDate(),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          "Includes: ${prepList.getIncludesText()}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          "Total Servings: ${prepList.getTotalServings()}",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 8.w),

                                  /// --- Tick button ---
                                  Icon(
                                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: isSelected ? AppColors.buttonColor : Colors.grey,
                                    size: 22.sp,
                                  ),
                                ],
                              ),

                            ),
                          );
                        });
                      },
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20.h),
            // NEXT BUTTON
            CustomTextButton(
              text: "NEXT",
              onTap: () => controller.onNext(),
            ),
            SizedBox(height: 12.h),
            Center(
              child: TextButton(
                onPressed: () => controller.onCancel(),
                child: Text(
                  "CANCEL",
                  style:
                  TextStyle(color: Colors.black54, fontSize: 14.sp),
                ),
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
