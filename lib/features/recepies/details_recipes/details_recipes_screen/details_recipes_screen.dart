// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/app_text_styles.dart';
// import '../../../core/utils/app_images.dart';
// import '../controller/recipe_details_controller.dart';
//
// class RecipeDetailsScreen extends StatelessWidget {
//   final RecipeDetailsController controller = Get.put(RecipeDetailsController());
//
//   RecipeDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.bgColor,
//         elevation: 0,
//         leading: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
//         title: Text("Recipe Details", style: AppTextStyle.medium16),
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
//         Text(controller.recipe.title, style: AppTextStyle.semiBold18),
//         Row(
//           children: [
//             Icon(Icons.star, color: AppColors.star, size: 18.sp),
//             SizedBox(width: 4.w),
//             Text(controller.recipe.rating.toString(), style: AppTextStyle.medium14),
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
//           Text("Description", style: AppTextStyle.medium16),
//           SizedBox(height: 4.h),
//           Text(
//             controller.recipe.description,
//             maxLines: controller.isDescriptionExpanded.value ? null : 2,
//             overflow: TextOverflow.fade,
//             style: AppTextStyle.regular14.copyWith(color: AppColors.textSecondary),
//           ),
//           TextButton(
//             onPressed: () => controller.isDescriptionExpanded.toggle(),
//             child: Text(
//               controller.isDescriptionExpanded.value ? "Show less" : "Read more",
//               style: AppTextStyle.medium14.copyWith(color: AppColors.primary),
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
//         title: Text("Ingredients", style: AppTextStyle.medium16),
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
//                       Text(key, style: AppTextStyle.regular14),
//                       Text(value, style: AppTextStyle.medium14),
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
//                 child: Text("Sign Up To Add Grocery", style: AppTextStyle.medium14.copyWith(color: Colors.white)),
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
//         Text("Preparation", style: AppTextStyle.medium16),
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
//         Text(title, style: AppTextStyle.regular12.copyWith(color: AppColors.textSecondary)),
//         SizedBox(height: 4.h),
//         Text(value, style: AppTextStyle.medium14),
//       ],
//     );
//   }
//
//   Widget _buildInstructionSection() {
//     return Obx(() {
//       return ExpansionTile(
//         initiallyExpanded: controller.isInstructionExpanded.value,
//         onExpansionChanged: (val) => controller.isInstructionExpanded(val),
//         title: Text("Instructions", style: AppTextStyle.medium16),
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildVideoPreview(),
//               SizedBox(height: 8.h),
//               ...controller.recipe.instructions.map(
//                     (text) => Padding(
//                   padding: EdgeInsets.only(bottom: 8.h),
//                   child: Text("• $text", style: AppTextStyle.regular14),
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
//                 child: Text("SIGN UP TO SEE", style: AppTextStyle.medium14.copyWith(color: Colors.white)),
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
//       title: Text("Nutritional Values", style: AppTextStyle.medium16),
//       children: [
//         Padding(
//           padding: EdgeInsets.all(8.w),
//           child: Text(
//             "Nutritional information about the recipe will appear here.",
//             style: AppTextStyle.regular14.copyWith(color: AppColors.textSecondary),
//           ),
//         ),
//       ],
//     );
//   }
// }
