
import 'package:flutter/material.dart';
import 'package:freshbite/core/navbar/controller/navbar_controller.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_screen/home_recepies_screen.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_all_screen/meal_planner_all_screen.dart';
import 'package:freshbite/features/profile/profile/profile_screen/profile_screen.dart';
import 'package:freshbite/features/recepies/recipes_search/recipes_search_screen/recipes_search_screen.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_screen/shopping_screen.dart';
import 'package:freshbite/localization/localization/localization_controller.dart';
import 'package:get/get.dart';


class BottomNavbar extends StatefulWidget {
  final int initialIndex;
  const BottomNavbar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late final BottomNavbarController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BottomNavbarController(widget.initialIndex));
  }

  final List<Widget> pages = [
    HomeScreen(),
    ShoppingScreen(),
    AddMealPlanningScreen(),
    RecipeRecipeSearchScreen(),
    ProfileScreen(),
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
        child: GetBuilder<LocalizationController>(
          builder: (localizationController) {
            final isGerman = localizationController.locale.languageCode == 'de';
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  activeImage: isGerman ? "assets/navbar/Home-gr-v1.png" : "assets/navbar/Home=v2.png",
                  passiveImage: isGerman ? "assets/navbar/Home-gr-v2.png" : "assets/navbar/Home=v1.png",
                  index: 0,
                ),
                _buildNavItem(
                  activeImage: isGerman ? "assets/navbar/Grocery-gr-v1.png" : "assets/navbar/Grocery=v2.png",
                  passiveImage: isGerman ? "assets/navbar/Grocery-gr-v2.png" : "assets/navbar/Grocery=v1.png",
                  index: 1,
                ),
                _buildNavItem(
                  activeImage: isGerman ? "assets/navbar/Plan-gr-v1.png" : "assets/navbar/Plan=V2.png",
                  passiveImage: isGerman ? "assets/navbar/Plan-gr-v2.png" : "assets/navbar/Plan=V1.png",
                  index: 2,
                ),
                _buildNavItem(
                  activeImage: isGerman ? "assets/navbar/Recipes-gr-v1.png" : "assets/navbar/Recipes=v2.png",
                  passiveImage: isGerman ? "assets/navbar/Recipes-gr-v2.png" : "assets/navbar/Recipes=v1.png",
                  index: 3,
                ),
                _buildNavItem(
                  activeImage: isGerman ? "assets/navbar/user-gr-v1.png" : "assets/navbar/user=v2.png",
                  passiveImage: isGerman ? "assets/navbar/user-gr-v2.png" : "assets/navbar/user=v1.png",
                  index: 4,
                ),
              ],
            );
          },
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
          alignment: Alignment.center,
          child: Image.asset(
            isSelected ? activeImage : passiveImage,
            height: isSelected ? 40 : 40,
            width: isSelected ? 100 : 40,
            fit: BoxFit.contain,
          ),
        );
      }),
    );
  }
}