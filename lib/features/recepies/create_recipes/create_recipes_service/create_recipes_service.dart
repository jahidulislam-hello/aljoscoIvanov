import 'dart:convert';
import 'dart:io';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

class CreateRecipesService {
  /// Create a new recipe with images
  /// POST {{baseUrl}}/user-recipe/create-recipe
  static Future<Map<String, dynamic>> createRecipe({
    required String title,
    required String description,
    required List<String> allergens,
    required List<String> tags,
    required int serving,
    required String cookingMode,
    required List<Map<String, dynamic>> ingredients,
    required List<Map<String, dynamic>> nutritionValue,
    required List<String> requiredSkill,
    required List<Map<String, dynamic>> instruction,
    required Map<String, String> time,
    required List<File> images,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      print("======================================");
      print("Creating recipe...");
      print("Title: $title");
      print("Description: $description");
      print("Cooking Mode: $cookingMode");
      print("Serving: $serving");
      print("Allergens: $allergens");
      print("Tags: $tags");
      print("Ingredients: $ingredients");
      print("Nutrition Value: $nutritionValue");
      print("Required Skill: $requiredSkill");
      print("Instructions: $instruction");
      print("Time: $time");
      print("Images count: ${images.length}");
      print("======================================");

      // Create multipart request for image upload
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Urls.baseUrl}/user-recipe/create-recipe"),
      );

      // Add headers
      request.headers['Content-Type'] = 'multipart/form-data';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add text fields matching the API structure
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['allergens'] = jsonEncode(allergens);
      request.fields['tags'] = jsonEncode(tags);
      request.fields['serving'] = serving.toString();
      request.fields['coocking_mode'] = cookingMode;
      request.fields['ingredients'] = jsonEncode(ingredients);
      request.fields['nutritionValue'] = jsonEncode(nutritionValue);
      request.fields['required_skill'] = jsonEncode(requiredSkill);
      request.fields['instruction'] = jsonEncode(instruction);
      request.fields['time'] = jsonEncode(time);

      // Add images
      for (int i = 0; i < images.length; i++) {
        final image = images[i];
        var multipartFile = await http.MultipartFile.fromPath(
          'images',
          image.path,
        );
        request.files.add(multipartFile);
        print("Added image ${i + 1}: ${image.path.split('/').last}");
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Create recipe response (${response.statusCode})");
      print("Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print("✅ Recipe created successfully");
          return responseData;
        } else {
          print("❌ Failed to create recipe: ${responseData['message']}");
          throw Exception("Failed to create recipe: ${responseData['message']}");
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        print("❌ Failed to create recipe: ${errorResponse['message'] ?? 'Unknown error'}");
        throw Exception("Failed to create recipe: ${errorResponse['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print("❌ Create recipe error: $e");
      rethrow;
    }
  }
}
