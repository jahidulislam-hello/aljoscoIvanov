// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:freshbite/core/themes/app_colors.dart';
// import 'package:freshbite/core/themes/text_styles.dart';
// import 'package:freshbite/features/recepies/details_recipes/details_recipes_controller/details_recipes_controller.dart';
// import 'package:get/get.dart';
//
//
// class RecipeDetailsScreen extends StatelessWidget {
//   final RecipeDetailsController controller = Get.put(RecipeDetailsController());
//
//   RecipeDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         leading: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
//         title: Text("Recipe Details", style: AppTextStyles.H6_Regular),
//         centerTitle: true,
//         actions: [
//           Icon(Icons.share_outlined, color: AppColors.textPrimary),
//           SizedBox(width: 10.w),
//           Icon(Icons.favorite_border, color: AppColors.textPrimary),
//           SizedBox(width: 12.w),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildImageSection(),
//             SizedBox(height: 12.h),
//             _buildTitleSection(),
//             _buildDescriptionSection(),
//             SizedBox(height: 16.h),
//             _buildIngredientsSection(),
//             SizedBox(height: 16.h),
//             _buildPreparationSection(),
//             SizedBox(height: 16.h),
//             _buildInstructionSection(),
//             SizedBox(height: 16.h),
//             _buildNutritionalSection(),
//             SizedBox(height: 32.h),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildImageSection() {
//     return Column(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(12.r),
//           child: Image.asset(controller.recipe.image, height: 180.h, width: double.infinity, fit: BoxFit.cover),
//         ),
//         SizedBox(height: 8.h),
//         SizedBox(
//           height: 60.h,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             itemCount: controller.recipe.gallery.length,
//             separatorBuilder: (_, __) => SizedBox(width: 8.w),
//             itemBuilder: (_, index) {
//               return ClipRRect(
//                 borderRadius: BorderRadius.circular(8.r),
//                 child: Image.asset(
//                   controller.recipe.gallery[index],
//                   width: 60.w,
//                   height: 60.h,
//                   fit: BoxFit.cover,
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTitleSection() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(controller.recipe.title, style: AppTextStyles.H5_Regular),
//         Row(
//           children: [
//             Icon(Icons.star, color: AppColors.secondary, size: 18.sp),
//             SizedBox(width: 4.w),
//             Text(controller.recipe.rating.toString(), style: AppTextStyles.H6_Regular),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDescriptionSection() {
//     return Obx(() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Description", style: AppTextStyles.H5_Regular),
//           SizedBox(height: 4.h),
//           Text(
//             controller.recipe.description,
//             maxLines: controller.isDescriptionExpanded.value ? null : 2,
//             overflow: TextOverflow.fade,
//             style: AppTextStyles.H6_Regular.copyWith(color: AppColors.textSecondary),
//           ),
//           TextButton(
//             onPressed: () => controller.isDescriptionExpanded.toggle(),
//             child: Text(
//               controller.isDescriptionExpanded.value ? "Show less" : "Read more",
//               style: AppTextStyles.H6_Regular.copyWith(color: AppColors.primary),
//             ),
//           ),
//         ],
//       );
//     });
//   }
//
//   Widget _buildIngredientsSection() {
//     return Obx(() {
//       return ExpansionTile(
//         initiallyExpanded: controller.isIngredientsExpanded.value,
//         onExpansionChanged: (val) => controller.isIngredientsExpanded(val),
//         title: Text("Ingredients", style: AppTextStyles.H5_Regular),
//         children: [
//           Column(
//             children: [
//               ...controller.recipe.ingredients.map((item) {
//                 final key = item.keys.first;
//                 final value = item.values.first;
//                 return Padding(
//                   padding: EdgeInsets.symmetric(vertical: 4.h),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(key, style: AppTextStyles.H6_Regular),
//                       Text(value, style: AppTextStyles.H5_Regular),
//                     ],
//                   ),
//                 );
//               }).toList(),
//               SizedBox(height: 12.h),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
//                   minimumSize: Size(double.infinity, 40.h),
//                 ),
//                 onPressed: () {},
//                 child: Text("Sign Up To Add Grocery", style: AppTextStyles.H6_Regular.copyWith(color: Colors.white)),
//               ),
//             ],
//           ),
//         ],
//       );
//     });
//   }
//
//   Widget _buildPreparationSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Preparation", style: AppTextStyles.H6_Regular),
//         SizedBox(height: 8.h),
//         Container(
//           padding: EdgeInsets.all(12.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildPrepItem("Total Time", controller.recipe.totalTime),
//               _buildPrepItem("Prep Time", controller.recipe.prepTime),
//               _buildPrepItem("Cook Time", controller.recipe.cookTime),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPrepItem(String title, String value) {
//     return Column(
//       children: [
//         Text(title, style: AppTextStyles.H6_Regular.copyWith(color: AppColors.textSecondary)),
//         SizedBox(height: 4.h),
//         Text(value, style: AppTextStyles.H5_Regular),
//       ],
//     );
//   }
//
//   Widget _buildInstructionSection() {
//     return Obx(() {
//       return ExpansionTile(
//         initiallyExpanded: controller.isInstructionExpanded.value,
//         onExpansionChanged: (val) => controller.isInstructionExpanded(val),
//         title: Text("Instructions", style: AppTextStyles.H5_Regular),
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildVideoPreview(),
//               SizedBox(height: 8.h),
//               ...controller.recipe.instructions.map(
//                     (text) => Padding(
//                   padding: EdgeInsets.only(bottom: 8.h),
//                   child: Text("• $text", style: AppTextStyles.H6_Regular),
//                 ),
//               ),
//               SizedBox(height: 12.h),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
//                   minimumSize: Size(double.infinity, 40.h),
//                 ),
//                 onPressed: () {},
//                 child: Text("SIGN UP TO SEE", style: AppTextStyles.H5_Regular.copyWith(color: Colors.white)),
//               ),
//             ],
//           ),
//         ],
//       );
//     });
//   }
//
//   Widget _buildVideoPreview() {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(12.r),
//           child: Image.asset(controller.recipe.instructionVideo,
//               height: 180.h, width: double.infinity, fit: BoxFit.cover),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.black45,
//             shape: BoxShape.circle,
//           ),
//           child: Icon(Icons.play_arrow, size: 48.sp, color: Colors.white),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNutritionalSection() {
//     return ExpansionTile(
//       title: Text("Nutritional Values", style: AppTextStyles.H5_Regular),
//       children: [
//         Padding(
//           padding: EdgeInsets.all(8.w),
//           child: Text(
//             "Nutritional information about the recipe will appear here.",
//             style: AppTextStyles.H5_Regular.copyWith(color: AppColors.textSecondary),
//           ),
//         ),
//       ],
//     );
//   }
// }
