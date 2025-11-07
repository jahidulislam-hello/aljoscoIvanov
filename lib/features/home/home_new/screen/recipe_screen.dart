import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/home/home_new/controller/recipe_controller.dart';
import 'package:get/get.dart';


class RecipeDetailScreen extends StatelessWidget {
  final controller = Get.put(RecipeDetailController());

  RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: AppColors.buttonColor),
        title: Text('Recipe', style: AppTextStyles.bioText),
        actions: [
          Icon(Icons.share, color: AppColors.mainTextColor),
          SizedBox(width: 12.w),
          Icon(Icons.favorite_border, color: AppColors.mainTextColor),
          SizedBox(width: 12.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Obx(() {
          final recipe = controller.recipe.value;
          if (recipe == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(AppImages.sashuka, fit: BoxFit.cover),
              ),
              SizedBox(height: 16.h),

              // Title + Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(recipe.title, style: AppTextStyles.H5_Regular),
                  Row(children: [
                    Icon(Icons.star, color: Colors.amber, size: 18.sp),
                    Text("${recipe.rating}", style: AppTextStyles.body),
                  ]),
                ],
              ),
              SizedBox(height: 8.h),

              Text(recipe.description, style: AppTextStyles.body),
              SizedBox(height: 16.h),

              // Allergens
              _buildExpandableSection(
                title: "Allergens",
                key: "allergens",
                content: Wrap(
                  spacing: 8.w,
                  children: recipe.allergens
                      .map((a) => Chip(
                    label: Text(a, style: AppTextStyles.bioText),
                    backgroundColor: AppColors.background,
                  ))
                      .toList(),
                ),
              ),

              // Ingredients
              _buildExpandableSection(
                title: "Ingredients",
                key: "ingredients",
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.ingredients
                      .map((item) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.keys.first, style: AppTextStyles.body),
                      Text(item.values.first,
                          style: AppTextStyles.body),
                    ],
                  ))
                      .toList(),
                ),
              ),

              SizedBox(height: 16.h),
              _buildTimerSection(),
              SizedBox(height: 16.h),

              // Skills
              _buildExpandableSection(
                title: "Skills Required",
                key: "skills",
                content: Column(
                  children: recipe.skills
                      .map((skill) => ListTile(
                    title: Text(skill, style: AppTextStyles.body),
                    dense: true,
                  ))
                      .toList(),
                ),
              ),

              // Instructions
              _buildExpandableSection(
                title: "Instructions",
                key: "instructions",
                content: Column(
                  children: recipe.instructions
                      .asMap()
                      .entries
                      .map((entry) => Card(
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.background,
                        child: Text("${entry.key + 1}",
                            style: AppTextStyles.H5_Regular
                                .copyWith(color: Colors.white)),
                      ),
                      title: Text(entry.value,
                          style: AppTextStyles.body),
                    ),
                  ))
                      .toList(),
                ),
              ),

              SizedBox(height: 16.h),
              _buildNotesSection(),
              SizedBox(height: 32.h),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required String key,
    required Widget content,
  }) {
    return Obx(() {
      final expanded = controller.isExpanded[key] ?? false;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(title, style: AppTextStyles.H5_Regular),
            trailing: Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.mainTextColor,
            ),
            onTap: () => controller.toggleExpand(key),
          ),
          if (expanded)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: content,
            ),
        ],
      );
    });
  }

  Widget _buildTimerSection() {
    return Obx(() {
      final recipe = controller.recipe.value;
      if (recipe == null) {
        return const SizedBox.shrink();
      }
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.background,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: recipe.timeOverview.entries
                  .map((e) => Column(
                children: [
                  Text(e.key, style: AppTextStyles.H6_Regular),
                  Text(e.value, style: AppTextStyles.HeadBold),
                ],
              ))
                  .toList(),
            ),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.background,
              minimumSize: Size(double.infinity, 46.h),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
            ),
            child:
            Text("START TIMER", style: AppTextStyles.buttonRegular.copyWith(color: Colors.white)),
          )
        ],
      );
    });
  }

  Widget _buildNotesSection() {
    return _buildExpandableSection(
      title: "Personal Notes",
      key: "notes",
      content: Obx(() {
        final recipe = controller.recipe.value;
        if (recipe == null) {
          return const SizedBox.shrink();
        }
        return Column(
          children: recipe.notes
              .map((note) => ListTile(
            leading: CircleAvatar(
                backgroundImage: AssetImage(AppImages.appLogo)),
            title: Text(note["name"]!, style: AppTextStyles.H4_Regular),
            subtitle: Text(note["note"]!, style: AppTextStyles.bioText),
          ))
              .toList(),
        );
      }),
    );
  }
}
