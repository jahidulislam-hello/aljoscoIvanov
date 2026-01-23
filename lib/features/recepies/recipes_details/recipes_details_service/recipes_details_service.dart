import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';

class RecipesDetailsService {
  /// Get single recipe by ID
  static Future<Map<String, dynamic>> getSingleRecipe(String recipeId) async {
    try {
      print("📤 Fetching recipe details for ID: $recipeId");

      final response = await HttpClient.get(
        Uri.parse("${Urls.baseUrl}/recipe/get-single-recipe/$recipeId"),
      );

      print("📥 Get single recipe response (${response.statusCode})");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          print("✅ Successfully fetched recipe: ${responseData['data']['title']}");
          return responseData;
        } else {
          throw Exception("Failed to load recipe: ${responseData['message']}");
        }
      } else {
        throw Exception("Failed to load recipe with status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Get recipe details error: $e");
      rethrow;
    }
  }
}
