// import 'package:get/get.dart';
// import 'package:freshbite/features/new/model/new_recipe_model.dart';
//
// class RecipeDetailController extends GetxController {
//   final Recipe recipe;
//
//   RecipeDetailController({required this.recipe});
//
//   /// Servings
//   var servings = 0.obs;
//
//   /// Checked Ingredients
//   late RxList<bool> checkedIngredients;
//
//   /// Expandable sections
//   var isDescriptionExpanded = true.obs;
//   var isTimeExpanded = true.obs;
//   var isAllergensExpanded = true.obs;
//   var isIngredientsExpanded = true.obs;
//   var isInstructionsExpanded = true.obs;
//   var isNutritionExpanded = true.obs;
//   var isNotesExpanded = true.obs; // Personal Notes
//
//   /// Personal Notes List
//   var personalNotes = <String>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     servings.value = recipe.servings;
//     checkedIngredients = RxList<bool>.filled(recipe.ingredients.length, false);
//
//     // Add default personal notes
//     personalNotes.add('Remember to preheat the oven before starting.');
//     personalNotes.add('Use fresh herbs for better flavor.');
//   }
//
//   /// Toggle expand/collapse
//   void toggleDescription() => isDescriptionExpanded.value = !isDescriptionExpanded.value;
//   void toggleTime() => isTimeExpanded.value = !isTimeExpanded.value;
//   void toggleAllergens() => isAllergensExpanded.value = !isAllergensExpanded.value;
//   void toggleIngredients() => isIngredientsExpanded.value = !isIngredientsExpanded.value;
//   void toggleInstructions() => isInstructionsExpanded.value = !isInstructionsExpanded.value;
//   void toggleNutrition() => isNutritionExpanded.value = !isNutritionExpanded.value;
//   void toggleNotes() => isNotesExpanded.value = !isNotesExpanded.value;
//
//   /// Servings increment/decrement
//   void increaseServings() => servings.value++;
//   void decreaseServings() {
//     if (servings.value > 1) servings.value--;
//   }
//
//   /// Check/uncheck ingredient
//   void toggleIngredient(int index) {
//     checkedIngredients[index] = !checkedIngredients[index];
//   }
//
//   /// Add a personal note
//   void addNote(String note) {
//     if (note.isNotEmpty) personalNotes.add(note);
//   }
//
//   /// Remove a personal note
//   void removeNoteAt(int index) {
//     if (index >= 0 && index < personalNotes.length) personalNotes.removeAt(index);
//   }
// }
//
//
//
// import 'package:freshbite/features/new/model/new_recipe_model.dart';
//
//
// class SampleData {
//   static Recipe getSampleRecipe() {
//     return Recipe(
//       id: '1',
//       title: 'Shakshuka',
//       titlechip:  ['Protein', 'Lactose-free', 'Tomato', 'Meal Prep', 'Spring'],
//       description:
//       'Shakshuka is a classic Middle Eastern and North African dish consisting of eggs poached in a spicy tomato and pepper sauce. It\'s traditionally served in a cast-iron skillet and makes for a hearty, flavorful meal.',
//       imageUrl: 'assets/images/shasuka.png',
//       images: [
//         'assets/images/shasuka.png',
//         'assets/images/shasuka.png',
//         'assets/images/shasuka.png',
//       ],
//       rating: 4.5,
//       reviewCount: 248,
//       prepTime: Duration(minutes: 10),
//       cookTime: Duration(minutes: 20),
//       difficulty: 'Medium',
//       servings: 4,
//       allergens: ['Egg', 'Lactose', 'Fish', 'Lactose','Lactose','Crustaceans','Tree Nuts'],
//       ingredients: [
//         Ingredient(name: 'For 4 people', quantity: ''),
//         Ingredient(name: 'Onion', quantity: '1pc'),
//         Ingredient(name: 'Green pepper', quantity: '1pc'),
//         Ingredient(name: 'Tomato', quantity: '4-5pcs'),
//         Ingredient(name: 'Egg', quantity: '4-5pcs'),
//         Ingredient(name: 'Food coloring', quantity: '1/4-cup'),
//         Ingredient(name: 'Salt', quantity: 'To taste'),
//         Ingredient(name: 'Ghee', quantity: '2-3 tsps'),
//       ],
//       instructions: [
//         'If using sun-dried tomatoes, place them in a small bowl and cover with hot water. Let them soak for 5-10 minutes until softened, then drain and roughly chop.',
//         'Heat the olive oil in a large, deep skillet or frying pan over medium heat. Add the chopped onion and cook for about 5 minutes, stirring occasionally, until softened.',
//         'Add the minced garlic, diced bell pepper, cumin, paprika, and cayenne pepper (if using). Cook for another 2-3 minutes, stirring frequently, until the vegetables are tender and fragrant.',
//         'Stir in the diced tomatoes, sun-dried tomatoes (if using), tomato paste, salt, and black pepper. Reduce the heat to low and let the sauce simmer for about 10 minutes, stirring occasionally, until it has thickened slightly.',
//         'Using the back of a spoon, make 4-6 small wells in the sauce. Carefully crack an egg into each well. Season the eggs with a pinch of salt and pepper.',
//         'Cover the skillet with a lid and cook for 5-8 minutes, or until the eggs are cooked to your desired level of doneness. For runny yolks, cook for about 5 minutes; for firmer yolks, cook for 7-8 minutes.',
//         'Remove the skillet from heat and garnish with chopped fresh parsley or cilantro and crumbled feta cheese, if desired. Serve hot with crusty bread or pita for dipping.',
//       ],
//       nutritionInfo: NutritionInfo(
//         calories: 218.8,
//         protein: 13.3,
//         carbs: 7.8,
//         fat: 9.6,
//       ),
//       personalNotes: [
//         PersonalNotes(
//           userName: 'Alanna D.',
//           userImage: 'assets/images/profil.png',
//
//           comment:
//           'This was delicious! I used whole eggs instead of just egg whites and it was perfect. Will definitely make again.',
//           date: DateTime.now().subtract(Duration(days: 2)),
//         ),
//         PersonalNotes(
//           userName: 'Alanna D.',
//           userImage: 'assets/images/profil.png',
//
//           comment:
//           'This was delicious! I used whole eggs instead of just egg whites and it was perfect. Will definitely make again.',
//           date: DateTime.now().subtract(Duration(days: 2)),
//         ),
//       ],
//     );
//   }
//
// }