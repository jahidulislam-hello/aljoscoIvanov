import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/filter/filter_controller/filter_controller.dart';
import 'package:get/get.dart';


class FilterScreen extends StatelessWidget {
  final controller = Get.put(FilterController());

  FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Icon(Icons.close, color: AppColors.mainTextColor),
        title: Text("Filter", style: AppTextStyles.bioText),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GetBuilder<FilterController>(
          builder: (_) => SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                _buildExpandableSection("Meal Type", controller.mealTypes),
                _buildExpandableSection("Recipe Components", controller.recipeComponents),
                _buildExpandableSection("Cooking Mode", controller.cookingModes),
                _buildExpandableSection("Flavor Profile", controller.flavorProfiles),
                _buildExpandableSection("Cuisine Type", controller.cuisineTypes),
                _buildExpandableSection("Season", controller.seasons),
                _buildExpandableSection("Diet Type", controller.dietTypes),
                _buildExpandableSection("Allergens (Exclude)", controller.allergens),
                SizedBox(height: 20.h),
                _buildApplyButton(),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, RxList items) {
    bool expanded = controller.expandedSections[title] ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => controller.toggleSection(title),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.H5_Regular),
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.borderSecondary,
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: items.map<Widget>((option) {
              return ChoiceChip(
                label: Text(option.name, style: AppTextStyles.H6_Regular),
                selected: option.isSelected,
                onSelected: (_) => controller.toggleSelection(option),
                backgroundColor: AppColors.background,
                selectedColor: AppColors.defaultbackground.withOpacity(0.8),
                labelStyle: option.isSelected
                    ? AppTextStyles.H5_Regular.copyWith(color: Colors.white)
                    : AppTextStyles.H5_Regular.copyWith(color: AppColors.mainTextColor),
              );
            }).toList(),
          ),
        Divider(height: 20.h, color: AppColors.borderSecondary),
      ],
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: controller.applyFilters,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Text("APPLY FILTERS", style: AppTextStyles.H4_Regular.copyWith(color: Colors.white)),
      ),
    );
  }
}
