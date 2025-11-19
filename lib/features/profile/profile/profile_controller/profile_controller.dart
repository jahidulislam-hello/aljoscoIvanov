import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/features/profile/profile/model/profile_recipe_model.dart';
import 'package:freshbite/features/profile/profile/model/user_model.dart';
import 'package:freshbite/features/profile/profile_settings/profile_settings_screen/profile_settings_screen.dart';
import 'package:freshbite/features/profile/settings/settings_screen/settings_screen.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<UserModel> user = UserModel(
    userId: 'its_cheryl_btw',
    name: 'Hariza Williamson',
    email: 'cherylboss@gmail.com',
    phoneNumber: '+999999999999',
    isPremium: true,
  ).obs;

  final RxList<ProfileRecipeModel> recipes = <ProfileRecipeModel>[
    ProfileRecipeModel(
      id: '1',
      title: 'Red velvet cupcake',
      imageUrl: AppImages.recipeImage1,
      addedDate: DateTime.now().subtract(Duration(days: 7)),
      isLiked: false,
    ),
    ProfileRecipeModel(
      id: '2',
      title: 'Red velvet cupcake',
      imageUrl: AppImages.recipeImage1,
      addedDate: DateTime.now().subtract(Duration(days: 21)),
      isLiked: false,
    ),
    ProfileRecipeModel(
      id: '3',
      title: 'Red velvet cupcake',
      imageUrl: AppImages.recipeImage1,
      addedDate: DateTime.now().subtract(Duration(days: 35)),
      isLiked: false,
    ),
  ].obs;

  final RxInt selectedTabIndex = 0.obs;

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
    Get.toNamed('/edit-profile');
  }

  void changeProfilePicture() {
    // Open image picker
  }

  void openSettings() {
    // Navigate to settings screen
    // Get.toNamed('/settings');
    Get.to(()=>SettingsScreen());

  }

  void viewRecipe(String recipeId) {
    // Navigate to recipe detail screen
    Get.toNamed('/recipe-detail', arguments: recipeId);
  }
}