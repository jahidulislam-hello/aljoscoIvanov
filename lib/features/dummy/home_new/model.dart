class RecipeModel {
  final String title;
  final String description;
  final List<String> tags;
  final double rating;
  final List<String> allergens;
  final List<Map<String, String>> ingredients;
  final Map<String, String> timeOverview;
  final List<String> skills;
  final List<String> instructions;
  final Map<String, dynamic> nutrition;
  final List<Map<String, String>> notes;

  RecipeModel({
    required this.title,
    required this.description,
    required this.tags,
    required this.rating,
    required this.allergens,
    required this.ingredients,
    required this.timeOverview,
    required this.skills,
    required this.instructions,
    required this.nutrition,
    required this.notes,
  });
}
