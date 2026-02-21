import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/navbar/controller/navbar_controller.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/search_filter/search_filter_screen/search_filter_screen.dart';
import 'package:freshbite/features/recepies/create_recipes/create_recipes_screen/create_recipes_screen.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_screen/recipes_details_screen.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_controller/recipes_details_controller.dart';
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
            title: 'Recipe Search'.tr,
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            onLeadingPressed: () {
              Get.find<BottomNavbarController>().changeIndex(0);
            },
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

                  // Show search results or default content
                  Obx(() {
                    if (controller.isSearching.value) {
                      return _buildSearchResults();
                    }

                    // Default content when not searching
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Loading indicator
                        if (controller.isLoading.value)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.h),
                              child: CircularProgressIndicator(
                                color: AppColors.buttonColor,
                              ),
                            ),
                          ),

                        // Everyday Section
                        _buildSectionHeader("EveryDay".tr),
                        SizedBox(height: 12.h),
                        _buildRecipeGrid(controller.everydayRecipes),
                        SizedBox(height: 24.h),

                        // Meal Prep Section
                        _buildSectionHeader("Meal Prep".tr),
                        SizedBox(height: 12.h),
                        _buildRecipeGrid(controller.mealPrepRecipes),
                        SizedBox(height: 24.h),

                        // Emergency Section
                        _buildSectionHeader("Emergency".tr),
                        SizedBox(height: 12.h),
                        _buildRecipeGrid(controller.emergencyRecipes),
                        SizedBox(height: 24.h),
                      ],
                    );
                  }),
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
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: "Search recipes".tr,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.isSearching.value) {
                    return GestureDetector(
                      onTap: () => controller.clearSearch(),
                      child: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Icon(
                          Icons.close,
                          size: 20.sp,
                          color: AppColors.mainTextColor,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
        SizedBox(width: 10.w),
        GestureDetector(
          onTap: () {
            Get.to(() => SearchFilterScreen());
          },
          child: Container(
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
          child: Text("See All".tr, style: AppTextStyles.bioText),
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
            "No recipes available".tr,
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
          return GestureDetector(
            onTap: () {
              // Navigate to details screen with recipe ID
              Get.delete<RecipesDetailsRecipeController>();
              Get.put(RecipesDetailsRecipeController(recipeId: recipe.id));
              Get.to(() => RecipesDetailsRecipeScreen());
            },
            child: Container(
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search loading indicator
        if (controller.isSearchLoading.value && controller.searchResults.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(20.h),
              child: CircularProgressIndicator(
                color: AppColors.buttonColor,
              ),
            ),
          ),

        // Search results header
        if (controller.searchResults.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Text(
              "${'Found'.tr} ${controller.totalSearchResults.value} ${'recipes for'.tr} \"${controller.searchQuery.value}\"",
              style: AppTextStyles.bioText.copyWith(
                color: AppColors.mainTextColor.withOpacity(0.7),
              ),
            ),
          ),

        // No results message
        if (!controller.isSearchLoading.value && controller.searchResults.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(40.h),
              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 48.sp,
                    color: AppColors.mainTextColor.withOpacity(0.5),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "${'No recipes found for'.tr} \"${controller.searchQuery.value}\"",
                    style: AppTextStyles.bioText.copyWith(
                      color: AppColors.mainTextColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

        // Search results grid
        if (controller.searchResults.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.75,
            ),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final recipe = controller.searchResults[index];
              return GestureDetector(
                onTap: () {
                  Get.delete<RecipesDetailsRecipeController>();
                  Get.put(RecipesDetailsRecipeController(recipeId: recipe.id));
                  Get.to(() => RecipesDetailsRecipeScreen());
                },
                child: Container(
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
                                    height: 120.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 120.h,
                                        color: Colors.grey[200],
                                        child: Icon(Icons.image_not_supported),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    recipe.image,
                                    height: 120.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Positioned(
                            right: 8.w,
                            top: 8.h,
                            child: GestureDetector(
                              onTap: () => controller.toggleFavorite(recipe.id),
                              child: Container(
                                width: 28.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                  color: AppColors.pureWhite,
                                  shape: BoxShape.circle,
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
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                recipe.title,
                                style: AppTextStyles.H5_Regular,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    AppImages.outline_time,
                                    width: 14.w,
                                    height: 14.h,
                                    color: AppColors.buttonColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "${recipe.timeMinutes} min",
                                    style: AppTextStyles.bioText.copyWith(fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

        // Load more indicator
        if (controller.isSearchLoading.value && controller.searchResults.isNotEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: CircularProgressIndicator(
                color: AppColors.buttonColor,
              ),
            ),
          ),

        // Load more button
        if (controller.searchResults.length < controller.totalSearchResults.value &&
            !controller.isSearchLoading.value)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: GestureDetector(
                onTap: () => controller.loadMoreSearchResults(),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.buttonColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    "Load More".tr,
                    style: AppTextStyles.buttonRegular.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),

        SizedBox(height: 24.h),
      ],
    );
  }
}
