// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:freshbite/features/meal_planner/create_reuse_popup/create_reuse_popup_controller/create_reuse_popup_controller.dart';
// import 'package:provider/provider.dart';
//
//
// class CreateReusePopup extends StatelessWidget {
//   const CreateReusePopup({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => CreateReuseController(),
//       child: Consumer<CreateReuseController>(
//         builder: (context, controller, child) {
//           return Dialog(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
//             insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Padding(
//               padding: EdgeInsets.all(20.w),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       "Please select the start date",
//                       style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
//                     ),
//                     SizedBox(height: 16.h),
//                     _buildMonthDropdown(controller),
//                     SizedBox(height: 12.h),
//                     _buildDateRow(controller),
//                     SizedBox(height: 20.h),
//                     _buildTextField(
//                       controller: controller.titleController,
//                       hintText: 'e.g. "My Monday Menu"',
//                       label: "Add Title",
//                     ),
//                     SizedBox(height: 12.h),
//                     _buildTextField(
//                       controller: controller.descriptionController,
//                       hintText: 'e.g. "usual Breakfast, family Dinner"',
//                       label: "Add Description",
//                     ),
//                     SizedBox(height: 20.h),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: controller.applyMealPlan,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF2B3A0B),
//                           padding: EdgeInsets.symmetric(vertical: 14.h),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
//                         ),
//                         child: Text(
//                           "APPLY TO THE MEAL PLANER",
//                           style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     Text(
//                       "Your saved meal plan will start on the chosen date.",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildMonthDropdown(CreateReuseController controller) {
//     return DropdownButton<String>(
//       value: DateFormat.yMMMM().format(controller.selectedDate),
//       isExpanded: true,
//       underline: const SizedBox(),
//       items: List.generate(
//         12,
//             (index) {
//           final month = DateTime(DateTime.now().year, index + 1);
//           return DropdownMenuItem(
//             value: DateFormat.yMMMM().format(month),
//             child: Text(
//               DateFormat.yMMMM().format(month),
//               style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
//             ),
//           );
//         },
//       ),
//       onChanged: (value) {
//         if (value != null) {
//           final newMonth = DateFormat.yMMMM().parse(value);
//           controller.selectDate(DateTime(newMonth.year, newMonth.month, controller.selectedDate.day));
//         }
//       },
//     );
//   }
//
//   Widget _buildDateRow(CreateReuseController controller) {
//     final now = controller.selectedDate;
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(7, (index) {
//         final date = now.subtract(Duration(days: now.weekday - 1 - index));
//         final isSelected = date.day == controller.selectedDate.day;
//         return GestureDetector(
//           onTap: () => controller.selectDate(date),
//           child: Column(
//             children: [
//               Text(
//                 DateFormat.E().format(date),
//                 style: TextStyle(fontSize: 12.sp),
//               ),
//               SizedBox(height: 4.h),
//               CircleAvatar(
//                 radius: 16.r,
//                 backgroundColor: isSelected ? const Color(0xFF2B3A0B) : Colors.transparent,
//                 child: Text(
//                   date.day.toString(),
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: isSelected ? Colors.white : Colors.black,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required String label,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
//         ),
//         SizedBox(height: 6.h),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hintText,
//             contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8.r),
//               borderSide: BorderSide(color: Colors.grey.shade400),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
