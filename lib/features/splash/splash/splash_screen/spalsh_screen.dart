import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freshbite/features/splash/splash/spalsh_controller/splash_controller.dart';

import '../../../../core/themes/app_colors.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Image.asset(
            'assets/images/g10.png',
            width: 260.w,
            height: 260.h,
            fit: BoxFit.contain,
          ),
        ),

      ),
    );
  }
}