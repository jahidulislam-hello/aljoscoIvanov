class CollectionModel {
  final String id;
  final String userId;
  final String collectionName;
  final List<RecipeInCollection> recipes;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  CollectionModel({
    required this.id,
    required this.userId,
    required this.collectionName,
    required this.recipes,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    List<RecipeInCollection> recipeList = [];
    if (json['recipes'] != null) {
      recipeList = (json['recipes'] as List)
          .map((recipe) => RecipeInCollection.fromJson(recipe))
          .toList();
    }

    return CollectionModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      collectionName: json['collactionName'] ?? '',
      recipes: recipeList,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'collactionName': collectionName,
      'recipes': recipes.map((r) => r.toJson()).toList(),
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class RecipeInCollection {
  final String id;
  final String title;
  final String description;
  final List<String> images;

  RecipeInCollection({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
  });

  factory RecipeInCollection.fromJson(Map<String, dynamic> json) {
    List<String> imageList = [];
    if (json['images'] != null) {
      imageList = (json['images'] as List).map((img) => img.toString()).toList();
    }

    return RecipeInCollection(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: imageList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'images': images,
    };
  }
}
