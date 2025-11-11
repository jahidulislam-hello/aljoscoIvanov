class CookingDetailsModel {
  final String title;
  final double rating;
  final String description;
  final List<String> tags;
  final List<String> allergensIncluded;
  final List<String> allergensExcluded;
  final List<Ingredient> ingredients;
  final int servings;
  final int totalTime;
  final int prepTime;
  final int cookTime;
  final List<String> images;

  final List<String> skills;
  final List<Instruction> instructions;
  final NutritionInfo nutrition;
  final List<Note> notes;

  CookingDetailsModel({
    required this.title,
    required this.rating,
    required this.description,
    required this.tags,
    required this.allergensIncluded,
    required this.allergensExcluded,
    required this.ingredients,
    required this.servings,
    required this.totalTime,
    required this.prepTime,
    required this.cookTime,
    required this.images,
    required this.skills,
    required this.instructions,
    required this.nutrition,
    required this.notes,
  });
}

class Ingredient {
  final String name;
  final String quantity;

  Ingredient({
    required this.name,
    required this.quantity,
  });
}

class Instruction {
  final int step;
  final String text;

  Instruction({required this.step, required this.text});
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

class Note {
  final String userName;
  final String avatar;
  final String text;
  final String date;

  Note({
    required this.userName,
    required this.avatar,
    required this.text,
    required this.date,
  });
}
