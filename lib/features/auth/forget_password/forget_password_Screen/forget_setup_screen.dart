// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// import '../../../../core/appbar/custom_appbar.dart';
// import '../../../../core/themes/app_icons.dart';
// import '../../../../core/widgets/button.dart';
// import '../../../../core/widgets/custom_text_form_field.dart';
// import '../forget_controller/forget_setup_pass_controller.dart';
//
//
// class ResetPasswordScreen extends StatelessWidget {
//   const ResetPasswordScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ResetPasswordController());
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: CustomAppBar(
//         title: "Reset Password",
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: size.height * 0.04),
//
//             /// New Password Field
//             Obx(() => CustomTextFormField(
//               controller: controller.newPasswordController,
//               hintText: "Set New Password",
//               keyboardType: "visiblePassword",
//               prefixSvg: AppImages.materialSymbolsSettingsOutline, // ✅ use prefixSvg
//               suffixSvg: controller.isNewPasswordHidden.value
//                   ? AppImages.passwordOff
//                   : AppImages.passwordOff, // ✅ toggle visibility icons
//               onTapSuffix: controller.toggleNewPasswordVisibility,
//             )),
//
//             SizedBox(height: size.height * 0.025),
//
//             /// Confirm Password Field
//             Obx(() => CustomTextFormField(
//               controller: controller.confirmPasswordController,
//               hintText: "Confirm New Password",
//               keyboardType: "visiblePassword",
//               prefixSvg: AppImages.materialSymbolsCall,
//               suffixSvg: controller.isConfirmPasswordHidden.value
//                   ? AppImages.passwordOff
//                   : AppImages.passwordOff,
//               onTapSuffix: controller.toggleConfirmPasswordVisibility,
//             )),
//
//             const Spacer(),
//
//
//             CustomButton(
//               text: "Submit Now",
//               onPressed: () {
//                 controller.resetPassword(); // ✅ logic here
//               },
//             ),
//
//             SizedBox(height: size.height * 0.03),
//           ],
//         ),
//       ),
//     );
//   }
// }