class ShoppingModel {
  final String id;
  final String title;
  final String description;
  final String coverImage;
  final String coocker;
  final String date;
  final bool isDone;
  final List<ShoppingListItem> list;
  final String userId;
  final String createdAt;

  ShoppingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.coocker,
    required this.date,
    this.isDone = false,
    required this.list,
    required this.userId,
    required this.createdAt,
  });

  factory ShoppingModel.fromJson(Map<String, dynamic> json) {
    return ShoppingModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImages'] ?? '',
      coocker: json['coocker'] ?? '',
      date: json['date'] ?? '',
      isDone: json['isDone'] ?? false,
      list: (json['list'] as List<dynamic>?)
          ?.map((item) => ShoppingListItem.fromJson(item))
          .toList() ?? [],
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'coverImages': coverImage,
      'coocker': coocker,
      'date': date,
      'isDone': isDone,
      'list': list.map((item) => item.toJson()).toList(),
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  ShoppingModel copyWith({
    String? id,
    String? title,
    String? description,
    String? coverImage,
    String? coocker,
    String? date,
    bool? isDone,
    List<ShoppingListItem>? list,
    String? userId,
    String? createdAt,
  }) {
    return ShoppingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      coocker: coocker ?? this.coocker,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
      list: list ?? this.list,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper method to get formatted date
  String getFormattedDate() {
    try {
      final dateTime = DateTime.parse(date);
      return "${dateTime.day}.${dateTime.month}.${dateTime.year.toString().substring(2)}";
    } catch (e) {
      return date;
    }
  }
}

class ShoppingListItem {
  final String name;
  final List<Ingredient> ingredients;

  ShoppingListItem({
    required this.name,
    required this.ingredients,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      name: json['name'] ?? '',
      ingredients: (json['ingredient'] as List<dynamic>?)
          ?.map((item) => Ingredient.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ingredient': ingredients.map((item) => item.toJson()).toList(),
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
