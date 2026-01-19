// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:freshbite/features/home/home_recipes/home_recepies_controller/favourites_controller.dart';
// import 'package:get/get.dart';
//
//
// class FavoritesScreen extends StatelessWidget {
//   FavoritesScreen({super.key});
//
//   final FavoritesController controller = Get.put(FavoritesController());
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
//           "Favorites",
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
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Search bar
//               Container(
//                 height: 45.h,
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(30.r),
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 12.w),
//                 child: Row(
//                   children: [
//                     Icon(Icons.search, color: AppColors.textSecondary, size: 22.sp),
//                     SizedBox(width: 8.w),
//                     Expanded(
//                       child: TextField(
//                         decoration: InputDecoration(
//                           hintText: "Search recipes",
//                           hintStyle: AppTextStyle.bodySmall.copyWith(color: AppColors.textSecondary),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     Icon(Icons.tune, color: AppColors.primary),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//
//               // Recent Favorites
//               Text(
//                 "Recent Favorites",
//                 style: AppTextStyle.titleMedium.copyWith(
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               SizedBox(height: 10.h),
//
//               Obx(() => GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisExtent: 200.h,
//                   crossAxisSpacing: 10.w,
//                   mainAxisSpacing: 10.h,
//                 ),
//                 itemCount: controller.favorites.length,
//                 itemBuilder: (context, index) {
//                   final item = controller.favorites[index];
//                   return Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Stack(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
//                               child: Image.asset(
//                                 item.image,
//                                 width: double.infinity,
//                                 height: 110.h,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             Positioned(
//                               right: 8.w,
//                               top: 8.h,
//                               child: CircleAvatar(
//                                 radius: 14.r,
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   item.isFavorite ? Icons.favorite : Icons.favorite_border,
//                                   color: AppColors.primary,
//                                   size: 16.sp,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(item.title,
//                                   style: AppTextStyle.bodyMedium
//                                       .copyWith(fontWeight: FontWeight.w600)),
//                               SizedBox(height: 4.h),
//                               Row(
//                                 children: [
//                                   Icon(Icons.access_time, size: 14.sp, color: AppColors.textSecondary),
//                                   SizedBox(width: 4.w),
//                                   Text(item.duration,
//                                       style: AppTextStyle.bodySmall
//                                           .copyWith(color: AppColors.textSecondary)),
//                                 ],
//                               ),
//                               SizedBox(height: 4.h),
//                               Row(
//                                 children: List.generate(
//                                   5,
//                                       (i) => Icon(
//                                     i < item.rating.round()
//                                         ? Icons.star
//                                         : Icons.star_border,
//                                     size: 14.sp,
//                                     color: AppColors.primary,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               )),
//
//               SizedBox(height: 20.h),
//
//               // Collections
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Collections",
//                     style: AppTextStyle.titleMedium.copyWith(
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   Text(
//                     "Create",
//                     style: AppTextStyle.bodySmall.copyWith(color: AppColors.primary),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10.h),
//
//               Obx(() => GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisExtent: 160.h,
//                   crossAxisSpacing: 10.w,
//                   mainAxisSpacing: 10.h,
//                 ),
//                 itemCount: controller.collections.length,
//                 itemBuilder: (context, index) {
//                   final col = controller.collections[index];
//                   return Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.white,
//                       borderRadius: BorderRadius.circular(12.r),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
//                           child: Image.asset(
//                             col.image,
//                             width: double.infinity,
//                             height: 110.h,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(8.w),
//                           child: Text(
//                             col.title,
//                             style: AppTextStyle.bodyMedium.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.textPrimary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
