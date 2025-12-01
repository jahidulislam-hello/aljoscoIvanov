import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
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
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Favourites',
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

  void _showCreateCollectionPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ---------- Header Row ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Create New Collection",
                      style: AppTextStyles.H5_Regular,
                    ),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        size: 20.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 18.h),

                // ---------- Bordered Text Field ----------
                Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Collection name",
                      hintStyle: AppTextStyles.bioText,
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // ---------- CustomTextButton ----------
                CustomTextButton(
                  text: "Create Collection",
                  onTap: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    controller.addNewCollection(name);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildRecentFavorites() {
    return Obx(
          () => GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.recentFavorites.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 12.w,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, i) {
          final recipe = controller.recentFavorites[i];
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
                      child: Image.asset(
                        recipe.image,
                        height: 120.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Favourite Icon
                    Positioned(
                      right: 16.w,
                      top: 12.h,
                      child: Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black.withOpacity(0.2),
                            width: 0.25,
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppImages.favourite,
                            width: 14.w,
                            height: 14.h,
                            color: AppColors.buttonColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Text section
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: AppTextStyles.H5_Regular,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5.h),

                      Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.outline_time,
                            width: 16.w,
                            height: 16.h,
                            color: AppColors.buttonColor,
                          ),
                          SizedBox(width: 6.w),
                          Text("${recipe.timeMinutes} min", style: AppTextStyles.bioText),
                        ],
                      ),

                      SizedBox(height: 5.h),

                      // Rating stars
                      Row(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 4.w),
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
      ),
    );
  }


  Widget _buildCollectionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Collections", style: AppTextStyles.H5_Regular),
        GestureDetector(
          onTap: () => _showCreateCollectionPopup(Get.context!),
          child: Text("Create", style: AppTextStyles.bioText),
        ),


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
        childAspectRatio: 0.9,// Adjust for image + text layout
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
                  height: 131.h,
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













