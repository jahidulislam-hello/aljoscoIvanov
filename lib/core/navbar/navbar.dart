// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
//
//
//
// class CustomNavbar extends StatefulWidget {
//   const CustomNavbar({super.key});
//
//   @override
//   State<CustomNavbar> createState() => CustomNavbarState();
// }
//
// class CustomNavbarState extends State<CustomNavbar> {
//   // HomeController homeController = Get.put(HomeController());
//   int currentIndex = 0;
//
//   final screens = [
//     // WorkoutScreen(),
//     // MealScreen(),
//     // WeightTrackingScreen(),
//     // SettingsProfileScreen(),
//
//   ];
//   @override
//   void initState() {
//     super.initState();
//     Get.put(this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final sizeH = MediaQuery.of(context).size.height;
//     final sizeW = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         leading: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: AppLogo(),
//         ),
//
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: AppIcons.fire,
//           ),
//           IconButton(
//             onPressed: () {
//               // Example navigation to cart screen
//               // Get.toNamed(RouteNames.cartScreen, preventDuplicates: false);
//             },
//             icon: const Icon(Icons.shopping_cart_outlined),
//           ),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 currentIndex = 3; // 👈 go to Settings Profile tab
//               });
//             },
//             child: Container(
//               margin: EdgeInsets.only(right: sizeW * .03),
//               padding: EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.grey.shade300, width: 1),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: CircleAvatar(
//                 radius: sizeH * .02,
//                 backgroundColor: Colors.grey.shade200,
//                 backgroundImage: const AssetImage('assets/images/profile_placeholder.png'),
//                 // If you have a dynamic image, uncomment this:
//                 // backgroundImage: NetworkImage("${ApiConstants.imageBaseUrl}${homeController.getMyCouponResponseModel.value.image}"),
//               ),
//             ),
//           ),
//         ],
//
//       ),
//       body: screens[currentIndex],
//       bottomNavigationBar: _buildBottomNavBar(sizeH, sizeW),
//     );
//   }
//
//   Widget _buildBottomNavBar(double sizeH, double sizeW) {
//     return Container(
//       height: sizeH * .08,
//       margin: EdgeInsets.all(sizeH * .01),
//       padding: EdgeInsets.symmetric(horizontal: sizeW * .04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(sizeH * .04),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(Icons.fitness_center, 0, true),
//           _buildNavItem(Icons.restaurant, 1, true),
//           _buildNavItem(Icons.show_chart, 2,true),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNavItem(IconData icon, int index, bool isIcon) {
//     final sizeH = MediaQuery.of(context).size.height;
//     final isSelected = currentIndex == index;
//
//     return GestureDetector(
//       onTap: () => setState(() => currentIndex = index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           isIcon == true ?  Icon(icon, color: isSelected ? AppColors.primaryColor : Colors.grey, size: sizeH * .03): SvgPicture.asset( AppIcons.chatIcon,width: 30.w,height: 30.h, colorFilter: ColorFilter.mode(
//             isSelected ? AppColors.primaryColor : Colors.grey,
//             BlendMode.srcIn,
//           ),),
//           if (isSelected)
//             Padding(
//               padding: EdgeInsets.only(top: sizeH * .004),
//               child: Container(
//                 height: 3.h,
//                 width: 25.w,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryColor,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }