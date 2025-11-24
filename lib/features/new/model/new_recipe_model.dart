class Recipe {
  final String id;
  final String title;
  final List<String> titlechip;
  final String description;
  final String imageUrl;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final Duration prepTime;
  final Duration cookTime;
  final int servings;
  final List<String> skills;
  final List<String> allergens;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final NutritionInfo nutritionInfo;
  final List<PersonalNotes> personalNotes;

  Recipe({
    required this.id,
    required this.title,
    required this.titlechip,
    required this.description,
    required this.imageUrl,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.allergens,
    required this.ingredients,
    required this.skills,
    required this.instructions,
    required this.nutritionInfo,
    required this.personalNotes,
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
  final String energy;
  final String fat;
  final String saturated;
  final String carbs;
  final String sugars;
  final String fibre;
  final String protein;
  final String salt;

  NutritionInfo({
    required this.energy,
    required this.fat,
    required this.saturated,
    required this.carbs,
    required this.sugars,
    required this.fibre,
    required this.protein,
    required this.salt,
  });
}

class PersonalNotes {
  final String userName;
  final String userImage;
  final String comment;
  final DateTime date;

  PersonalNotes({
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.date,
  });
}


