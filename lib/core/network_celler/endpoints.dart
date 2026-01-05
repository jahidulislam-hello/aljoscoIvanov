class Urls {
  static const String baseUrl = 'https://ibrahim8000.sobhoy.com/api/v1';
  static const String imageBaseUrl = "https://rakib6590.sobhoy.com";
  static const String pictureUrl = 'https://argentoba.s3.us-east-2.amazonaws.com';

  // Profile endpoints
  static const String getMyProfile = '$baseUrl/auth/get-my-profile';
  static const String getUserRecipes = '$baseUrl/user-recipe/get-recipes';
  static const String updateProfile = '$baseUrl/auth/update-profile';

  // Recipe endpoints
  static const String getAllRecipes = '$baseUrl/recipe/get-all-recipe';
}