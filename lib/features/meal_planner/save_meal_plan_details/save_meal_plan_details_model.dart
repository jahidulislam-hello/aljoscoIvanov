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

  factory MealItemModel.fromJson(Map<String, dynamic> json) {
    // Get meal type
    String mealType = json['meal_time'] ?? 'Meal';
    // Capitalize first letter
    mealType = mealType[0].toUpperCase() + mealType.substring(1);

    // Get title from recipes
    String title = 'Meal Plan';
    if (json['recipes'] != null && json['recipes'] is List && (json['recipes'] as List).isNotEmpty) {
      final recipe = json['recipes'][0];
      if (recipe is Map) {
        title = recipe['title'] ?? 'Recipe';
      }
    }

    // Get servings
    int serving = json['serving'] ?? 2;

    return MealItemModel(
      mealType: mealType,
      title: title,
      servings: '$serving Servings',
    );
  }
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

  factory DailyMealPlanModel.fromJson(Map<String, dynamic> json) {
    // Format the date
    String formattedDate = '';
    if (json['date'] != null) {
      try {
        final date = DateTime.parse(json['date']);
        final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
        final months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        formattedDate = '${days[date.weekday % 7]} ${date.day}, ${months[date.month - 1]}';
      } catch (e) {
        formattedDate = json['date'] ?? '';
      }
    }

    // Parse meals
    List<MealItemModel> meals = [];
    if (json['meals'] != null && json['meals'] is List) {
      for (var meal in json['meals']) {
        if (meal is Map<String, dynamic>) {
          meals.add(MealItemModel.fromJson(meal));
        }
      }
    }

    return DailyMealPlanModel(
      date: formattedDate,
      planTitle: null,
      meals: meals,
    );
  }
}

/// Full sequence meal details model
class SequenceMealDetailsModel {
  final String id;
  final String title;
  final String description;
  final List<DailyMealPlanModel> plans;

  SequenceMealDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.plans,
  });

  factory SequenceMealDetailsModel.fromJson(Map<String, dynamic> json) {
    List<DailyMealPlanModel> parsedPlans = [];
    if (json['plans'] != null && json['plans'] is List) {
      for (var plan in json['plans']) {
        if (plan is Map<String, dynamic>) {
          parsedPlans.add(DailyMealPlanModel.fromJson(plan));
        }
      }
    }

    return SequenceMealDetailsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      plans: parsedPlans,
    );
  }
}
