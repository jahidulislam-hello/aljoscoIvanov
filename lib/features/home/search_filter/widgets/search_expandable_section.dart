import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchExpandableSection extends StatelessWidget {
  final String title;
  final RxBool expanded;
  final Widget child;

  const SearchExpandableSection({
    super.key,
    required this.title,
    required this.expanded,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => expanded.value = !expanded.value,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title.tr,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2B2B2B),
                    ),
                  ),
                  Icon(
                    expanded.value ? Icons.expand_less : Icons.expand_more,
                    color: const Color(0xFF4A4A4A),
                    size: 22.sp,
                  ),
                ],
              ),
            ),
          ),

          if (expanded.value) SizedBox(height: 10.h),

          // ⭐ chips will wrap automatically
          if (expanded.value) child,

          SizedBox(height: 18.h),
        ],
      );
    });
  }
}
