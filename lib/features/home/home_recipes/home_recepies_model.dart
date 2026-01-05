class HomeRecepieModel {
  final String title;
  final String category;
  final String image;
  final String description;
  final String? recipeId;
  final String? cookingMode;
  final List<String>? images;

  HomeRecepieModel({
    required this.title,
    required this.category,
    required this.image,
    required this.description,
    this.recipeId,
    this.cookingMode,
    this.images,
  });

  // Factory method to create from API response
  factory HomeRecepieModel.fromJson(Map<String, dynamic> json) {
    List<String> imageList = [];
    if (json['images'] != null && json['images'] is List) {
      imageList = List<String>.from(json['images']);
    }

    // Get cooking mode (handle both with and without space)
    String cookingMode = json['coocking_mode'] ?? json[' coocking_mode'] ?? '';

    return HomeRecepieModel(
      recipeId: json['_id'] ?? '',
      title: cookingMode, // Use cooking_mode as title (e.g., "everyday", "meal prep")
      category: json['title'] ?? '', // Use actual recipe title as category
      image: imageList.isNotEmpty ? imageList[0] : '',
      description: json['description'] ?? '',
      cookingMode: cookingMode,
      images: imageList,
    );
  }
}
