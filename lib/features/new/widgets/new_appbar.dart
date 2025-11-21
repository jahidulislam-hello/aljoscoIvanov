import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';


class NewAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const NewAppbar({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: AppColors.textPrimary,
          size: 20.sp,
        ),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.h);
}