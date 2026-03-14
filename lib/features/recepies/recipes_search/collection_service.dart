import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/core/network_celler/http_client.dart';
import 'package:freshbite/features/recepies/recipes_search/models/collection_model.dart';

class CollectionService {
  /// Get all collections for the user
  static Future<List<CollectionModel>> getCollections() async {
    try {
      print("📤 Fetching all collections from API...");

      final token = await SharedPreferencesHelper.getAccessToken();
      final response = await HttpClient.get(
        Uri.parse("${Urls.baseUrl}/collaction/get-collactions"),
        headers: {
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      print("📥 Get collections response (${response.statusCode})");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final dataList = responseData['data'] as List? ?? [];
          final collections = dataList
              .map((json) => CollectionModel.fromJson(json))
              .toList();
          print("✅ Fetched ${collections.length} collections");
          return collections;
        } else {
          throw Exception("Failed to load collections: ${responseData['message']}");
        }
      } else {
        throw Exception("Failed to load collections");
      }
    } catch (e) {
      print("❌ Get collections error: $e");
      rethrow;
    }
  }

  /// Create a new collection
  static Future<CollectionModel?> createCollection(String collectionName) async {
    try {
      print("📤 Creating new collection: $collectionName");

      final token = await SharedPreferencesHelper.getAccessToken();
      final response = await HttpClient.post(
        Uri.parse("${Urls.baseUrl}/collaction/create-collaction"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "collactionName": collectionName,
        }),
      );

      print("📥 Create collection response (${response.statusCode})");
      print("📄 Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final collection = CollectionModel.fromJson(responseData['data']);
          print("✅ Collection created successfully: $collectionName");
          return collection;
        }
      }
      print("❌ Failed to create collection: ${response.body}");
      return null;
    } catch (e) {
      print("❌ Create collection error: $e");
      return null;
    }
  }

  /// Add recipe to collection
  static Future<bool> addRecipeToCollection({
    required String recipeId,
    required String collectionId,
  }) async {
    try {
      print("📤 Adding recipe $recipeId to collection $collectionId");

      final token = await SharedPreferencesHelper.getAccessToken();
      final response = await HttpClient.patch(
        Uri.parse("${Urls.baseUrl}/collaction/add-recipes"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "recipeId": recipeId,
          "collactionId": collectionId,
        }),
      );

      print("📥 Add recipe to collection response (${response.statusCode})");
      print("📄 Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print("✅ Recipe added to collection successfully");
          return true;
        }
      }
      print("❌ Failed to add recipe to collection: ${response.body}");
      return false;
    } catch (e) {
      print("❌ Add recipe to collection error: $e");
      return false;
    }
  }
}
