import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:get/get.dart';

enum AppBarTitleAlignment {
  left,
  center,
  right,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Title Properties
  final String? title;
  final TextStyle? titleStyle;
  final AppBarTitleAlignment titleAlignment;
  final Widget? customTitle;

  // Left Side Properties
  final Widget? leading;
  final VoidCallback? onLeadingPressed;
  final bool showBackButton;
  final IconData? leadingIcon;
  final double? leadingIconSize;
  final Color? leadingIconColor;
  final String? leadingImage;
  final double? leadingImageSize;

  // Right Side Properties
  final List<Widget>? actions;
  final List<AppBarAction>? actionButtons;

  // Background Properties
  final Color? backgroundColor;
  final double? elevation;
  final Gradient? gradient;

  // Container Properties
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool showShadow;

  // Border Properties
  final Border? border;
  final BorderRadius? borderRadius;

  const CustomAppBar({
    Key? key,
    // Title
    this.title,
    this.titleStyle,
    this.titleAlignment = AppBarTitleAlignment.center,
    this.customTitle,
    // Left Side
    this.leading,
    this.onLeadingPressed,
    this.showBackButton = true,
    this.leadingIcon,
    this.leadingIconSize,
    this.leadingIconColor,
    this.leadingImage,
    this.leadingImageSize,
    // Right Side
    this.actions,
    this.actionButtons,
    // Background
    this.backgroundColor,
    this.elevation,
    this.gradient,
    // Container
    this.height,
    this.padding,
    this.showShadow = true,
    // Border
    this.border,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 60.h,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      // decoration: BoxDecoration(
      //   color: gradient == null ? (backgroundColor ?? AppColors.background) : null,
      //   gradient: gradient,
      //   border: border,
      //   borderRadius: borderRadius,
      //   // boxShadow: showShadow
      //   //     ? [
      //   //   BoxShadow(
      //   //     color: Colors.black.withOpacity(0.05),
      //   //     blurRadius: 10,
      //   //     offset: const Offset(0, 2),
      //   //   ),
      //   // ]
      //   //     : null,
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side
          _buildLeading(),

          // Title (Center or Dynamic)
          if (titleAlignment == AppBarTitleAlignment.center)
            Expanded(child: _buildTitle())
          else if (titleAlignment == AppBarTitleAlignment.left)
            Expanded(child: _buildTitle())
          else
            const Spacer(),

          // Right Side Actions
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildLeading() {
    if (leading != null) return leading!;

    if (!showBackButton) return const SizedBox.shrink();

    // Custom Leading Image
    if (leadingImage != null) {
      return GestureDetector(
        onTap: onLeadingPressed ?? () => Get.back(),
        child: Container(
          width: leadingImageSize ?? 36.w,
          height: leadingImageSize ?? 34.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Image.asset(
              leadingImage!,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    // Default Back Button
    return GestureDetector(
      onTap: onLeadingPressed ?? () => Get.back(),
      child: Container(
        width: 36.w,
        height: 34.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          leadingIcon ?? Icons.arrow_back,
          size: leadingIconSize ?? 24.sp,
          color: leadingIconColor ?? const Color(0xFF2E3E5C),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (customTitle != null) {
      return titleAlignment == AppBarTitleAlignment.center
          ? Center(child: customTitle!)
          : Align(
        alignment: titleAlignment == AppBarTitleAlignment.left
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: customTitle!,
      );
    }

    if (title == null) return const SizedBox.shrink();

    final defaultStyle = TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF2E3E5C),
      fontFamily: 'Rubik',
    );

    return titleAlignment == AppBarTitleAlignment.center
        ? Center(
      child: Text(
        title!,
        style: titleStyle ?? defaultStyle,
        overflow: TextOverflow.ellipsis,
      ),
    )
        : Align(
      alignment: titleAlignment == AppBarTitleAlignment.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Text(
        title!,
        style: titleStyle ?? defaultStyle,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildActions() {
    if (actions != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: actions!,
      );
    }

    if (actionButtons != null && actionButtons!.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: actionButtons!.asMap().entries.map((entry) {
          final index = entry.key;
          final action = entry.value;
          final isLast = index == actionButtons!.length - 1; // Last icon = rightmost = border side

          return Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: _buildActionButton(action, showBox: isLast),
          );
        }).toList(),
      );
    }

    return const SizedBox.shrink();
  }


  Widget _buildActionButton(AppBarAction action, {bool showBox = false}) {
    const double fixedWidth = 36;
    const double fixedHeight = 34;
    const double fixedIconSize = 24;

    final double boxWidth = fixedWidth.w;
    final double boxHeight = fixedHeight.h;
    final double iconSize = fixedIconSize.sp;

    if (action.customWidget != null) {
      return GestureDetector(
        onTap: action.onPressed,
        child: action.customWidget!,
      );
    }

    // If showBox is false (not the last icon), show without background box
    if (!showBox) {
      return GestureDetector(
        onTap: action.onPressed,
        child: action.imagePath != null
            ? Image.asset(
          action.imagePath!,
          fit: BoxFit.contain,
          width: iconSize,
          height: iconSize,
          color: action.iconColor ?? const Color(0xFF2E3E5C),
        )
            : Icon(
          action.icon ?? Icons.more_vert,
          size: iconSize,
          color: action.iconColor ?? const Color(0xFF2E3E5C),
        ),
      );
    }

    // If showBox is true (last icon = rightmost = border side), show with background box
    return GestureDetector(
      onTap: action.onPressed,
      child: Container(
        width: boxWidth,
        height: boxHeight,
        decoration: BoxDecoration(
          color: action.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(action.borderRadius ?? 5.r),
          boxShadow: action.showShadow
              ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5.r,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: action.imagePath != null
            ? Padding(
          padding: EdgeInsets.all(6.w),
          child: Image.asset(
            action.imagePath!,
            fit: BoxFit.contain,
            width: iconSize,
            height: iconSize,
            color: action.iconColor,
          ),
        )
            : Icon(
          action.icon ?? Icons.more_vert,
          size: iconSize,
          color: action.iconColor ?? const Color(0xFF2E3E5C),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 56.h);
}

// ==================== APP BAR ACTION MODEL ====================
class AppBarAction {
  final IconData? icon;
  final String? imagePath;
  final double? iconSize;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double? size;
  final double? borderRadius;
  final bool showShadow;
  final double? padding;
  final Widget? customWidget;
  final String? badge;
  final Color? badgeColor;

  AppBarAction({
    this.icon,
    this.imagePath,
    this.iconSize,
    this.iconColor,
    this.onPressed,
    this.backgroundColor,
    this.size,
    this.borderRadius,
    this.showShadow = true,
    this.padding,
    this.customWidget,
    this.badge,
    this.badgeColor,
  });
}