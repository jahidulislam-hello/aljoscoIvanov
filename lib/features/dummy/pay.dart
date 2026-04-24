// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:freshbite/core/appbar/custom_appbar.dart';
// import 'package:freshbite/core/themes/app_colors.dart';
// import 'package:freshbite/core/themes/text_styles.dart';
// import 'package:freshbite/core/widgets/custom_text_button.dart';
// import 'package:freshbite/features/subscription/payment/stripe_helper.dart';
// import 'package:freshbite/features/subscription/payment/stripe_config.dart';
// import 'package:freshbite/features/subscription/subscription_controller/subscription_controller.dart';
// import 'package:freshbite/routes/routes.dart';
//
// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});
//
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   final SubscriptionController subscriptionController = Get.find<SubscriptionController>();
//   late StripePaymentHelper _stripeHelper;
//   bool _isLoading = false;
//
//   final List<Map<String, dynamic>> plans = [
//     {"title": "Guest / Free Account", "price": 0.0, "currency": "CHF"},
//     {"title": "Family subscription", "price": 24.0, "currency": "CHF"},
//     {"title": "Premium subscription", "price": 19.0, "currency": "CHF"},
//     {"title": "Premium trial (1 week)", "price": 0.0, "currency": "CHF"},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize Stripe helper with a config
//     // In a real app, you should fetch the secret key from your backend or a secure config
//     _stripeHelper = StripePaymentHelper(
//       config: const StripeConfig(
//         secretKey: '***REMOVED***', // Placeholder
//         publishableKey: 'pk_test_51Sc2RyJFE0G3dpbM443Q7nmngbU8sW3KUATGLTTEnYEHzYcAaRlCoweeIThMxMMbf037sjbQetOf97cMKbr2odCF009RKE7jeP', // Placeholder
//         merchantDisplayName: 'FreshBite Subscription',
//       ),
//       onLog: (msg) => debugPrint('[Stripe] $msg'),
//     );
//   }
//
//   Future<void> _handlePayment() async {
//     final selectedIndex = subscriptionController.selectedPlan.value;
//     if (selectedIndex == -1) return;
//
//     final plan = plans[selectedIndex];
//     final double amount = plan['price'];
//
//     if (amount <= 0) {
//       // For free plans, just navigate to home
//       Get.offAllNamed(AppRoute.getBottomNavbar());
//       return;
//     }
//
//     setState(() => _isLoading = true);
//
//     try {
//       final result = await _stripeHelper.processPayment(
//         context: context,
//         amount: amount,
//         currency: plan['currency'],
//         description: 'Subscription for ${plan['title']}',
//       );
//
//       if (result.isSuccess) {
//         Get.snackbar(
//           "Success",
//           "Payment completed successfully!",
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//         Get.offAllNamed(AppRoute.getBottomNavbar());
//       } else {
//         Get.snackbar(
//           "Payment Failed",
//           result.message ?? "Something went wrong",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "An unexpected error occurred: $e",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final selectedIndex = subscriptionController.selectedPlan.value;
//     final plan = selectedIndex != -1 ? plans[selectedIndex] : null;
//
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight + 40.h),
//         child: Padding(
//           padding: EdgeInsets.only(top: 40.h),
//           child: const CustomAppBar(
//             title: "Payment",
//             height: kToolbarHeight,
//           ),
//         ),
//       ),
//       body: plan == null
//           ? const Center(child: Text("No plan selected"))
//           : Padding(
//         padding: EdgeInsets.all(20.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Order Summary",
//               style: AppTextStyles.heading2,
//             ),
//             SizedBox(height: 20.h),
//             Container(
//               padding: EdgeInsets.all(16.w),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(plan['title'], style: AppTextStyles.body),
//                       Text("${plan['currency']} ${plan['price'].toStringAsFixed(2)}",
//                           style: AppTextStyles.H4_Regular),
//                     ],
//                   ),
//                   const Divider(height: 32),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("Total", style: AppTextStyles.H3_Regular),
//                       Text("${plan['currency']} ${plan['price'].toStringAsFixed(2)}",
//                           style: AppTextStyles.H3_Regular.copyWith(color: AppColors.buttonColor)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : CustomTextButton(
//               text: plan['price'] > 0 ? "CONFIRM AND PAY" : "ACTIVATE PLAN",
//               onTap: _handlePayment,
//             ),
//             SizedBox(height: 20.h),
//           ],
//         ),
//       ),
//     );
//   }
// }