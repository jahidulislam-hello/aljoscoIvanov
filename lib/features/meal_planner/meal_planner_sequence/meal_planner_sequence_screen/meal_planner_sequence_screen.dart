import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/features/meal_planner/meal_planner_sequence/meal_planner_sequence_controller/meal_planner_sequence_controller.dart';
import 'package:freshbite/features/meal_planner/meal_planner_sequence/meal_planner_sequence_model.dart';
import 'package:get/get.dart';


class MealPlanSequence extends StatelessWidget {
  MealPlanSequence({Key? key}) : super(key: key);

  final MealPlanController controller = Get.put(MealPlanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Text('Meal Planner', style: TextStyle(color: Colors.black, fontSize: 18.sp)),
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('January 2025', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  int day = 15 + index;
                  bool isSelected = controller.selectedDays.contains(day);
                  return GestureDetector(
                    onTap: () => controller.toggleDay(day),
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text('CREATE MEAL PLAN', style: TextStyle(fontSize: 16.sp)),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView(
                children: [
                  buildMealSection('Breakfast', controller.breakfastRecipes),
                  buildMealSection('Snack', controller.snackRecipes),
                  buildMealSection('Lunch', controller.lunchRecipes),
                  buildMealSection('Snack', controller.snackRecipes),
                  buildMealSection('Dinner', controller.dinnerRecipes),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMealSection(String title, RxList<MealRecipe> recipes) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              SizedBox(width: 8.w),
              Text('Base, Vegetable, Protein, Connector, Finisher',
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              Spacer(),
              Icon(Icons.check_circle, color: recipes.isNotEmpty ? Colors.green : Colors.grey, size: 20.sp),
            ],
          ),
          SizedBox(height: 8.h),
          ...recipes.map((recipe) => buildRecipeCard(recipe)).toList(),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: 60.h,
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(child: Text('+ Add Recipe', style: TextStyle(fontSize: 14.sp))),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      );
    });
  }

  Widget buildRecipeCard(MealRecipe recipe) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Image.asset(recipe.image, width: 60.w, height: 60.w, fit: BoxFit.cover),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Text('${recipe.servings} Servings', style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                if (recipe.note.isNotEmpty) Text(recipe.note, style: TextStyle(fontSize: 12.sp)),
                SizedBox(height: 4.h),
                Text('${recipe.addedBy} • ${recipe.date}', style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
