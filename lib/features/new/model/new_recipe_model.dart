class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final Duration prepTime;
  final Duration cookTime;
  final String difficulty;
  final int servings;
  final List<String> allergens;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final NutritionInfo nutritionInfo;
  final List<Review> reviews;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.prepTime,
    required this.cookTime,
    required this.difficulty,
    required this.servings,
    required this.allergens,
    required this.ingredients,
    required this.instructions,
    required this.nutritionInfo,
    required this.reviews,
  });

  Duration get totalTime => prepTime + cookTime;
}

class Ingredient {
  final String name;
  final String quantity;

  Ingredient({
    required this.name,
    required this.quantity,
  });
}

class NutritionInfo {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

class Review {
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.date,
  });
}