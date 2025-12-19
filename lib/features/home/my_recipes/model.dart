class MyRecipeModel {
  final String id;
  final String title;
  final String image;
  final int timeMinutes;
  final double rating;
  final bool isFavorite;

  MyRecipeModel({
    required this.id,
    required this.title,
    required this.image,
    required this.timeMinutes,
    required this.rating,
    this.isFavorite = false,
  });

  /// Factory constructor to create from API response
  factory MyRecipeModel.fromJson(Map<String, dynamic> json) {
    // Extract time
    int totalTime = 0;
    if (json['time'] != null && json['time']['totalTime'] != null) {
      totalTime = int.tryParse(json['time']['totalTime'].toString()) ?? 0;
    }

    // Extract first image or use placeholder
    String imageUrl = 'assets/icons/01.png';
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      imageUrl = json['images'][0];
    }

    // Calculate average rating from reviews
    double averageRating = 0.0;
    if (json['reviews'] != null && (json['reviews'] as List).isNotEmpty) {
      final reviews = json['reviews'] as List;
      final totalRating = reviews.fold<double>(
        0.0,
        (sum, review) => sum + (review['rating']?.toDouble() ?? 0.0),
      );
      averageRating = totalRating / reviews.length;
    }

    return MyRecipeModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Unknown Recipe',
      image: imageUrl,
      timeMinutes: totalTime,
      rating: averageRating,
      isFavorite: false,
    );
  }
}
