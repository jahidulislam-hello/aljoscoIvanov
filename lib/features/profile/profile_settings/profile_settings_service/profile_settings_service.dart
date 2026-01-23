import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/core/network_celler/http_client.dart';

class ProfileSettingsService {
  static Future<Map<String, dynamic>> getMyProfile() async {
    try {
      print('📤 Fetching profile for settings...');

      final response = await HttpClient.get(
        Uri.parse(Urls.getMyProfile),
      );

      print('📥 Profile settings response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('✅ Profile retrieved successfully for settings');
          return responseData;
        } else {
          throw Exception("${responseData['message']}");
        }
      } else {
        throw Exception("Failed to fetch profile with status: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Error fetching profile for settings: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String phoneNumber,
    String? profileImagePath,
  }) async {
    try {
      print('📤 Updating profile...');

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(Urls.updateProfile),
      );

      request.headers['Content-Type'] = 'multipart/form-data';

      // Add text fields
      request.fields['fullName'] = fullName;
      request.fields['phoneNumber'] = phoneNumber;

      // Add profile image if provided
      if (profileImagePath != null && profileImagePath.isNotEmpty) {
        if (!profileImagePath.startsWith('http')) {
          var multipartFile = await http.MultipartFile.fromPath(
            'profileImage',
            profileImagePath,
          );
          request.files.add(multipartFile);
          print('📸 Adding profile image to request');
        }
      }

      print('📤 Sending update request with: fullName=$fullName, phone=$phoneNumber');

      final streamedResponse = await HttpClient.sendMultipart(request);
      final response = await http.Response.fromStream(streamedResponse);

      print('📥 Update profile response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('✅ Profile updated successfully');

          // Save new token if provided
          if (responseData['data'] != null && responseData['data'] is String) {
            final newToken = responseData['data'];
            await SharedPreferencesHelper.saveToken(newToken);
            print('✅ New token saved');
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
