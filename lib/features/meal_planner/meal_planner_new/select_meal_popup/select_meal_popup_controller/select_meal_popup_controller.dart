import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_service/meal_planner_service.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/select_meal_popup_model/select_meal_popup_model.dart';
import 'package:get/get.dart';


class SelectMealPopupController extends GetxController {
  var searchQuery = ''.obs;
  var recentFavorites = <SelectMealPopupModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  /// Fetch all recipes from API
  Future<void> fetchRecipes() async {
    try {
      isLoading.value = true;

      final response = await MealPlannerService.getAllRecipes();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> recipesJson = response['data'];

        recentFavorites.value = recipesJson
            .map((json) => SelectMealPopupModel.fromJson(json))
            .toList();

        print("✅ Loaded ${recentFavorites.length} recipes");
      }
    } catch (e) {
      print("❌ Error fetching recipes: $e");
      // Keep empty list on error
      recentFavorites.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

}







