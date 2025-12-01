

// ============================================
// MODEL CLASS
// ============================================
class Comment {
  final String userName;
  final String date;
  final String message;
  final String? avatarUrl;

  Comment({
    required this.userName,
    required this.date,
    required this.message,
    this.avatarUrl,
  });
}

class MealRecipe {
  final String name;
  final String servings;
  final String? imageUrl;

  MealRecipe({
    required this.name,
    required this.servings,
    this.imageUrl,
  });
}

class MealSection {
  final String id;
  final String title;
  final List<String> tags;
  MealRecipe? recipe;
  final List<Comment> comments;
  bool isExpanded;

  MealSection({
    required this.id,
    required this.title,
    required this.tags,
    this.recipe,
    this.comments = const [],
    this.isExpanded = true,
  });
}

class MealPlanningItem {
  String day;
  String meal;
  String servings;

  MealPlanningItem({
    required this.day,
    required this.meal,
    required this.servings,
  });
}

class PreparationItem {
  String day;
  String servings;

  PreparationItem({
    required this.day,
    required this.servings,
  });
}