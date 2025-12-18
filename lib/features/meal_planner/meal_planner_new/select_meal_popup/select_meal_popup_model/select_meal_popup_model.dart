class SelectMealPopupModel {
  final String id;
  final String title;
  final String image;
  final int timeMinutes;
  final bool isFavorite;

  SelectMealPopupModel({
    required this.id,
    required this.title,
    required this.image,
    required this.timeMinutes,
    this.isFavorite = false,
  });

  /// Factory constructor to create from API response
  factory SelectMealPopupModel.fromJson(Map<String, dynamic> json) {
    return SelectMealPopupModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Unknown Recipe',
      image: (json['images'] != null && (json['images'] as List).isNotEmpty)
          ? json['images'][0]
          : 'assets/icons/01.png',
      timeMinutes: int.tryParse(json['time']?['totalTime']?.toString() ?? '0') ?? 0,
      isFavorite: false,
    );
  }

  /// Convert to JSON (if needed)
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'image': image,
      'timeMinutes': timeMinutes,
      'isFavorite': isFavorite,
    };
  }
}
