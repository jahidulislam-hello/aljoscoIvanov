import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/favourites/favourites_controller/favourites_controller.dart';
import 'package:get/get.dart';


class FavoritesScreen extends StatelessWidget {
  final controller = Get.put(FavoritesController());

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight((56.h) + 20.h), // Original height + desired top spacing
        child: Column(
          children: [
            SizedBox(height: 30.h), // Top spacing
            CustomAppBar(
              title: 'Favourites',
              titleAlignment: AppBarTitleAlignment.center,
              showBackButton: true,
              actionButtons: [
                AppBarAction(
                  imagePath: 'assets/icons/charm_menu.png', // your menu icon asset
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SizedBox(height: 20.h),
              Text("Recent Favorites", style: AppTextStyles.H5_Regular),
              SizedBox(height: 12.h),
              _buildRecentFavorites(),
              SizedBox(height: 24.h),
              _buildCollectionsHeader(),
              SizedBox(height: 12.h),
              _buildCollectionsGrid(),
            ],
          ),
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
            color: Colors.black,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Center(
            child: Image.asset(
              AppImages.filter, // your PNG asset path
              width: 24.w,      // adjust size as needed
              height: 24.h,
              color: AppColors.mainTextColor,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildRecentFavorites() {
    return Obx(() => SizedBox(
      height: 210.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.recentFavorites.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (_, i) {
          final recipe = controller.recentFavorites[i];
          return Container(
            width: 160.w,
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
                      child: Image.asset(recipe.image, height: 130.h, width: 160.w, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: Image.asset(
                        'assets/icons/favourite.png', // your image path
                        width: 24.w,
                        height: 24.w,
                        color: AppColors.borderSecondary, // remove this if you don't want tint
                      ),
                    )

                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.title, style: AppTextStyles.bioText),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14.sp, color: AppColors.defaultbackground),
                          SizedBox(width: 4.w),
                          Text("${recipe.timeMinutes} min", style: AppTextStyles.bioText),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < recipe.rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            size: 14.sp,
                            color: AppColors.mainTextColor,
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
      ),
    ));
  }

  Widget _buildCollectionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Collections", style: AppTextStyles.bioText),
        Text("Create", style: AppTextStyles.bioText),
      ],
    );
  }


  Widget _buildCollectionsGrid() {
    return Obx(() => GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.collections.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.8, // Adjust for image + text layout
      ),
      itemBuilder: (_, i) {
        final collection = controller.collections[i];
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
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.asset(
                  collection['image']!,
                  width: double.infinity,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Text(
                  collection['title']!,
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
