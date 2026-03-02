import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

class MealPlannerService {
  /// Get all recipes
  static Future<Map<String, dynamic>> getAllRecipes() async {
    try {
      final response = await HttpClient.get(
        Uri.parse("${Urls.baseUrl}/recipe/get-all-recipe"),
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

      final response = await HttpClient.post(
        Uri.parse("${Urls.baseUrl}/mealplan/create-meal"),
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
  static Future<Map<String, dynamic>> getAllMealPlans() async {
    throw Exception("Get all meal plans endpoint not supported - use getMealPlan(date) instead");
  }

  /// Get meal plan for a specific date using GET with body
  static Future<Map<String, dynamic>> getMealPlan(String date) async {
    try {
      // Format date as ISO 8601 with time 08:00:00 UTC
      final parsedDate = DateTime.parse(date);
      // Use DateTime.utc to create UTC time directly (no conversion needed)
      final formattedDate = DateTime.utc(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        8, 0, 0, // 08:00:00 UTC
      ).toIso8601String();

      final url = "${Urls.baseUrl}/mealplan/get-meal-plan";
      final body = {"date": formattedDate};

      // Get auth token
      final token = await SharedPreferencesHelper.getAccessToken();

      print("═══════════════════════════════════════════");
      print("📤 MEAL PLAN API REQUEST:");
      print("   URL: $url");
      print("   Method: GET (with body)");
      print("   Body: ${jsonEncode(body)}");
      print("   Token: ${token != null ? '${token.substring(0, 20)}...' : 'NULL'}");
      print("═══════════════════════════════════════════");

      // Use http.Request to send GET with body (unusual but supported)
      final request = http.Request('GET', Uri.parse(url));
      request.headers['Content-Type'] = 'application/json';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.body = jsonEncode(body);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📥 Get meal plan response (${response.statusCode})");
      print("📥 Response body: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}...");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> mealPlans = responseData['data'];
          print("✅ Found ${mealPlans.length} meal plans for $formattedDate");

          // Log meal times found
          for (var plan in mealPlans) {
            final mealTime = plan['meal_time'] ?? 'unknown';
            final recipes = plan['recipes'] as List? ?? [];
            final recipeTitle = recipes.isNotEmpty ? (recipes[0]['title'] ?? 'unknown') : 'no recipe';
            print("   - $mealTime: $recipeTitle");
          }
        }

        return responseData;
      } else {
        print("❌ Get meal plan failed: ${response.statusCode}");
        print("   Response: ${response.body}");
        return {
          'success': false,
          'data': [],
          'message': 'Failed to fetch meal plans'
        };
      }
    } catch (e) {
      print("❌ Get meal plan error: $e");
      return {
        'success': false,
        'data': [],
        'message': e.toString()
      };
    }
  }

  /// Add comment to meal plan
  static Future<Map<String, dynamic>> addCommentToMealPlan({
    required String mealPlanId,
    required String comment,
  }) async {
    try {
      print("📤 Adding comment to meal plan: $mealPlanId");
      print("   Comment: $comment");

      final response = await HttpClient.patch(
        Uri.parse("${Urls.baseUrl}/mealplan/commnets-meal-plan/$mealPlanId"),
        body: jsonEncode({
          "comment": comment,
        }),
      );

      print("📥 Add comment response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print("✅ Comment added successfully");
        return responseData;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception("Failed to add comment: ${errorResponse['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print("❌ Add comment error: $e");
      rethrow;
    }
  }

  /// Get single sequence meal details
  static Future<Map<String, dynamic>> getSingleSequenceMeal(String id) async {
    try {
      print("📤 GET SINGLE SEQUENCE MEAL REQUEST:");
      print("   Endpoint: ${Urls.baseUrl}/sequence/get-single-sequence-meal/$id");

      final response = await HttpClient.get(
        Uri.parse("${Urls.baseUrl}/sequence/get-single-sequence-meal/$id"),
      );

      print("📥 GET SINGLE SEQUENCE MEAL RESPONSE:");
      print("   Status Code: ${response.statusCode}");
      print("   Response Body: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}...");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print("✅ Single sequence meal fetched successfully");
        }
        return responseData;
      } else {
        print("❌ API returned error status: ${response.statusCode}");
        throw Exception("Failed to fetch sequence meal details");
      }
    } catch (e) {
      print("❌ Get single sequence meal error: $e");
      rethrow;
    }
  }

  /// Create nested meal (apply multiple saved meal plans)
  static Future<Map<String, dynamic>> createNestedMeal({
    required String title,
    required String description,
    required String date,
    required List<String> mealsId,
  }) async {
    try {
      final body = {
        "title": title,
        "description": description,
        "date": date,
        "mealsId": mealsId,
      };

      print("📤 CREATE NESTED MEAL REQUEST:");
      print("   Endpoint: ${Urls.baseUrl}/sequence/create-nested-meal");
      print("   Title: $title");
      print("   Description: $description");
      print("   Date: $date");
      print("   Meals IDs: $mealsId");

      final response = await HttpClient.post(
        Uri.parse("${Urls.baseUrl}/sequence/create-nested-meal"),
        body: jsonEncode(body),
      );

      print("📥 CREATE NESTED MEAL RESPONSE:");
      print("   Status Code: ${response.statusCode}");
      print("   Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print("✅ Nested meal created successfully");
        }
        return responseData;
      } else {
        print("❌ API returned error status: ${response.statusCode}");
        final errorResponse = jsonDecode(response.body);
        throw Exception("Failed to create nested meal: ${errorResponse['message']}");
      }
    } catch (e) {
      print("❌ Create nested meal error: $e");
      rethrow;
    }
  }

  /// Get saved sequence meals
  static Future<Map<String, dynamic>> getSequenceMeals() async {
    try {
      print("📤 GET SEQUENCE MEALS REQUEST:");
      print("   Endpoint: ${Urls.baseUrl}/sequence/get-sequence-meal");

      final response = await HttpClient.get(
        Uri.parse("${Urls.baseUrl}/sequence/get-sequence-meal"),
      );

      print("📥 GET SEQUENCE MEALS RESPONSE:");
      print("   Status Code: ${response.statusCode}");
      print("   Response Body: ${response.body.substring(0, response.body.length > 500 ? 500 : response.body.length)}...");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print("✅ Sequence meals fetched successfully");
          final data = responseData['data'] as List? ?? [];
          print("   Total saved meal plans: ${data.length}");
        }
        return responseData;
      } else {
        print("❌ API returned error status: ${response.statusCode}");
        throw Exception("Failed to fetch sequence meals");
      }
    } catch (e) {
      print("❌ Get sequence meals error: $e");
      rethrow;
    }
  }

  /// Create sequence meal plan (save meal plan for multiple dates)
  static Future<Map<String, dynamic>> createSequenceMeal({
    required String title,
    required String description,
    required List<Map<String, dynamic>> plans,
  }) async {
    try {
      final body = {
        "title": title,
        "description": description,
        "plans": plans,
      };

      print("📤 CREATE SEQUENCE MEAL REQUEST:");
      print("   Endpoint: ${Urls.baseUrl}/sequence/create-sequence-meal");
      print("   Title: $title");
      print("   Description: $description");
      print("   Plans Count: ${plans.length}");
      for (var i = 0; i < plans.length; i++) {
        print("   Plan ${i + 1}: date=${plans[i]['date']}, meals=${plans[i]['meals']}");
      }

      final response = await HttpClient.post(
        Uri.parse("${Urls.baseUrl}/sequence/create-sequence-meal"),
        body: jsonEncode(body),
      );

      print("📥 CREATE SEQUENCE MEAL RESPONSE:");
      print("   Status Code: ${response.statusCode}");
      print("   Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print("✅ Sequence meal plan created successfully");
        } else {
          print("⚠️ API returned status 200/201 but success=false");
        }
        return responseData;
      } else {
        print("❌ API returned error status: ${response.statusCode}");
        final errorResponse = jsonDecode(response.body);
        print("   Error Message: ${errorResponse['message']}");
        throw Exception("Failed to create sequence meal: ${errorResponse['message']}");
      }
    } catch (e) {
      print("❌ Create sequence meal error: $e");
      rethrow;
    }
  }

  /// Get prep list
  static Future<Map<String, dynamic>> getPrepList(String date) async {
    try {
      // Format date as YYYY-MM-DD for query parameter
      final parsedDate = DateTime.parse(date);
      final formattedDate = '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';

      print("📤 Fetching prep list with GET query: ?date=$formattedDate");

      final response = await HttpClient.get(
        Uri.parse("${Urls.baseUrl}/preplist/get-preplist?date=$formattedDate"),
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
