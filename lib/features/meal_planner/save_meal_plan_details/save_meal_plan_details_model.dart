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
  final String? planTitle;
  final List<MealItemModel> meals;

  DailyMealPlanModel({
    required this.date,
    this.planTitle,
    required this.meals,
  });
}
