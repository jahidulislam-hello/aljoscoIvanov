import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/recepies/cooking/cooking_details_controller/cooking_details_controller.dart';
import 'package:get/get.dart';


class CookingDetailsScreen extends StatelessWidget {
  const CookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CookingDetailsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.buttonColor),
          onPressed: () => Get.back(),
        ),
        title: Text("Cooking Details",
            style: AppTextStyles.H5_Regular.copyWith(fontSize: 18.sp)),
        centerTitle: true,
      ),
      body: Obx(() {
        final r = controller.recipe;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======== IMAGES ========
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.asset(
                  r.images.first,
                  height: 200.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 70.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: r.images.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (_, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(r.images[i], width: 80.w, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // ======== TITLE & RATING ========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r.title, style: AppTextStyles.H4_Regular.copyWith(fontSize: 20.sp)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18.sp),
                      SizedBox(width: 4.w),
                      Text("${r.rating}", style: AppTextStyles.heading1),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // ======== DESCRIPTION ========
              Text(r.description,
                  style: AppTextStyles.H4_Regular
                      .copyWith(fontSize: 13.sp, color: AppColors.defaultTextColor)),
              SizedBox(height: 16.h),

              // ======== TAGS ========
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: r.tags
                    .map((t) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(t,
                      style: AppTextStyles.buttonRegular.copyWith(fontSize: 12.sp)),
                ))
                    .toList(),
              ),
              SizedBox(height: 20.h),

              // ======== INGREDIENTS ========
              Text("Ingredients", style: AppTextStyles.H3_Regular.copyWith(fontSize: 14.sp)),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("For ${controller.servings} servings",
                            style: AppTextStyles.HeadBold.copyWith(fontSize: 13.sp)),
                        Row(
                          children: [
                            IconButton(
                                onPressed: controller.decreaseServings,
                                icon: Icon(Icons.remove_circle_outline, size: 22.sp)),
                            Text("${controller.servings.value}",
                                style: AppTextStyles.H4_Regular.copyWith(fontSize: 14.sp)),
                            IconButton(
                                onPressed: controller.increaseServings,
                                icon: Icon(Icons.add_circle_outline, size: 22.sp)),
                          ],
                        ),
                      ],
                    ),
                    ...r.ingredients.map(
                          (i) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(i.name, style: AppTextStyles.buttonText),
                            Text(i.quantity,
                                style: AppTextStyles.buttonRegular
                                    .copyWith(color: AppColors.mainTextColor)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // ======== SKILLS ========
              _expandableHeader(
                "Skills Required",
                controller.skillsExpanded.value,
                controller.toggleSkills,
              ),
              if (controller.skillsExpanded.value)
                ...r.skills.map((s) => _simpleTile(s)),
              SizedBox(height: 16.h),

              // ======== INSTRUCTIONS ========
              _expandableHeader(
                "Instructions",
                controller.instructionsExpanded.value,
                controller.toggleInstructions,
              ),
              if (controller.instructionsExpanded.value)
                ...r.instructions.map((i) => _instructionTile(i.step, i.text)),
              if (controller.instructionsExpanded.value)
                _mainButton("START COOKING", AppColors.primary),
              SizedBox(height: 24.h),

              // ======== NUTRITION ========
              Text("Nutritional Values (1 serving = 500g)",
                  style: AppTextStyles.H3_Regular.copyWith(fontSize: 14.sp)),
              SizedBox(height: 8.h),
              _nutritionRow("Energy", r.nutrition.energy),
              _nutritionRow("Fat", r.nutrition.fat),
              _nutritionRow("Saturates", r.nutrition.saturated),
              _nutritionRow("Carbohydrates", r.nutrition.carbs),
              _nutritionRow("Sugars", r.nutrition.sugars),
              _nutritionRow("Fibre", r.nutrition.fibre),
              _nutritionRow("Protein", r.nutrition.protein),
              _nutritionRow("Salt", r.nutrition.salt),
              SizedBox(height: 24.h),

              // ======== NOTES ========
              _expandableHeader(
                "Personal Notes (${r.notes.length})",
                controller.notesExpanded.value,
                controller.toggleNotes,
              ),
              if (controller.notesExpanded.value)
                ...r.notes.map((n) => _noteTile(n.userName, n.text, n.avatar)),
              SizedBox(height: 32.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _expandableHeader(String title, bool expanded, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.H3_Regular.copyWith(fontSize: 14.sp)),
          Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.mainTextColor)
        ],
      ),
    );
  }

  Widget _simpleTile(String text) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
    margin: EdgeInsets.only(top: 6.h),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Text(text, style: AppTextStyles.buttonRegular),
  );

  Widget _instructionTile(int step, String text) => Container(
    margin: EdgeInsets.only(top: 8.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26.w,
          height: 26.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text("$step",
              style: AppTextStyles.H4_Regular
                  .copyWith(color: Colors.white, fontSize: 12.sp)),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(text,
              style: AppTextStyles.button.copyWith(fontSize: 13.sp)),
        ),
      ],
    ),
  );

  Widget _nutritionRow(String label, String value) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.buttonText
                .copyWith(color: AppColors.defaultTextColor, fontSize: 13.sp)),
        Text(value,
            style: AppTextStyles.button
                .copyWith(color: AppColors.mainTextColor, fontSize: 13.sp)),
      ],
    ),
  );

  Widget _noteTile(String name, String text, String avatar) => Container(
    margin: EdgeInsets.only(top: 10.h),
    padding: EdgeInsets.all(10.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18.r,
          backgroundImage: AssetImage(avatar), // ✅ FIXED
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: AppTextStyles.body.copyWith(fontSize: 13.sp)),
              SizedBox(height: 4.h),
              Text(
                text,
                style: AppTextStyles.body.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.defaultTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );


  Widget _mainButton(String label, Color color) => Container(
    width: double.infinity,
    height: 48.h,
    margin: EdgeInsets.only(top: 16.h),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
      onPressed: () {},
      child: Text(label,
          style: AppTextStyles.H3_Regular
              .copyWith(color: Colors.white, fontSize: 14.sp)),
    ),
  );
}
