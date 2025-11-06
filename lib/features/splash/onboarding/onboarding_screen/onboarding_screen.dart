import 'package:flutter/material.dart';
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

  final List<Map<String, String>> onboardingData = [
    {
      "title": "Wellcome to FreshBite !".tr,
      "description": "Log in to start cooking!".tr,
      "onboardImage": "assets/images/onboard.png",
    },
  ];

  final _localizationController = Get.find<LocalizationController>();



  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != currentPage) {
        setState(() => currentPage = newPage);
      }
    });
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
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    onboardingData[0]['onboardImage']!,
                    height: 400.h,
                    width: 393.w,
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    onboardingData[0]['title']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w900,

                      color: Color(0xFF1C2D07),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    onboardingData[0]['description']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 80.h),
                ],
              ),
            ),

            /// SIGN UP Button
            Positioned(
              bottom: 120.h,
              left: sizeW * 0.12,
              right: sizeW * 0.12,
              child: CustomTextButton(
                text: 'SIGN UP'.tr,
                onTap: () {
                  // context.pushNamed(RouteNames.signUpScreen);
                },
              ),
            ),
            SizedBox(height: 20.h),

            /// LOGIN Button
            Positioned(
              bottom: 70.h,
              left: sizeW * 0.12,
              right: sizeW * 0.12,
              child: CustomTextButton(
                text: 'LOGIN'.tr,
                onTap: () {
                  // context.pushNamed(RouteNames.loginScreen);
                },
              ),
            ),

            /// "Continue as Guest" section
            Positioned(
              bottom: 30.h,
              left: sizeW * 0.12,
              right: sizeW * 0.12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "or",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: () {
                      // context.pushNamed(RouteNames.signInScreen);
                    },
                    child: Text(
                      "Continue as Guest",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.background,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Language toggle at top-right
            Positioned(
              top: sizeH * 0.05,
              right: sizeW * 0.05,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _localizationController.setLanguage(
                                const Locale('de', "DE"));
                          },
                          child: Text(
                            'DE',
                            style: TextStyle(
                              color: _localizationController.locale.languageCode == 'de' ? AppColors.buttonColor : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Switch(
                          value: _localizationController.locale.languageCode == 'en',
                          onChanged: (value) {
                            setState(() {
                              value
                                  ? _localizationController.setLanguage(
                                  const Locale('en', "US"))
                                  : _localizationController.setLanguage(
                                  const Locale('de', "DE"));
                            });
                          },
                          activeThumbColor: AppColors.background,
                          inactiveThumbColor: Colors.grey[300],
                          inactiveTrackColor: Colors.grey,
                        ),
                        GestureDetector(
                          onTap: () {
                            _localizationController.setLanguage(
                                const Locale('en', "US"));
                          },
                          child: Text(
                            'EN',
                            style: TextStyle(
                              color: _localizationController.locale.languageCode == 'en' ? AppColors.buttonColor : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
