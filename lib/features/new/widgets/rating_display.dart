// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:freshbite/core/themes/app_colors.dart';
// import 'package:freshbite/core/themes/text_styles.dart';
//
//
// class RatingDisplay extends StatelessWidget {
//   final double rating;
//   final int reviewCount;
//   final double starSize;
//   final double fontSize;
//
//   const RatingDisplay({
//     Key? key,
//     required this.rating,
//     required this.reviewCount,
//     this.starSize = 16,
//     this.fontSize = 14,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ...List.generate(5, (index) {
//           if (index < rating.floor()) {
//             return Icon(
//               Icons.star,
//               color: AppColors.starYellow,
//               size: starSize.sp,
//             );
//           } else if (index < rating) {
//             return Icon(
//               Icons.star_half,
//               color: AppColors.starYellow,
//               size: starSize.sp,
//             );
//           } else {
//             return Icon(
//               Icons.star_border,
//               color: AppColors.starYellow,
//               size: starSize.sp,
//             );
//           }
//         }),
//         SizedBox(width: 6.w),
//         Text(
//           rating.toStringAsFixed(1),
//           style: AppTextStyles.H5_Regular.copyWith(
//             fontSize: fontSize.sp,
//           ),
//         ),
//         SizedBox(width: 4.w),
//         Text(
//           '($reviewCount)',
//           style: AppTextStyles.H6_Regular.copyWith(
//             fontSize: fontSize.sp,
//             color: AppColors.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }