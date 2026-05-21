import 'dart:convert';
import 'dart:io';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';
import 'package:http/http.dart' as http;

class CreateRecipesService {
  /// Upload a single image
  /// POST {{baseUrl}}/recipe/single-upload
  static Future<String?> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Urls.baseUrl}/recipe/single-upload"),
      );

      var multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      );
      request.files.add(multipartFile);

      final streamedResponse = await HttpClient.sendMultipart(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['url'];
        }
      }
      print("❌ Image upload failed: ${response.body}");
      return null;
    } catch (e) {
      print("❌ Image upload error: $e");
      return null;
    }
  }

  /// Upload a video
  /// POST {{baseUrl}}/recipe/video-upload
  static Future<String?> uploadVideo(File videoFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Urls.baseUrl}/recipe/video-upload"),
      );

      var multipartFile = await http.MultipartFile.fromPath(
        'video',
        videoFile.path,
      );
      request.files.add(multipartFile);

      final streamedResponse = await HttpClient.sendMultipart(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['url'];
        }
      }
      print("❌ Video upload failed: ${response.body}");
      return null;
    } catch (e) {
      print("❌ Video upload error: $e");
      return null;
    }
  }

  /// Upload multiple images
  /// POST {{baseUrl}}/recipe/multiple-upload
  static Future<List<String>?> uploadMultipleImages(List<File> imageFiles) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Urls.baseUrl}/recipe/multiple-upload"),
      );

      for (var file in imageFiles) {
        var multipartFile = await http.MultipartFile.fromPath(
          'images',
          file.path,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await HttpClient.sendMultipart(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return List<String>.from(data['url']);
        }
      }
      print("❌ Multiple images upload failed: ${response.body}");
      return null;
    } catch (e) {
      print("❌ Multiple images upload error: $e");
      return null;
    }
  }

  /// Create a new recipe with image URLs
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
    required List<String> required_skill,
    required List<Map<String, dynamic>> instruction,
    required Map<String, dynamic> time,
    required List<String> images,
  }) async {
    try {
      // Build JSON payload
      final Map<String, dynamic> payload = {
        'title': title,
        'description': description,
        'allergens': allergens,
        'tags': tags,
        'serving': serving,
        'coocking_mode': cookingMode,
        'ingredients': ingredients,
        'nutritionValue': nutritionValue,
        'required_skill': required_skill,
        'instruction': instruction,
        'time': time,
        'images': images,
      };

      final response = await HttpClient.post(
        Uri.parse("${Urls.baseUrl}/user-recipe/create-recipe"),
        body: jsonEncode(payload),
      );

      print("Create recipe response (${response.statusCode})");
      print("Response body: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['success'] == true) {
          print("✅ Recipe created successfully");
          return responseData;
        } else {
          throw Exception("${responseData['message']}");
        }
      } else {
        throw Exception("${responseData['message'] ?? 'Unknown error'}");
      }
    } catch (e) {
      print("❌ Create recipe error: $e");
      rethrow;
    }
  }
}
