// lib/features/subscription/payment/payment.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/subscription/subscription_controller/subscription_controller.dart';
import 'package:freshbite/features/subscription/payment/iap_service.dart';
import 'package:freshbite/routes/routes.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final SubscriptionController subscriptionController =
  Get.find<SubscriptionController>();
  final IAPService iap = IAPService.to;

  StreamSubscription? _premiumListener;

  final List<Map<String, dynamic>> plans = const [
    {"title": "Guest / Free Account",   "price": 0.0,  "currency": "CHF"},
    {"title": "Family subscription",    "price": 24.0, "currency": "CHF"},
    {"title": "Premium subscription",   "price": 19.0, "currency": "CHF"},
    {"title": "Premium trial (1 week)", "price": 0.0,  "currency": "CHF"},
  ];

  @override
  void initState() {
    super.initState();
    // ✅ Listen ONCE for premium unlock → navigate
    _premiumListener = iap.isPremium.listen((val) {
      if (val && mounted) {
        Get.offAllNamed(AppRoute.getBottomNavbar());
      }
    });
  }

  @override
  void dispose() {
    _premiumListener?.cancel();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    final selectedIndex = subscriptionController.selectedPlan.value;
    if (selectedIndex == -1) return;

    final plan = plans[selectedIndex];
    final double price = plan['price'];

    if (price <= 0) {
      Get.offAllNamed(AppRoute.getBottomNavbar());
      return;
    }

    if (iap.products.isEmpty) {
      // ✅ Delay snackbar until after current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Loading...',
          'Fetching products, please try again.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      });
      await iap.fetchProducts();
      return;
    }

    await iap.buyPlan(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedIndex = subscriptionController.selectedPlan.value;
      final plan = selectedIndex != -1 ? plans[selectedIndex] : null;

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 40.h),
          child: Padding(
            padding: EdgeInsets.only(top: 40.h),
            child:
            const CustomAppBar(title: "Payment", height: kToolbarHeight),
          ),
        ),
        body: plan == null
            ? const Center(child: Text("No plan selected"))
            : Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order Summary", style: AppTextStyles.heading2),
              SizedBox(height: 20.h),

              // Order summary card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(plan['title'], style: AppTextStyles.body),
                        Text(
                          "${plan['currency']} ${(plan['price'] as double).toStringAsFixed(2)}",
                          style: AppTextStyles.H4_Regular,
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total", style: AppTextStyles.H3_Regular),
                        Text(
                          "${plan['currency']} ${(plan['price'] as double).toStringAsFixed(2)}",
                          style: AppTextStyles.H3_Regular
                              .copyWith(color: AppColors.buttonColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 12.h),

              // ✅ Show product status for debugging
              if (iap.products.isEmpty && iap.isAvailable.value)
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Products not loaded yet. Tap "Confirm and Pay" to retry.',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),

              // Store unavailable warning
              if (!iap.isAvailable.value &&
                  (plan['price'] as double) > 0)
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Store not available. Please check your connection.',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // Pay button
              iap.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : CustomTextButton(
                text: (plan['price'] as double) > 0
                    ? "CONFIRM AND PAY"
                    : "ACTIVATE PLAN",
                onTap: _handlePayment,
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      );
    });
  }
}