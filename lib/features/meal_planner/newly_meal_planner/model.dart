class NewMealModel {
  String id;
  String title;
  String subtitle;
  String imageAsset; // local asset path for now
  bool visible;

  NewMealModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    this.visible = true,
  });

  NewMealModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageAsset,
    bool? visible,
  }) {
    return NewMealModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageAsset: imageAsset ?? this.imageAsset,
      visible: visible ?? this.visible,
    );
  }
}
