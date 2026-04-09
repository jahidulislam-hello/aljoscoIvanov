import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/home_menu/home_menu_screen/home_menu_screen.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_controller/home_recepies_controller.dart';
import 'package:freshbite/features/home/search_filter/search_filter_screen/search_filter_screen.dart';
import 'package:freshbite/core/navbar/controller/navbar_controller.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_screen/recipes_details_screen.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_controller/recipes_details_controller.dart';
import 'package:get/get.dart';
import 'package:freshbite/features/splash/create_account/create_account_prompt.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';

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
                            radius: 30.r,
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
                            style: AppTextStyles.heading2.copyWith(
                                color: AppColors.buttonColor),
                          )),
                          Text("Ready to cook?".tr,
                              style: AppTextStyles.body.copyWith(
                                  color: AppColors.mainTextColor)),
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
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.w),
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
              ),
              SizedBox(height: 20.h),

              // Show search results or default content
              Obx(() {
                if (controller.isSearching.value) {
                  return _buildSearchResults();
                }

                // Default content when not searching
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Featured recipe carousel with auto-swipe
                    if (controller.featuredRecipes.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(
                            height: 160.h,
                            child: PageView.builder(
                              controller: controller.featuredPageController,
                              onPageChanged: controller.onFeaturedPageChanged,
                              itemCount: controller.featuredRecipes.length,
                              itemBuilder: (context, index) {
                                final item = controller.featuredRecipes[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 20.h),
                                  child: Stack(
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
                                  ),
                                );
                              },
                            ),
                          ),
                          // Page indicator dots
                          Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              controller.featuredRecipes.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                width: controller.currentFeaturedIndex.value == index ? 20.w : 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.r),
                                  color: controller.currentFeaturedIndex.value == index
                                      ? AppColors.buttonColor
                                      : AppColors.mainTextColor.withOpacity(0.3),
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),

                    SizedBox(height: 20.h),

                    // Let's cook section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Let's cook!".tr,
                          style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Switch to RecipeRecipeSearchScreen tab in navbar (index 3)
                            Get.find<BottomNavbarController>().changeIndex(3);
                          },
                          child: Text(
                            "See all".tr,
                            style: AppTextStyles.bioText.copyWith(color: AppColors.buttonColor),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    SingleChildScrollView(
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
                    ),

                    SizedBox(height: 20.h),

                    // Next Planned Prep List Section
                    Text(
                      "Next planned Prep List:".tr,
                      style: AppTextStyles.heading2.copyWith(
                          fontWeight: FontWeight.w600, color: AppColors.black),
                    ),
                    SizedBox(height: 20.h),
                    Builder(builder: (context) {
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
                            "You don't have a meal plan yet. Go to the meal planning section to create one.".tr,
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
                              Text(
                                controller.assignedText.value,
                                style: AppTextStyles.bioText.copyWith(
                                    color: AppColors.mainTextColor.withOpacity(0.7)),
                              ),
                              SizedBox(height: 16.h),
                            ],
                          );
                        }).toList(),
                      );
                    }),

                    SizedBox(height: 30.h),

                    // Next Planned Shopping Section
                    Text(
                      "Next planned Shopping:".tr,
                      style: AppTextStyles.heading2.copyWith(
                          fontWeight: FontWeight.w600, color: AppColors.black),
                    ),
                    SizedBox(height: 20.h),
                    Builder(builder: (context) {
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
                            "You don't have a meal plan yet. Go to the meal planning section to create one.".tr,
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
                                      Text(
                                        controller.assignedText.value,
                                        style: AppTextStyles.bioText.copyWith(
                                            color: AppColors.mainTextColor.withOpacity(0.7)),
                                      ),
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
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Search results widget for HomeScreen
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
              "Found @count recipes for \"@query\"".tr.replaceAll('@count', controller.totalSearchResults.value.toString()).replaceAll('@query', controller.searchQuery.value),
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
                    "No recipes found for \"@query\"".tr.replaceAll('@query', controller.searchQuery.value),
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
                onTap: () async {
                  bool isGuest = await SharedPreferencesHelper.isGuest();
                  if (isGuest) {
                    Get.dialog(const CreateAccountPromptPage(), barrierDismissible: true);
                    return;
                  }
                  
                  if (recipe.recipeId != null && recipe.recipeId!.isNotEmpty) {
                    Get.delete<RecipesDetailsRecipeController>();
                    Get.put(RecipesDetailsRecipeController(recipeId: recipe.recipeId!));
                    Get.to(() => RecipesDetailsRecipeScreen());
                  }
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
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                        child: _buildImage(
                          recipe.image,
                          width: double.infinity,
                          height: 120.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                recipe.category, // This is the actual recipe title
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
                                    recipe.title, // This is cooking mode
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




class _SidebarMenuOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // BLUR BACKGROUND + CLOSE TAP
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
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

