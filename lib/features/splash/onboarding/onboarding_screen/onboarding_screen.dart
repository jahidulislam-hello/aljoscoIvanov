import 'package:flutter/material.dart';
import 'package:freshbite/features/auth/sign_in/signin_screen/signin_screen.dart';
import 'package:freshbite/features/auth/sign_up/signUp_screen/signUp_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/localization/localization/localization_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  final _localizationController = Get.find<LocalizationController>();
  String selectedLang = 'EN'; // Default

  @override
  void initState() {
    super.initState();
    selectedLang = _localizationController.locale.languageCode == 'de' ? 'DE' : 'EN';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    final sizeW = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// Main onboarding content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sizeW * .12),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/onboard.png',
                    height: 400.h,
                    width: 593.w,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Wellcome to FreshBite !'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Baste B', // your custom font
                      fontWeight: FontWeight.w900, // 900 = Black weight
                      fontStyle: FontStyle.normal, // since 'Black' is weight, style stays normal
                      fontSize: 40.sp,
                      height: 46 / 40, // line height ratio → 46px line-height for 40px font-size
                      letterSpacing: 0,
                      color: const Color(0xFF1C2D07),
                    ),
                  ),

                  SizedBox(height: 10.h),
                  Text(
                    'Log in to start cooking!'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Color(0xFF677259),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 80.h),
                ],
              ),
            ),

            /// LOGIN Button (Filled)
            Positioned(
              bottom: 150.h,
              left: sizeW * 0.12,
              right: sizeW * 0.12,
              child: CustomTextButton(
                text: 'LOGIN'.tr,
                filled: true,
                onTap: () {
                  Get.offAll(() => LoginScreen());
                },
              ),
            ),

            /// SIGN UP Button (Outlined)
            Positioned(
              bottom: 90.h,
              left: sizeW * 0.12,
              right: sizeW * 0.12,
              child: CustomTextButton(
                text: 'SIGN UP'.tr,
                filled: false,
                color: Color(0xFF1C2D07), // border & text color
                onTap: () {
                  Get.offAll(() => SignUpScreen());
                },
              ),
            ),


            /// "Continue as Guest"
            Positioned(
              bottom: 50.h,
              left: sizeW * 0.12,
              right: sizeW * 0.12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('or'.tr, style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Continue as Guest'.tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.buttonColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Language dropdown (top-right)
            Positioned(
              top: sizeH * 0.05,
              right: sizeW * 0.05,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLang,
                    icon: Icon(Icons.keyboard_arrow_down, color: AppColors.mainTextColor),
                    items: [
                      DropdownMenuItem(
                        value: 'EN',
                        child: Row(
                          children: [
                            Image.asset('assets/icons/us.png', width: 24.w, height: 24.h),
                            SizedBox(width: 8.w),
                            Text('EN', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'DE',
                        child: Row(
                          children: [
                            Image.asset('assets/icons/ger.png', width: 24.w, height: 24.h),
                            SizedBox(width: 8.w),
                            Text('DE', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedLang = value);
                        if (value == 'EN') {
                          _localizationController.setLanguage(const Locale('en', "US"));
                        } else {
                          _localizationController.setLanguage(const Locale('de', "DE"));
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
