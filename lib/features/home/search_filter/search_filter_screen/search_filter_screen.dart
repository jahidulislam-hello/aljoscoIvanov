import 'package:flutter/material.dart';
import 'package:freshbite/features/home/search_filter/search_filter_controller/search_filter_controller.dart';
import 'package:freshbite/features/home/search_filter/widgets/search_expandable_section.dart';
import 'package:freshbite/features/home/search_filter/widgets/search_selectable_chip.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SearchFilterScreen extends StatelessWidget {
  SearchFilterScreen({super.key});

  final controller = Get.put(SearchFilterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ===== Meal Type =====
            SearchExpandableSection(
              title: "Meal Type",
              expanded: controller.mealTypeExpanded,
              child: Obx(() {
                final items = ["Breakfast", "Main Meal", "Snack", "Drink"];
                return Wrap(
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

            // ===== Recipe Components =====
            SearchExpandableSection(
              title: "Recipe Components",
              expanded: controller.recipeComponentsExpanded,
              child: Obx(() {
                final items = [
                  "Base",
                  "Vegetables",
                  "Protein",
                  "Connector",
                  "Topping"
                ];
                return Wrap(
                  children: items.map((item) {
                    return SearchSelectableChip(
                      label: item,
                      selected:
                      controller.selectedRecipeComponents.contains(item),
                      onTap: () => controller.toggleItem(
                          controller.selectedRecipeComponents, item),
                    );
                  }).toList(),
                );
              }),
            ),

            // ===== Add other expandable sections similarly =====

            // ===== APPLY BUTTON =====
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF263715),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                onPressed: () {
                  // You can return selected data here
                  Get.back();
                },
                child: Text(
                  "APPLY FILTERS",
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
