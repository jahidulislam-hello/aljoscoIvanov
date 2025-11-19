// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'create_shopping_controller.dart';
// import 'package:your_app/core/app_colors.dart';
// import 'package:your_app/core/app_textstyles.dart';
// import 'package:your_app/core/app_images.dart';
//
// class CreateShoppingScreen extends StatelessWidget {
//   const CreateShoppingScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CreateShoppingController());
//     final nameController = TextEditingController();
//     final amountController = TextEditingController();
//     final unitController = TextEditingController();
//
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new, color: AppColors.text),
//           onPressed: () => Get.back(),
//         ),
//         title: Text(
//           "create Shopping List",
//           style: AppTextStyles.title.copyWith(fontSize: 18.sp),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.menu, color: AppColors.text),
//             onPressed: () {},
//           )
//         ],
//       ),
//
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 10.h),
//             Text(
//               "Custom Shopping List",
//               style: AppTextStyles.subtitle.copyWith(fontSize: 14.sp),
//             ),
//             SizedBox(height: 8.h),
//
//             /// --- Shopping list items ---
//             Obx(() => Column(
//               children: [
//                 ...controller.shoppingItems.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final item = entry.value;
//                   return _ShoppingItemTile(
//                     name: item.name,
//                     amount: item.amount,
//                     unit: item.unit,
//                     checked: item.isChecked,
//                     onCheck: () => controller.toggleItem(index),
//                   );
//                 }).toList(),
//
//                 /// --- Add custom item row ---
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: TextField(
//                         controller: nameController,
//                         decoration: InputDecoration(
//                           hintText: "Add custom item",
//                           hintStyle: AppTextStyles.body.copyWith(fontSize: 12.sp),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: amountController,
//                         decoration: InputDecoration(
//                           hintText: "Amount",
//                           hintStyle: AppTextStyles.body.copyWith(fontSize: 12.sp),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: TextField(
//                         controller: unitController,
//                         decoration: InputDecoration(
//                           hintText: "Unit",
//                           hintStyle: AppTextStyles.body.copyWith(fontSize: 12.sp),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.add, color: AppColors.primary),
//                       onPressed: () {
//                         controller.addNewItem(
//                           nameController.text,
//                           amountController.text,
//                           unitController.text,
//                         );
//                         nameController.clear();
//                         amountController.clear();
//                         unitController.clear();
//                       },
//                     )
//                   ],
//                 ),
//               ],
//             )),
//
//             SizedBox(height: 16.h),
//             Text("Description", style: AppTextStyles.subtitle.copyWith(fontSize: 14.sp)),
//             SizedBox(height: 6.h),
//             Container(
//               decoration: BoxDecoration(
//                 color: AppColors.cardBackground,
//                 borderRadius: BorderRadius.circular(8.r),
//                 border: Border.all(color: AppColors.border.withOpacity(0.4)),
//               ),
//               child: TextField(
//                 maxLines: 3,
//                 onChanged: (v) => controller.description.value = v,
//                 decoration: InputDecoration(
//                   hintText: "Add a short description",
//                   hintStyle: AppTextStyles.body.copyWith(fontSize: 12.sp),
//                   contentPadding: EdgeInsets.all(10.w),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 20.h),
//             Text("Plan your shopping", style: AppTextStyles.subtitle.copyWith(fontSize: 14.sp)),
//             SizedBox(height: 6.h),
//
//             /// Who and When row
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(8.r),
//                       border: Border.all(color: AppColors.border.withOpacity(0.5)),
//                     ),
//                     child: Obx(() => DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: controller.selectedUser.value,
//                         items: [
//                           'Aljoscha Ivanov',
//                           'John Doe',
//                           'Jane Smith'
//                         ]
//                             .map((e) => DropdownMenuItem(
//                           value: e,
//                           child: Text(e, style: AppTextStyles.body.copyWith(fontSize: 12.sp)),
//                         ))
//                             .toList(),
//                         onChanged: (value) => controller.selectedUser.value = value!,
//                       ),
//                     )),
//                   ),
//                 ),
//                 SizedBox(width: 10.w),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () async {
//                       DateTime? picked = await showDatePicker(
//                         context: context,
//                         initialDate: controller.selectedDate.value,
//                         firstDate: DateTime(2020),
//                         lastDate: DateTime(2030),
//                       );
//                       if (picked != null) controller.selectedDate.value = picked;
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8.r),
//                         border: Border.all(color: AppColors.border.withOpacity(0.5)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Obx(() => Text(
//                             "${controller.selectedDate.value.day}.${controller.selectedDate.value.month}.${controller.selectedDate.value.year}",
//                             style: AppTextStyles.body.copyWith(fontSize: 12.sp),
//                           )),
//                           Icon(Icons.calendar_today, size: 16.sp, color: AppColors.icon),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             SizedBox(height: 30.h),
//
//             /// --- SAVE / CANCEL Buttons ---
//             Column(
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(6.r),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 12.h),
//                     ),
//                     onPressed: controller.saveList,
//                     child: Text("SAVE", style: AppTextStyles.button.copyWith(color: Colors.white)),
//                   ),
//                 ),
//                 SizedBox(height: 10.h),
//                 TextButton(
//                   onPressed: () => Get.back(),
//                   child: Text("CANCEL", style: AppTextStyles.body.copyWith(color: AppColors.text)),
//                 ),
//                 SizedBox(height: 20.h),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// --- Single Shopping List Item Tile ---
// class _ShoppingItemTile extends StatelessWidget {
//   final String name;
//   final String amount;
//   final String unit;
//   final bool checked;
//   final VoidCallback onCheck;
//
//   const _ShoppingItemTile({
//     required this.name,
//     required this.amount,
//     required this.unit,
//     required this.checked,
//     required this.onCheck,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 4.h),
//       padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         color: AppColors.cardBackground,
//         borderRadius: BorderRadius.circular(6.r),
//       ),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: onCheck,
//             child: Icon(
//               checked ? Icons.check_box : Icons.check_box_outline_blank,
//               color: checked ? AppColors.primary : AppColors.border,
//               size: 20.sp,
//             ),
//           ),
//           SizedBox(width: 8.w),
//           Expanded(
//             flex: 2,
//             child: Text(
//               name,
//               style: AppTextStyles.body.copyWith(
//                 fontSize: 12.sp,
//                 decoration: checked ? TextDecoration.lineThrough : TextDecoration.none,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               amount,
//               textAlign: TextAlign.center,
//               style: AppTextStyles.body.copyWith(fontSize: 12.sp),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               unit,
//               textAlign: TextAlign.center,
//               style: AppTextStyles.body.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w500),
//             ),
//           ),
//           Icon(Icons.edit, size: 16.sp, color: AppColors.icon.withOpacity(0.7)),
//         ],
//       ),
//     );
//   }
// }
