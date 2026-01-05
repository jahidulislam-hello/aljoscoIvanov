import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';

class ProfileService {
  static Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      print('📤 Fetching user profile...');

      final response = await http.get(
        Uri.parse(Urls.getMyProfile),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      print('📥 Profile response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('✅ Profile retrieved successfully');
          return responseData;
        } else {
          throw Exception("${responseData['message']}");
        }
      } else {
        throw Exception("Failed to fetch profile with status: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Error fetching profile: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getUserRecipes() async {
    try {
      final token = await SharedPreferencesHelper.getAccessToken();

      print('📤 Fetching user recipes...');

      final response = await http.get(
        Uri.parse(Urls.getUserRecipes),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      print('📥 User recipes response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('✅ User recipes retrieved successfully');
          return responseData;
        } else {
          throw Exception("${responseData['message']}");
        }
      } else {
        throw Exception("Failed to fetch recipes with status: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Error fetching user recipes: $e');
      rethrow;
    }
  }
}
