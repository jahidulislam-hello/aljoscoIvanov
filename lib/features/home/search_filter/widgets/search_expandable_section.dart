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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style:
                    TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                Icon(expanded.value ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
          if (expanded.value) SizedBox(height: 12.h),
          if (expanded.value) child,
          SizedBox(height: 20.h)
        ],
      );
    });
  }
}
