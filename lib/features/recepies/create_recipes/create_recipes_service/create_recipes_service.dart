import 'dart:convert';
import 'dart:io';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:http/http.dart' as http;

class CreateRecipesService {
  /// Create a new recipe with images
  static Future<Map<String, dynamic>> createRecipe({
    required String title,
    required String description,
    required List<String> allergens,
    required List<String> tags,
    required int serving,
    required List<Map<String, dynamic>> ingredients,
    required List<Map<String, dynamic>> nutritionValue,
    required List<String> requiredSkill,
    required List<Map<String, dynamic>> instruction,
    required Map<String, String> time,
    required String cookingMode,
    required List<File> images,
  }) async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      print("📤 Creating recipe...");
      print("   Title: $title");
      print("   Cooking Mode: $cookingMode");
      print("   Images count: ${images.length}");

      // Create multipart request for image upload
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Urls.baseUrl}/recipe/create-recipe"),
      );

      // Add headers
      request.headers['Content-Type'] = 'multipart/form-data';
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add text fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['allergens'] = jsonEncode(allergens);
      request.fields['tags'] = jsonEncode(tags);
      request.fields['serving'] = serving.toString();
      request.fields['ingredients'] = jsonEncode(ingredients);
      request.fields['nutritionValue'] = jsonEncode(nutritionValue);
      request.fields['required_skill'] = jsonEncode(requiredSkill);
      request.fields['instruction'] = jsonEncode(instruction);
      request.fields['time'] = jsonEncode(time);
      request.fields['coocking_mode'] = cookingMode.toLowerCase();

      // Add images
      for (int i = 0; i < images.length; i++) {
        final image = images[i];
        var multipartFile = await http.MultipartFile.fromPath(
          'images',
          image.path,
        );
        request.files.add(multipartFile);
        print("   Added image ${i + 1}: ${image.path.split('/').last}");
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📥 Create recipe response (${response.statusCode})");
      print("   Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print("✅ Recipe created successfully");
          return responseData;
        } else {
          throw Exception("Failed to create recipe: ${responseData['message']}");
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception("Failed to create recipe: ${errorResponse['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print("❌ Create recipe error: $e");
      rethrow;
    }
  }
}
