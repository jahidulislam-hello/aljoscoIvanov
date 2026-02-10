

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
  String? cooker;

  PreparationItem({
    required this.day,
    required this.servings,
    this.cooker,
  });
}

// ============================================
// API RESPONSE MODELS
// ============================================
class MealPlanApiModel {
  final String id;
  final String userId;
  final String date;
  final int serving;
  final String mealTime;
  final List<dynamic> recipes;
  final List<dynamic> comments;

  MealPlanApiModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.serving,
    required this.mealTime,
    required this.recipes,
    required this.comments,
  });

  factory MealPlanApiModel.fromJson(Map<String, dynamic> json) {
    return MealPlanApiModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] ?? '',
      serving: json['serving'] ?? 0,
      mealTime: json['meal_time'] ?? '',
      recipes: json['recipes'] ?? [],
      comments: json['comments'] ?? [],
    );
  }
}

class PrepListApiModel {
  final String id;
  final String userId;
  final String date;
  final int serving;
  final String cooker;
  final List<PrepListRecipe> recipes;

  PrepListApiModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.serving,
    required this.cooker,
    required this.recipes,
  });

  factory PrepListApiModel.fromJson(Map<String, dynamic> json) {
    return PrepListApiModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] ?? '',
      serving: json['serving'] ?? 0,
      cooker: json['cooker'] ?? '',
      recipes: (json['recipes'] as List?)
              ?.map((r) => PrepListRecipe.fromJson(r))
              .toList() ??
          [],
    );
  }
}

class PrepListRecipe {
  final String? recipeId;
  final String? recipeTitle;
  final String? recipeImage;
  bool isDone;

  PrepListRecipe({
    this.recipeId,
    this.recipeTitle,
    this.recipeImage,
    required this.isDone,
  });

  factory PrepListRecipe.fromJson(Map<String, dynamic> json) {
    // Handle recipeId which can be either a String or a populated Map
    String? id;
    String? title;
    String? image;

    final recipeData = json['recipeId'];
    if (recipeData is String) {
      id = recipeData;
    } else if (recipeData is Map<String, dynamic>) {
      id = recipeData['_id'] ?? '';
      title = recipeData['title'] ?? '';
      if (recipeData['images'] != null && (recipeData['images'] as List).isNotEmpty) {
        image = recipeData['images'][0];
      }
    }

    return PrepListRecipe(
      recipeId: id,
      recipeTitle: title,
      recipeImage: image,
      isDone: json['isDone'] ?? false,
    );
  }
}