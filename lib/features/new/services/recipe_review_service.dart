import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';

class RecipeReviewService {
  /// Add a review/rating to a recipe
  static Future<Map<String, dynamic>> addReview({
    required double rating,
    required String comment,
    required String recipeId,
  }) async {
    try {
      print("📤 Adding review for recipe: $recipeId");

      final response = await HttpClient.post(
        Uri.parse("${Urls.baseUrl}/reviews/add-review"),
        body: jsonEncode({
          "rating": rating,
          "comment": comment,
          "recipeId": recipeId,
        }),
      );

      print("📥 Add review response (${response.statusCode})");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("✅ Review added successfully");
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Failed to add review");
      }
    } catch (e) {
      print("❌ Add review error: $e");
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Add a personal note to a recipe
  static Future<Map<String, dynamic>> addNote({
    required String note,
    required String recipeId,
  }) async {
    try {
      print("📤 Adding note to recipe: $recipeId");

      final response = await HttpClient.patch(
        Uri.parse("${Urls.baseUrl}/recipe/add-note/$recipeId"),
        body: jsonEncode({
          "note": note,
        }),
      );

      print("📥 Add note response (${response.statusCode})");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("✅ Note added successfully");
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Failed to add note");
      }
    } catch (e) {
      print("❌ Add note error: $e");
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}
