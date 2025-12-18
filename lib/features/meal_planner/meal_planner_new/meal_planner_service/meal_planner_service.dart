import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

class MealPlannerService {
  /// Get all recipes
  static Future<Map<String, dynamic>> getAllRecipes() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final response = await http.get(
        Uri.parse("${Urls.baseUrl}/recipe/get-all-recipe"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      print("📥 Get all recipes response: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load recipes");
      }
    } catch (e) {
      print("❌ Get recipes error: $e");
      rethrow;
    }
  }

  /// Create meal plan
  static Future<Map<String, dynamic>> createMealPlan({
    required String recipeId,
    required Map<String, dynamic> prepList,
    required List<Map<String, dynamic>> meals,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      final body = {
        "recipes": recipeId,
        "prepList": prepList,
        "meals": meals,
      };

      print("📤 CREATE MEAL PLAN REQUEST:");
      print("   Endpoint: ${Urls.baseUrl}/mealplan/create-meal");
      print("   Recipe ID: $recipeId");
      print("   PrepList Date: ${prepList['date']}");
      print("   PrepList Serving: ${prepList['serving']}");
      print("   PrepList Cooker: ${prepList['cooker']}");
      print("   Meals Count: ${meals.length}");
      for (var i = 0; i < meals.length; i++) {
        print("   Meal ${i + 1}: ${meals[i]['meal_time']} on ${meals[i]['date']} (${meals[i]['serving']} servings)");
      }

      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/mealplan/create-meal"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("📥 CREATE MEAL PLAN RESPONSE:");
      print("   Status Code: ${response.statusCode}");
      print("   Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print("✅ API returned success");
        } else {
          print("⚠️ API returned status 200/201 but success=false");
        }
        return responseData;
      } else {
        print("❌ API returned error status: ${response.statusCode}");
        final errorResponse = jsonDecode(response.body);
        print("   Error Message: ${errorResponse['message']}");
        throw Exception("Failed to create meal plan: ${errorResponse['message']}");
      }
    } catch (e) {
      print("❌ Create meal plan error: $e");
      rethrow;
    }
  }

  /// Get all meal plans (no date filter) - NOT SUPPORTED BY BACKEND
  /// The backend has corrupted data causing "Invalid Date" errors
  /// This method is disabled - use getMealPlan(date) for specific dates instead
  static Future<Map<String, dynamic>> getAllMealPlans() async {
    // Backend has corrupted date data that causes "Invalid Date" errors
    // when trying to fetch all meal plans. Throwing exception to trigger
    // fallback to date-specific fetching.
    throw Exception("Get all meal plans endpoint has backend data issues - use date-specific queries instead");
  }

  /// Get meal plan for a specific date
  /// Uses POST with ISO 8601 date in body as per API documentation
  static Future<Map<String, dynamic>> getMealPlan(String date) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      // Format date as ISO 8601 with time at 8:00 AM UTC (as per API example: "2025-11-15T08:00:00.000Z")
      final parsedDate = DateTime.parse(date);
      final formattedDate = DateTime.utc(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        8, 0, 0
      ).toIso8601String();

      final requestBody = {"date": formattedDate};

      print("📤 Fetching meal plan with POST request");
      print("   URL: ${Urls.baseUrl}/mealplan/get-meal-plan");
      print("   Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse("${Urls.baseUrl}/mealplan/get-meal-plan"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(requestBody),
      );

      print("📥 Get meal plan response (${response.statusCode}): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Sort data by date (ascending - oldest first)
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> mealPlans = responseData['data'];
          mealPlans.sort((a, b) {
            try {
              final dateA = DateTime.parse(a['date'] ?? '');
              final dateB = DateTime.parse(b['date'] ?? '');
              return dateA.compareTo(dateB);
            } catch (e) {
              return 0;
            }
          });
          responseData['data'] = mealPlans;
          print("✅ Found ${mealPlans.length} meal plans for $formattedDate");
        }

        return responseData;
      } else {
        throw Exception("Failed to load meal plan");
      }
    } catch (e) {
      print("❌ Get meal plan error: $e");
      rethrow;
    }
  }

  /// Get prep list
  static Future<Map<String, dynamic>> getPrepList(String date) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      // Format date as YYYY-MM-DD for query parameter
      final parsedDate = DateTime.parse(date);
      final formattedDate = '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';

      print("📤 Fetching prep list with GET query: ?date=$formattedDate");

      final response = await http.get(
        Uri.parse("${Urls.baseUrl}/preplist/get-preplist?date=$formattedDate"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      print("📥 Get prep list response (${response.statusCode}): ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Sort recipes within prep list if available
        if (responseData['success'] == true &&
            responseData['data'] != null &&
            responseData['data']['recipes'] != null) {
          final List<dynamic> recipes = responseData['data']['recipes'];
          // Sort recipes by any available criteria (e.g., recipeId or isDone status)
          recipes.sort((a, b) {
            // Prioritize incomplete items first
            final isDoneA = a['isDone'] ?? false;
            final isDoneB = b['isDone'] ?? false;
            return isDoneA == isDoneB ? 0 : (isDoneA ? 1 : -1);
          });
          responseData['data']['recipes'] = recipes;
          print("✅ Sorted ${recipes.length} recipes in prep list (incomplete first)");
        }

        return responseData;
      } else {
        throw Exception("Failed to load prep list");
      }
    } catch (e) {
      print("❌ Get prep list error: $e");
      rethrow;
    }
  }

}
