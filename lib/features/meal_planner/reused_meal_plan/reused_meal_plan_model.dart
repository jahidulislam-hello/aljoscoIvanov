// ================= MODEL =================
class MealPlanModel {
  final String title;
  final String description;
  final String createdBy;
  final String date;
  bool isSelected;

  MealPlanModel({
    required this.title,
    required this.description,
    required this.createdBy,
    required this.date,
    this.isSelected = false,
  });
}