import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/features/profile/profile/model/profile_recipe_model.dart';
import 'package:freshbite/features/profile/profile/model/user_model.dart';
import 'package:freshbite/features/profile/profile/profile_service/profile_service.dart';
import 'package:freshbite/features/profile/profile_settings/profile_settings_screen/profile_settings_screen.dart';
import 'package:freshbite/features/profile/settings/settings_screen/settings_screen.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxList<ProfileRecipeModel> recipes = <ProfileRecipeModel>[].obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxBool isLoadingProfile = false.obs;
  final RxBool isLoadingRecipes = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
    fetchUserRecipes();
  }

  Future<void> fetchProfileData() async {
    try {
      isLoadingProfile.value = true;
      final response = await ProfileService.getMyProfile();

      if (response['success'] == true && response['data'] != null) {
        user.value = UserModel.fromJson(response['data']);
      }
    } catch (e) {
      print('Error fetching profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingProfile.value = false;
    }
  }

  Future<void> fetchUserRecipes() async {
    try {
      isLoadingRecipes.value = true;
      final response = await ProfileService.getUserRecipes();

      if (response['success'] == true && response['response'] != null) {
        final recipesList = response['response'] as List;
        recipes.value = recipesList
            .map((recipe) => ProfileRecipeModel.fromJson(recipe))
            .toList();
      }
    } catch (e) {
      print('Error fetching recipes: $e');
      Get.snackbar(
        'Error',
        'Failed to load recipes',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingRecipes.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await Future.wait([
      fetchProfileData(),
      fetchUserRecipes(),
    ]);
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }

  void toggleLike(String recipeId) {
    final index = recipes.indexWhere((recipe) => recipe.id == recipeId);
    if (index != -1) {
      recipes[index] = recipes[index].copyWith(
        isLiked: !recipes[index].isLiked,
      );
    }
  }

  void editProfile() {
    // Navigate to edit profile screen
    Get.to(()=> SettingsScreen());
  }

  void changeProfilePicture() {
    // Open image picker
  }

  void openSettings() {
    // Navigate to settings screen
    // Get.toNamed('/settings');
    Get.to(()=> ProfileSettingsScreen());

  }

  void viewRecipe(String recipeId) {
    // Navigate to recipe detail screen
    Get.toNamed('/recipe-detail', arguments: recipeId);
  }
}