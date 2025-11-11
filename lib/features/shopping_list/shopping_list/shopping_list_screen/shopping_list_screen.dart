// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:freshbite/core/themes/app_colors.dart';
// import 'package:freshbite/core/themes/app_images.dart';
// import 'package:freshbite/core/themes/text_styles.dart';
// import 'package:freshbite/features/shopping_list/shopping_list/shopping_list_controller/shopping_list_controller.dart';
// import 'package:get/get.dart';
//
//
// class ShoppingListScreen extends StatelessWidget {
//   final ShoppingListController controller = Get.put(ShoppingListController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Padding(
//         padding: EdgeInsets.all(16.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Shopping List from Prep List(s) 21.1.25',
//               style: AppTextStyles.heading,
//             ),
//             SizedBox(height: 4.h),
//             Text(
//               'Date: January 21, 2025',
//               style: AppTextStyles.subHeading,
//             ),
//             SizedBox(height: 16.h),
//
//             // Shopping Notes
//             Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: AssetImage(AppImages.userAvatar),
//                   radius: 20.r,
//                 ),
//                 SizedBox(width: 8.w),
//                 Expanded(
//                   child: TextField(
//                     onChanged: controller.updateNote,
//                     decoration: InputDecoration(
//                       hintText: 'Please buy some carrots for me',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.r),
//                         borderSide: BorderSide(color: AppColors.border),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 12.w,
//                         vertical: 10.h,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.h),
//
//             // Categories
//             Expanded(
//               child: Obx(
//                     () => ListView.builder(
//                   itemCount: controller.categories.length,
//                   itemBuilder: (context, index) {
//                     final category = controller.categories[index];
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Category header
//                         InkWell(
//                           onTap: () => controller.toggleCategoryExpansion(category),
//                           child: Container(
//                             color: AppColors.lightGrey,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 12.w,
//                               vertical: 8.h,
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   category.title,
//                                   style: AppTextStyles.category,
//                                 ),
//                                 Icon(
//                                   category.isExpanded
//                                       ? Icons.keyboard_arrow_up
//                                       : Icons.keyboard_arrow_down,
//                                   color: AppColors.iconGrey,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//
//                         // Category items
//                         if (category.isExpanded)
//                           ...category.items.map(
//                                 (item) => Container(
//                               color: item.isChecked
//                                   ? AppColors.lightGrey
//                                   : Colors.transparent,
//                               child: ListTile(
//                                 onTap: () => controller.toggleItem(category, item),
//                                 leading: Checkbox(
//                                   value: item.isChecked,
//                                   onChanged: (_) =>
//                                       controller.toggleItem(category, item),
//                                   activeColor: AppColors.primary,
//                                 ),
//                                 title: Text(
//                                   item.name,
//                                   style: AppTextStyles.item,
//                                 ),
//                                 trailing: Text(
//                                   item.quantity,
//                                   style: AppTextStyles.item,
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
