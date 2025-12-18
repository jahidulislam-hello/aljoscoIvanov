import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

class RecipesSearchService {
  /// Get all recipes
  static Future<Map<String, dynamic>> getAllRecipes() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      print("📤 Fetching all recipes from API...");

      final response = await http.get(
        Uri.parse("${Urls.baseUrl}/recipe/get-all-recipe"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      print("📥 Get all recipes response (${response.statusCode})");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          print("✅ Fetched ${(responseData['data'] as List).length} recipes");
          return responseData;
        } else {
          throw Exception("Failed to load recipes: ${responseData['message']}");
        }
      } else {
        throw Exception("Failed to load recipes");
      }
    } catch (e) {
      print("❌ Get recipes error: $e");
      rethrow;
    }
  }

  /// Toggle favorite status for a recipe
  static Future<bool> toggleFavoriteRecipe(String recipeId, bool isFavorite) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      // TODO: Update with actual endpoint when available
      print("📤 Toggling favorite for recipe: $recipeId to $isFavorite");

      // Placeholder - replace with actual API call
      // final response = await http.post(
      //   Uri.parse("${Urls.baseUrl}/recipe/toggle-favorite"),
      //   headers: {
      //     "Content-Type": "application/json",
      //     if (token != null) "Authorization": "Bearer $token",
      //   },
      //   body: jsonEncode({
      //     "recipeId": recipeId,
      //     "isFavorite": isFavorite,
      //   }),
      // );

      return true; // Return success for now
    } catch (e) {
      print("❌ Toggle favorite error: $e");
      return false;
    }
  }
}
