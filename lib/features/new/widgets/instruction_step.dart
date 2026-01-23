import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/text_styles.dart';

class InstructionStep extends StatelessWidget {
  final int stepNumber;
  final String instruction;

  const InstructionStep({
    Key? key,
    required this.stepNumber,
    required this.instruction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Step Number Box
            Container(
              width: 26.w,
              height: 26.w,
              alignment: Alignment.center,
              child: Text(
                "$stepNumber",
                style: AppTextStyles.H4_Regular.copyWith(
                  color: Colors.black,
                  fontSize: 12.sp,
                ),
              ),
            ),

            SizedBox(width: 10.w),

            /// Instruction Text
            Expanded(
              child: Text(
                instruction,
                style: AppTextStyles.button.copyWith(
                  fontSize: 13.sp,
                  color: Colors.black,   // <-- ADD THIS
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
