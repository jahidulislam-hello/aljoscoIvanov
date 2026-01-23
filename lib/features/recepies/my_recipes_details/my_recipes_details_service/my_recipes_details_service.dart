import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';


class MyRecipesDetailsService {
  /// Get all user recipes
  static Future<Map<String, dynamic>> getUserRecipes() async {
    try {
      print("📤 Fetching user recipes from API...");

      final response = await HttpClient.get(
        Uri.parse("${Urls.baseUrl}/user-recipe/get-recipes"),
      );

      print("📥 Get user recipes response (${response.statusCode})");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          print("✅ Fetched ${(responseData['response'] as List).length} user recipes");
          return responseData;
        } else {
          throw Exception("Failed to load user recipes: ${responseData['message']}");
        }
      } else {
        throw Exception("Failed to load user recipes with status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Get user recipes error: $e");
      rethrow;
    }
  }

  /// Get single user recipe by ID
  static Future<Map<String, dynamic>> getSingleUserRecipe(String recipeId) async {
    try {
      print("📤 Fetching user recipe details for ID: $recipeId");

      final response = await HttpClient.get(
        Uri.parse("${Urls.baseUrl}/user-recipe/get-recipe/$recipeId"),
      );

      print("📥 Get single user recipe response (${response.statusCode})");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          print("✅ Successfully fetched user recipe: ${responseData['response']['title']}");
          return responseData;
        } else {
          throw Exception("Failed to load user recipe: ${responseData['message']}");
        }
      } else {
        throw Exception("Failed to load user recipe with status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Get user recipe details error: $e");
      rethrow;
    }
  }
}
