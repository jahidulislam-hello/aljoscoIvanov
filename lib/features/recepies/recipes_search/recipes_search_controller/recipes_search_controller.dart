import 'package:freshbite/core/themes/app_images.dart';
import 'package:get/get.dart';

import '../recipes_search_model/recipes_search_model.dart';

class RecipeSearchController extends GetxController {
  var recipes = <RecipeModel>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecipes();
  }

  void loadRecipes() {
    recipes.assignAll([
      RecipeModel(
        title: "Pancake",
        image: AppImages.pancake,
        duration: 45,
        category: "Everyday",
      ),
      RecipeModel(
        title: "Red Velvet",
        image: AppImages.redVelvet,
        duration: 45,
        category: "Everyday",
      ),
      RecipeModel(
        title: "Burrito",
        image: AppImages.burrito,
        duration: 45,
        category: "Meal Prep",
      ),
    ]);
  }

  List<RecipeModel> getByCategory(String category) {
    return recipes.where((r) => r.category == category).toList();
  }
}
