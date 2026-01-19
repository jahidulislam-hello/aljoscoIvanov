
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/features/dummy/recipe_search/recipe_search_model.dart';
import 'package:get/get.dart';



class RecipeSearchController extends GetxController {
  var recipes = <RecipeSearchModel>[].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecipes();
  }

  void loadRecipes() {
    recipes.assignAll([
      RecipeSearchModel(
        title: "Pancake",
        image: AppImages.appLogo,
        duration: 45,
        category: "Everyday",
      ),
      RecipeSearchModel(
        title: "Red Velvet",
        image: AppImages.appLogo,
        duration: 45,
        category: "Everyday",
      ),
      RecipeSearchModel(
        title: "Burrito",
        image: AppImages.appLogo,
        duration: 45,
        category: "Meal Prep",
      ),
    ]);
  }

  List<RecipeSearchModel> getByCategory(String category) {
    return recipes.where((r) => r.category == category).toList();
  }
}
