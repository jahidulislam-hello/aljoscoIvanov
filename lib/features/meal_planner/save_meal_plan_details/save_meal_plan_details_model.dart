// ================= MODEL =================
class MealItemModel {
  final String mealType; // Breakfast, Lunch, Dinner
  final String title;
  final String servings;

  MealItemModel({
    required this.mealType,
    required this.title,
    required this.servings,
  });
}

class DailyMealPlanModel {
  final String date;
  final List<MealItemModel> meals;

  DailyMealPlanModel({required this.date, required this.meals});
}