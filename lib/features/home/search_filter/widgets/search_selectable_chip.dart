import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchSelectableChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? prefixIcon; // ⭐ optional prefix icon

  const SearchSelectableChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        margin: EdgeInsets.only(right: 8.w),

        decoration: BoxDecoration(
          color: selected ? const Color(0xFF263715) : const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: selected ? const Color(0xFF263715) : const Color(0xFFD6D6D6),
            width: 1,
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: 6.w),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : const Color(0xFF4A4A4A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
