class RecipeDetailsModel {
  final String title;
  final String description;
  final String image;
  final double rating;
  final List<String> gallery;
  final List<Map<String, String>> ingredients;
  final String totalTime;
  final String prepTime;
  final String cookTime;
  final String instructionVideo;
  final List<String> instructions;

  RecipeDetailsModel({
    required this.title,
    required this.description,
    required this.image,
    required this.rating,
    required this.gallery,
    required this.ingredients,
    required this.totalTime,
    required this.prepTime,
    required this.cookTime,
    required this.instructionVideo,
    required this.instructions,
  });
}
