import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_controller/reused_meal_plan_controller.dart';
import 'package:get/get.dart';



// ================= SCREEN =================
class ReusedMealPlanScreen extends StatelessWidget {
  const ReusedMealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReusedMealPlanController());
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F3EF),
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Apply Saved Meal Plan",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2D2D),
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(
              "Saved Meal Plans",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),

            // Sort Button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
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
            ),
            SizedBox(height: 20.h),

            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.mealPlans.length,
                  itemBuilder: (context, index) {
                    final item = controller.mealPlans[index];

                    return GestureDetector(
                      onTap: () => controller.selectMeal(index),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  item.isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: item.isSelected
                                      ? const Color(0xFF4A8A38)
                                      : Colors.grey,
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

            // CONTINUE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A8A38),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "CONTINUE",
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
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
