import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshbite/features/home/search_filter/search_filter_service.dart';
import 'package:freshbite/features/recepies/recipes_search/recipe_search_model.dart';

class SearchFilterController extends GetxController {
  // Search query
  final searchController = TextEditingController();
  var searchQuery = ''.obs;
  
  // Expandable section states
  RxBool mealTypeExpanded = true.obs;
  RxBool recipeComponentsExpanded = false.obs;
  RxBool cookingModeExpanded = false.obs;
  RxBool flavorProfileExpanded = false.obs;
  RxBool cuisineTypeExpanded = false.obs;
  RxBool seasonExpanded = false.obs;
  RxBool dietTypeExpanded = false.obs;
  RxBool allergensExpanded = false.obs;

  // Multi select filter states
  RxList<String> selectedMealTypes = <String>[].obs;
  RxList<String> selectedRecipeComponents = <String>[].obs;
  RxList<String> selectedCookingModes = <String>[].obs;
  RxList<String> selectedFlavors = <String>[].obs;
  RxList<String> selectedCuisines = <String>[].obs;
  RxList<String> selectedSeasons = <String>[].obs;
  RxList<String> selectedDietTypes = <String>[].obs;
  RxList<String> selectedAllergens = <String>[].obs;

  // Search results
  var searchResults = <RecipeRecipeSearchModel>[].obs;
  var isLoading = false.obs;
  var hasSearched = false.obs;
  var totalResults = 0.obs;

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void toggleItem(RxList<String> list, String item) {
    if (list.contains(item)) {
      list.remove(item);
    } else {
      list.add(item);
    }
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
  }

  /// Apply filters and search
  Future<void> applyFilters() async {
    try {
      isLoading.value = true;
      hasSearched.value = true;

      print("🔍 Applying filters...");

      final response = await SearchFilterService.searchRecipesWithFilters(
        searchQuery: searchController.text.trim().isEmpty ? null : searchController.text.trim(),
        mealTypes: selectedMealTypes.isEmpty ? null : selectedMealTypes,
        recipeComponents: selectedRecipeComponents.isEmpty ? null : selectedRecipeComponents,
        cookingModes: selectedCookingModes.isEmpty ? null : selectedCookingModes,
        flavorProfiles: selectedFlavors.isEmpty ? null : selectedFlavors,
        cuisines: selectedCuisines.isEmpty ? null : selectedCuisines,
        seasons: selectedSeasons.isEmpty ? null : selectedSeasons,
        dietTypes: selectedDietTypes.isEmpty ? null : selectedDietTypes,
        allergens: selectedAllergens.isEmpty ? null : selectedAllergens,
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> recipesJson = response['data'];
        
        searchResults.value = recipesJson
            .map((json) => RecipeRecipeSearchModel.fromJson(json))
            .toList();

        if (response['meta'] != null) {
          totalResults.value = response['meta']['totalDocument'] ?? 0;
        }

        print("✅ Found ${searchResults.length} recipes");
      }
    } catch (e) {
      print("❌ Filter error: $e");
      Get.snackbar(
        'Error'.tr,
        'Failed to search recipes',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear all filters
  void clearAllFilters() {
    searchController.clear();
    searchQuery.value = '';
    selectedMealTypes.clear();
    selectedRecipeComponents.clear();
    selectedCookingModes.clear();
    selectedFlavors.clear();
    selectedCuisines.clear();
    selectedSeasons.clear();
    selectedDietTypes.clear();
    selectedAllergens.clear();
    searchResults.clear();
    hasSearched.value = false;
  }

  /// Check if any filter is selected
  bool hasActiveFilters() {
    return searchController.text.trim().isNotEmpty ||
        selectedMealTypes.isNotEmpty ||
        selectedRecipeComponents.isNotEmpty ||
        selectedCookingModes.isNotEmpty ||
        selectedFlavors.isNotEmpty ||
        selectedCuisines.isNotEmpty ||
        selectedSeasons.isNotEmpty ||
        selectedDietTypes.isNotEmpty ||
        selectedAllergens.isNotEmpty;
  }
}
