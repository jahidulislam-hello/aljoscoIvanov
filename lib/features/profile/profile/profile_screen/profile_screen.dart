import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/profile/profile/model/profile_recipe_model.dart';
import 'package:freshbite/features/profile/profile/profile_controller/profile_controller.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoadingProfile.value && controller.user.value == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshProfile,
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 24.h),
                        _buildProfileHeader(),
                        SizedBox(height: 32.h),
                        _buildProfileInformation(),
                        SizedBox(height: 32.h),
                        _buildTabs(),
                        SizedBox(height: 16.h),
                        _buildContent(),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return CustomAppBar(
      title: 'My Profile',
      titleStyle: AppTextStyles.heading2,
      // padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      showShadow: false,
      actionButtons: [
        AppBarAction(
          icon: Icons.settings_outlined,
          onPressed: () => controller.openSettings(),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Obx(() {
      final user = controller.user.value;
      if (user == null) {
        return SizedBox.shrink();
      }

      return Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.lightGrey,
                  image: user.profileImageUrl != null
                      ? DecorationImage(
                    image: NetworkImage(user.profileImageUrl!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: user.profileImageUrl == null
                    ? Icon(
                  Icons.person,
                  size: 60.sp,
                  color: AppColors.grey,
                )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => controller.changeProfilePicture(),
                  child: Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.background,
                        width: 3.w,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 18.sp,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            user.name,
            style: AppTextStyles.heading2,
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: () => controller.editProfile(),
            child: Text(
              'Edit Profile',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.borderSecondary,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey, width: 1.5.w),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  user.isGuestUser
                      ? Icons.person_outline
                      : Icons.workspace_premium,
                  size: 16.sp,
                  color: user.isTrialUser
                      ? Colors.orange
                      : user.isGuestUser
                          ? AppColors.grey
                          : AppColors.black,
                ),
                SizedBox(width: 6.w),
                Text(
                  user.getPlanDisplayName(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: user.isTrialUser
                        ? Colors.orange
                        : user.isGuestUser
                            ? AppColors.grey
                            : AppColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProfileInformation() {
    return Obx(() {
      final user = controller.user.value;
      if (user == null) {
        return SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style: AppTextStyles.heading3,
            ),
            SizedBox(height: 16.h),
            _buildInfoRow('User id', user.userId),
            SizedBox(height: 12.h),
            _buildInfoRow('Email', user.email),
            SizedBox(height: 12.h),
            _buildInfoRow('Phone number', user.phoneNumber),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mainTextColor,
            ),
          ),
        ),
        Text(
          ':',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.lightGrey,
              width: 1.w,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: controller.selectedTabIndex.value == 0
                            ? AppColors.defaultbackground
                            : Colors.transparent,
                        width: 2.w,
                      ),
                    ),
                  ),
                  child: Text(
                    'My Recipes',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: controller.selectedTabIndex.value == 0
                          ? AppColors.defaultbackground
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.changeTab(1),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: controller.selectedTabIndex.value == 1
                            ? AppColors.defaultbackground
                            : Colors.transparent,
                        width: 2.w,
                      ),
                    ),
                  ),
                  child: Text(
                    'Activities',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: controller.selectedTabIndex.value == 1
                          ? AppColors.defaultbackground
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildContent() {
    return Obx(() {
      if (controller.selectedTabIndex.value == 0) {
        return _buildRecipesList(showLikeButton: true);
      } else {
        return _buildRecipesList(showLikeButton: false, showTimeAgo: true);
      }
    });
  }

  Widget _buildRecipesList({
    required bool showLikeButton,
    bool showTimeAgo = false,
  }) {
    return Obx(() {
      if (controller.isLoadingRecipes.value && controller.recipes.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 40.h),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
        );
      }

      if (controller.recipes.isEmpty) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 64.sp,
                  color: AppColors.grey,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No recipes yet',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: controller.recipes.length,
        itemBuilder: (context, index) {
          final recipe = controller.recipes[index];
          return _buildRecipeCard(
            recipe,
            showLikeButton: showLikeButton,
            showTimeAgo: showTimeAgo,
          );
        },
      );
    });
  }

  Widget _buildRecipeCard(
      ProfileRecipeModel recipe, {
        required bool showLikeButton,
        required bool showTimeAgo,
      }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.lightGrey,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: recipe.imageUrl.isNotEmpty
                  ? Image.network(
                      recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.restaurant,
                          size: 40.sp,
                          color: AppColors.grey,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        );
                      },
                    )
                  : Icon(
                      Icons.restaurant,
                      size: 40.sp,
                      color: AppColors.grey,
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You added ${recipe.title} to your collection',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () => controller.viewRecipe(recipe.id),
                  child: Row(
                    children: [
                      Text(
                        showTimeAgo ? recipe.getTimeAgo() : 'See recipe',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (!showTimeAgo) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10.sp,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showLikeButton) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () => controller.toggleLike(recipe.id),
              child: Icon(
                recipe.isLiked ? Icons.favorite : Icons.favorite_border,
                color: recipe.isLiked ? Colors.red : AppColors.grey,
                size: 24.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
