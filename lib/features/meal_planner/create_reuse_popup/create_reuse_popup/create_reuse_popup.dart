import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/features/meal_planner/create_reuse_popup/create_reuse_popup_controller/create_reuse_popup_controller.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';


class CreateReusePopup extends StatelessWidget {
  const CreateReusePopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateReuseController(),
      child: Consumer<CreateReuseController>(
        builder: (context, controller, child) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Please select the start date".tr,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 16.h),
                    _buildMonthDropdown(controller),
                    SizedBox(height: 12.h),
                    _buildDateRow(controller),
                    SizedBox(height: 20.h),
                    _buildTextField(
                      controller: controller.titleController,
                      hintText: 'e.g. "My Monday Menu"'.tr,
                      label: "Add Title".tr,
                    ),
                    SizedBox(height: 12.h),
                    _buildTextField(
                      controller: controller.descriptionController,
                      hintText: 'e.g. "Usual Breakfast and family dinner"'.tr,
                      label: "Add Description".tr,
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.applyMealPlan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2B3A0B),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                        ),
                        child: Text(
                          "Apply to the Meal Planer".tr,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Your saved meal plan will start on the chosen date.".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1].tr;
  }

  Widget _buildMonthDropdown(CreateReuseController controller) {
    final currentMonthIndex = controller.selectedDate.month;

    return DropdownButton<int>(
      value: currentMonthIndex,
      isExpanded: true,
      underline: const SizedBox(),
      items: List.generate(
        12,
            (index) {
          final monthNum = index + 1;
          final year = DateTime.now().year;
          return DropdownMenuItem(
            value: monthNum,
            child: Text(
              '${_getMonthName(monthNum)} $year',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
          );
        },
      ),
      onChanged: (value) {
        if (value != null) {
          controller.selectDate(DateTime(DateTime.now().year, value, controller.selectedDate.day));
        }
      },
    );
  }

  String _getDayOfWeek(DateTime date) {
    const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return days[date.weekday - 1].tr;
  }

  Widget _buildDateRow(CreateReuseController controller) {
    final now = controller.selectedDate;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final date = now.subtract(Duration(days: now.weekday - 1 - index));
        final isSelected = date.day == controller.selectedDate.day;
        return GestureDetector(
          onTap: () => controller.selectDate(date),
          child: Column(
            children: [
              Text(
                _getDayOfWeek(date),
                style: TextStyle(fontSize: 12.sp),
              ),
              SizedBox(height: 4.h),
              CircleAvatar(
                radius: 16.r,
                backgroundColor: isSelected ? const Color(0xFF2B3A0B) : Colors.transparent,
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
      ],
    );
  }
}
