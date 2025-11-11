import 'package:freshbite/features/recepies/cooking/cooking_details_model/cooking_details_model.dart';
import 'package:get/get.dart';


class CookingDetailsController extends GetxController {
  late CookingDetailsModel recipe;

  RxInt servings = 4.obs;
  RxBool skillsExpanded = false.obs;
  RxBool instructionsExpanded = false.obs;
  RxBool notesExpanded = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecipe();
  }

  void increaseServings() => servings.value++;
  void decreaseServings() {
    if (servings.value > 1) servings.value--;
  }

  void toggleSkills() => skillsExpanded.toggle();
  void toggleInstructions() => instructionsExpanded.toggle();
  void toggleNotes() => notesExpanded.toggle();

  void loadRecipe() {
    recipe = CookingDetailsModel(
      title: "Shakshuka",
      rating: 4.5,
      description:
      "A classic Middle Eastern dish made from poached eggs in a spiced tomato sauce. Perfect for breakfast, brunch, or dinner.",
      tags: ["Lactose-free", "Protein", "Tomato", "Meal Prep", "Spring"],
      allergensIncluded: ["Peanuts", "Soy", "Mustard", "Milk (Lactose)"],
      allergensExcluded: ["Fish", "Crustaceans", "Tree Nuts"],
      ingredients: [
        Ingredient(name: "Olive oil", quantity: "2 tbsp"),
        Ingredient(name: "Onion", quantity: "1 pc"),
        Ingredient(name: "Red bell pepper", quantity: "1 pc"),
        Ingredient(name: "Garlic cloves", quantity: "3 cloves"),
        Ingredient(name: "Ground cumin", quantity: "1 tsp"),
        Ingredient(name: "Smoked paprika", quantity: "1 tsp"),
        Ingredient(name: "Tomatoes", quantity: "1 can (28 oz)"),
        Ingredient(name: "Eggs", quantity: "4 large"),
        Ingredient(name: "Fresh parsley", quantity: "1/4 cup"),
      ],
      servings: 4,
      totalTime: 50,
      prepTime: 20,
      cookTime: 30,
      images: [
        "assets/icons/sha1.png",
        "assets/icons/sha2.png",
        "assets/icons/sha3.png",
      ],
      skills: [
        "Chopping Vegetables Evenly",
        "Sautéing Aromatics",
        "Controlling Heat",
        "Layering Spices & Seasoning",
        "Poaching Eggs in Sauce"
      ],
      instructions: List.generate(
        6,
            (i) => Instruction(
          step: i + 1,
          text:
          "Step ${i + 1}: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus volutpat diam at velit interdum.",
        ),
      ),
      nutrition: NutritionInfo(
        energy: "970 kJ / 230 kcal",
        fat: "13 g",
        saturated: "3.2 g",
        carbs: "14 g",
        sugars: "4 g",
        fibre: "1 g",
        protein: "8 g",
        salt: "0.9 g",
      ),
      notes: [
        Note(
          userName: "Olivia Afly",
          avatar: "assets/icons/shasuka.png",
          text:
          "Loved making this dish — simple yet full of flavor! I added feta for extra tang.",
          date: "1 day ago",
        ),
        Note(
          userName: "Mia Jensen",
          avatar: "assets/icons/shasuka.png",
          text: "A great brunch recipe. Highly recommend serving with crusty bread.",
          date: "2 days ago",
        ),
      ],
    );
  }
}
