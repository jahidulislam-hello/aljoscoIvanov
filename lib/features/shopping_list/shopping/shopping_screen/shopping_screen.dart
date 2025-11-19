// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'shopping_controller.dart';
// import 'shopping_model.dart';
// import 'package:your_app/core/app_colors.dart';
// import 'package:your_app/core/app_textstyles.dart';
// import 'package:your_app/core/app_images.dart';
//
// class ShoppingScreen extends StatelessWidget {
//   const ShoppingScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ShoppingController());
//
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.background,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new, color: AppColors.text),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           "Shopping",
//           style: AppTextStyles.title.copyWith(fontSize: 18.sp),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: Icon(Icons.menu, color: AppColors.text),
//           ),
//         ],
//       ),
//
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// --- Calendar header ---
//             Container(
//               margin: EdgeInsets.only(top: 8.h, bottom: 10.h),
//               decoration: BoxDecoration(
//                 border: Border.all(color: AppColors.border.withOpacity(0.5)),
//                 borderRadius: BorderRadius.circular(8.r),
//               ),
//               padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Month selector row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "January 2025",
//                         style: AppTextStyles.subtitle.copyWith(fontSize: 15.sp),
//                       ),
//                       Icon(Icons.keyboard_arrow_down, color: AppColors.icon),
//                     ],
//                   ),
//                   SizedBox(height: 8.h),
//
//                   /// Days Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: List.generate(7, (index) {
//                       final days = ["15", "16", "17", "18", "19", "20", "21"];
//                       final isSelected = days[index] == "18";
//                       return Container(
//                         width: 36.w,
//                         height: 34.h,
//                         decoration: BoxDecoration(
//                           color: isSelected ? AppColors.primary : Colors.transparent,
//                           borderRadius: BorderRadius.circular(5.r),
//                           border: Border.all(color: AppColors.border, width: 0.5),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           days[index],
//                           style: AppTextStyles.body.copyWith(
//                             fontSize: 14.sp,
//                             color: isSelected ? Colors.white : AppColors.text,
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ],
//               ),
//             ),
//
//             /// --- Shopping Lists title ---
//             Obx(() => Text(
//               "Shopping Lists for ${controller.selectedDate.value.day}.${controller.selectedDate.value.month}.${controller.selectedDate.value.year.toString().substring(2)}",
//               style: AppTextStyles.subtitle.copyWith(fontSize: 14.sp),
//             )),
//             SizedBox(height: 12.h),
//
//             /// --- List of shopping items ---
//             Expanded(
//               child: Obx(() => ListView.builder(
//                 itemCount: controller.shoppingLists.length,
//                 itemBuilder: (context, index) {
//                   final item = controller.shoppingLists[index];
//                   return _ShoppingListTile(
//                     item: item,
//                     onToggle: () => controller.toggleFinished(index),
//                   );
//                 },
//               )),
//             ),
//           ],
//         ),
//       ),
//
//       /// --- Floating add button ---
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: AppColors.primary,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
//         onPressed: () {
//           // Placeholder for Add New List action
//         },
//         child: Icon(Icons.add, color: Colors.white, size: 28.sp),
//       ),
//     );
//   }
// }
//
// class _ShoppingListTile extends StatelessWidget {
//   final ShoppingModel item;
//   final VoidCallback onToggle;
//
//   const _ShoppingListTile({
//     required this.item,
//     required this.onToggle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 10.h),
//       decoration: BoxDecoration(
//         color: AppColors.cardBackground,
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Row(
//         children: [
//           /// --- Image ---
//           ClipRRect(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(8.r),
//               bottomLeft: Radius.circular(8.r),
//             ),
//             child: Image.asset(
//               item.image,
//               width: 90.w,
//               height: 90.h,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           SizedBox(width: 10.w),
//
//           /// --- Texts + Avatar + Tick ---
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.title,
//                     style: AppTextStyles.subtitle.copyWith(fontSize: 14.sp),
//                   ),
//                   SizedBox(height: 4.h),
//                   Text(
//                     item.description,
//                     style: AppTextStyles.body.copyWith(
//                       fontSize: 12.sp,
//                       color: AppColors.textLight,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 4.h),
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 10.r,
//                         backgroundImage: AssetImage(AppImages.avatarPlaceholder),
//                       ),
//                       SizedBox(width: 4.w),
//                       Text(
//                         "created by ${item.createdBy}, on ${item.date}",
//                         style: AppTextStyles.caption.copyWith(
//                           fontSize: 10.sp,
//                           color: AppColors.textLight,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           /// --- Tick button ---
//           GestureDetector(
//             onTap: onToggle,
//             child: Container(
//               margin: EdgeInsets.only(right: 12.w),
//               child: Icon(
//                 item.isFinished ? Icons.check_circle : Icons.radio_button_unchecked,
//                 color: item.isFinished ? AppColors.primary : AppColors.border,
//                 size: 22.sp,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
