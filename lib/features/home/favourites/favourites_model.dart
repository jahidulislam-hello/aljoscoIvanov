class FavouritesModel {
  final String title;
  final String image;
  final int timeMinutes;
  final double rating;
  final bool isFavorite;

  FavouritesModel({
    required this.title,
    required this.image,
    required this.timeMinutes,
    required this.rating,
    this.isFavorite = false,
  });
}
