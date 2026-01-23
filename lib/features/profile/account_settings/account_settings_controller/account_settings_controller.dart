
import 'package:get/get.dart';



class SettingsProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxString profileImage = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchUserProfile();
  }

  // Future<void> fetchUserProfile() async {
  //   isLoading.value = true;
  //
  //   final token = await SharedPreferencesHelper.getAccessToken();
  //   if (token == null || isTokenExpired(token)) {
  //     debugPrint("❌ Token expired. Please log in again.");
  //     isLoading.value = false;
  //     return;
  //   }
  //
  //   try {
  //     final response = await http.get(
  //       Uri.parse('${Urls.baseUrl}/users/profile/me'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body)['data'];
  //
  //       final fullName = data['profile']['fullName'] ?? '';
  //       final names = fullName.split(' ');
  //       firstName.value = names.isNotEmpty ? names.first : '';
  //       lastName.value = names.length > 1 ? names.sublist(1).join(' ') : '';
  //       email.value = data['email'] ?? '';
  //
  //       profileImage.value =
  //           data['profile']['profileImage'] ?? 'https://i.pravatar.cc/150?img=3';
  //
  //       debugPrint("✅ Profile fetched: $firstName $lastName, $email");
  //     } else {
  //       debugPrint("❌ Failed to fetch profile: ${response.body}");
  //     }
  //   } catch (e) {
  //     debugPrint("❌ Profile fetch exception: $e");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  String dataUserId() {
    return "user_id_here"; // Replace later with real ID
  }

  bool isTokenExpired(String token) {
    return false; // Implement later
  }
}