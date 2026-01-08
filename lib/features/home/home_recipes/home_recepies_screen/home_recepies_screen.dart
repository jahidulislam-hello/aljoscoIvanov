import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/home_menu/home_menu_screen/home_menu_screen.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_controller/home_recepies_controller.dart';
import 'package:freshbite/features/home/recipe_search/recipe_search_screen/receipe_search_screen.dart';
import 'package:freshbite/features/home/search_filter/search_filter_screen/search_filter_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  // Helper method to determine if image is a network URL or local asset
  Widget _buildImage(String imagePath, {required double width, required double height, BoxFit fit = BoxFit.cover}) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // Network image
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to placeholder if network image fails
          return Container(
            width: width,
            height: height,
            color: AppColors.background,
            child: Icon(Icons.image_not_supported, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: AppColors.background,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );
    } else {
      // Local asset
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(() {
                        if (controller.userProfileImage.value.isNotEmpty) {
                          return CircleAvatar(
                            radius: 22.r,
                            backgroundImage: NetworkImage(controller.userProfileImage.value),
                            backgroundColor: AppColors.background,
                            onBackgroundImageError: (exception, stackTrace) {
                              debugPrint('Error loading profile image');
                            },
                          );
                        } else {
                          return CircleAvatar(
                            radius: 22.r,
                            backgroundImage: AssetImage(AppImages.appLogo),
                          );
                        }
                      }),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            "Hi, ${controller.userName.value}",
                            style: AppTextStyles.H4_Regular,
                          )),
                          Text("Ready to cook?",
                              style: AppTextStyles.bioText.copyWith(
                                  color: AppColors.defaultTextColor)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: AppColors.pureWhite,
                    ),
                    padding: EdgeInsets.all(8.r),
                    child: GestureDetector(
                      onTap: () {
                        Get.dialog(
                          _SidebarMenuOverlay(),
                          barrierColor: Colors.black.withOpacity(0.3), // transparent background
                          useSafeArea: false,
                        );
                      },

                      child: const Icon(Icons.menu),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 16.h),

              // Search bar
              Row(
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
                            width: 24.w,          // adjust size as needed
                            height: 24.h,
                            color: AppColors.mainTextColor, // optional: if you want to tint the PNG
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search recipes",
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.w),
                              ),
                            ),
                          ),
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
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.tune,
                          color: AppColors.pureWhite,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20.h),

              // Featured recipe card
              Obx(() {
                if (controller.featuredRecipe.value == null) return const SizedBox.shrink();
                final item = controller.featuredRecipe.value!;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: AppColors.pureWhite,
                      ),
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.category,
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.mainTextColor)),
                                SizedBox(height: 4.h),
                                Text(item.title,
                                    style: AppTextStyles.HeadBold.copyWith(
                                        color: AppColors.mainTextColor)),
                                SizedBox(height: 6.h),
                                Text(item.description,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.mainTextColor,
                                        height: 1.4)),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.w),
                          SizedBox(width: 100.w),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 2.w,
                      bottom: -20.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: _buildImage(
                          item.image,
                          width: 140.w,
                          height: 150.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: 20.h),

              // Let’s cook section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Let's cook!",
                    style: AppTextStyles.heading1.copyWith(fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to RecipeSearchScreen
                      Get.to(() => RecipeSearchScreen());
                    },
                    child: Text(
                      "See all",
                      style: AppTextStyles.bioText.copyWith(color: AppColors.buttonColor),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.recipes
                      .map((recipe) => Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                              BorderRadius.circular(12.r),
                              child: _buildImage(
                                recipe.image,
                                width: 110.w,
                                height: 145.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 32.h,
                                decoration: BoxDecoration(
                                  color: Colors.black
                                      .withOpacity(0.4),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                    Radius.circular(12.r),
                                    bottomRight:
                                    Radius.circular(12.r),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  recipe.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles
                                      .buttonRegular
                                      .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              )),

              SizedBox(height: 20.h),

              // Next Planned Prep List Section
              Text(
                "Next planned Prep List:",
                style: AppTextStyles.heading2.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.black),
              ),
              SizedBox(height: 20.h),
              Obx(
                    () {
                  if (controller.prepList.isEmpty) {
                    // Show placeholder card when no prep data
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        "You don’t have a meal plan yet. Go to the meal planning section to create one.",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.mainTextColor.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                    );
                  }

                  // Show normal PrepList UI when data exists
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.prepList.map((prep) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prep.title,
                            style: AppTextStyles.H6_Regular.copyWith(
                                fontWeight: FontWeight.w600, color: AppColors.black),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            prep.description,
                            style: AppTextStyles.body.copyWith(
                                color: AppColors.black, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 4.h),
                          Obx(() => Text(
                            controller.assignedText.value,
                            style: AppTextStyles.bioText.copyWith(
                                color: AppColors.mainTextColor.withOpacity(0.7)),
                          )),
                          SizedBox(height: 16.h),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),

              SizedBox(height: 30.h),

// Next Planned Shopping Section
              Text(
                "Next Planned Shopping:",
                style: AppTextStyles.heading2.copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.black),
              ),
              SizedBox(height: 20.h),
              Obx(
                    () {
                  if (controller.shoppingList.isEmpty) {
                    // Show placeholder card when no shopping data
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        "You don’t have a meal plan yet. Go to the meal planning section to create one.",
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.mainTextColor.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),
                    );
                  }

                  // Show normal ShoppingList UI when data exists
                  return Column(
                    children: controller.shoppingList.map((shop) {
                      return Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Container(
                                width: 70.w,
                                height: 70.h,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.buttonColor),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: _buildImage(
                                  shop.image,
                                  width: 70.w,
                                  height: 70.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shop.title,
                                    style: AppTextStyles.H6_Regular.copyWith(
                                        fontWeight: FontWeight.w600, color: AppColors.black),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    shop.description,
                                    style: AppTextStyles.body.copyWith(
                                        color: AppColors.black, fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(height: 4.h),
                                  Obx(() => Text(
                                    controller.assignedText.value,
                                    style: AppTextStyles.bioText.copyWith(
                                        color: AppColors.mainTextColor.withOpacity(0.7)),
                                  )),
                                ],
                              ),
                            ),
                            Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(AppImages.appLogo),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}




class _SidebarMenuOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // BLUR BACKGROUND + CLOSE TAP
        GestureDetector(
          onTap: () => Get.back(),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),

        // SIDEBAR
        Align(
          alignment: Alignment.centerLeft,
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: -250, end: 0),
            duration: const Duration(milliseconds: 250),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(value, 0),
                child: child,
              );
            },
            child: SafeArea(
              child: Container(
                width: 300,
                height: Get.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r), // FULL 10
                ),
                child: HomeScreenMenu(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

