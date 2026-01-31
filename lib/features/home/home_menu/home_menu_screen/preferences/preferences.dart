import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/features/home/home_menu/home_menu_screen/preferences/preferences_controller.dart';
import 'package:freshbite/features/home/search_filter/widgets/search_expandable_section.dart';
import 'package:freshbite/features/home/search_filter/widgets/search_selectable_chip.dart';
import 'package:get/get.dart';

class PreferencesScreen extends StatelessWidget {
  final controller = Get.put(PreferencesController());

  PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: Text(
          "Preferences",
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),

                  // 🍽️ Diet Type Section
                  SearchExpandableSection(
                    title: "Diet Type",
                    expanded: controller.mealTypeExpanded,
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
                            selected: controller.selectedMealTypes.contains(item),
                            onTap: () => controller.toggleItem(
                                controller.selectedMealTypes, item),
                          );
                        }).toList(),
                      );
                    }),
                  ),

                  SizedBox(height: 16.h),

                  // 🚫 Allergens Section
                  SearchExpandableSection(
                    title: "Allergens (Exclude)",
                    expanded: controller.allergensExpanded,
                    child: Obx(() {
                      final items = [
                        "Peanuts",
                        "Soy",
                        "Mustard",
                        "Crustaceans",
                        "Sesame",
                        "Molluscs",
                        "Sulphites",
                        "Lupins",
                        "Cereals containing gluten",
                        "Celery",
                        "Eggs",
                        "Fish",
                        "Milk",
                        "Tree Nuts"
                      ];

                      return Wrap(
                        spacing: 8.w,
                        runSpacing: 10.h,
                        children: items.map((item) {
                          return SearchSelectableChip(
                            label: item,
                            selected: controller.selectedAllergens.contains(item),
                            onTap: () => controller.toggleItem(
                                controller.selectedAllergens, item),
                          );
                        }).toList(),
                      );
                    }),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Bottom Buttons
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Obx(() {
                // Check if any selections exist
                bool hasSelections = controller.selectedMealTypes.isNotEmpty ||
                    controller.selectedAllergens.isNotEmpty;

                if (hasSelections) {
                  // Show both Reset and Apply buttons
                  return Row(
                    children: [
                      // Reset Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => controller.clearAllFilters(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: const Color(0xFF263715),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                          ),
                          child: Text(
                            "RESET",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF263715),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Apply Button
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () => controller.applyFilters(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF263715),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            elevation: 0,
                          ),
                          child: Text(
                            "APPLY PREFERENCES",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Show only Apply button when no selections
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => controller.applyFilters(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF263715),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        elevation: 0,
                      ),
                      child: Text(
                        "APPLY PREFERENCES",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}