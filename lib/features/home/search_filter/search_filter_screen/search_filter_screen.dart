import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/features/home/search_filter/search_filter_controller/search_filter_controller.dart';
import 'package:freshbite/features/home/search_filter/widgets/search_expandable_section.dart';
import 'package:freshbite/features/home/search_filter/widgets/search_selectable_chip.dart';
import 'package:get/get.dart';
import 'package:freshbite/core/themes/app_colors.dart';



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
          onPressed: () => Get.back(),
        ),
      ),

      body: SingleChildScrollView(
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
                  spacing: 8.w,       // horizontal spacing between chips
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
                            : null, // optional: color for selected state
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
                  spacing: 8.w,       // horizontal spacing between chips
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
                  spacing: 8.w,       // horizontal spacing between chips
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
                  spacing: 8.w,       // horizontal spacing between chips
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
                  spacing: 8.w,       // horizontal spacing between chips
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
                  spacing: 8.w,       // horizontal spacing between chips
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
                  spacing: 8.w,       // horizontal spacing between chips
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

            // APPLY BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF263715),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r)),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  "APPLY FILTERS",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 25.h),
          ],
        ),
      ),
    );
  }
}
