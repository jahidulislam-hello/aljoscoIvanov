
// view/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/features/home/cooking_skill/cooking_skill_Screen.dart';
import 'package:freshbite/features/home/favourites/favourites_screen/favourite_screen.dart';
import 'package:freshbite/features/home/home_menu/home_menu_screen/preferences/preferences.dart' show PreferencesScreen;
import 'package:freshbite/features/home/terms_condition/about_freshbite.dart';
import 'package:freshbite/features/home/terms_condition/frequently_ask_question.dart';
import 'package:freshbite/features/home/terms_condition/privacy_policy.dart';
import 'package:freshbite/features/home/terms_condition/terms_conditions.dart';
import 'package:freshbite/features/subscription/subscription_screen.dart';
import 'package:freshbite/features/auth/sign_in/signin_screen/signin_screen.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/core/navbar/controller/navbar_controller.dart';
import 'package:get/get.dart';



class HomeScreenMenu extends StatefulWidget {
  const HomeScreenMenu({Key? key}) : super(key: key);
  @override
  State<HomeScreenMenu> createState() => _HomeScreenMenuState();
}

class _HomeScreenMenuState extends State<HomeScreenMenu> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  bool _isMenuOpen = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );


  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (!mounted) return;
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _closeMenu() {
    if (_isMenuOpen && mounted) {
      setState(() {
        _isMenuOpen = false;
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Sidebar Menu
          _buildSidebar(),

          // Main Content with Animation
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.translate(
                  offset: Offset(
                    MediaQuery.of(context).size.width * _slideAnimation.value,
                    0,
                  ),
                  child: GestureDetector(
                    onTap: _closeMenu,
                    child: AbsorbPointer(
                      absorbing: _isMenuOpen,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_isMenuOpen ? 20.r : 0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: _isMenuOpen ? 5.0 : 0.0,
                            sigmaY: _isMenuOpen ? 5.0 : 0.0,
                          ),

                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }




  Widget _buildSidebar() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white, // Full sidebar background
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==============================
          //        FULL-WIDTH HEADER
          // ==============================
          Container(
            height: 100.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.r),
                bottomRight: Radius.circular(10.r),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              'freshbite',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w900,
                fontFamily: "BasteB",
                color: AppColors.buttonColor,
              ),
            ),
          ),

          // Padding starts AFTER the header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),

                _buildMenuItem('assets/icons/menu1.png', 'My Profile'.tr, onTap: () {
                  Get.find<BottomNavbarController>().changeIndex(4);
                },),
                _buildMenuItem('assets/icons/menu2.png', 'Subscription'.tr, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubscriptionScreen(),
                    ),
                  );
                },),
                _buildMenuItem(
                  'assets/icons/menu3.png',
                  'Favourites'.tr,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FavoritesScreen(),
                      ),
                    );
                  },
                ),

                _buildMenuItem('assets/icons/menu4.png', 'Preferences'.tr,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PreferencesScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  'assets/icons/menu5.png',
                  'Cooking Skills'.tr,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CookingSkillsScreen(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 26.h),

                // Divider
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey.withOpacity(0.3),
                ),

                SizedBox(height: 26.h),

                _buildMenuItem('assets/icons/menu6.png', 'About freshbite'.tr, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AboutUs(),
                    ),
                  );
                },),
                _buildMenuItem('assets/icons/menu7.png', 'FAQ'.tr, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FrequentlyAskQuestion(),
                    ),
                  );
                },),
                _buildMenuItem('assets/icons/menu8.png', 'Privacy Policy'.tr, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrivacyPolicy(),
                    ),
                  );
                },),
                _buildMenuItem('assets/icons/menu9.png', 'Terms & Conditions'.tr, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TermsConditions(),
                    ),
                  );
                },),

                SizedBox(height: 16.h),

                _buildMenuItem('assets/icons/menu10.png', 'Sign Out'.tr, isLogout: true, onTap: () async {
                  await SharedPreferencesHelper.clearAllData();
                  Get.offAll(() => const LoginScreen());
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }




  Widget _buildMenuItem(
      dynamic icon, // Changed from IconData to dynamic
      String title, {
        bool hasArrow = false,
        bool isLogout = false,
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: () {
        Get.back(); // close the menu dialog/overlay first
        if (onTap != null) {
          onTap();
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            // Handle both Image assets and IconData
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: icon is String
                  ? Image.asset(
                icon,
                width: 20.w,
                height: 20.h,
                color: isLogout ? Colors.red : Colors.black,
              )
                  : Icon(
                icon as IconData,
                size: 20.sp,
                color: isLogout ? Colors.red : Colors.black,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isLogout ? Colors.red : Colors.black,
                ),
              ),
            ),
            if (hasArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: Colors.grey[600],
              ),
          ],
        ),
      ),
    );
  }


}