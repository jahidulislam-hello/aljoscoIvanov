import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/select_meal_popup_controller/select_meal_popup_controller.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/select_meal_popup_model/select_meal_popup_model.dart';
import 'package:get/get.dart';

class SelectMealPopup extends StatelessWidget {
  final controller = Get.put(SelectMealPopupController());
  final Function(SelectMealPopupModel)? onRecipeSelected;

  SelectMealPopup({super.key, this.onRecipeSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSearchBar(),
            SizedBox(height: 20.h),
            Text("My Recipes", style: AppTextStyles.H5_Regular),
            SizedBox(height: 12.h),
            _buildHorizontalList(controller.myRecipes),
            SizedBox(height: 24.h),
            Text("Popular Recipes", style: AppTextStyles.H5_Regular),
            SizedBox(height: 12.h),
            _buildHorizontalList(controller.popularRecipes),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  // ---------------- SEARCH BAR ----------------
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 45.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r),
              color: Colors.white, // Keep white for contrast in search field
            ),
            child: Row(
              children: [
                SizedBox(width: 12.w),
                Image.asset(AppImages.search, width: 22.w, height: 22.h),
                Expanded(
                  child: TextField(
                    onChanged: controller.updateSearch,
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
              borderRadius: BorderRadius.circular(5.r)),
          child: Center(
            child: Image.asset(AppImages.filter,
                width: 22.w, height: 22.h, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ---------------- HORIZONTAL LIST ----------------
  Widget _buildHorizontalList(RxList<SelectMealPopupModel> list) {
    return SizedBox(
      height: 180.h,
      child: Obx(
        () {
          // Show loading indicator only if the specific list is empty AND loading
          if (controller.isLoading.value && list.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.buttonColor,
              ),
            );
          }

          if (list.isEmpty) {
            return Center(
              child: Text(
                "No recipes available",
                style: AppTextStyles.bioText,
              ),
            );
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: list.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, i) {
              final recipe = list[i];
              return _buildCard(recipe);
            },
          );
        },
      ),
    );
  }

  // ---------------- SINGLE CARD ----------------
  Widget _buildCard(SelectMealPopupModel recipe) {
    return GestureDetector(
      onTap: () {
        if (onRecipeSelected != null) {
          Get.back();
          onRecipeSelected!(recipe);
        }
      },
      child: Container(
        width: 150.w,
        decoration: BoxDecoration(
          color: Colors.transparent, // Changed from white to transparent
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: recipe.image.startsWith('http')
                      ? Image.network(
                          recipe.image,
                          height: 110.h,
                          width: 150.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 110.h,
                              width: 150.w,
                              color: AppColors.buttonColor.withOpacity(0.3),
                              child: Icon(
                                Icons.restaurant,
                                color: AppColors.buttonColor,
                                size: 40,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 110.h,
                              width: 150.w,
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
                          width: 150.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 110.h,
                              width: 150.w,
                              color: AppColors.buttonColor.withOpacity(0.3),
                              child: Icon(
                                Icons.restaurant,
                                color: AppColors.buttonColor,
                                size: 40,
                              ),
                            );
                          },
                        ),
                ),

                // Favourite icon
                Positioned(
                  right: 8.w,
                  top: 8.h,
                  child: Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.black.withOpacity(0.2), width: 0.3)),
                    child: Center(
                      child: SvgPicture.asset(
                        AppImages.favourite,
                        width: 14.w,
                        height: 14.h,
                        color: AppColors.buttonColor,
                      ),
                    ),
                  ),
                )
              ],
            ),

            // Title + Time - with white background for readability
            Container(
              width: 150.w,
              decoration: BoxDecoration(
                color: Colors.white, // Keep white for readability
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipe.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.H5_Regular),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        SvgPicture.asset(AppImages.outline_time,
                            width: 14.w, height: 14.h),
                        SizedBox(width: 4.w),
                        Text("${recipe.timeMinutes} min",
                            style: AppTextStyles.bioText),
                      ],
                    )
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
