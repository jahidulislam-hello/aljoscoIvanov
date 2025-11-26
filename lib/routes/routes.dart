import 'package:freshbite/core/navbar/navbar/navbar_screen.dart';
import 'package:freshbite/features/auth/sign_in/signin_screen/signin_screen.dart';
import 'package:freshbite/features/auth/sign_up/signUp_screen/signUp_screen.dart';
import 'package:freshbite/features/home/favourites/favourites_screen/favourite_screen.dart';
import 'package:freshbite/features/home/filter/filter_screen/filter_screen.dart';
import 'package:freshbite/features/home/home_new/screen/cooking_screen.dart';
import 'package:freshbite/features/home/home_new/screen/recipe_screen.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_screen/home_recepies_screen.dart';
import 'package:freshbite/features/home/my_recipes/my_recepies_screen/my_recepies_screen.dart';
import 'package:freshbite/features/home/recipe_search/recipe_search_screen/receipe_search_screen.dart';
import 'package:freshbite/features/meal_planner/meal_planner/meal_planner_screen/meal_planner_screen.dart';
import 'package:freshbite/features/meal_planner/meal_planner_sequence/meal_planner_sequence_screen/meal_planner_sequence_screen.dart';
import 'package:freshbite/features/meal_planner/meal_prepare_date.dart';
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_screen/reused_meal_plan_screen.dart';
import 'package:freshbite/features/meal_planner/save_meal_plan_details/save_meal_plan_details_screen/save_meal_plan_details_screen.dart';
import 'package:freshbite/features/new/controller/new_recipe_controller.dart';
import 'package:freshbite/features/new/screen/new_recipe.dart';
import 'package:freshbite/features/profile/profile/profile_screen/profile_screen.dart';
import 'package:freshbite/features/profile/profile_settings/profile_settings_screen/profile_settings_screen.dart';
import 'package:freshbite/features/recepies/cooking/cooking_details_screen/cooking_details_screen.dart';
import 'package:freshbite/features/recepies/create_recipes/create_recipes_screen/create_recipes_screen.dart';
import 'package:freshbite/features/recepies/details_recipes/details_recipes_screen/details_recipes_screen.dart';
import 'package:freshbite/features/shopping_list/create_shopping/create_shopping_screen/create_shopping_screen.dart';
import 'package:freshbite/features/shopping_list/edit_shopping_list/edit_shopping_list_screen/edit_shopping_list_screen.dart';
import 'package:freshbite/features/shopping_list/select_prep_list/select_prep_list_screen/select_prep_list_screen.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_screen/shopping_screen.dart';
import 'package:freshbite/features/shopping_list/shopping_list/shopping_list_screen/shopping_list_screen.dart';
import 'package:freshbite/features/splash/onboarding/onboarding_screen/onboarding_screen.dart';
import 'package:freshbite/features/splash/splash/splash_screen/spalsh_screen.dart';
import 'package:get/get.dart';
import '../features/profile/settings/settings_screen/settings_screen.dart' show SettingsScreen;






class AppRoute {
  static String splashScreen = '/splashScreen';
  static String onboardingScreen = '/onboardingScreen';
  static String signInScreen = '/signInScreen';
  static String signUpScreen = '/signUpScreen';
  static String signScreen = '/signUpScreen';
  static String cookingSkillsScreen = '/cookingSkillsScreen';
  static String homeScreen = '/homeScreen';
  static String recipeDetailScreen = '/recipeDetailScreen';
  static String newRecipeDetailScreen = '/newRecipeDetailScreen';
  static String bottomNavbar = '/bottomNavbar';

  static String getSplashScreen() => splashScreen;
  static String getOnboardingScreen() => onboardingScreen;
  static String getSignInScreen() => signInScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getScreen() => signInScreen;
  static String getCookingSkillsScreen() => cookingSkillsScreen;
  static String getHomeScreen() => homeScreen;
  static String getRecipeDetailScreen() => recipeDetailScreen;
  static String getNewRecipeDetailScreen() => newRecipeDetailScreen;
  static String getBottomNavbar() => bottomNavbar;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SelectPrepListScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: signInScreen, page: () => LoginScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: bottomNavbar, page: () => const BottomNavbar()),

    // Home screen routes
    GetPage(name: homeScreen, page: () => RecipeDetailScreen()),
    GetPage(name: recipeDetailScreen, page: () => CookingDetailsScreen()),

    // New recipe detail screen route with proper controller instantiation
    GetPage(
      name: newRecipeDetailScreen,
      page: () {
        final controller = Get.put(NewRecipeDetailController());
        return NewRecipeDetailScreen(recipe: controller.recipe);
      },
    ),
  ];
}