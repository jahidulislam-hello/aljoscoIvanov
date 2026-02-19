class PrepListModel {
  final String id;
  final String userId;
  final String date;
  final List<RecipeDetail> recipes;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  PrepListModel({
    required this.id,
    required this.userId,
    required this.date,
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
      recipes: (json['recipes'] as List<dynamic>?)
              ?.map((item) => RecipeDetail.fromJson(item))
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
    final count = recipes.where((r) => !r.isDeleted).length;
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
    final validRecipes = recipes.where((r) => !r.isDeleted).toList();
    if (validRecipes.isEmpty) {
      return "No recipes included";
    }
    // Show actual recipe names
    final recipeNames = validRecipes.map((r) => r.title).take(2).join(", ");
    return validRecipes.length > 2
        ? "$recipeNames, +${validRecipes.length - 2} more"
        : recipeNames;
  }

  // Helper method to get total servings from all recipes
  int getTotalServings() {
    final validRecipes = recipes.where((r) => !r.isDeleted).toList();
    if (validRecipes.isEmpty) {
      return 0;
    }
    return validRecipes.fold<int>(0, (sum, recipe) => sum + recipe.serving);
  }
}

class RecipeDetail {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final List<String> allergens;
  final List<String> tags;
  final int serving;
  final List<Ingredient> ingredients;
  final bool isDeleted;

  RecipeDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.allergens,
    required this.tags,
    required this.serving,
    required this.ingredients,
    this.isDeleted = false,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) {
    return RecipeDetail(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      serving: json['serving'] ?? 0,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((item) => Ingredient.fromJson(item))
              .toList() ??
          [],
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'images': images,
      'allergens': allergens,
      'tags': tags,
      'serving': serving,
      'ingredients': ingredients.map((item) => item.toJson()).toList(),
      'isDeleted': isDeleted,
    };
  }
}

class Ingredient {
  final String name;
  final String unit;
  final String value;
  final String? singleValue;
  final String? categories;
  final String? houseHoldUnit;
  final String? householdValue;
  final String? houseHoldForSingleValue;

  Ingredient({
    required this.name,
    required this.unit,
    required this.value,
    this.singleValue,
    this.categories,
    this.houseHoldUnit,
    this.householdValue,
    this.houseHoldForSingleValue,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      unit: json['unit'] ?? '',
      value: json['value'] ?? '',
      singleValue: json['singleValue'],
      categories: json['categories'],
      houseHoldUnit: json['houseHoldUnit'],
      householdValue: json['householdValue'],
      houseHoldForSingleValue: json['houseHoldForSingleValue'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
      'value': value,
      if (singleValue != null) 'singleValue': singleValue,
      if (categories != null) 'categories': categories,
      if (houseHoldUnit != null) 'houseHoldUnit': houseHoldUnit,
      if (householdValue != null) 'householdValue': householdValue,
      if (houseHoldForSingleValue != null) 'houseHoldForSingleValue': houseHoldForSingleValue,
    };
  }
}
