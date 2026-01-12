import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';

class ShoppingService {
  /// Get all shopping lists for the current user
  static Future<Map<String, dynamic>> getMyShoppingLists() async {
    try {
      debugPrint('📤 Fetching my shopping lists...');

      final response = await HttpClient.get(
        Uri.parse('${Urls.baseUrl}/shopping/get-my-shopping-lists'),
      );

      debugPrint('📥 Get shopping lists response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          debugPrint('✅ Shopping lists retrieved successfully');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch shopping lists');
        }
      } else {
        throw Exception('Failed to fetch shopping lists with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching shopping lists: $e');
      rethrow;
    }
  }

  /// Get single shopping list by ID
  static Future<Map<String, dynamic>> getSingleShoppingList(String id) async {
    try {
      debugPrint('📤 Fetching shopping list: $id');

      final response = await HttpClient.get(
        Uri.parse('${Urls.baseUrl}/shopping/get-single-shopping-list/$id'),
      );

      debugPrint('📥 Get single shopping list response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          debugPrint('✅ Shopping list retrieved successfully');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch shopping list');
        }
      } else {
        throw Exception('Failed to fetch shopping list with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching shopping list: $e');
      rethrow;
    }
  }

  /// Get all prep lists for the current user
  static Future<Map<String, dynamic>> getAllPrepLists() async {
    try {
      debugPrint('📤 Fetching all prep lists...');

      final response = await HttpClient.get(
        Uri.parse('${Urls.baseUrl}/preplist/get-prepList'),
      );

      debugPrint('📥 Get all prep lists response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          debugPrint('✅ Prep lists retrieved successfully');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch prep lists');
        }
      } else {
        throw Exception('Failed to fetch prep lists with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching prep lists: $e');
      rethrow;
    }
  }

  /// Get grocery list with full recipe details
  static Future<Map<String, dynamic>> getGroceryList() async {
    try {
      debugPrint('📤 Fetching grocery list...');

      final response = await HttpClient.get(
        Uri.parse('${Urls.baseUrl}/grocery/get-grocery'),
      );

      debugPrint('📥 Get grocery list response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          debugPrint('✅ Grocery list retrieved successfully');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch grocery list');
        }
      } else {
        throw Exception('Failed to fetch grocery list with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching grocery list: $e');
      rethrow;
    }
  }

  /// Get prep list for a specific date
  static Future<Map<String, dynamic>> getPrepList({String? date}) async {
    try {
      debugPrint('📤 Fetching prep list...');

      String url = '${Urls.baseUrl}/preplist/get-prepList';
      if (date != null) {
        url += '?date=$date';
      }

      final response = await HttpClient.get(Uri.parse(url));

      debugPrint('📥 Get prep list response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          debugPrint('✅ Prep list retrieved successfully');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to fetch prep list');
        }
      } else {
        throw Exception('Failed to fetch prep list with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching prep list: $e');
      rethrow;
    }
  }

  /// Create custom shopping list
  static Future<Map<String, dynamic>> createShoppingList({
    required String title,
    required String description,
    required String date,
    required List<Map<String, dynamic>> list,
    required String coocker,
    File? coverImage,
  }) async {
    try {
      debugPrint('📤 Creating shopping list...');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Urls.baseUrl}/shopping/create-shopping-list'),
      );

      // Add form fields
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['date'] = date;
      request.fields['coocker'] = coocker;
      request.fields['list'] = jsonEncode(list);

      // Add cover image if provided
      if (coverImage != null && await coverImage.exists()) {
        var stream = http.ByteStream(coverImage.openRead());
        var length = await coverImage.length();
        var multipartFile = http.MultipartFile(
          'coverImage',
          stream,
          length,
          filename: coverImage.path.split('/').last,
        );
        request.files.add(multipartFile);
        debugPrint('📎 Cover image attached: ${coverImage.path}');
      }

      debugPrint('📤 Sending create shopping list request...');
      var streamedResponse = await HttpClient.sendMultipart(request);
      var response = await http.Response.fromStream(streamedResponse);

      debugPrint('📥 Create shopping list response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          debugPrint('✅ Shopping list created successfully');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to create shopping list');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create shopping list');
      }
    } catch (e) {
      debugPrint('❌ Error creating shopping list: $e');
      rethrow;
    }
  }

  /// Update shopping list (mark as done/undone)
  static Future<Map<String, dynamic>> updateShoppingList({
    required String id,
    required bool isDone,
  }) async {
    try {
      debugPrint('📤 Updating shopping list: $id');

      final response = await HttpClient.patch(
        Uri.parse('${Urls.baseUrl}/shopping/update-shopping-list/$id'),
        body: jsonEncode({'isDone': isDone}),
      );

      debugPrint('📥 Update shopping list response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          debugPrint('✅ Shopping list updated successfully');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to update shopping list');
        }
      } else {
        throw Exception('Failed to update shopping list with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error updating shopping list: $e');
      rethrow;
    }
  }

  /// Create grocery list
  static Future<Map<String, dynamic>> createGroceryList({
    required String date,
    required List<String> recipeIds,
  }) async {
    try {
      debugPrint('📤 Creating grocery list...');

      final response = await HttpClient.post(
        Uri.parse('${Urls.baseUrl}/grocery/create-grocery'),
        body: jsonEncode({
          'date': date,
          'recipes': recipeIds,
        }),
      );

      debugPrint('📥 Create grocery list response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          debugPrint('✅ Grocery list created successfully');
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to create grocery list');
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create grocery list');
      }
    } catch (e) {
      debugPrint('❌ Error creating grocery list: $e');
      rethrow;
    }
  }
}
