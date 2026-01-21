import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_service/meal_planner_service.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/select_meal_popup_model/select_meal_popup_model.dart';
import 'package:get/get.dart';
import 'dart:convert';

class SelectMealPopupController extends GetxController {
  var searchQuery = ''.obs;
  var myRecipes = <SelectMealPopupModel>[].obs;  // For user recipes
  var popularRecipes = <SelectMealPopupModel>[].obs;  // For popular recipes
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyRecipes();  // Fetch user recipes
    fetchPopularRecipes();  // Fetch popular recipes
  }

  /// Fetch user recipes from API
  Future<void> fetchMyRecipes() async {
    try {
      isLoading.value = true;

      final response = await HttpClient.get(
        Uri.parse("${Urls.baseUrl}/user-recipe/get-recipes"),
      );

      print("📥 Get user recipes response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['response'] != null) {
          final List<dynamic> recipesJson = responseData['response'];

          myRecipes.value = recipesJson
              .map((json) => SelectMealPopupModel.fromJson(json))
              .toList();

          print("✅ Loaded ${myRecipes.length} user recipes");
        } else {
          print("⚠️ API returned success=false or no data");
          myRecipes.value = [];
        }
      } else {
        print("❌ API request failed with status: ${response.statusCode}");
        myRecipes.value = [];
      }
    } catch (e) {
      print("❌ Error fetching user recipes: $e");
      // Keep empty list on error
      myRecipes.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch popular recipes from the original API
  Future<void> fetchPopularRecipes() async {
    try {
      isLoading.value = true;

      final response = await MealPlannerService.getAllRecipes();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> recipesJson = response['data'];

        popularRecipes.value = recipesJson
            .map((json) => SelectMealPopupModel.fromJson(json))
            .toList();

        print("✅ Loaded ${popularRecipes.length} popular recipes");
      }
    } catch (e) {
      print("❌ Error fetching popular recipes: $e");
      // Keep empty list on error
      popularRecipes.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

}







