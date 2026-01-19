import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:http/http.dart' as http;
import 'package:freshbite/core/network_celler/http_client.dart';

class RecipesSearchService {
  /// Get all recipes
  static Future<Map<String, dynamic>> getAllRecipes() async {
    try {
      print("📤 Fetching all recipes from API...");

      final response = await HttpClient.get(
        Uri.parse("${Urls.baseUrl}/recipe/get-all-recipe"),
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

  /// Search recipes with query, page and limit
  static Future<Map<String, dynamic>> searchRecipes({
    required String search,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      print("📤 Searching recipes with query: $search, page: $page, limit: $limit");

      final queryParams = {
        'search': search,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse("${Urls.baseUrl}/recipe/get-all-recipe")
          .replace(queryParameters: queryParams);

      final response = await HttpClient.get(uri);

      print("📥 Search recipes response (${response.statusCode})");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final dataList = responseData['data'] as List? ?? [];
          print("✅ Found ${dataList.length} recipes for search: $search");
          return responseData;
        } else {
          throw Exception("Failed to search recipes: ${responseData['message']}");
        }
      } else {
        throw Exception("Failed to search recipes");
      }
    } catch (e) {
      print("❌ Search recipes error: $e");
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
