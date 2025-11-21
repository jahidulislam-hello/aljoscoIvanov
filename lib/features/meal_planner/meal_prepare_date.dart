import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecipeModel {
  final String name;
  final String image;
  final int servings;
  final bool isFinished;
  final String cookedBy;
  final String comment;

  RecipeModel({
    required this.name,
    required this.image,
    required this.servings,
    this.isFinished = false,
    required this.cookedBy,
    this.comment = '',
  });
}


class MealPrepareController extends GetxController {
  RxList<RecipeModel> recipes = <RecipeModel>[
    RecipeModel(
      name: 'Tomato Soup',
      image: 'assets/images/tomato_soup.png',
      servings: 4,
      cookedBy: 'Olivia afgv',
      isFinished: true,
      comment: 'I will cook this in the evening and will also cut cucumbers for kids.',
    ),
    RecipeModel(
      name: 'Chicken Soup',
      image: 'assets/images/tomato_soup.png',
      servings: 8,
      cookedBy: 'Olivia afgv',
    ),
    RecipeModel(
      name: 'Lentil Soup',
      image: 'assets/images/tomato_soup.png',
      servings: 4,
      cookedBy: 'Olivia afgv',
    ),
  ].obs;

  void toggleFinished(int index) {
    recipes[index] = RecipeModel(
      name: recipes[index].name,
      image: recipes[index].image,
      servings: recipes[index].servings,
      cookedBy: recipes[index].cookedBy,
      comment: recipes[index].comment,
      isFinished: !recipes[index].isFinished,
    );
  }
}




class MealPrepareDate extends StatelessWidget {
  MealPrepareDate({Key? key}) : super(key: key);

  final MealPrepareController controller = Get.put(MealPrepareController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {},
            ),
            title: Text('Meal Planner',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {},
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Calendar header
                Text(
                  'January 2025',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final days = ['15','16','17','18','19','20','21'];
                    final dayNames = ['Mo','Tu','We','Th','Fr','Sa','Su'];
                    bool isSelected = days[index] == '18';
                    return Column(
                      children: [
                        Text(dayNames[index], style: TextStyle(fontSize: 12.sp)),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.green : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            days[index],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ),
                SizedBox(height: 16.h),

                // Tabs
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(child: Text('MEAL PLAN', style: TextStyle(fontSize: 14.sp))),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(child: Text('PREP LIST', style: TextStyle(color: Colors.white, fontSize: 14.sp))),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Text(
                  'Recipes to prepare on 18.1.25',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 8.h),

                Expanded(
                  child: Obx(() => ListView.separated(
                    itemCount: controller.recipes.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final recipe = controller.recipes[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Recipe Image
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.asset(
                                  recipe.image,
                                  width: 80.w,
                                  height: 80.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4.h,
                                right: 4.w,
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${recipe.servings} Servings',
                                    style: TextStyle(fontSize: 8.sp),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 12.w),

                          // Recipe Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(recipe.name,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12.r,
                                      backgroundImage: AssetImage('assets/images/profil.png'),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(recipe.cookedBy, style: TextStyle(fontSize: 12.sp)),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        controller.toggleFinished(index);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.green),
                                          color: recipe.isFinished ? Colors.green : Colors.transparent,
                                        ),
                                        child: Icon(
                                          recipe.isFinished
                                              ? Icons.check
                                              : Icons.circle_outlined,
                                          color: Colors.white,
                                          size: 20.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (recipe.comment.isNotEmpty)
                                  Container(
                                    margin: EdgeInsets.only(top: 8.h),
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Text(
                                      recipe.comment,
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  )),
                ),

                SizedBox(height: 16.h),

                // Create Shopping List button
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'CREATE SHOPPING LIST FOR 18.1.25',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
