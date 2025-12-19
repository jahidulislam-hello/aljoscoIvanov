import 'package:freshbite/features/recepies/my_recipes_details/my_recipes_details_model/my_recipes_details_model.dart';
import 'package:freshbite/features/recepies/my_recipes_details/my_recipes_details_service/my_recipes_details_service.dart';
import 'package:get/get.dart';

class MyRecipesDetailsController extends GetxController {
  /// Recipe ID to fetch
  String? recipeId;

  /// Observable recipe details
  Rx<MyRecipesDetailsModel?> myrecipe = Rx<MyRecipesDetailsModel?>(null);

  /// Loading state
  var isLoading = false.obs;

  /// Error message
  var errorMessage = ''.obs;

  MyRecipesDetailsController({this.recipeId});

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

      print("🔄 Fetching user recipe details for ID: $id");

      final response = await MyRecipesDetailsService.getSingleUserRecipe(id);

      if (response['success'] == true && response['response'] != null) {
        myrecipe.value = MyRecipesDetailsModel.fromJson(response['response']);

        // Initialize servings and checked ingredients after data is loaded
        if (myrecipe.value != null) {
          servings.value = myrecipe.value!.servings;
          checkedIngredients = RxList<bool>.filled(myrecipe.value!.ingredients.length, false);
        }

        print("✅ Successfully loaded user recipe: ${myrecipe.value?.title}");
      } else {
        errorMessage.value = "Failed to load user recipe details";
        print("❌ Failed to load user recipe: Invalid response");
      }
    } catch (e) {
      errorMessage.value = "Error loading user recipe: $e";
      print("❌ Error fetching user recipe details: $e");
      // Load sample data as fallback
      _loadSampleData();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load sample data as fallback
  void _loadSampleData() {
    myrecipe.value = MyRecipesDetailsModel(
      id: '1',
      title: 'Shakshuka',
      titlechip: ['Protein', 'Lactose-free', 'Tomato', 'Meal Prep', 'Spring'],
      description:
      'Shakshuka is a classic Middle Eastern and North African dish consisting of eggs poached in a spicy tomato and pepper sauce. It\'s traditionally served in a cast-iron skillet and makes for a hearty, flavorful meal.',
      imageUrl: 'assets/images/shasuka.png',
      images: [
        'assets/images/shasuka.png',
        'assets/images/shasuka.png',
        'assets/images/shasuka.png',
      ],
      rating: 4.5,
      reviewCount: 248,
      prepTime: Duration(minutes: 10),
      cookTime: Duration(minutes: 20),
      servings: 4,
      allergens: [
        'Egg',
        'Lactose',
        'Fish',
        'Lactose',
        'Lactose',
        'Crustaceans',
        'Tree Nuts'
      ],
      ingredients: [
        MyRecipeDetailsIngredient(name: 'Onion', quantity: '1pc'),
        MyRecipeDetailsIngredient(name: 'Green pepper', quantity: '1pc'),
        MyRecipeDetailsIngredient(name: 'Tomato', quantity: '4-5pcs'),
        MyRecipeDetailsIngredient(name: 'Egg', quantity: '4-5pcs'),
        MyRecipeDetailsIngredient(name: 'Food coloring', quantity: '1/4-cup'),
        MyRecipeDetailsIngredient(name: 'Salt', quantity: 'To taste'),
        MyRecipeDetailsIngredient(name: 'Ghee', quantity: '2-3 tsps'),
      ],
      instructions: [
        'If using sun-dried tomatoes, place them in a small bowl and cover with hot water. Let them soak for 5-10 minutes until softened, then drain and roughly chop.',
        'Heat the olive oil in a large, deep skillet or frying pan over medium heat. Add the chopped onion and cook for about 5 minutes, stirring occasionally, until softened.',
        'Add the minced garlic, diced bell pepper, cumin, paprika, and cayenne pepper (if using). Cook for another 2-3 minutes, stirring frequently, until the vegetables are tender and fragrant.',
        'Stir in the diced tomatoes, sun-dried tomatoes (if using), tomato paste, salt, and black pepper. Reduce the heat to low and let the sauce simmer for about 10 minutes, stirring occasionally, until it has thickened slightly.',
        'Using the back of a spoon, make 4-6 small wells in the sauce. Carefully crack an egg into each well. Season the eggs with a pinch of salt and pepper.',
        'Cover the skillet with a lid and cook for 5-8 minutes, or until the eggs are cooked to your desired level of doneness. For runny yolks, cook for about 5 minutes; for firmer yolks, cook for 7-8 minutes.',
        'Remove the skillet from heat and garnish with chopped fresh parsley or cilantro and crumbled feta cheese, if desired. Serve hot with crusty bread or pita for dipping.',
      ],
      nutritionInfo: MyRecipeDetailsNutritionInfo(
        energy: "970 kJ / 230 kcal",
        fat: "13 g",
        saturated: "3.2 g",
        carbs: "14 g",
        sugars: "4 g",
        fibre: "1 g",
        protein: "8 g",
        salt: "0.9 g",
      ),
      personalNotes: [
        MyRecipeDetailsPersonalNotes(
          userName: 'Alanna D.',
          userImage: 'assets/images/profil.png',
          comment:
          'This was delicious! I used whole eggs instead of just egg whites and it was perfect. Will definitely make again.',
          date: DateTime.now().subtract(Duration(days: 2)),
        ),
        MyRecipeDetailsPersonalNotes(
          userName: 'Alanna D.',
          userImage: 'assets/images/profil.png',
          comment:
          'This was delicious! I used whole eggs instead of just egg whites and it was perfect. Will definitely make again.',
          date: DateTime.now().subtract(Duration(days: 2)),
        ),
      ],
    );

    // Initialize servings and checked ingredients for sample data
    servings.value = myrecipe.value!.servings;
    checkedIngredients = RxList<bool>.filled(myrecipe.value!.ingredients.length, false);
  }

  /// -------------------------------------------------------------
  /// CONTROLLER LOGIC (Previously RecipeDetailController)
  /// -------------------------------------------------------------

  /// Servings
  var servings = 0.obs;

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
  void increaseServings() => servings.value++;
  void decreaseServings() {
    if (servings.value > 1) servings.value--;
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
