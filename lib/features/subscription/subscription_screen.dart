import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/subscription/subscription_controller/subscription_controller.dart';
import 'package:get/get.dart';
import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';


class SubscriptionScreen extends StatelessWidget{
  SubscriptionScreen({super.key});

  final SubscriptionController controller = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: "Subscription"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            /// ---------- GRID: 2 BOXES IN EACH ROW ----------
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 0.58,
              children: [
                _card(
                  index: 0,
                  icon: AppImages.crown_icon,
                  title: "Guest /\n Free Account",
                  items: const [
                    "Free, single user",
                    "Access to 5 recipes",
                    "New recipes locked",
                    "Plan 1 day",
                    "Create up to 3 recipes",
                  ],
                  price: "CHF 00.00",
                  unit: "/month",
                ),
                _card(
                  index: 1,
                  icon: AppImages.family_icon,
                  title: "Family\n subscription",
                  items: const [
                    "Full access to all recipes",
                    "Invite 4 users",
                    "Synced meal planner",
                    "Shared notes",
                    "All users can create",
                  ],
                  price: "CHF 24.00",
                  unit: "/month",
                ),
                _card(
                  index: 2,
                  icon: AppImages.pepper_icon,
                  title: "Premium subscription",
                  items: const [
                    "Full access to all recipes",
                    "Unlimited planner",
                    "Save unlimited recipes",
                    "Kitchen skills library",
                    "Single user only",
                  ],
                  price: "CHF 19.00",
                  unit: "/month",
                ),
                _card(
                  index: 3,
                  icon: AppImages.handshake_icon,
                  title: "Premium trial (1 week)",
                  items: const [
                    "Free, single user",
                    "Full access",
                    "Limited to 1 week",
                  ],
                  price: "CHF 00.00",
                  unit: "/1 week",
                ),
              ],
            ),

            30.verticalSpace,

            /// ---------- PAY BUTTON ----------
            CustomTextButton(
              text: "PAY NOW",
              onTap: () {
                if (controller.selectedPlan.value == -1) {
                  Get.snackbar("Alert", "Please select a plan first");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ------------------------------------------------------------
  ///                  SINGLE CARD WIDGET
  /// ------------------------------------------------------------
  Widget _card({
    required int index,
    required String icon,
    required String title,
    required List<String> items,
    required String price,
    required String unit,
  }) {
    return Obx(() {
      bool isSelected = controller.selectedPlan.value == index;

      /// last card background color change
      Color cardBg = index == 3 ? AppColors.buttonColor : AppColors.background;

      /// text color for last card = white
      Color textColor = index == 3 ? Colors.white : AppColors.textPrimary;
      Color subTextColor = index == 3 ? Colors.white : AppColors.textSecondary;

      return GestureDetector(
        onTap: () => controller.selectPlan(index),

        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected ? AppColors.grey : AppColors.darkGrey,
              width: isSelected ? 2 : 1,
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// --------------------- CIRCULAR ICON ---------------------
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: index == 3 ? Colors.white : AppColors.buttonColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Image.asset(
                    icon,
                    width: 28.w,
                    height: 28.h,
                  ),
                ),
              ),

              10.verticalSpace,

              /// TITLE
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.H4_Regular.copyWith(
                  fontSize: 12.sp,
                  color: textColor, // white for last card
                ),
              ),

              10.verticalSpace,

              /// FEATURE LIST
              SizedBox(
                height: 80.h,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            index == 3
                                ? AppImages.white_thikki_icon
                                : AppImages.thikki_icon,
                            width: 12.w,
                            height: 12.h,
                          ),

                          6.horizontalSpace,

                          Expanded(
                            child: Text(
                              items[i],
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10.sp,
                                color: subTextColor, // white for last card
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              12.verticalSpace,

              /// PRICE
              Text(
                "$price$unit",
                style: AppTextStyles.H3_Regular.copyWith(
                  fontSize: 14.sp,
                  color: textColor, // white for last card
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
