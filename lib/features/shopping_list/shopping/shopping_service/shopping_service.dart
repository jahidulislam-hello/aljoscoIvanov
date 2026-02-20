import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';

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

      final token = await SharedPreferencesHelper.getAccessToken();

      // Log all values before sending
      debugPrint('📋 Request data:');
      debugPrint('   title: "$title"');
      debugPrint('   description: "$description"');
      debugPrint('   date: "$date"');
      debugPrint('   coocker: "$coocker"');
      debugPrint('   list items: ${list.length}');
      debugPrint('   coverImage: ${coverImage?.path ?? "null"}');

      // Get userId from SharedPreferences
      final userId = await SharedPreferencesHelper.getUserId();
      debugPrint('   userId: "$userId"');

      // Process list to ensure all required fields have valid values
      final processedList = list.map((section) {
        final ingredients = (section['ingredient'] as List).map((ing) {
          return {
            'name': ing['name'] ?? '',
            'unit': ing['unit'] ?? 'pcs',
            'value': ing['value'] ?? '1',
            'singleValue': (ing['singleValue'] != null && ing['singleValue'].toString().isNotEmpty)
                ? ing['singleValue']
                : '0.5',
            'categories': (ing['categories'] != null && ing['categories'].toString().isNotEmpty)
                ? ing['categories']
                : 'Convenience',
            'houseHoldUnit': ing['houseHoldUnit'] ?? 'g',
            'householdValue': ing['householdValue'] ?? '100',
            'houseHoldForSingleValue': (ing['houseHoldForSingleValue'] != null && ing['houseHoldForSingleValue'].toString().isNotEmpty)
                ? ing['houseHoldForSingleValue']
                : '50',
          };
        }).toList();

        return {
          'name': section['name'],
          'ingredient': ingredients,
        };
      }).toList();

      // Prepare request body
      final Map<String, dynamic> body = {
        'title': title.isNotEmpty ? title : 'Shopping List',
        'description': description.isNotEmpty ? description : 'My shopping list',
        'date': date,
        'coocker': coocker.isNotEmpty ? coocker : 'me',
        'list': processedList,
        'coverImages': '',  // Empty string when no image
        if (userId != null) 'userId': userId,  // Add userId if available
      };

      // If there's a cover image, use multipart; otherwise use JSON
      if (coverImage != null && await coverImage.exists()) {
        debugPrint('📤 Sending as multipart (with image)...');

        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${Urls.baseUrl}/shopping/create-shopping-list'),
        );

        // Add authorization header
        if (token != null) {
          request.headers['Authorization'] = 'Bearer $token';
        }

        // Add form fields
        request.fields['title'] = body['title'];
        request.fields['description'] = body['description'];
        request.fields['date'] = body['date'];
        request.fields['coocker'] = body['coocker'];
        request.fields['list'] = jsonEncode(body['list']);

        // Add cover image
        String filename = coverImage.path.split('/').last;
        if (filename.contains('\\')) {
          filename = filename.split('\\').last;
        }

        var multipartFile = await http.MultipartFile.fromPath(
          'coverImages',
          coverImage.path,
          filename: filename,
        );
        request.files.add(multipartFile);
        debugPrint('📎 Cover image attached: $filename');

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        debugPrint('📥 Create shopping list response: ${response.statusCode}');
        debugPrint('📥 Response body: ${response.body}');

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
      } else {
        // No image - send as JSON
        debugPrint('📤 Sending as JSON (no image)...');
        debugPrint('📤 Request body: ${jsonEncode(body)}');

        final response = await http.post(
          Uri.parse('${Urls.baseUrl}/shopping/create-shopping-list'),
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );

        debugPrint('📥 Create shopping list response: ${response.statusCode}');
        debugPrint('📥 Response body: ${response.body}');

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
      }
    } catch (e) {
      debugPrint('❌ Error creating shopping list: $e');
      rethrow;
    }
  }

  /// Update shopping list (supports full update or just isDone)
  static Future<Map<String, dynamic>> updateShoppingList({
    required String id,
    bool? isDone,
    String? title,
    String? description,
    String? date,
    List<Map<String, dynamic>>? list,
    String? coocker,
    String? note,
  }) async {
    try {
      debugPrint('📤 Updating shopping list: $id');

      // Build request body with only provided fields
      final Map<String, dynamic> body = {};

      if (isDone != null) body['isDone'] = isDone;
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (date != null) body['date'] = date;
      if (coocker != null) body['coocker'] = coocker;
      if (note != null) body['note'] = note;

      if (list != null) {
        // Process list to ensure all required fields have valid values
        final processedList = list.map((section) {
          final ingredients = (section['ingredient'] as List).map((ing) {
            return {
              'name': ing['name'] ?? '',
              'unit': ing['unit'] ?? 'pcs',
              'value': ing['value'] ?? '1',
              'singleValue': (ing['singleValue'] != null && ing['singleValue'].toString().isNotEmpty)
                  ? ing['singleValue']
                  : '0.5',
              'categories': (ing['categories'] != null && ing['categories'].toString().isNotEmpty)
                  ? ing['categories']
                  : 'Convenience',
              'houseHoldUnit': ing['houseHoldUnit'] ?? 'g',
              'householdValue': ing['householdValue'] ?? '100',
              'houseHoldForSingleValue': (ing['houseHoldForSingleValue'] != null && ing['houseHoldForSingleValue'].toString().isNotEmpty)
                  ? ing['houseHoldForSingleValue']
                  : '50',
            };
          }).toList();

          return {
            'name': section['name'],
            'ingredient': ingredients,
          };
        }).toList();

        body['list'] = processedList;
      }

      debugPrint('📤 Update body: ${jsonEncode(body)}');

      final response = await HttpClient.patch(
        Uri.parse('${Urls.baseUrl}/shopping/update-shopping-list/$id'),
        body: jsonEncode(body),
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
