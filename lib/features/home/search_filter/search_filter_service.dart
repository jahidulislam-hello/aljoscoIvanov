import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/core/network_celler/http_client.dart';

class SearchFilterService {
  /// Search recipes with filters
  static Future<Map<String, dynamic>> searchRecipesWithFilters({
    String? searchQuery,
    List<String>? mealTypes,
    List<String>? recipeComponents,
    List<String>? cookingModes,
    List<String>? flavorProfiles,
    List<String>? cuisines,
    List<String>? seasons,
    List<String>? dietTypes,
    List<String>? allergens,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      print("📤 Searching recipes with filters...");

      final token = await SharedPreferencesHelper.getAccessToken();

      // Build request body
      final Map<String, dynamic> requestBody = {
        'page': page,
        'limit': limit,
      };

      // Add search query if provided
      if (searchQuery != null && searchQuery.isNotEmpty) {
        requestBody['search'] = searchQuery;
      }

      // Add filters if they have values
      if (mealTypes != null && mealTypes.isNotEmpty) {
        requestBody['mealTypes'] = mealTypes;
      }
      if (recipeComponents != null && recipeComponents.isNotEmpty) {
        requestBody['recipeComponents'] = recipeComponents;
      }
      if (cookingModes != null && cookingModes.isNotEmpty) {
        requestBody['cookingModes'] = cookingModes;
      }
      if (flavorProfiles != null && flavorProfiles.isNotEmpty) {
        requestBody['flavorProfiles'] = flavorProfiles;
      }
      if (cuisines != null && cuisines.isNotEmpty) {
        requestBody['cuisines'] = cuisines;
      }
      if (seasons != null && seasons.isNotEmpty) {
        requestBody['seasons'] = seasons;
      }
      if (dietTypes != null && dietTypes.isNotEmpty) {
        requestBody['dietTypes'] = dietTypes;
      }
      if (allergens != null && allergens.isNotEmpty) {
        requestBody['allergens'] = allergens;
      }

      print("📄 Request body: ${jsonEncode(requestBody)}");

      final response = await HttpClient.post(
        Uri.parse("${Urls.baseUrl}/recipe/search"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      print("📥 Search recipes response (${response.statusCode})");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print("✅ Found ${(responseData['data'] as List).length} recipes");
          return responseData;
        } else {
          throw Exception("Search failed: ${responseData['message']}");
        }
      } else {
        throw Exception("Search failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error: $e");
      rethrow;

    }
  }
}
