import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/features/meal_planner/create_reuse_popup/create_reuse_popup/create_reuse_popup.dart';
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_controller/reused_meal_plan_controller.dart';
import 'package:freshbite/features/meal_planner/save_meal_plan_details/save_meal_plan_details_screen/save_meal_plan_details_screen.dart';
import 'package:get/get.dart';

import '../../../../core/appbar/custom_appbar.dart';

// ================= SCREEN =================
class ReusedMealPlanScreen extends StatelessWidget {
  final String? title;
  final String? description;
  final List<Map<String, dynamic>> plansData;

  const ReusedMealPlanScreen({
    super.key,
    this.title,
    this.description,
    this.plansData = const [],
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReusedMealPlanController());
    ScreenUtil.init(context);

    // Always refresh the meal plans when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSavedSequenceMeals();
    });

    // Set the sequence meal data if provided
    if (title != null && description != null && plansData.isNotEmpty) {
      controller.setSequenceMealData(title!, description!, plansData);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Apply Saved Meal Plan',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(imagePath: 'assets/icons/charm_menu.png', onPressed: () {}),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),

            // Saved Meal Plans and Sort Button in same row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Saved Meal Plans",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFB5B7B4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sorted by date",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      const Icon(Icons.keyboard_arrow_down, size: 18),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            Expanded(
              child: Obx(() {
                // Show loading indicator
                if (controller.isLoadingMealPlans.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1C2D07),
                    ),
                  );
                }

                // Show empty state
                if (controller.mealPlans.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No saved meal plans",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Your saved meal plans will appear here",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.mealPlans.length,
                  itemBuilder: (context, index) {
                    final item = controller.mealPlans[index];

                    return GestureDetector(
                      onTap: () {
                        // Single tap - navigate to details screen
                        if (item.id.isNotEmpty) {
                          Get.to(() => SavedMealPlanDetails(
                            selectedMealPlans: [item],
                          ));
                        }
                      },
                      onLongPress: () {
                        // Long press - toggle selection for multi-select
                        controller.toggleSelection(index);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12.r),
                          border: item.isSelected
                              ? Border.all(color: const Color(0xFF1C2D07), width: 2)
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Circular checkbox for multiple selection
                                GestureDetector(
                                  onTap: () {
                                    // Toggle selection on checkbox tap
                                    controller.toggleSelection(index);
                                  },
                                  child: Container(
                                    width: 22.w,
                                    height: 22.h,
                                    decoration: BoxDecoration(
                                      color: item.isSelected
                                          ? const Color(0xFF1C2D07)
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: item.isSelected
                                            ? const Color(0xFF1C2D07)
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    child: item.isSelected
                                        ? Icon(
                                            Icons.check,
                                            size: 14.sp,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      color: const Color(0xFF2D2D2D),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Icon(Icons.more_vert, color: Colors.black54),
                              ],
                            ),
                            SizedBox(height: 6.h),

                            Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF666666),
                              ),
                            ),

                            SizedBox(height: 8.h),
                            Text(
                              "created by ${item.createdBy}, on ${item.date}",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF808080),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            SizedBox(height: 10.h),

            // CONTINUE BUTTON (for selecting existing plans)
            if (plansData.isEmpty)
              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.hasSelection()
                        ? const Color(0xFF1C2D07)
                        : const Color(0xFF1C2D07).withOpacity(0.5),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: controller.hasSelection()
                      ? () {
                          final selectedPlans = controller.getSelectedMealPlans();
                          print('Selected Meal Plans: ${selectedPlans.length}');
                          for (var plan in selectedPlans) {
                            print('- ${plan.title} (${plan.date})');
                          }

                          // If multiple plans selected, show CreateReusePopup
                          if (selectedPlans.length > 1) {
                            // Collect all meal IDs from selected plans
                            List<String> allMealIds = [];
                            for (var plan in selectedPlans) {
                              // Add the plan ID itself
                              if (plan.id.isNotEmpty) {
                                allMealIds.add(plan.id);
                              }
                              // Also add meal IDs from plans
                              for (var seqPlan in plan.plans) {
                                allMealIds.addAll(seqPlan.mealIds);
                              }
                            }

                            print('All Meal IDs: $allMealIds');

                            // Show CreateReusePopup dialog
                            showDialog(
                              context: context,
                              builder: (context) => CreateReusePopup(
                                selectedMealIds: allMealIds,
                              ),
                            );
                          } else {
                            // Single plan selected, go directly to details
                            Get.to(() => SavedMealPlanDetails(
                              selectedMealPlans: selectedPlans,
                            ));
                          }
                        }
                      : null,
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
