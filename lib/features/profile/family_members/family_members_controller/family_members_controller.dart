import 'package:freshbite/features/profile/family_members/family_member_model.dart';
import 'package:freshbite/features/profile/family_members/family_member_service/family_member_service.dart';
import 'package:get/get.dart';

class FamilyMemberController extends GetxController {
  var members = <FamilyMemberModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMembers();
  }

  /// Fetch all child accounts from API
  Future<void> fetchMembers() async {
    try {
      isLoading.value = true;

      final response = await FamilyMemberService.getChild();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> childrenData = response['data'] as List<dynamic>;
        members.value = childrenData
            .map((json) => FamilyMemberModel.fromJson(json as Map<String, dynamic>))
            .toList();

        print('✅ Loaded ${members.length} family members');
      }
    } catch (e) {
      print('❌ Error loading family members: $e');
      Get.snackbar(
        'Error',
        'Failed to load family members: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new child account
  Future<bool> createMember({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final response = await FamilyMemberService.createChild(
        email: email,
        password: password,
      );

      if (response['success'] == true) {
        print('✅ Child account created successfully');

        Get.snackbar(
          'Success',
          'Family member added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        // Refresh the list
        await fetchMembers();

        return true;
      }

      return false;
    } catch (e) {
      print('❌ Error creating child account: $e');
      Get.snackbar(
        'Error',
        'Failed to add family member: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
