import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/shopping_list/create_shopping/create_shopping_screen/create_shopping_screen.dart';
import 'package:freshbite/features/shopping_list/select_prep_list/select_prep_list_screen/select_prep_list_screen.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_controller/shopping_controller.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_model/shopping_model.dart';
import 'package:get/get.dart';

import '../../../new/widgets/primary_button.dart';


class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShoppingController());

    return Scaffold(
      backgroundColor: AppColors.background,

      // -------------------------------------
      // YOUR APPBAR (UNTOUCHED)
      // -------------------------------------
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Shopping',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(
                imagePath: 'assets/icons/charm_menu.png',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

      // -------------------------------------
      // BODY
      // -------------------------------------
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Calendar header container
            Container(
              margin: EdgeInsets.only(top: 8.h, bottom: 10.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Month selector row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              "January 2025",
                              style: AppTextStyles.heading1.copyWith(fontSize: 16.sp),
                            ),
                            SizedBox(width: 4.w),
                            Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
                          ],
                        ),
                      ),
                      Icon(Icons.more_vert, color: AppColors.grey),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  /// Weekday labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                        .map(
                          (e) => SizedBox(
                        width: 30.w,
                        child: Center(
                          child: Text(
                            e,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.textLight,
                            ),
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),

                  SizedBox(height: 8.h),

                  /// Dates row (15–21)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (i) {
                      final days = ["15", "16", "17", "18", "19", "20", "21"];
                      bool isSelected = days[i] == "18";

                      return InkWell(
                        onTap: () {
                          controller.changeDate(
                            DateTime(2025, 1, int.parse(days[i])),
                          );
                        },
                        child: Container(
                          width: 36.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.buttonColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            days[i],
                            style: AppTextStyles.body.copyWith(
                              fontSize: 14.sp,
                              color: isSelected ? Colors.white : AppColors.text,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  SizedBox(height: 8.h),

                  /// Icons row
                  Row(
                    children: [
                      Image.asset(AppImages.recipe_icon, width: 16.w, height: 16.h),
                      Image.asset(AppImages.shopping_icon, width: 16.w, height: 16.h),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  /// Title row
                  Obx(() {
                    final d = controller.selectedDate.value;
                    String formatted =
                        "${d.day}.${d.month}.${d.year.toString().substring(2)}";

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Shopping Lists for $formatted",
                          style: AppTextStyles.heading3.copyWith(fontSize: 14.sp),
                        ),
                        Text(
                          "Shopped by  Finished?",
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 11.sp,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 12.h),

                  /// LISTVIEW
                  SizedBox(
                    height: 300.h, // Must constrain inside column
                    child: Obx(
                          () => ListView.builder(
                        itemCount: controller.shoppingLists.length,
                        itemBuilder: (context, index) {
                          final item = controller.shoppingLists[index];
                          return _ShoppingListTile(
                            item: item,
                            onToggle: () => controller.toggleFinished(index),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // =======================
      // Floating Add Button
      // =======================
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        onPressed: () {
          showCreateShoppingListPopup(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 28.sp,
        ),
      ),
    );
  }
}






class _ShoppingListTile extends StatelessWidget {
  final ShoppingModel item;
  final VoidCallback onToggle;
  const _ShoppingListTile({
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          /// --- Image ---
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              bottomLeft: Radius.circular(8.r),
            ),
            child: Image.asset(
              item.image,
              width: 90.w,
              height: 90.h,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 10.w),

          /// --- Texts + Avatar + Tick ---
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTextStyles.heading1.copyWith(fontSize: 14.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.description,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10.r,
                        backgroundImage: AssetImage(AppImages.profile),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "created by ${item.createdBy}, on ${item.date}",
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 10.sp,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// --- Tick button ---
          GestureDetector(
            onTap: onToggle,
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              child: Icon(
                item.isFinished ? Icons.check_circle : Icons.radio_button_unchecked,
                color: item.isFinished ? AppColors.buttonColor : AppColors.buttonColor,
                size: 22.sp,
              ),
            ),
          ),
        ],
      ),

    );
  }
}











void showCreateShoppingListPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 360,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 42),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // TITLE
              Text(
                "How would you like to create your shopping list?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 24),

              // ==============================
              // FROM PREP LIST (CustomTextButton)
              // ==============================
              CustomTextButton(
                text: "FROM PREP LIST",
                onTap: () {
                  Navigator.pop(context); // close popup first
                  Get.to(() => SelectPrepListScreen());
                },

              ),

              const SizedBox(height: 14),

              // ==============================
              // CUSTOM (CustomTextButton)
              // ==============================
              CustomTextButton(
                text: "CUSTOM",
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => CreateShoppingScreen());
                },
              ),

              const SizedBox(height: 14),

              // ==============================
              // CANCEL (PrimaryButton)
              // ==============================
              PrimaryButton(
                text: "CANCEL",
                onPressed: () {
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

