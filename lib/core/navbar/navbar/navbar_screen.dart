
import 'package:flutter/material.dart';
import 'package:freshbite/core/navbar/controller/navbar_controller.dart';
import 'package:freshbite/features/home/favourites/favourites_screen/favourite_screen.dart';
import 'package:freshbite/features/home/home_new/screen/cooking_screen.dart';
import 'package:freshbite/features/home/home_new/screen/recipe_screen.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_screen/home_recepies_screen.dart';
import 'package:get/get.dart';


class BottomNavbar extends StatefulWidget {
  final int initialIndex;
  const BottomNavbar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  // Initialize controller with the initial index directly
  late final BottomNavbarController controller;

  @override
  void initState() {
    super.initState();
    // Create controller with initial index - no setState needed
    controller = Get.put(BottomNavbarController(widget.initialIndex));
  }

  final List<Widget> pages = [
    HomeScreen(),
    CookingSkillsScreen(),
    RecipeDetailScreen(),
    FavoritesScreen(),
    RecipeDetailScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              activeImage: "assets/navbar/Home=v2.png",
              passiveImage: "assets/navbar/Home=v1.png",
              index: 0,
            ),
            _buildNavItem(
              activeImage: "assets/navbar/Grocery=v2.png",
              passiveImage: "assets/navbar/Grocery=v1.png",
              index: 1,
            ),
            _buildNavItem(
              activeImage: "assets/navbar/Plan=V2.png",
              passiveImage: "assets/navbar/Plan=V1.png",
              index: 2,
            ),
            _buildNavItem(
              activeImage: "assets/navbar/Recipes=v2.png",
              passiveImage: "assets/navbar/Recipes=v1.png",
              index: 3,
            ),
            _buildNavItem(
              activeImage: "assets/navbar/user=v2.png",
              passiveImage: "assets/navbar/user=v1.png",
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String activeImage,
    required String passiveImage,
    required int index,
  }) {
    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: Obx(() {
        final isSelected = controller.currentIndex.value == index;

        return Container(
          // decoration: BoxDecoration(
          //   border: Border(
          //     top: BorderSide(
          //       color: isSelected ? const Color(0xFF1C2D07) : Colors.transparent,
          //       width: 2,
          //     ),
          //   ),
          // ),
          alignment: Alignment.center,
          child: Image.asset(
            isSelected ? activeImage : passiveImage,
            height: 48,
            fit: BoxFit.contain,
          ),
        );
      }),
    );
  }
}