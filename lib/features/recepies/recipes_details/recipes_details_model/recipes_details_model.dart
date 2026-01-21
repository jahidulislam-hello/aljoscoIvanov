class RecipesDetailsModel {
  final String id;
  final String title;
  final List<String> titlechip;
  final String description;
  final String imageUrl;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final Duration prepTime;
  final Duration cookTime;
  final Duration totalTime;
  final int servings;
  final List<String> skills;
  final List<String> allergens;
  final List<IngredientDetails> ingredients;
  final List<String> instructions;
  final NutritionInfoDetails nutritionInfo;
  final List<PersonalNotesDeatils> personalNotes;

  RecipesDetailsModel({
    required this.id,
    required this.title,
    required this.titlechip,
    required this.description,
    required this.imageUrl,
    required this.images,
    required this.rating,
    required this.reviewCount,
    required this.prepTime,
    required this.cookTime,
    required this.totalTime,
    required this.servings,
    required this.allergens,
    required this.ingredients,
    required this.skills,
    required this.instructions,
    required this.nutritionInfo,
    required this.personalNotes,
  });

  // totalTime is now a field, not a getter
  // Duration get totalTime => prepTime + cookTime;

  /// Factory constructor to create from API response
  factory RecipesDetailsModel.fromJson(Map<String, dynamic> json) {
    // Extract images
    List<String> imagesList = [];
    if (json['images'] != null && json['images'] is List) {
      imagesList = (json['images'] as List).map((e) => e.toString()).toList();
    }

    // Extract allergens
    List<String> allergensList = [];
    if (json['allergens'] != null && json['allergens'] is List) {
      allergensList = (json['allergens'] as List).map((e) => e.toString()).toList();
    }

    // Extract tags as titlechip
    List<String> tagsList = [];
    if (json['tags'] != null && json['tags'] is List) {
      tagsList = (json['tags'] as List).map((e) => e.toString()).toList();
    }

    // Extract ingredients
    List<IngredientDetails> ingredientsList = [];
    if (json['ingredients'] != null && json['ingredients'] is List) {
      ingredientsList = (json['ingredients'] as List)
          .map((item) => IngredientDetails(
                name: item['name'] ?? '',
                quantity: '${item['value']} ${item['unit']}',
              ))
          .toList();
    }

    // Extract nutrition info
    NutritionInfoDetails nutritionInfo = NutritionInfoDetails(
      energy: '',
      fat: '',
      saturated: '',
      carbs: '',
      sugars: '',
      fibre: '',
      protein: '',
      salt: '',
    );

    if (json['nutritionValue'] != null && json['nutritionValue'] is List) {
      final nutritionList = json['nutritionValue'] as List;
      for (var item in nutritionList) {
        final name = item['name']?.toString().toLowerCase() ?? '';
        final value = '${item['value']} ${item['unit']}';

        if (name.contains('calorie') || name.contains('energy')) {
          nutritionInfo = NutritionInfoDetails(
            energy: value,
            fat: nutritionInfo.fat,
            saturated: nutritionInfo.saturated,
            carbs: nutritionInfo.carbs,
            sugars: nutritionInfo.sugars,
            fibre: nutritionInfo.fibre,
            protein: nutritionInfo.protein,
            salt: nutritionInfo.salt,
          );
        } else if (name.contains('fat')) {
          nutritionInfo = NutritionInfoDetails(
            energy: nutritionInfo.energy,
            fat: value,
            saturated: nutritionInfo.saturated,
            carbs: nutritionInfo.carbs,
            sugars: nutritionInfo.sugars,
            fibre: nutritionInfo.fibre,
            protein: nutritionInfo.protein,
            salt: nutritionInfo.salt,
          );
        } else if (name.contains('carb')) {
          nutritionInfo = NutritionInfoDetails(
            energy: nutritionInfo.energy,
            fat: nutritionInfo.fat,
            saturated: nutritionInfo.saturated,
            carbs: value,
            sugars: nutritionInfo.sugars,
            fibre: nutritionInfo.fibre,
            protein: nutritionInfo.protein,
            salt: nutritionInfo.salt,
          );
        } else if (name.contains('protein')) {
          nutritionInfo = NutritionInfoDetails(
            energy: nutritionInfo.energy,
            fat: nutritionInfo.fat,
            saturated: nutritionInfo.saturated,
            carbs: nutritionInfo.carbs,
            sugars: nutritionInfo.sugars,
            fibre: nutritionInfo.fibre,
            protein: value,
            salt: nutritionInfo.salt,
          );
        }
      }
    }

    // Extract skills
    List<String> skillsList = [];
    if (json['required_skill'] != null && json['required_skill'] is List) {
      skillsList = (json['required_skill'] as List).map((e) => e.toString()).toList();
    }

    // Extract instructions
    List<String> instructionsList = [];
    if (json['instruction'] != null && json['instruction'] is List) {
      instructionsList = (json['instruction'] as List)
          .map((item) => item['title']?.toString() ?? '')
          .toList();
    }

    // Extract time
    int prepTimeMinutes = 0;
    int cookTimeMinutes = 0;
    int totalTimeMinutes = 0;
    if (json['time'] != null) {
      prepTimeMinutes = int.tryParse(json['time']['prepTime']?.toString() ?? '0') ?? 0;
      cookTimeMinutes = int.tryParse(json['time']['cookTime']?.toString() ?? '0') ?? 0;
      totalTimeMinutes = int.tryParse(json['time']['totalTime']?.toString() ?? '0') ?? 0;
    }

    // Extract notes as personal notes
    List<PersonalNotesDeatils> notesList = [];
    if (json['notes'] != null && json['notes'] is List) {
      notesList = (json['notes'] as List)
          .map((noteItem) => PersonalNotesDeatils(
                userName: 'Anonymous', // Always show as Anonymous for privacy
                userImage: 'assets/images/profil.png', // Default avatar
                comment: noteItem['note'] ?? '', // API uses 'note' field
                date: DateTime.now(), // Use current date as placeholder
              ))
          .toList();
    }

    // Calculate average rating from reviews
    double averageRating = 0.0;
    int reviewCount = 0;
    if (json['reviews'] != null && json['reviews'] is List) {
      final reviews = json['reviews'] as List;
      reviewCount = reviews.length;
      if (reviewCount > 0) {
        final totalRating = reviews.fold<double>(
          0.0,
          (sum, review) => sum + (review['rating']?.toDouble() ?? 0.0),
        );
        averageRating = totalRating / reviewCount;
      }
    }

    return RecipesDetailsModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Unknown Recipe',
      titlechip: tagsList,
      description: json['description'] ?? '',
      imageUrl: imagesList.isNotEmpty ? imagesList.first : 'assets/icons/01.png',
      images: imagesList.isNotEmpty ? imagesList : ['assets/icons/01.png'],
      rating: averageRating,
      reviewCount: reviewCount,
      prepTime: Duration(minutes: prepTimeMinutes),
      cookTime: Duration(minutes: cookTimeMinutes),
      totalTime: Duration(minutes: totalTimeMinutes),
      servings: json['serving'] ?? 1,
      allergens: allergensList,
      ingredients: ingredientsList,
      skills: skillsList,
      instructions: instructionsList,
      nutritionInfo: nutritionInfo,
      personalNotes: notesList,
    );
  }
}

class IngredientDetails {
  final String name;
  final String quantity; // For backward compatibility
  final String metricValue; // e.g., "200"
  final String metricUnit; // e.g., "g", "ml", "pcs"
  final String householdValue; // e.g., "560"
  final String householdUnit; // e.g., "cup", "tbsp"

  IngredientDetails({
    required this.name,
    required this.quantity,
    this.metricValue = '',
    this.metricUnit = '',
    this.householdValue = '',
    this.householdUnit = '',
  });

  /// Get metric quantity string (e.g., "200 g")
  String get metricQuantity {
    if (metricValue.isNotEmpty && metricUnit.isNotEmpty) {
      return '$metricValue $metricUnit';
    } else if (metricValue.isNotEmpty) {
      return metricValue;
    }
    return quantity;
  }

  /// Get household quantity string (e.g., "560 cup")
  String get householdQuantity {
    if (householdValue.isNotEmpty && householdUnit.isNotEmpty) {
      return '$householdValue $householdUnit';
    }
    return metricQuantity; // Fallback to metric if no household data
  }

  /// Create a copy with updated values for serving adjustments
  IngredientDetails copyWithMultiplier(double multiplier) {
    String newMetricValue = metricValue;
    String newHouseholdValue = householdValue;

    // Update metric value
    final metricNum = double.tryParse(metricValue);
    if (metricNum != null) {
      final result = (metricNum * multiplier);
      newMetricValue = result == result.roundToDouble()
          ? result.toInt().toString()
          : result.toStringAsFixed(1);
    }

    // Update household value
    final householdNum = double.tryParse(householdValue);
    if (householdNum != null) {
      final result = (householdNum * multiplier);
      newHouseholdValue = result == result.roundToDouble()
          ? result.toInt().toString()
          : result.toStringAsFixed(1);
    }

    return IngredientDetails(
      name: name,
      quantity: '$newMetricValue $metricUnit',
      metricValue: newMetricValue,
      metricUnit: metricUnit,
      householdValue: newHouseholdValue,
      householdUnit: householdUnit,
    );
  }
}

class NutritionInfoDetails {
  final String energy;
  final String fat;
  final String saturated;
  final String carbs;
  final String sugars;
  final String fibre;
  final String protein;
  final String salt;

  NutritionInfoDetails ({
    required this.energy,
    required this.fat,
    required this.saturated,
    required this.carbs,
    required this.sugars,
    required this.fibre,
    required this.protein,
    required this.salt,
  });
}

class PersonalNotesDeatils {
  final String userName;
  final String userImage;
  final String comment;
  final DateTime date;

  PersonalNotesDeatils ({
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.date,
  });
}


