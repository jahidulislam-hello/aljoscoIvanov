import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/my_recipes/my_recipes_controller/my_recipes_controller.dart';
import 'package:get/get.dart';


class MyRecipesScreen extends StatelessWidget {
  final controller = Get.put(MyRecipesController());

  MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'My Recipes',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(imagePath: 'assets/icons/charm_menu.png', onPressed: () {}),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 20.h),
            Text("My Recipes", style: AppTextStyles.H5_Regular),
            SizedBox(height: 12.h),
            Expanded(child: _buildRecipeGrid()),
          ],
        ),
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
                  AppImages.search, // your PNG asset path
                  width: 24.w,      // adjust size as needed
                  height: 24.h,
                  color: AppColors.mainTextColor, // optional: tint the PNG
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
              AppImages.filter, // your PNG asset path
              width: 24.w,      // adjust size as needed
              height: 24.h,
              color: AppColors.pureWhite,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildRecipeGrid() {
    return Obx(() {
      final recipes = controller.filteredRecipes;
      return GridView.builder(
        itemCount: recipes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, i) {
          final recipe = recipes[i];
          return Container(
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
                      child: Image.asset(recipe.image,
                          height: 120.h, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 16.w,
                      top: 12.h,
                      child: Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,      // background circle color
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black.withOpacity(0.2),  // subtle border color
                            width: 0.25,                            // border width
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppImages.favourite,   // your SVG asset path
                            width: 14.w,
                            height: 14.h,
                            color: AppColors.buttonColor, // optional tint
                          ),
                        ),

                      ),
                    ),

                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.title,
                          style: AppTextStyles.H5_Regular,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.outline_time,        // your SVG path
                            width: 16.w,
                            height: 16.h,
                            color: AppColors.buttonColor,
                          ),

                          SizedBox(width: 6.w),
                          Text("${recipe.timeMinutes} min",
                              style: AppTextStyles.bioText),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 4.w),   // space between stars
                            child: SvgPicture.asset(
                              index < recipe.rating.round()
                                  ? AppImages.fill_star
                                  : AppImages.blank_star,
                              width: 16.w,
                              height: 16.h,
                              color: AppColors.buttonColor,
                            ),
                          );
                        }),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
