// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:freshbite/core/themes/app_colors.dart';
// import 'package:freshbite/core/themes/app_images.dart';
// import 'package:freshbite/core/themes/text_styles.dart';
// import 'package:freshbite/features/shopping_list/edit_shopping_list/edit_shopping_list_controller/edit_shopping_list_controller.dart';
// import 'package:get/get.dart';
//
//
// class ShoppingListScreen extends StatelessWidget {
//   final ShoppingListController controller = Get.put(ShoppingListController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: Image.asset(AppImages.backIcon),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text("Edit Shopping List", style: AppTextStyles.appBarTitle),
//         actions: [
//           IconButton(
//             icon: Image.asset(AppImages.menuIcon),
//             onPressed: () {},
//           )
//         ],
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 16.h),
//             Text(
//               "Shopping List from Prep List(s) 21.1.25",
//               style: AppTextStyles.subTitle,
//             ),
//             SizedBox(height: 16.h),
//
//             // Tab bar
//             Obx(() => Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => controller.changeTab(0),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 10.h),
//                       decoration: BoxDecoration(
//                         color: controller.tabIndex.value == 0
//                             ? AppColors.primary
//                             : AppColors.tabBackground,
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         "BY RECIPE",
//                         style: controller.tabIndex.value == 0
//                             ? AppTextStyles.tabSelected
//                             : AppTextStyles.tabUnselected,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () => controller.changeTab(1),
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 10.h),
//                       decoration: BoxDecoration(
//                         color: controller.tabIndex.value == 1
//                             ? AppColors.primary
//                             : AppColors.tabBackground,
//                         borderRadius: BorderRadius.circular(8.r),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         "BY CATEGORY",
//                         style: controller.tabIndex.value == 1
//                             ? AppTextStyles.tabSelected
//                             : AppTextStyles.tabUnselected,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )),
//
//             SizedBox(height: 16.h),
//
//             // Shopping List Items
//             Expanded(
//               child: Obx(() => ListView.builder(
//                 itemCount: controller.shoppingList.length,
//                 itemBuilder: (context, index) {
//                   final item = controller.shoppingList[index];
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: 8.h),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () => controller.toggleItemCheck(index),
//                           child: Container(
//                             width: 24.w,
//                             height: 24.w,
//                             decoration: BoxDecoration(
//                               border: Border.all(color: AppColors.borderColor),
//                               color: item.isChecked ? AppColors.primary : Colors.white,
//                               borderRadius: BorderRadius.circular(4.r),
//                             ),
//                             child: item.isChecked
//                                 ? Icon(Icons.check, size: 16.sp, color: Colors.white)
//                                 : null,
//                           ),
//                         ),
//                         SizedBox(width: 8.w),
//                         Expanded(
//                           child: Text(
//                             "${item.name} ${item.amount} ${item.unit}",
//                             style: AppTextStyles.itemText,
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             // Edit logic
//                           },
//                           child: Image.asset(AppImages.editIcon, width: 20.w),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               )),
//             ),
//
//             // Description
//             TextField(
//               onChanged: (val) => controller.description.value = val,
//               decoration: InputDecoration(
//                 hintText: "Add a short description about this shopping list",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.r),
//                   borderSide: BorderSide(color: AppColors.borderColor),
//                 ),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//               ),
//               maxLines: 2,
//             ),
//
//             SizedBox(height: 16.h),
//
//             // Assigned To & Date
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField(
//                     value: controller.assignedTo.value.isEmpty ? null : controller.assignedTo.value,
//                     items: ["Aljoscha Ivanov"].map((e) => DropdownMenuItem(
//                       value: e,
//                       child: Text(e),
//                     )).toList(),
//                     onChanged: (val) => controller.assignedTo.value = val as String,
//                     decoration: InputDecoration(
//                       labelText: "Who?",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: BorderSide(color: AppColors.borderColor),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 Expanded(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       labelText: "When?",
//                       suffixIcon: Icon(Icons.calendar_today, size: 20.sp),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.r),
//                         borderSide: BorderSide(color: AppColors.borderColor),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 16.h),
//
//             // Save & Cancel Buttons
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: controller.saveShoppingList,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: EdgeInsets.symmetric(vertical: 14.h),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
//                 ),
//                 child: Text("SAVE", style: AppTextStyles.buttonText),
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Center(
//               child: TextButton(
//                 onPressed: controller.cancelShoppingList,
//                 child: Text("CANCEL", style: AppTextStyles.cancelText),
//               ),
//             ),
//             SizedBox(height: 16.h),
//           ],
//         ),
//       ),
//     );
//   }
// }
