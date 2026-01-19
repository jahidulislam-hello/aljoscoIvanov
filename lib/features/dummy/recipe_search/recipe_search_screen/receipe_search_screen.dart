import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/dummy/recipe_search/recipe_search_controller/recipe_search_controller.dart';

import 'package:get/get.dart';



class RecipeSearchScreen extends StatelessWidget {
  final RecipeSearchController controller = Get.put(RecipeSearchController());

  RecipeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Icon(Icons.arrow_back_ios_new, color: AppColors.mainTextColor),
        title: Text(
          "Recipe Search",
          style: AppTextStyles.H6_Regular,
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.menu, color: AppColors.mainTextColor),
          SizedBox(width: 12.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            _buildSearchBar(),
            SizedBox(height: 16.h),
            _buildCategoryChips(),
            SizedBox(height: 24.h),
            _buildSection("Everyday", controller.getByCategory("Everyday")),
            SizedBox(height: 16.h),
            _buildBanner(),
            SizedBox(height: 16.h),
            _buildSection("Meal Prep", controller.getByCategory("Meal Prep")),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.mainTextColor),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.defaultTextColor),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              onChanged: (value) => controller.searchQuery(value),
              decoration: InputDecoration(
                hintText: "Search recipes",
                hintStyle: AppTextStyles.H5_Regular.copyWith(color: AppColors.defaultTextColor),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final filters = ["Gluten-free", "Meal Type", "Savory", "Traditional"];
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (_, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: index == 0 ? AppColors.background : AppColors.background,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              filters[index],
              style: AppTextStyles.H4_Regular.copyWith(
                color: index == 0 ? Colors.white : AppColors.mainTextColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List recipes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.H5_Regular),
            Text("See all", style: AppTextStyles.H6_Regular.copyWith(color: AppColors.defaultTextColor)),
          ],
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 180.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, index) => _buildRecipeCard(recipes[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard(recipe) {
    return Container(
      width: 150.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: Image.asset(recipe.image, height: 100.h, width: 150.w, fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title, style: AppTextStyles.H5_Regular),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14.sp, color: AppColors.defaultTextColor),
                    SizedBox(width: 4.w),
                    Text("${recipe.duration} min", style: AppTextStyles.bioText),
                    Spacer(),
                    Icon(Icons.favorite_border, size: 16.sp, color: AppColors.defaultTextColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: DecorationImage(
          image: AssetImage(AppImages.appLogo),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 16.w,
            bottom: 16.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("5 min Snacks Recipe", style: AppTextStyles.H5_Regular.copyWith(color: Colors.white)),
                Text("10 Recipes", style: AppTextStyles.bioText.copyWith(color: Colors.white70)),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text("VIEW RECIPE", style: AppTextStyles.bioText.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
