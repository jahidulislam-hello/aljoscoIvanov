class ProfileRecipeModel {
  final String id;
  final String title;
  final String imageUrl;
  final DateTime addedDate;
  final bool isLiked;

  ProfileRecipeModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.addedDate,
    this.isLiked = false,
  });

  factory ProfileRecipeModel.fromJson(Map<String, dynamic> json) {
    return ProfileRecipeModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: (json['images'] != null && (json['images'] as List).isNotEmpty)
          ? json['images'][0]
          : '',
      addedDate: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      isLiked: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'images': [imageUrl],
      'createdAt': addedDate.toIso8601String(),
      'isLiked': isLiked,
    };
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(addedDate);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return 'Just now';
    }
  }

  ProfileRecipeModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    DateTime? addedDate,
    bool? isLiked,
  }) {
    return ProfileRecipeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      addedDate: addedDate ?? this.addedDate,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}