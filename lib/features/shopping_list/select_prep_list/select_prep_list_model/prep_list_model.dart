class PrepListModel {
  final String id;
  final String userId;
  final String date;
  final int serving;
  final String cooker;
  final List<PrepListRecipe> recipes;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  PrepListModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.serving,
    required this.cooker,
    required this.recipes,
    this.isDeleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrepListModel.fromJson(Map<String, dynamic> json) {
    return PrepListModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] ?? '',
      serving: json['serving'] ?? 0,
      cooker: json['cooker'] ?? '',
      recipes: (json['recipes'] as List<dynamic>?)
              ?.map((item) => PrepListRecipe.fromJson(item))
              .toList() ??
          [],
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'date': date,
      'serving': serving,
      'cooker': cooker,
      'recipes': recipes.map((item) => item.toJson()).toList(),
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Helper method to get formatted date
  String getFormattedDate() {
    try {
      final dateTime = DateTime.parse(date);
      final weekday = _getWeekdayName(dateTime.weekday);
      return "Prep List from $weekday, ${dateTime.day}.${dateTime.month}.${dateTime.year.toString().substring(2)}";
    } catch (e) {
      return "Prep List";
    }
  }

  // Helper method to get weekday name
  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }

  // Helper method to get recipe count text
  String getRecipeCountText() {
    final count = recipes.where((r) => r.recipeId != null).length;
    if (count == 0) {
      return "No recipes";
    } else if (count == 1) {
      return "1 recipe";
    } else {
      return "$count recipes";
    }
  }

  // Helper method to get includes text (for display)
  String getIncludesText() {
    final validRecipes = recipes.where((r) => r.recipeId != null).toList();
    if (validRecipes.isEmpty) {
      return "No recipes included";
    }
    // You can enhance this to show actual recipe names if you fetch recipe details
    return "${validRecipes.length} recipe(s) included";
  }
}

class PrepListRecipe {
  final String? recipeId;
  final bool isDone;

  PrepListRecipe({
    this.recipeId,
    this.isDone = false,
  });

  factory PrepListRecipe.fromJson(Map<String, dynamic> json) {
    return PrepListRecipe(
      recipeId: json['recipeId'],
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'isDone': isDone,
    };
  }
}
