import 'package:freshbite/features/splash/splash/splash_screen/spalsh_screen.dart';
import 'package:get/get.dart';



class AppRoute {

  static String splashScreen = '/splashScreen';
  static String signInScreen = '/signInScreen';
  static String signUpScreen = '/signUpScreen';
  static String signScreen = '/signUpScreen';


  static String getSplashScreen() => splashScreen;
  static String getSignInScreen() => signInScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getScreen() => signInScreen;


  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    // GetPage(name: signInScreen, page: () => SignInScreen()),
    // GetPage(name: signUpScreen, page: () => SignUpScreen()),
    // GetPage(name: signInScreen, page: () => SignInScreen()),

  ];
}