// ================= MODEL =================
class MealPlanModel {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final String date;
  final List<SequencePlan> plans;
  bool isSelected;

  MealPlanModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.createdBy,
    required this.date,
    this.plans = const [],
    this.isSelected = false,
  });

  factory MealPlanModel.fromJson(Map<String, dynamic> json) {
    // Parse plans array
    List<SequencePlan> parsedPlans = [];
    if (json['plans'] != null && json['plans'] is List) {
      parsedPlans = (json['plans'] as List)
          .map((p) => SequencePlan.fromJson(p))
          .toList();
    }

    // Format the date
    String formattedDate = '';
    if (json['createdAt'] != null) {
      try {
        final date = DateTime.parse(json['createdAt']);
        final months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        formattedDate = '${months[date.month - 1]} ${date.day}, ${date.year}';
      } catch (e) {
        formattedDate = json['createdAt'] ?? '';
      }
    }

    return MealPlanModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdBy: 'You', // API doesn't provide creator name
      date: formattedDate,
      plans: parsedPlans,
      isSelected: false,
    );
  }
}

class SequencePlan {
  final String date;
  final List<String> mealIds;

  SequencePlan({
    required this.date,
    required this.mealIds,
  });

  factory SequencePlan.fromJson(Map<String, dynamic> json) {
    List<String> ids = [];
    if (json['meals'] != null && json['meals'] is List) {
      for (var meal in json['meals']) {
        if (meal is String) {
          ids.add(meal);
        } else if (meal is Map) {
          ids.add(meal['_id'] ?? '');
        }
      }
    }
    return SequencePlan(
      date: json['date'] ?? '',
      mealIds: ids,
    );
  }
}