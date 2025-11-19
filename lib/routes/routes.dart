import 'package:freshbite/core/navbar/navbar/navbar_screen.dart';
import 'package:freshbite/features/auth/sign_in/signin_screen/signin_screen.dart';
import 'package:freshbite/features/home/favourites/favourites_screen/favourite_screen.dart';
import 'package:freshbite/features/home/home_new/screen/cooking_screen.dart';
import 'package:freshbite/features/home/home_new/screen/recipe_screen.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_screen/home_recepies_screen.dart';
import 'package:freshbite/features/home/recipe_search/recipe_search_screen/receipe_search_screen.dart';
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_screen/reused_meal_plan_screen.dart';
import 'package:freshbite/features/profile/profile/profile_screen/profile_screen.dart';
import 'package:freshbite/features/profile/profile_settings/profile_settings_screen/profile_settings_screen.dart';
import 'package:freshbite/features/recepies/cooking/cooking_details_screen/cooking_details_screen.dart';
import 'package:freshbite/features/recepies/create_recipes/create_recipes_screen/create_recipes_screen.dart';
import 'package:freshbite/features/splash/splash/splash_screen/spalsh_screen.dart';
import 'package:get/get.dart';

import '../features/profile/settings/settings_screen/settings_screen.dart' show SettingsScreen;





class AppRoute {

  static String splashScreen = '/splashScreen';
  static String signInScreen = '/signInScreen';
  static String signUpScreen = '/signUpScreen';
  static String signScreen = '/signUpScreen';
  static String cookingSkillsScreen = '/cookingSkillsScreen';


  static String getSplashScreen() => splashScreen;
  static String getSignInScreen() => signInScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getScreen() => signInScreen;
  static String getCookingSkillsScreen() => cookingSkillsScreen;


  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () =>  SettingsScreen()),
    // GetPage(name: signInScreen, page: () => SignInScreen()),
    // GetPage(name: signUpScreen, page: () => SignUpScreen()),
    // GetPage(name: signInScreen, page: () => SignInScreen()),

  ];
}