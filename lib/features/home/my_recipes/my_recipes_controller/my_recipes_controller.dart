import 'package:freshbite/features/home/my_recipes/model.dart';
import 'package:freshbite/features/recepies/my_recipes_details/my_recipes_details_service/my_recipes_details_service.dart';
import 'package:get/get.dart';


class MyRecipesController extends GetxController {
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  var myRecipes = <MyRecipeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecipes();
  }

  /// Fetch user recipes from API
  Future<void> fetchUserRecipes() async {
    try {
      isLoading.value = true;

      print("🔄 Fetching user recipes from API...");

      final response = await MyRecipesDetailsService.getUserRecipes();

      if (response['success'] == true && response['response'] != null) {
        final List<dynamic> recipesJson = response['response'];

        // Parse all recipes
        final allRecipes = recipesJson
            .map((json) => MyRecipeModel.fromJson(json))
            .toList();

        print("📊 Parsed ${allRecipes.length} user recipes");

        myRecipes.value = allRecipes;
        myRecipes.refresh();

        print("✅ Successfully loaded user recipes");
      } else {
        print("❌ Failed to fetch user recipes: Invalid response");
      }
    } catch (e) {
      print("❌ Error fetching user recipes: $e");
      // Keep using empty list on error
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  List<MyRecipeModel> get filteredRecipes {
    if (searchQuery.isEmpty) return myRecipes;
    return myRecipes
        .where((r) => r.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  /// Refresh recipes
  Future<void> refreshRecipes() async {
    await fetchUserRecipes();
  }
}
