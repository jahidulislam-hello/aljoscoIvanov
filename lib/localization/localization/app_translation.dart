import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'language_title': 'Language',
      'LOGIN': 'Login',
      'SIGN UP': 'Sign Up',
      'Continue as Guest': 'Continue as Guest',
      'or': 'or',
      'Wellcome to FreshBite !': 'Welcome to FreshBite !',
      'Log in to start cooking!': 'Log in to start cooking!',
    },
    'de_DE': {
      'language_title': 'Sprache',
      'LOGIN': 'Anmelden',
      'SIGN UP': 'Registrieren',
      'Continue as Guest': 'Als Gast fortfahren',
      'or': 'oder',
      'Wellcome to FreshBite !': 'Willkommen bei FreshBite !',
      'Log in to start cooking!': 'Melden Sie sich an, um mit dem Kochen zu beginnen!',
    },
  };
}
