import 'package:freshbite/features/recepies/recipes_details/recipes_details_model/recipes_details_model.dart';
import 'package:freshbite/features/recepies/recipes_details/recipes_details_service/recipes_details_service.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/features/video/instruction_video.dart';
import 'package:get/get.dart';
import 'package:freshbite/features/new/model/new_recipe_model.dart';

class RecipesDetailsRecipeController extends GetxController {
  /// Recipe ID to fetch
  String? recipeId;

  /// Observable recipe details
  Rx<RecipesDetailsModel?> recipeDetails = Rx<RecipesDetailsModel?>(null);

  /// Raw skill data from API for navigation to instructions screen
  List<SkillData> skillsData = [];

  /// Loading state
  var isLoading = false.obs;

  /// Error message
  var errorMessage = ''.obs;

  RecipesDetailsRecipeController({this.recipeId});

  @override
  void onInit() {
    super.onInit();
    if (recipeId != null) {
      fetchRecipeDetails(recipeId!);
    } else {
      // Fallback to hardcoded data if no ID provided
      _loadSampleData();
    }
  }

  /// Fetch recipe details from API
  Future<void> fetchRecipeDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print("🔄 Fetching recipe details for ID: $id");

      final response = await RecipesDetailsService.getSingleRecipe(id);

      // Check if the response indicates success
      if (response['success'] == true && response['data'] != null) {
        // Manually map the API response to the model since the format has changed
        final data = response['data'];

        // Parse time values
        int totalTime = int.tryParse(data['time']?['totalTime']?.toString() ?? '0') ?? 0;
        int prepTime = int.tryParse(data['time']?['prepTime']?.toString() ?? '0') ?? 0;
        int cookTime = int.tryParse(data['time']?['cookTime']?.toString() ?? '0') ?? 0;

        // Map ingredients with both metric and household values
        List<IngredientDetails> ingredients = [];
        if (data['ingredients'] != null) {
          for (var ingredient in data['ingredients']) {
            if (ingredient is Map<String, dynamic>) {
              String name = ingredient['name'] ?? '';
              String metricUnit = ingredient['unit'] ?? '';
              String metricValue = ingredient['value'] ?? '';
              String householdUnit = ingredient['houseHoldUnit'] ?? '';
              String householdValue = ingredient['householdValue'] ?? '';

              // Default quantity for backward compatibility (metric first)
              String quantity = '';
              if (metricUnit.isNotEmpty && metricValue.isNotEmpty) {
                quantity = '$metricValue $metricUnit';
              } else if (metricValue.isNotEmpty) {
                quantity = metricValue;
              }

              ingredients.add(IngredientDetails(
                name: name,
                quantity: quantity,
                metricValue: metricValue,
                metricUnit: metricUnit,
                householdValue: householdValue,
                householdUnit: householdUnit,
              ));
            }
          }
        }

        // Map instructions
        List<String> instructions = [];
        if (data['instruction'] != null) {
          for (var instruction in data['instruction']) {
            if (instruction is String) {
              // If instruction is a string, add it directly
              instructions.add(instruction);
            } else if (instruction is Map<String, dynamic>) {
              // If instruction is a map, extract the title
              String title = instruction['title'] ?? '';
              instructions.add(title);
            }
          }
        }

        // Map nutrition info
        String energy = '';
        String fat = '';
        String saturated = '';
        String carbs = '';
        String sugars = '';
        String fibre = '';
        String protein = '';
        String salt = '';

        if (data['nutritionValue'] != null) {
          for (var nutValue in data['nutritionValue']) {
            if (nutValue is Map<String, dynamic>) {
              String name = nutValue['name']?.toLowerCase() ?? '';
              String value = nutValue['value'] ?? '';
              String unit = nutValue['unit'] ?? '';
              String formattedValue = '$value $unit';

              if (name.contains('calories') || name.contains('energy')) {
                energy = formattedValue;
              } else if (name.contains('fat')) {
                fat = formattedValue;
              } else if (name.contains('saturated')) {
                saturated = formattedValue;
              } else if (name.contains('carbo') || name.contains('carbs')) {
                carbs = formattedValue;
              } else if (name.contains('sugar')) {
                sugars = formattedValue;
              } else if (name.contains('fibre') || name.contains('fiber')) {
                fibre = formattedValue;
              } else if (name.contains('protein')) {
                protein = formattedValue;
              } else if (name.contains('salt')) {
                salt = formattedValue;
              }
            }
          }
        }

        // Calculate average rating from reviews
        double averageRating = 0.0;
        int reviewCount = 0;
        if (data['reviews'] != null && data['reviews'] is List) {
          final reviews = data['reviews'] as List;
          reviewCount = reviews.length;
          if (reviewCount > 0) {
            final totalRating = reviews.fold<double>(
              0.0,
              (sum, review) => sum + (review['rating']?.toDouble() ?? 0.0),
            );
            averageRating = totalRating / reviewCount;
          }
        }

        // Parse skills data for video instructions
        skillsData = [];
        if (data['required_skill'] != null && data['required_skill'] is List) {
          for (var skill in data['required_skill']) {
            if (skill is Map<String, dynamic>) {
              skillsData.add(SkillData.fromJson(skill));
            }
          }
        }

        // Create the recipe details model
        recipeDetails.value = RecipesDetailsModel(
          id: data['_id'] ?? '',
          title: data['title'] ?? 'No Title',
          titlechip: (data['tags'] != null && data['tags'] is List)
              ? List<String>.from(data['tags'].map((e) => e.toString()))
              : [],
          description: data['description'] ?? '',
          imageUrl: (data['images'] != null && data['images'].length > 0)
              ? data['images'][0]
              : 'assets/images/shasuka.png',
          images: List<String>.from(data['images'] ?? []),
          rating: averageRating,
          reviewCount: reviewCount,
          prepTime: Duration(minutes: prepTime),
          cookTime: Duration(minutes: cookTime),
          totalTime: Duration(minutes: totalTime),
          servings: data['serving'] ?? 1,
          allergens: (data['allergens'] != null && data['allergens'] is List)
              ? List<String>.from((data['allergens'] as List).expand((allergen) {
                  if (allergen is String) {
                    // If allergen is a string, split by comma if needed
                    return allergen.split(',').map((s) => s.trim());
                  } else if (allergen is List) {
                    // If allergen is a list, flatten it
                    return allergen.map((e) => e.toString());
                  } else {
                    // If it's something else, convert to string
                    return [allergen.toString()];
                  }
                }))
              : [],
          ingredients: ingredients,
          skills: (data['required_skill'] != null && data['required_skill'] is List)
              ? List<String>.from((data['required_skill'] as List).map((skill) {
                  if (skill is Map<String, dynamic>) {
                    return skill['skillTitle'] ?? skill['title'] ?? skill.toString();
                  } else {
                    return skill.toString();
                  }
                }))
              : [],
          instructions: instructions,
          nutritionInfo: NutritionInfoDetails(
            energy: energy,
            fat: fat,
            saturated: saturated,
            carbs: carbs,
            sugars: sugars,
            fibre: fibre,
            protein: protein,
            salt: salt,
          ),
          personalNotes: (data['notes'] != null && data['notes'] is List)
              ? (data['notes'] as List).map((note) {
                  if (note is Map<String, dynamic>) {
                    return PersonalNotesDeatils(
                      userName: 'You', // Will be updated with actual user name
                      userImage: 'assets/images/profil.png',
                      comment: note['note'] ?? '',
                      date: DateTime.now(),
                    );
                  }
                  return PersonalNotesDeatils(
                    userName: 'You',
                    userImage: 'assets/images/profil.png',
                    comment: note.toString(),
                    date: DateTime.now(),
                  );
                }).toList()
              : [],
        );

        // Initialize servings and checked ingredients after data is loaded
        if (recipeDetails.value != null) {
          servings.value = recipeDetails.value!.servings;
          originalServings = recipeDetails.value!.servings;
          originalIngredients = List.from(recipeDetails.value!.ingredients);
          checkedIngredients = RxList<bool>.filled(recipeDetails.value!.ingredients.length, false);

          // Update personal notes with actual user name
          await _updateNotesWithUserName();
        }

        print("✅ Successfully loaded recipe: ${recipeDetails.value?.title}");
      } else {
        errorMessage.value = "Failed to load recipe details";
        print("❌ Failed to load recipe: Invalid response");
      }
    } catch (e) {
      errorMessage.value = "Error loading recipe: $e";
      print("❌ Error fetching recipe details: $e");
      // Load sample data as fallback
      _loadSampleData();
    } finally {
      isLoading.value = false;
    }
  }

  /// Update personal notes with actual user name from SharedPreferences
  Future<void> _updateNotesWithUserName() async {
    try {
      // Get user's first and last name from SharedPreferences
      final firstName = await SharedPreferencesHelper.getUserFirstName() ?? '';
      final lastName = await SharedPreferencesHelper.getUserLastName() ?? '';
      final fullName = '$firstName $lastName'.trim();

      // If we have a name, update all notes (they're all from the current user)
      if (fullName.isNotEmpty && recipeDetails.value != null) {
        final updatedNotes = recipeDetails.value!.personalNotes.map((note) {
          return PersonalNotesDeatils(
            userName: fullName,
            userImage: note.userImage,
            comment: note.comment,
            date: note.date,
          );
        }).toList();

        // Update the recipe details with the new notes
        recipeDetails.value = RecipesDetailsModel(
          id: recipeDetails.value!.id,
          title: recipeDetails.value!.title,
          titlechip: recipeDetails.value!.titlechip,
          description: recipeDetails.value!.description,
          imageUrl: recipeDetails.value!.imageUrl,
          images: recipeDetails.value!.images,
          rating: recipeDetails.value!.rating,
          reviewCount: recipeDetails.value!.reviewCount,
          prepTime: recipeDetails.value!.prepTime,
          cookTime: recipeDetails.value!.cookTime,
          totalTime: recipeDetails.value!.totalTime,
          servings: recipeDetails.value!.servings,
          allergens: recipeDetails.value!.allergens,
          ingredients: recipeDetails.value!.ingredients,
          skills: recipeDetails.value!.skills,
          instructions: recipeDetails.value!.instructions,
          nutritionInfo: recipeDetails.value!.nutritionInfo,
          personalNotes: updatedNotes,
        );

        print("✅ Updated notes with user name: $fullName");
      }
    } catch (e) {
      print("⚠️ Could not update user name in notes: $e");
    }
  }

  /// Load sample data as fallback
  void _loadSampleData() {
    recipeDetails.value = RecipesDetailsModel(
      id: '1',
      title: 'German Vegan Lentil Soup',
      titlechip: ['Vegan', 'Soup', 'Healthy'], // Updated to match API format
      description:
      'A hearty and nutritious vegan lentil soup with carrots, tomatoes, and aromatic herbs.',
      imageUrl: 'https://res.cloudinary.com/dymnrefpr/image/upload/v1762756838/Vegan%20Lentil%20Soup_5931198640674613_images.jpg',
      images: [
        'https://res.cloudinary.com/dymnrefpr/image/upload/v1762756838/Vegan%20Lentil%20Soup_5931198640674613_images.jpg',
        'https://res.cloudinary.com/dymnrefpr/image/upload/v1762756838/Vegan%20Lentil%20Soup_5931198640674613_images2.jpg',
      ],
      rating: 4.5, // Sample rating
      reviewCount: 248, // Sample review count
      prepTime: Duration(minutes: 10), // From API: prepTime: "10"
      cookTime: Duration(minutes: 30), // From API: cookTime: "30"
      totalTime: Duration(minutes: 40), // From API: totalTime: "40"
      servings: 4,
      allergens: [
        'soy',
        'gluten'
      ], // Updated to match API format
      ingredients: [
        IngredientDetails(name: 'Lentils', quantity: '200 g', metricValue: '200', metricUnit: 'g', householdValue: '560', householdUnit: 'cup'),
        IngredientDetails(name: 'Carrots', quantity: '150 g', metricValue: '150', metricUnit: 'g', householdValue: '560', householdUnit: 'cup'),
        IngredientDetails(name: 'Tomatoes', quantity: '4 pcs', metricValue: '4', metricUnit: 'pcs', householdValue: '560', householdUnit: 'cup'),
        IngredientDetails(name: 'Onion', quantity: '1 pcs', metricValue: '1', metricUnit: 'pcs', householdValue: '560', householdUnit: 'cup'),
        IngredientDetails(name: 'Garlic', quantity: '3 cloves', metricValue: '3', metricUnit: 'cloves', householdValue: '560', householdUnit: 'cup'),
        IngredientDetails(name: 'Vegetable broth', quantity: '1000 ml', metricValue: '1000', metricUnit: 'ml', householdValue: '560', householdUnit: 'cup'),
        IngredientDetails(name: 'Olive oil', quantity: '2 tbsp', metricValue: '2', metricUnit: 'tbsp', householdValue: '560', householdUnit: 'cup'),
      ], // Updated to match API format with metric and household values
      instructions: [
        'Prepare the vegetables',
        'Cook the soup',
        'Serve hot',
      ], // Updated to match API format
      skills: [
        "Chopping",
        "Simmering"
      ], // Updated to match API format
      nutritionInfo:   NutritionInfoDetails(
        energy: "250 kcal", // From API: Calories: "250"
        fat: "8 g", // From API: Fat: "8"
        saturated: "", // API doesn't have saturated fat
        carbs: "35 g", // From API: Carbohydrates: "35"
        sugars: "", // API doesn't have sugars
        fibre: "", // API doesn't have fibre
        protein: "15 g", // From API: Protein: "15"
        salt: "", // API doesn't have salt
      ), // Updated to match API format
      personalNotes: [
        PersonalNotesDeatils(
          userName: 'Alanna D.',
          userImage: 'assets/images/profil.png',
          comment:
          'This was delicious! I used whole eggs instead of just egg whites and it was perfect. Will definitely make again.',
          date: DateTime.now().subtract(Duration(days: 2)),
        ),
        PersonalNotesDeatils(
          userName: 'Alanna D.',
          userImage: 'assets/images/profil.png',
          comment:
          'This was delicious! I used whole eggs instead of just egg whites and it was perfect. Will definitely make again.',
          date: DateTime.now().subtract(Duration(days: 2)),
        ),
      ],

    );

    // Initialize servings and checked ingredients for sample data
    servings.value = recipeDetails.value!.servings;
    originalServings = recipeDetails.value!.servings;
    originalIngredients = List.from(recipeDetails.value!.ingredients);
    checkedIngredients = RxList<bool>.filled(recipeDetails.value!.ingredients.length, false);
  }

  /// -------------------------------------------------------------
  /// CONTROLLER LOGIC (Previously RecipeDetailController)
  /// -------------------------------------------------------------

  /// Servings
  var servings = 0.obs;

  /// Original servings (for calculating multiplier)
  int originalServings = 1;

  /// Original ingredients (for serving calculations)
  List<IngredientDetails> originalIngredients = [];

  /// Unit display mode: true = metric (g/ml), false = household (cup/tbsp)
  var isMetricUnit = true.obs;

  /// Toggle unit display mode
  void toggleUnitMode(bool isMetric) {
    isMetricUnit.value = isMetric;
  }

  /// Checked Ingredients
  late RxList<bool> checkedIngredients;

  /// Expandable sections
  var isDescriptionExpanded = true.obs;
  var isTimeExpanded = true.obs;
  var isAllergensExpanded = true.obs;
  var isIngredientsExpanded = true.obs;
  var isInstructionsExpanded = true.obs;
  var isNutritionExpanded = true.obs;
  var isNotesExpanded = true.obs;

  /// Personal Notes (User Notes, not recipe notes)
  var personalNotes = <String>[].obs;

  /// Toggle expand/collapse
  void toggleDescription() =>
      isDescriptionExpanded.value = !isDescriptionExpanded.value;
  void toggleTime() => isTimeExpanded.value = !isTimeExpanded.value;
  void toggleAllergens() =>
      isAllergensExpanded.value = !isAllergensExpanded.value;
  void toggleIngredients() =>
      isIngredientsExpanded.value = !isIngredientsExpanded.value;
  void toggleInstructions() =>
      isInstructionsExpanded.value = !isInstructionsExpanded.value;
  void toggleNutrition() =>
      isNutritionExpanded.value = !isNutritionExpanded.value;
  void toggleNotes() => isNotesExpanded.value = !isNotesExpanded.value;

  /// Servings controls
  void increaseServings() {
    servings.value++;
    _updateIngredientsForServingChange();
  }

  void decreaseServings() {
    if (servings.value > 1) {
      servings.value--;
      _updateIngredientsForServingChange();
    }
  }

  /// Update ingredients based on serving change
  void _updateIngredientsForServingChange() {
    if (recipeDetails.value != null && originalIngredients.isNotEmpty) {
      final currentServings = servings.value;
      final multiplier = currentServings / originalServings;

      // Update the ingredients from ORIGINAL values with the multiplier
      final updatedIngredients = originalIngredients.map((ingredient) {
        return ingredient.copyWithMultiplier(multiplier);
      }).toList();

      // Update the recipe details with new ingredients
      recipeDetails.value = RecipesDetailsModel(
        id: recipeDetails.value!.id,
        title: recipeDetails.value!.title,
        titlechip: recipeDetails.value!.titlechip,
        description: recipeDetails.value!.description,
        imageUrl: recipeDetails.value!.imageUrl,
        images: recipeDetails.value!.images,
        rating: recipeDetails.value!.rating,
        reviewCount: recipeDetails.value!.reviewCount,
        prepTime: recipeDetails.value!.prepTime,
        cookTime: recipeDetails.value!.cookTime,
        totalTime: recipeDetails.value!.totalTime,
        servings: servings.value,
        allergens: recipeDetails.value!.allergens,
        ingredients: updatedIngredients,
        skills: recipeDetails.value!.skills,
        instructions: recipeDetails.value!.instructions,
        nutritionInfo: recipeDetails.value!.nutritionInfo,
        personalNotes: recipeDetails.value!.personalNotes,
      );
    }
  }

  /// Ingredient check/uncheck
  void toggleIngredient(int index) {
    checkedIngredients[index] = !checkedIngredients[index];
  }

  /// Manage personal notes
  void addNote(String note) {
    if (note.isNotEmpty) personalNotes.add(note);
  }

  void removeNoteAt(int index) {
    if (index >= 0 && index < personalNotes.length) {
      personalNotes.removeAt(index);
    }
  }
}
