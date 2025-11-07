import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_controller/home_recepies_controller.dart';
import 'package:get/get.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
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
                      CircleAvatar(
                        radius: 22.r,
                        backgroundImage: AssetImage(AppImages.appLogo),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hi, Hariza", style: AppTextStyles.H4_Regular),
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
                    child: const Icon(Icons.menu),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Search bar
              Container(
                height: 45.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  color: AppColors.pureWhite,
                ),
                child: Row(
                  children: [
                    SizedBox(width: 12.w),
                    Icon(Icons.search, color: AppColors.mainTextColor),
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
                    Icon(Icons.tune, color: AppColors.background),
                    SizedBox(width: 12.w),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Featured recipe card
              Obx(() {
                if (controller.recipes.isEmpty) return SizedBox.shrink();
                final item = controller.recipes.first;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: AppColors.pureWhite,
                  ),
                  padding: EdgeInsets.all(12.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.category,
                                style: AppTextStyles.bioText.copyWith(
                                    color: AppColors.defaultTextColor)),
                            SizedBox(height: 4.h),
                            Text(item.title,
                                style: AppTextStyles.H4_Regular
                                    .copyWith(color: AppColors.background)),
                            SizedBox(height: 4.h),
                            Text(item.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bioText),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.asset(item.image,
                            width: 90.w, height: 80.h, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 20.h),

              // Let’s cook section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Let`s cook!",
                      style: AppTextStyles.H3_Regular
                          .copyWith(fontWeight: FontWeight.w700)),
                  Text("See all",
                      style: AppTextStyles.bioText
                          .copyWith(color: AppColors.mainTextColor)),
                ],
              ),
              SizedBox(height: 10.h),

              Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.recipes
                      .skip(1)
                      .map((recipe) => Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.asset(recipe.image,
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover),
                        ),
                        SizedBox(height: 6.h),
                        Text(recipe.title,
                            style: AppTextStyles.bioText),
                      ],
                    ),
                  ))
                      .toList(),
                ),
              )),

              SizedBox(height: 20.h),

              // Next planned prep list
              Text("Next planned Prep List:",
                  style: AppTextStyles.H4_Regular
                      .copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 4.h),
              Text("Regular meal plan",
                  style: AppTextStyles.H4_Regular
                      .copyWith(fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
                  style: AppTextStyles.body),

              SizedBox(height: 20.h),

              // Next planned shopping
              Text("Next planned Shopping:",
                  style: AppTextStyles.H4_Regular
                      .copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 6.h),
              Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
                  style: AppTextStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}
