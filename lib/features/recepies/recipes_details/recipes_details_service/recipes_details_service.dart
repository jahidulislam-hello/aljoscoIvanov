import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

class RecipesDetailsService {
  /// Get single recipe by ID
  static Future<Map<String, dynamic>> getSingleRecipe(String recipeId) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      print("📤 Fetching recipe details for ID: $recipeId");

      final response = await http.get(
        Uri.parse("${Urls.baseUrl}/recipe/get-single-recipe/$recipeId"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
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
