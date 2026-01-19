// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
//
// class CookingSkillsScreen extends StatelessWidget {
//   CookingSkillsScreen({super.key});
//
//   final CookingSkillController controller = Get.put(CookingSkillController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.bgColor,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18.sp),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           "Cooking Skills",
//           style: AppTextStyle.titleMedium.copyWith(
//             fontWeight: FontWeight.w700,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         actions: [
//           Container(
//             margin: EdgeInsets.only(right: 12.w),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.r),
//               color: AppColors.white,
//             ),
//             padding: EdgeInsets.all(8.r),
//             child: Icon(Icons.menu, color: AppColors.textPrimary),
//           )
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         child: Obx(() {
//           if (controller.skills.isEmpty) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return ListView.separated(
//             itemCount: controller.skills.length,
//             separatorBuilder: (_, __) => SizedBox(height: 10.h),
//             itemBuilder: (context, index) {
//               final skill = controller.skills[index];
//               return Container(
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(12.r),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 4.r,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 padding: EdgeInsets.all(8.w),
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8.r),
//                       child: Image.asset(
//                         skill.image,
//                         width: 70.w,
//                         height: 70.h,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             skill.title,
//                             style: AppTextStyle.bodyMedium.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                           SizedBox(height: 6.h),
//                           Row(
//                             children: [
//                               Text(
//                                 "View Skill",
//                                 style: AppTextStyle.bodySmall.copyWith(
//                                   color: AppColors.primary,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               Icon(Icons.arrow_forward_ios,
//                                   size: 12.sp, color: AppColors.primary),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
// }
