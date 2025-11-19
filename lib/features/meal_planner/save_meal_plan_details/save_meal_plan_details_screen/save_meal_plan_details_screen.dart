import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/features/meal_planner/save_meal_plan_details/save_meal_plan_details_controller/save_meal_plan_details_controller.dart';
import 'package:get/get.dart';




// ================= SCREEN =================
class SavedMealPlanDetails extends StatelessWidget {
  const SavedMealPlanDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SavedMealPlanDetailsController());
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F3EF),
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "My meal plan for this week",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D2D2D),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Obx(() {
          return ListView(
            children: [
              SizedBox(height: 10.h),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: const Color(0xFFB5B7B4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Print",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2D2D2D),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      const Icon(Icons.print, size: 18),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // ====== DAILY SECTIONS ======
              for (var day in controller.dailyPlans)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.date,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D2D2D),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Meals under each day
                    ...day.meals.map(
                          (meal) => Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.mealType,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D2D2D),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      meal.title,
                                      style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                                    ),
                                    Text(
                                      meal.servings,
                                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      meal.title,
                                      style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                                    ),
                                    Text(
                                      meal.servings,
                                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),
                  ],
                ),

              SizedBox(height: 40.h),
            ],
          );
        }),
      ),
    );
  }
}
