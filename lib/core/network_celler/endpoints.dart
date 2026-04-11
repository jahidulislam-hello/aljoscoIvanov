class Urls {
  static const String baseUrl = 'https://server.freshbite.ch/api/v1';
  // static const String baseUrl = 'https://ibrahim8000.sobhoy.com/api/v1';
  static const String imageBaseUrl = "https://rakib6590.sobhoy.com";
  static const String pictureUrl = 'https://argentoba.s3.us-east-2.amazonaws.com';

  // Profile endpoints
  static const String getMyProfile = '$baseUrl/auth/get-my-profile';
  static const String getUserRecipes = '$baseUrl/user-recipe/get-recipes';
  static const String updateProfile = '$baseUrl/auth/update-profile';

  // Recipe endpoints
  static const String getAllRecipes = '$baseUrl/recipe/get-all-recipe';
  static const String createUserRecipe = '$baseUrl/user-recipe/create-recipe';

  // Shopping List endpoints
  static const String getMyShoppingLists = '$baseUrl/shopping/get-my-shopping-lists';
  static const String createShoppingList = '$baseUrl/shopping/create-shopping-list';
  static const String getPrepList = '$baseUrl/preplist/get-prepList';

  // Family Member endpoints
  static const String getChild = '$baseUrl/user/get-child';
  static const String createChild = '$baseUrl/user/create-child';

  // Skill endpoints
  static const String getAllSkills = '$baseUrl/skill/get-all-skill';
  static String getSkillById(String id) => '$baseUrl/skill/get-skill/$id';
}