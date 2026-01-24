import 'package:flutter/material.dart';
import 'package:freshbite/features/home/cooking_skill/cooking_skill_service.dart';
import 'package:freshbite/features/video/instruction_video.dart';
import 'package:get/get.dart';

class CookingSkillController extends GetxController {
  final RxList<SkillData> skills = <SkillData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllSkills();
  }

  /// Fetches all cooking skills from the API
  Future<void> fetchAllSkills() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await CookingSkillService.getAllSkills();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        skills.value = data.map((json) => SkillData.fromJson(json)).toList();
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load skills';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
      debugPrint('Error fetching skills: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches a single skill by ID and navigates to RecipeInstructionsScreen
  Future<void> navigateToSkillDetail(String skillId) async {
    try {
      final response = await CookingSkillService.getSkillById(skillId);

      if (response['success'] == true && response['data'] != null) {
        final skill = SkillData.fromJson(response['data']);
        Get.to(() => RecipeInstructionsScreen(skills: [skill]));
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to load skill details',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      debugPrint('Error fetching skill detail: $e');
      Get.snackbar(
        'Error',
        'An error occurred while loading skill details',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
