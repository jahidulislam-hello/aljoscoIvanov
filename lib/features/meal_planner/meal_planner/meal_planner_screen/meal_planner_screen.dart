import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/meal_planner/meal_planner/meal_planner_controller/meal_planner_controller.dart';
import 'package:get/get.dart';


class MealPlannerScreen extends StatelessWidget {
  final MealPlannerController controller = Get.put(MealPlannerController());

  MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Meal Planner',
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
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  _buildMonthHeader(),
                  SizedBox(height: 16.h),
                  _buildDateSelector(),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _buildTabButtons(),
            SizedBox(height: 24.h),
            Expanded(child: _buildEmptyState()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        onPressed: () {
          // Future navigation to AddMealPlanScreen
        },
        child: Icon(Icons.add, color: Colors.white, size: 28.sp),
      ),
    );
  }

  Widget _buildMonthHeader() {
    final now = DateTime.now();
    final month = _getMonthName(now.month);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "$month ${now.year}",
                style: AppTextStyles.H6_Regular.copyWith(fontSize: 16.sp),
              ),
              SizedBox(width: 4.w),
              Icon(Icons.arrow_drop_down, color: AppColors.grey),
            ],
          ),
          Row(
            children: [
              Icon(Icons.more_vert, color: AppColors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final today = DateTime.now();
    final weekDates = List.generate(7, (i) => today.add(Duration(days: i - 2)));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Weekday labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            return SizedBox(
              width: 26.w,
              child: Center(
                child: Text(
                  _getWeekday(weekDates[i].weekday),
                  style: AppTextStyles.H6_Regular.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 8.h),
        /// Dates row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: weekDates.map((date) {
            final isSelected = date.day == controller.selectedDate.value.day &&
                date.month == controller.selectedDate.value.month;
            return GestureDetector(
              onTap: () => controller.selectDate(date),
              child: Container(
                width: 26.w,
                height: 26.h,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.2),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  date.day.toString(),
                  style: AppTextStyles.H6_Regular.copyWith(
                    fontSize: 14.sp,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTabButtons() {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.switchTab(0),
              child: Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: controller.selectedTab.value == 0
                      ? AppColors.primary
                      : Colors.transparent,
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    bottomLeft: Radius.circular(8.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    "MEAL PLAN",
                    style: AppTextStyles.H6_Regular.copyWith(
                      fontSize: 14.sp,
                      color: controller.selectedTab.value == 0
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.switchTab(1),
              child: Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: controller.selectedTab.value == 1
                      ? AppColors.primary
                      : Colors.transparent,
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    "PREP LIST",
                    style: AppTextStyles.H6_Regular.copyWith(
                      fontSize: 14.sp,
                      color: controller.selectedTab.value == 1
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.textSecondary.withOpacity(0.1)),
        ),
        child: Text(
          "Tap the + button to create your personal Meal plan, organize your cooking and invite your family to join.",
          textAlign: TextAlign.center,
          style: AppTextStyles.H6_Regular.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  String _getWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return "Mo";
      case 2:
        return "Tu";
      case 3:
        return "We";
      case 4:
        return "Th";
      case 5:
        return "Fr";
      case 6:
        return "Sa";
      case 7:
        return "Su";
      default:
        return "";
    }
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }
}
