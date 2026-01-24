import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';

class CookingSkillService {
  /// Fetches all cooking skills from the API
  static Future<Map<String, dynamic>> getAllSkills() async {
    try {
      final response = await HttpClient.get(Uri.parse(Urls.getAllSkills));
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to fetch skills: $e',
      };
    }
  }

  /// Fetches a single skill by ID
  static Future<Map<String, dynamic>> getSkillById(String id) async {
    try {
      final response = await HttpClient.get(Uri.parse(Urls.getSkillById(id)));
      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to fetch skill: $e',
      };
    }
  }
}
