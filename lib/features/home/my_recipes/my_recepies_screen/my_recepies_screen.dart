import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/my_recipes/my_recipes_controller/my_recipes_controller.dart';
import 'package:get/get.dart';


class MyRecipesScreen extends StatelessWidget {
  final controller = Get.put(MyRecipesController());

  MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: AppColors.mainTextColor),
        title: Text("My Recipes", style: AppTextStyles.H3_Regular),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(Icons.menu, color: AppColors.mainTextColor),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 20.h),
            Text("My Recipes", style: AppTextStyles.H4_Regular),
            SizedBox(height: 12.h),
            Expanded(child: _buildRecipeGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: controller.updateSearch,
      decoration: InputDecoration(
        hintText: "Search recipes",
        hintStyle: AppTextStyles.H4_Regular.copyWith(color: AppColors.defaultTextColor),
        prefixIcon: Icon(Icons.search, color: AppColors.mainTextColor),
        suffixIcon: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.filter_alt, color: Colors.white),
        ),
        filled: true,
        fillColor: AppColors.borderSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRecipeGrid() {
    return Obx(() {
      final recipes = controller.filteredRecipes;
      return GridView.builder(
        itemCount: recipes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, i) {
          final recipe = recipes[i];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                      child: Image.asset(recipe.image,
                          height: 100.h, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: Icon(Icons.favorite, color: AppColors.background),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.title,
                          style: AppTextStyles.H5_Regular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14.sp, color: AppColors.defaultTextColor),
                          SizedBox(width: 4.w),
                          Text("${recipe.timeMinutes} min",
                              style: AppTextStyles.bioText),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < recipe.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            size: 14.sp,
                            color: AppColors.buttonColor,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
