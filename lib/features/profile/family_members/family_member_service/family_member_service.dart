import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';

class FamilyMemberService {
  /// GET: Fetch all child accounts
  static Future<Map<String, dynamic>> getChild() async {
    try {
      print('📤 Fetching child accounts...');

      final response = await HttpClient.get(
        Uri.parse(Urls.getChild),
      );

      print('📥 Get child response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('✅ Child accounts retrieved successfully');
          return responseData;
        } else {
          throw Exception("${responseData['message']}");
        }
      } else {
        throw Exception("Failed to fetch child accounts with status: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Error fetching child accounts: $e');
      rethrow;
    }
  }

  /// POST: Create a new child account
  static Future<Map<String, dynamic>> createChild({
    required String email,
    required String password,
  }) async {
    try {
      print('📤 Creating child account...');

      final body = jsonEncode({
        'email': email,
        'password': password,
      });

      final response = await HttpClient.post(
        Uri.parse(Urls.createChild),
        body: body,
      );

      print('📥 Create child response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          print('✅ Child account created successfully');
          return responseData;
        } else {
          throw Exception("${responseData['message']}");
        }
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception("${errorData['message'] ?? 'Failed to create child account'}");
      }
    } catch (e) {
      print('❌ Error creating child account: $e');
      rethrow;
    }
  }
}
