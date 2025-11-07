// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
//
// import '../../../../core/appbar/custom_appbar.dart';
// import '../../../../core/themes/app_icons.dart';
// import '../../../../core/widgets/button.dart';
// import '../../../../core/widgets/custom_text_form_field.dart';
// import '../forget_controller/forget_password_controller.dart';
// import 'forget_password_otp_screen.dart';
//
// class ForgotPasswordScreen extends StatelessWidget {
//   final ForgotPasswordController controller = Get.put(ForgotPasswordController());
//
//   ForgotPasswordScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: 'Forgot Password',
//         showBackButton: true,
//       ),
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Header text
//                 const Center(
//                   child: Text(
//                     "Forget Password?",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//
//                 /// Description
//                 const Center(
//                   child: Text(
//                     "Enter your email and we will send you a verification code",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.white70,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 32),
//
//                 /// Email input
//                 CustomTextFormField(
//                   controller: controller.emailController,
//                   hintText: "Email",
//                   keyboardType: 'email',
//                   prefixSvg: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: SvgPicture.asset(
//                       AppImages.upLine, // 👈 your svg path
//                       width: 20,
//                       height: 20,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 24),
//
//                 /// Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: CustomButton(
//                     text: "Get OTP",
//                     onPressed: controller.forgetPass,
//
//
//
//
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }