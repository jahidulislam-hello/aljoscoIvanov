class SelectMealPopupModel {
  final String title;
  final String image;
  final int timeMinutes;
  final bool isFavorite;

  SelectMealPopupModel({
    required this.title,
    required this.image,
    required this.timeMinutes,
    this.isFavorite = false,
  });
}
