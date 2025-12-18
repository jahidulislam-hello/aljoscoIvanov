import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/recepies/create_recipes/create_recipes_screen/create_recipes_screen.dart';
import 'package:freshbite/features/recepies/recipes_search/recipes_search_controller/recipes_search_controller.dart';
import 'package:get/get.dart';




class RecipeRecipeSearchScreen extends StatelessWidget {
  final controller = Get.put(RecipeRecipeSearchController());
  RecipeRecipeSearchScreen({super.key});

  // Filter chips data
  final List<String> filterChips = [
    'Gluten-free',
    'Meal Type',
    'Savory',
    'Traditional',
    'Recipe',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Recipe Search',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(imagePath: 'assets/icons/charm_menu.png', onPressed: () {}),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: RefreshIndicator(
              onRefresh: () => controller.refreshRecipes(),
              color: AppColors.buttonColor,
              child: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  SizedBox(height: 16.h),
                  _buildFilterChips(),
                  SizedBox(height: 24.h),

                  // Loading indicator
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.h),
                          child: CircularProgressIndicator(
                            color: AppColors.buttonColor,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  }),

                  // Everyday Section
                  _buildSectionHeader("EveryDay"),
                  SizedBox(height: 12.h),
                  Obx(() => _buildRecipeGrid(controller.everydayRecipes)),
                  SizedBox(height: 24.h),

                  // Meal Prep Section
                  _buildSectionHeader("Meal Prep"),
                  SizedBox(height: 12.h),
                  Obx(() => _buildRecipeGrid(controller.mealPrepRecipes)),
                  SizedBox(height: 24.h),

                  // Emergency Section
                  _buildSectionHeader("Emergency"),
                  SizedBox(height: 12.h),
                  Obx(() => _buildRecipeGrid(controller.emergencyRecipes)),
                  SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),

          // Floating Add Button
          Positioned(
            bottom: 20.h,
            right: 16.w,
            child: GestureDetector(
              onTap: () {
               Get.to(()=> CreateRecipeScreen());
              },
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Color(0xFF1C2D07),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 34.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              color: AppColors.pureWhite,
            ),
            child: Row(
              children: [
                SizedBox(width: 12.w),
                Image.asset(
                  AppImages.search,
                  width: 24.w,
                  height: 24.h,
                  color: AppColors.mainTextColor,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search recipes",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: AppColors.buttonColor,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Center(
            child: Image.asset(
              AppImages.filter,
              width: 24.w,
              height: 24.h,
              color: AppColors.pureWhite,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filterChips.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final chip = filterChips[index];

          return Obx(() {
            final isSelected = controller.selectedFilter.value == chip;

            return GestureDetector(
              onTap: () {
                if (isSelected) {
                  controller.selectedFilter.value = '';
                } else {
                  controller.selectedFilter.value = chip;
                }
              },
              child: Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF1C2D07) : Color(0xFFB9BEB2),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Color(0xFF1C2D07),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    chip,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Color(0xFF1C2D07),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.H5_Regular),
        GestureDetector(
          onTap: () {

          },
          child: Text("See All", style: AppTextStyles.bioText),
        ),
      ],
    );
  }

  Widget _buildRecipeGrid(List recipes) {
    if (recipes.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Text(
            "No recipes available",
            style: AppTextStyles.bioText,
          ),
        ),
      );
    }

    return Container(
      height: 190.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, i) {
          final recipe = recipes[i];
          return Container(
            width: 165.w,
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
                      child: recipe.image.startsWith('http')
                          ? Image.network(
                              recipe.image,
                              height: 110.h,
                              width: 165.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/icons/01.png',
                                  height: 110.h,
                                  width: 165.w,
                                  fit: BoxFit.cover,
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 110.h,
                                  width: 165.w,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.buttonColor,
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Image.asset(
                              recipe.image,
                              height: 110.h,
                              width: 165.w,
                              fit: BoxFit.cover,
                            ),
                    ),

                    // Favourite Icon
                    Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: GestureDetector(
                        onTap: () {
                          controller.toggleFavorite(recipe.id);
                        },
                        child: Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black.withOpacity(0.2),
                              width: 0.25,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 16.sp,
                              color: AppColors.buttonColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Text section (without rating)
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: AppTextStyles.H5_Regular,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),

                      Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.outline_time,
                            width: 16.w,
                            height: 16.h,
                            color: AppColors.buttonColor,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "${recipe.timeMinutes} min",
                            style: AppTextStyles.bioText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
