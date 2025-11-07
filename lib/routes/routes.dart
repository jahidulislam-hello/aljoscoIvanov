import 'package:freshbite/core/navbar/navbar/navbar_screen.dart';
import 'package:freshbite/features/home/home_new/screen/cooking_screen.dart';
import 'package:freshbite/features/home/home_new/screen/recipe_screen.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_screen/home_recepies_screen.dart';
import 'package:freshbite/features/splash/splash/splash_screen/spalsh_screen.dart';
import 'package:get/get.dart';

import '../features/auth/sign_up/signup_screen/signup_screen.dart';



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
    GetPage(name: splashScreen, page: () => SignUpScreen()),
    // GetPage(name: signInScreen, page: () => SignInScreen()),
    // GetPage(name: signUpScreen, page: () => SignUpScreen()),
    // GetPage(name: signInScreen, page: () => SignInScreen()),

  ];
}