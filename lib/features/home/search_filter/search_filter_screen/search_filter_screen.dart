import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/search_filter/search_filter_controller/search_filter_controller.dart';
import 'package:freshbite/features/home/search_filter/widgets/search_expandable_section.dart';
import 'package:freshbite/features/home/search_filter/widgets/search_selectable_chip.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_controller/recipes_details_controller.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_screen/recipes_details_screen.dart';
import 'package:get/get.dart';

class SearchFilterScreen extends StatelessWidget {
  SearchFilterScreen({super.key});

  final controller = Get.put(SearchFilterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text(
          "Filter".tr,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // Clear all button
          Obx(() {
            if (controller.hasActiveFilters()) {
              return TextButton(
                onPressed: () => controller.clearAllFilters(),
                child: Text(
                  "Clear All".tr,
                  style: TextStyle(
                    color: const Color(0xFF1D3108),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            child: _buildSearchBar(),
          ),

          // Results count (when searched)
          Obx(() {
            if (controller.hasSearched.value && !controller.isLoading.value) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                child: Row(
                  children: [
                    Text(
                      "${controller.searchResults.length} ${'results found'.tr}",
                      style: AppTextStyles.bioText.copyWith(
                        color: AppColors.mainTextColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Search results or filters
          Expanded(
            child: Obx(() {
              if (controller.hasSearched.value) {
                // Show search results
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                
                if (controller.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64.sp,
                          color: AppColors.mainTextColor.withOpacity(0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "No recipes found".tr,
                          style: AppTextStyles.bioText.copyWith(
                            color: AppColors.mainTextColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _buildSearchResults();
              } else {
                // Show filters
                return _buildFilters();
              }
            }),
          ),

          // APPLY BUTTON
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
            child: Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isLoading.value ? null : () => controller.applyFilters(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF263715),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        controller.hasSearched.value ? "SEARCH AGAIN".tr : "APPLY FILTERS".tr,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
                hintText: "Search recipes...".tr,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
              ),
              onChanged: (value) => controller.updateSearchQuery(value),
            ),
          ),
          Obx(() {
            if (controller.searchController.text.isNotEmpty) {
              return GestureDetector(
                onTap: () {
                  controller.searchController.clear();
                  controller.updateSearchQuery('');
                },
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
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🍳 Meal Type
          SearchExpandableSection(
            title: "Meal Type",
            expanded: controller.mealTypeExpanded,
            child: Obx(() {
              final items = ["Breakfast", "Main Meal", "Snack", "Drink"];
              return Wrap(
                spacing: 8.w,
                runSpacing: 10.h,
                children: items.map((item) {
                  return SearchSelectableChip(
                    label: item,
                    selected: controller.selectedMealTypes.contains(item),
                    onTap: () =>
                        controller.toggleItem(controller.selectedMealTypes, item),
                  );
                }).toList(),
              );
            }),
          ),

          // 🥗 Recipe Components
          SearchExpandableSection(
            title: "Recipe Components",
            expanded: controller.recipeComponentsExpanded,
            child: Obx(() {
              final items = [
                {"label": "Base", "icon": "assets/icons/topping.png"},
                {"label": "Vegetables", "icon": "assets/icons/vegetable.png"},
                {"label": "Protein", "icon": "assets/icons/protein.png"},
                {"label": "Connector", "icon": "assets/icons/bow.png"},
                {"label": "Topping", "icon": "assets/icons/drop.png"},
              ];

              return Wrap(
                spacing: 8.w,
                runSpacing: 10.h,
                children: items.map((item) {
                  return SearchSelectableChip(
                    label: item["label"]!,
                    prefixIcon: Image.asset(
                      item["icon"]!,
                      width: 20.w,
                      height: 20.h,
                      color: controller.selectedRecipeComponents.contains(item["label"])
                          ? Colors.white
                          : null,
                    ),
                    selected: controller.selectedRecipeComponents.contains(item["label"]),
                    onTap: () => controller.toggleItem(
                        controller.selectedRecipeComponents, item["label"]!),
                  );
                }).toList(),
              );
            }),
          ),


          // 🍳 Cooking Mode
          SearchExpandableSection(
            title: "Cooking Mode",
            expanded: controller.cookingModeExpanded,
            child: Obx(() {
              final items = ["Everyday", "Emergency", "Meal Prep"];
              return Wrap(
                spacing: 8.w,
                runSpacing: 10.h,
                children: items.map((item) {
                  return SearchSelectableChip(
                    label: item,
                    selected: controller.selectedCookingModes.contains(item),
                    onTap: () =>
                        controller.toggleItem(controller.selectedCookingModes, item),
                  );
                }).toList(),
              );
            }),
          ),

          // 🌶 Flavor Profile
          SearchExpandableSection(
            title: "Flavor Profile",
            expanded: controller.flavorProfileExpanded,
            child: Obx(() {
              final items = ["Sweet", "Savory", "Warm", "Cold", "Spicy"];
              return Wrap(
                spacing: 8.w,
                runSpacing: 10.h,
                children: items.map((item) {
                  return SearchSelectableChip(
                    label: item,
                    selected: controller.selectedFlavors.contains(item),
                    onTap: () =>
                        controller.toggleItem(controller.selectedFlavors, item),
                  );
                }).toList(),
              );
            }),
          ),

          // 🌍 Cuisine Type
          SearchExpandableSection(
            title: "Cuisine Type",
            expanded: controller.cuisineTypeExpanded,
            child: Obx(() {
              final items = [
                "Mediterranean",
                "Balkan",
                "Asian",
                "Fusion",
                "Oriental",
                "Latin American",
                "Traditional",
              ];
              return Wrap(
                spacing: 8.w,
                runSpacing: 10.h,
                children: items.map((item) {
                  return SearchSelectableChip(
                    label: item,
                    selected: controller.selectedCuisines.contains(item),
                    onTap: () =>
                        controller.toggleItem(controller.selectedCuisines, item),
                  );
                }).toList(),
              );
            }),
          ),

          // 🍂 Season
          SearchExpandableSection(
            title: "Season",
            expanded: controller.seasonExpanded,
            child: Obx(() {
              final items = [
                "All Year",
                "Spring",
                "Summer",
                "Autumn",
                "Winter"
              ];
              return Wrap(
                spacing: 8.w,
                runSpacing: 10.h,
                children: items.map((item) {
                  return SearchSelectableChip(
                    label: item,
                    selected: controller.selectedSeasons.contains(item),
                    onTap: () =>
                        controller.toggleItem(controller.selectedSeasons, item),
                  );
                }).toList(),
              );
            }),
          ),

          // 🥑 Diet Type
          SearchExpandableSection(
            title: "Diet Type",
            expanded: controller.dietTypeExpanded,
            child: Obx(() {
              final items = [
                "Vegetarian",
                "Lactose-free",
                "Gluten-free",
                "Vegan"
              ];
              return Wrap(
                spacing: 8.w,
                runSpacing: 10.h,
                children: items.map((item) {
                  return SearchSelectableChip(
                    label: item,
                    selected: controller.selectedDietTypes.contains(item),
                    onTap: () =>
                        controller.toggleItem(controller.selectedDietTypes, item),
                  );
                }).toList(),
              );
            }),
          ),

          // 🚫 Allergens
          SearchExpandableSection(
            title: "Allergens (Exclude)",
            expanded: controller.allergensExpanded,
            child: Obx(() {
              final items = [
                "Peanuts", "Soy", "Mustard", "Crustaceans",
                "Sesame", "Molluscs", "Sulphites", "Lupins",
                "Cereals containing gluten", "Celery", "Eggs",
                "Fish", "Milk", "Tree Nuts"
              ];

              return Wrap(
                spacing: 8.w,
                runSpacing: 10.h,
                children: items.map((item) {
                  return SearchSelectableChip(
                    label: item,
                    selected: controller.selectedAllergens.contains(item),
                    onTap: () =>
                        controller.toggleItem(controller.selectedAllergens, item),
                  );
                }).toList(),
              );
            }),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                                  child: const Icon(Icons.image_not_supported),
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
                      child: Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 16.sp,
                          color: AppColors.buttonColor,
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
    );
  }
}
