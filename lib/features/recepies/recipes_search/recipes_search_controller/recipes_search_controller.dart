import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/features/recepies/recipes_search/recipe_search_model.dart';
import 'package:freshbite/features/recepies/recipes_search/recipes_search_service.dart';
import 'package:get/get.dart';


class RecipeRecipeSearchController extends GetxController {
  var searchQuery = ''.obs;
  var selectedFilter = ''.obs;
  var isLoading = false.obs;

  // Recipe lists organized by cooking mode
  var everydayRecipes = <RecipeRecipeSearchModel>[].obs;
  var mealPrepRecipes = <RecipeRecipeSearchModel>[].obs;
  var emergencyRecipes = <RecipeRecipeSearchModel>[].obs;

  // Deprecated - keeping for backward compatibility during migration
  var recentFavorites = <RecipeRecipeSearchModel>[].obs;
  var collections = <RecipeRecipeSearchModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  /// Fetch all recipes from API and organize by cooking mode
  Future<void> fetchRecipes() async {
    try {
      isLoading.value = true;

      print("🔄 Fetching recipes from API...");

      final response = await RecipesSearchService.getAllRecipes();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> recipesJson = response['data'];

        // Parse all recipes
        final allRecipes = recipesJson
            .map((json) => RecipeRecipeSearchModel.fromJson(json))
            .toList();

        print("📊 Parsed ${allRecipes.length} recipes");

        // Clear existing lists
        everydayRecipes.clear();
        mealPrepRecipes.clear();
        emergencyRecipes.clear();

        // Organize recipes by cooking mode
        for (var recipe in allRecipes) {
          final mode = recipe.cookingMode.toLowerCase().trim();

          if (mode == 'everyday') {
            everydayRecipes.add(recipe);
          } else if (mode == 'meal prep' || mode == 'mealprep') {
            mealPrepRecipes.add(recipe);
          } else if (mode == 'emergency') {
            emergencyRecipes.add(recipe);
          } else {
            // Default to everyday if mode is unknown
            print("⚠️ Unknown cooking mode: '$mode', adding to everyday");
            everydayRecipes.add(recipe);
          }
        }

        print("✅ Organized recipes:");
        print("   Everyday: ${everydayRecipes.length}");
        print("   Meal Prep: ${mealPrepRecipes.length}");
        print("   Emergency: ${emergencyRecipes.length}");

        // Update deprecated lists for backward compatibility
        recentFavorites.value = everydayRecipes.take(10).toList();
        collections.value = mealPrepRecipes.take(10).toList();

        // Refresh all observable lists
        everydayRecipes.refresh();
        mealPrepRecipes.refresh();
        emergencyRecipes.refresh();
        recentFavorites.refresh();
        collections.refresh();
      } else {
        print("❌ Failed to fetch recipes: Invalid response");
      }
    } catch (e) {
      print("❌ Error fetching recipes: $e");
      // Keep using empty lists on error
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void toggleFavorite(String recipeId) {
    // Find and toggle in everydayRecipes
    final everydayIndex = everydayRecipes.indexWhere((r) => r.id == recipeId);
    if (everydayIndex != -1) {
      everydayRecipes[everydayIndex].isFavorite = !everydayRecipes[everydayIndex].isFavorite;
      everydayRecipes.refresh();

      // Call API to update favorite status
      RecipesSearchService.toggleFavoriteRecipe(
        recipeId,
        everydayRecipes[everydayIndex].isFavorite,
      );
      return;
    }

    // Find and toggle in mealPrepRecipes
    final mealPrepIndex = mealPrepRecipes.indexWhere((r) => r.id == recipeId);
    if (mealPrepIndex != -1) {
      mealPrepRecipes[mealPrepIndex].isFavorite = !mealPrepRecipes[mealPrepIndex].isFavorite;
      mealPrepRecipes.refresh();

      // Call API to update favorite status
      RecipesSearchService.toggleFavoriteRecipe(
        recipeId,
        mealPrepRecipes[mealPrepIndex].isFavorite,
      );
      return;
    }

    // Find and toggle in emergencyRecipes
    final emergencyIndex = emergencyRecipes.indexWhere((r) => r.id == recipeId);
    if (emergencyIndex != -1) {
      emergencyRecipes[emergencyIndex].isFavorite = !emergencyRecipes[emergencyIndex].isFavorite;
      emergencyRecipes.refresh();

      // Call API to update favorite status
      RecipesSearchService.toggleFavoriteRecipe(
        recipeId,
        emergencyRecipes[emergencyIndex].isFavorite,
      );
      return;
    }

    // Also update in deprecated lists for backward compatibility
    final recentIndex = recentFavorites.indexWhere((r) => r.id == recipeId);
    if (recentIndex != -1) {
      recentFavorites[recentIndex].isFavorite = !recentFavorites[recentIndex].isFavorite;
      recentFavorites.refresh();
    }

    final collectionIndex = collections.indexWhere((r) => r.id == recipeId);
    if (collectionIndex != -1) {
      collections[collectionIndex].isFavorite = !collections[collectionIndex].isFavorite;
      collections.refresh();
    }
  }

  /// Refresh recipes from API
  Future<void> refreshRecipes() async {
    await fetchRecipes();
  }
}
