import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/core/network_celler/http_client.dart';

class ProfileService {
  static Future<Map<String, dynamic>> getMyProfile() async {
    try {
      print('📤 Fetching user profile...');

      final response = await HttpClient.get(
        Uri.parse(Urls.getMyProfile),
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
      print('📤 Fetching user recipes...');

      final response = await HttpClient.get(
        Uri.parse(Urls.getUserRecipes),
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

  static Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String phoneNumber,
    String? profileImagePath,
  }) async {
    try {
      print('📤 Updating user profile...');

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(Urls.updateProfile),
      );

      // Add form fields
      request.fields['fullName'] = fullName;
      request.fields['phoneNumber'] = phoneNumber;

      // Add profile image if provided
      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        File imageFile = File(profileImagePath);
        if (await imageFile.exists()) {
          var stream = http.ByteStream(imageFile.openRead());
          var length = await imageFile.length();
          var multipartFile = http.MultipartFile(
            'profileImage',
            stream,
            length,
            filename: imageFile.path.split('/').last,
          );
          request.files.add(multipartFile);
          print('📎 Profile image attached: ${imageFile.path}');
        }
      }

      print('📤 Sending update request...');
      var streamedResponse = await HttpClient.sendMultipart(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('📥 Update profile response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('✅ Profile updated successfully');

          // Save new JWT token if provided in response
          if (responseData['data'] is String && responseData['data'].isNotEmpty) {
            final newToken = responseData['data'] as String;
            await SharedPreferencesHelper.saveToken(newToken);
            print('✅ New JWT token saved');
          }

          return responseData;
        } else {
          throw Exception("${responseData['message']}");
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception("${errorData['message'] ?? 'Failed to update profile'}");
      }
    } catch (e) {
      print('❌ Error updating profile: $e');
      rethrow;
    }
  }
}
