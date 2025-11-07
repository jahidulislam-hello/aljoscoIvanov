//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// import '../../../../core/appbar/custom_appbar.dart';
// import '../../../../core/widgets/button.dart';
// import '../forget_controller/forget_password_otp_controller.dart';
//
// class ForgotPasswordOtpScreen extends StatelessWidget {
//   final ForgotPasswordOtpController controller = Get.put(ForgotPasswordOtpController());
//
//   ForgotPasswordOtpScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: const CustomAppBar(
//         title: 'Verify OTP',
//         showBackButton: true,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 24),
//
//               /// Header text
//               const Center(
//                 child: Text(
//                   "Check your email",
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 8),
//
//               /// Dynamic email from controller
//               Center(
//                 child: Obx(() {
//                   return Text(
//                     "We sent a reset link to ${controller.email.value}\n"
//                         "Enter 6 digit code that mentioned in the email",
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.white70,
//                     ),
//                   );
//                 }),
//               ),
//
//
//               const SizedBox(height: 32),
//
//               /// OTP Input Boxes
//               Center(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: List.generate(6, (index) {
//                     return Obx(() {
//                       final isFilled = controller.otpDigits[index].isNotEmpty;
//
//                       return Container(
//                         width: 41,
//                         height: 49,
//                         margin: const EdgeInsets.symmetric(horizontal: 6),
//                         decoration: BoxDecoration(
//                           color: Colors.black12,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(
//                             color: isFilled
//                                 ? const Color(0xFF0071E9)
//                                 : Colors.grey.shade400,
//                             width: 2,
//                           ),
//                         ),
//                         child: Center(
//                           child: TextField(
//                             textAlign: TextAlign.center,
//                             maxLength: 1,
//                             keyboardType: TextInputType.number,
//                             style: const TextStyle(
//                                 fontSize: 22, color: Colors.white70),
//                             decoration: const InputDecoration(
//                               counterText: '',
//                               border: InputBorder.none,
//                             ),
//                             onChanged: (val) {
//                               controller.updateDigit(index, val);
//                               if (val.isNotEmpty && index < 5) {
//                                 FocusScope.of(context).nextFocus();
//                               } else if (index == 5) {
//                                 FocusScope.of(context).unfocus();
//                               }
//                             },
//                           ),
//                         ),
//                       );
//                     });
//                   }),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               /// Resend Section (Right aligned now)
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Obx(() {
//                   if (controller.secondsRemaining.value == 0) {
//                     return GestureDetector(
//                       onTap: controller.resendCode,
//                       child: const Text(
//                         "Resend OTP",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white70,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                     );
//                   } else {
//                     final seconds = controller.secondsRemaining.value;
//                     final timerText =
//                         "00:${seconds.toString().padLeft(2, '0')}";
//                     return RichText(
//                       text: TextSpan(
//                         style: const TextStyle(fontSize: 14),
//                         children: [
//                           const TextSpan(
//                             text: 'Resend OTP ',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           TextSpan(
//                             text: timerText,
//                             style: const TextStyle(
//                               color: Colors.redAccent,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                 }),
//               ),
//
//               const SizedBox(height: 32),
//
//               /// Verify Button
//               SizedBox(
//                 width: double.infinity,
//                 child: CustomButton(
//                   text: "Verify OTP",
//                   onPressed: () {
//                     if (controller.isOtpComplete()) {
//                       // ✅ Navigate after verifying OTP
//                     } else {
//                       Get.snackbar("Error", "Please enter the full OTP");
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }