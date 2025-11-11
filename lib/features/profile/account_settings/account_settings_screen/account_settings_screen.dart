// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:freshbite/features/profile/account_settings/account_settings_controller/account_settings_controller.dart';
// import 'package:get/get.dart';
// import '../../../../core/widgets/button.dart';
//
//
//
//
// class SettingsProfileScreen extends StatelessWidget {
//   final controller = Get.put(SettingsProfileController());
//
//   SettingsProfileScreen({super.key});
//
//   String _getInitials(String name) {
//     if (name.trim().isEmpty) return '';
//     final parts = name.trim().split(' ');
//     if (parts.length == 1) {
//       return parts[0][0].toUpperCase();
//     }
//     return (parts[0][0] + parts[1][0]).toUpperCase();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return Column(
//             children: [
//               CustomAppBar(title: "Profile"  , showBackButton: false),
//               const SizedBox(height: 24),
//
//
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//
//                     // Profile Picture
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12), // rounded corners
//                       child: controller.profileImage.value.isNotEmpty
//                           ? Image.network(
//                         controller.profileImage.value,
//                         width: 64,
//                         height: 64,
//                         fit: BoxFit.cover,
//                       )
//                           : Container(
//                         width: 64,
//                         height: 64,
//                         color: Colors.purple.shade200,
//                         alignment: Alignment.center,
//                         child: Text(
//                           _getInitials(
//                             "${controller.firstName.value} ${controller.lastName.value}",
//                           ),
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 24,
//                           ),
//                         ),
//                       ),
//                     ),
//
//
//                     const SizedBox(width: 16),
//
//                     // Name + Edit Profile Text
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Name
//                           Text(
//                             "${controller.firstName.value} ${controller.lastName.value}".trim(),
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                             ),
//                           ),
//
//                           const SizedBox(height: 6),
//
//                           // View & Edit Profile (clickable)
//                           GestureDetector(
//                             onTap: () {
//                               // TODO: Navigate to Edit Profile Screen
//                               Get.to(() => ViewProfileScreen());
//                             },
//                             child: const Text(
//                               "View & Edit Profile",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: Color(0xFFFFB800),
//                                 fontWeight: FontWeight.w500,
//                                 // decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//
//
//               const SizedBox(height: 24),
//
//               // Settings List
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 24),
//                     SettingTile(
//                       // Left icon as SVG
//                       iconWidget: SvgPicture.asset(
//                         AppImages.interfaceLockCombinationComboLockLockedPadlockSecureSecurityShieldKeyholeStreamlineCore,
//                         width: 16,
//                         height: 16,
//                       ),
//                       title: "Change Password",
//                       // Right icon as SVG
//                       trailingIcon: SvgPicture.asset(
//                         AppImages.interfaceArrowsButtonRightArrowRightKeyboardStreamlineCore,
//                         width: 16,
//                         height: 16,
//                       ),
//
//                       onTap: () {
//                         Get.to(() => ChangePasswordScreen());
//                       },
//                     ),
//
//                     const SizedBox(height: 24),
//                     SettingTile(
//                       iconWidget: SvgPicture.asset(
//                         AppImages.interfaceSecurityShield2ShieldProtectionSecurityDefendCrimeWarCoverStreamlineCore,
//                         width: 16,
//                         height: 16,
//                       ),
//                       title: "Privacy Policy",
//                       trailingIcon: SvgPicture.asset(
//                         AppImages.interfaceArrowsButtonRightArrowRightKeyboardStreamlineCore,
//                         width: 16,
//                         height: 16,
//                       ),
//                       onTap: () {
//                         Get.to(() => PrivacyScreen());
//                       },
//                     ),
//
//                     const SizedBox(height: 24),
//                     SettingTile(
//                       iconWidget: SvgPicture.asset(
//                         AppImages.interfaceAlertWarningTriangleFrameAlertWarningTriangleExclamationCautionStreamlineCore,
//                         width: 16,
//                         height: 16,
//                       ),
//                       title: "Terms & Conditions",
//                       trailingIcon: SvgPicture.asset(
//                         AppImages.interfaceArrowsButtonRightArrowRightKeyboardStreamlineCore,
//                         width: 16,
//                         height: 16,
//                       ),
//
//                       onTap: () {
//                         Get.to(() => TermsScreen());
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     SettingTile(
//                       iconWidget: SvgPicture.asset(
//                         AppImages.interfaceAlertInformationCircleInformationFrameInfoMoreHelpPointCircleStreamlineCore,
//                         width: 16,
//                         height: 16,
//                       ),
//                       title: "About Us",
//                       trailingIcon: SvgPicture.asset(
//                         AppImages.interfaceArrowsButtonRightArrowRightKeyboardStreamlineCore,
//                         width: 16,
//                         height: 16,
//                       ),
//                       onTap: () {
//                         Get.to(() => AboutUs());
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     SettingTile(
//                       iconWidget: SvgPicture .asset(
//                         AppImages.paymentSvgIcon,
//                         width: 16,
//                         height: 16,
//                       ),
//                       title: "Payment Methods",
//                       trailingIcon: SvgPicture.asset(
//                         AppImages.interfaceArrowsButtonRightArrowRightKeyboardStreamlineCore,
//                         width: 16,
//                         height: 16,
//                       ),
//                       onTap: () {
//                         Get.to(() => PaymentOptionsScreen());
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//
//
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
//
// class SettingTile extends StatelessWidget {
//   final Widget? iconWidget; // changed from String iconPath
//   final String title;
//   final VoidCallback? onTap;
//   final Widget? trailingIcon;
//
//   const SettingTile({
//     super.key,
//     this.iconWidget,
//     required this.title,
//     this.onTap,
//     this.trailingIcon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         height: 54,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(color: Color(0xFFEBEBEB)),
//         ),
//         child: Row(
//           children: [
//             iconWidget ?? const SizedBox.shrink(),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             trailingIcon ?? const Icon(Icons.arrow_forward_ios, size: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
// class LogoutPopup extends StatelessWidget {
//   const LogoutPopup({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.white,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Ready to log out?",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () {
//                       Get.back();
//                     },
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Colors.grey),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100), // pill shape
//                       ),
//                     ),
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       child: Text(
//                         "Cancel",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton(
//                     // onPressed: () async {
//                     //   await SharedPreferencesHelper.clearAllData();
//                     //   Get.back();
//                     //   Get.offAll(() => LoginScreen());
//                     // },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(100), // pill shape
//                       ),
//                     ),
//                     onPressed: () {
//                       // SharedPreferencesHelper.clearAllData();
//                       // Get.offAll(() => SignUpScreen());
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       child: Text(
//                         "Logout",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }