class MealRecipe {
  final String name;
  final String image;
  final int servings;
  final String addedBy;
  final String date;
  final String note;

  MealRecipe({
    required this.name,
    required this.image,
    required this.servings,
    required this.addedBy,
    required this.date,
    this.note = "",
  });
}
