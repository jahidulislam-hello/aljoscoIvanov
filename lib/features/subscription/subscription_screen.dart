import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/subscription/subscription_controller/subscription_controller.dart';
import 'package:freshbite/features/subscription/payment/payment.dart';
import 'package:get/get.dart';
import '../../core/themes/text_styles.dart';

class SubscriptionScreen extends StatelessWidget {
  final String currentPlanType;
  final String currentSubscriptionStatus;

  SubscriptionScreen({
    super.key,
    this.currentPlanType = '',
    this.currentSubscriptionStatus = '',
  }) {
    controller.setCurrentSubscription(
      planType: currentPlanType,
      status: currentSubscriptionStatus,
    );
  }

  final SubscriptionController controller = Get.put(SubscriptionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: CustomAppBar(
            title: "Subscription",
            height: kToolbarHeight,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              /// ---------- GRID: 2 BOXES IN EACH ROW (FROM API) ----------
              GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.58,
                children: List.generate(controller.subscriptions.length, (index) {
                  final sub = controller.subscriptions[index];
                  return _card(
                    index: index,
                    icon: SubscriptionController.getIconForPlan(sub.plan),
                    title: SubscriptionController.getTitleForPlan(sub.plan),
                    items: sub.features,
                    price: "CHF ${sub.price.toStringAsFixed(2)}",
                    unit: SubscriptionController.getUnitForDuration(sub.duration),
                  );
                }),
              ),

              30.verticalSpace,

              /// ---------- ALREADY SUBSCRIBED BANNER ----------
              if (controller.hasActiveSubscription)
                Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          "You already have an active subscription",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              /// ---------- PAY BUTTON ----------
              CustomTextButton(
                text: controller.hasActiveSubscription
                    ? "ALREADY SUBSCRIBED"
                    : "PAY NOW",
                onTap: () {
                  if (controller.hasActiveSubscription) {
                    Get.snackbar(
                      "Info",
                      "You already have an active subscription",
                    );
                    return;
                  }
                  if (controller.selectedPlan.value == -1) {
                    Get.snackbar("Alert", "Please select a plan first");
                  } else {
                    Get.to(() => PaymentScreen());
                  }
                },
              ),
            ],
          ),
        );
      }),
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
                    color: index == 3 ? AppColors.buttonColor : Colors.white,
                    colorBlendMode: BlendMode.srcIn,
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
              ListView.builder(
                shrinkWrap: true,
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

              /// PUSH PRICE TO BOTTOM BORDER
              const Spacer(),

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
