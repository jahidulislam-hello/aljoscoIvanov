import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/app_images.dart';
import '../controller/recipe_search_controller.dart';

class RecipeSearchScreen extends StatelessWidget {
  final RecipeSearchController controller = Get.put(RecipeSearchController());

  RecipeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        leading: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
        title: Text(
          "Recipe Search",
          style: AppTextStyle.medium16,
        ),
        centerTitle: true,
        actions: [
          Icon(Icons.menu, color: AppColors.textPrimary),
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
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.textSecondary),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              onChanged: (value) => controller.searchQuery(value),
              decoration: InputDecoration(
                hintText: "Search recipes",
                hintStyle: AppTextStyle.regular14.copyWith(color: AppColors.textSecondary),
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
              color: index == 0 ? AppColors.primary : AppColors.chipBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              filters[index],
              style: AppTextStyle.medium14.copyWith(
                color: index == 0 ? Colors.white : AppColors.textPrimary,
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
            Text(title, style: AppTextStyle.medium16),
            Text("See all", style: AppTextStyle.regular14.copyWith(color: AppColors.textSecondary)),
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
                Text(recipe.title, style: AppTextStyle.medium14),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.timer_outlined, size: 14.sp, color: AppColors.textSecondary),
                    SizedBox(width: 4.w),
                    Text("${recipe.duration} min", style: AppTextStyle.regular12),
                    Spacer(),
                    Icon(Icons.favorite_border, size: 16.sp, color: AppColors.textSecondary),
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
          image: AssetImage(AppImages.snacksBanner),
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
                Text("5 min Snacks Recipe", style: AppTextStyle.semiBold16.copyWith(color: Colors.white)),
                Text("10 Recipes", style: AppTextStyle.regular12.copyWith(color: Colors.white70)),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text("VIEW RECIPE", style: AppTextStyle.medium12.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
