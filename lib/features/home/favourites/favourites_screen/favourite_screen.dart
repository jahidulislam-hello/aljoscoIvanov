import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: AppColors.mainTextColor),
        title: Text("Favorites", style: AppTextStyles.H5_Regular),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Icon(Icons.menu, color: AppColors.mainTextColor),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SizedBox(height: 20.h),
              Text("Recent Favorites", style: AppTextStyles.H4_Regular),
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
    return TextField(
      onChanged: controller.updateSearch,
      decoration: InputDecoration(
        hintText: "Search recipes",
        hintStyle: AppTextStyles.bioText.copyWith(color: AppColors.buttonColor),
        prefixIcon: Icon(Icons.search, color: AppColors.buttonColor),
        suffixIcon: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.filter_alt, color: Colors.white),
        ),
        filled: true,
        fillColor: AppColors.mainTextColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
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
                      child: Image.asset(recipe.image, height: 100.h, width: 160.w, fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 8.w,
                      top: 8.h,
                      child: Icon(Icons.favorite, color: AppColors.background),
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
        childAspectRatio: 1.1,
      ),
      itemBuilder: (_, i) {
        final collection = controller.collections[i];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(collection['image']!, fit: BoxFit.cover),
              Container(
                color: Colors.black26,
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(10.w),
                child: Text(collection['title']!,
                    style: AppTextStyles.H5_Regular.copyWith(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    ));
  }
}
