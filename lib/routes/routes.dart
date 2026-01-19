import 'package:freshbite/core/navbar/navbar/navbar_screen.dart';
import 'package:freshbite/features/auth/sign_in/signin_screen/signin_screen.dart';
import 'package:freshbite/features/auth/sign_up/signUp_screen/signUp_screen.dart';
import 'package:freshbite/features/home/home_new/screen/recipe_screen.dart';
import 'package:freshbite/features/new/controller/new_recipe_controller.dart';
import 'package:freshbite/features/new/screen/new_recipe.dart';
import 'package:freshbite/features/recepies/cooking/cooking_details_screen/cooking_details_screen.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_controller/recipes_details_controller.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_screen/recipes_details_screen.dart' hide NewRecipeDetailScreen;
import 'package:freshbite/features/splash/onboarding/onboarding_screen/onboarding_screen.dart';
import 'package:freshbite/features/splash/splash/splash_screen/spalsh_screen.dart';
import 'package:get/get.dart';




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
  static String recipesDetailsRecipeScreen = '/recipesDetailsRecipeScreen';


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
  static String getRecipesDetailsRecipeScreen() => recipesDetailsRecipeScreen;




  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: signInScreen, page: () => LoginScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: bottomNavbar, page: () =>  BottomNavbar()),
    GetPage(name: homeScreen, page: () => RecipeDetailScreen()),
    GetPage(name: recipeDetailScreen, page: () => CookingDetailsScreen()),
    GetPage(
      name: newRecipeDetailScreen,
      page: () {
        final controller = Get.put(NewRecipeDetailController());
        return NewRecipeDetailScreen(recipe: controller.recipe);
      },
    ),
    GetPage(
      name: recipesDetailsRecipeScreen,
      page: () {
        Get.put(RecipesDetailsRecipeController());
        return const RecipesDetailsRecipeScreen();
      },
    ),
  ];
}