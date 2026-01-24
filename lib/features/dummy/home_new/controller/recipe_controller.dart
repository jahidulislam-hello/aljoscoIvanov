// import 'package:freshbite/features/home/home_new/model.dart';
// import 'package:get/get.dart';
//
//
// class RecipeDetailController extends GetxController {
//   var servings = 4.obs;
//   var isExpanded = {
//     'allergens': false,
//     'ingredients': true,
//     'skills': false,
//     'instructions': true,
//     'notes': false,
//   }.obs;
//
//   final Rx<RecipeModel?> recipe = Rx<RecipeModel?>(null);
//
//   @override
//   void onInit() {
//     super.onInit();
//     recipe.value = RecipeModel(
//       title: "Shakshuka",
//       description:
//       "A traditional North African and Middle Eastern dish with poached eggs in a spicy tomato sauce.",
//       tags: ["Lactose-free", "Protein", "Tomato", "Meal Prep", "Spring"],
//       rating: 4.5,
//       allergens: ["Peanuts", "Soy", "Mustard", "Milk (Lactose)"],
//       ingredients: [
//         {"Olive oil": "2 tbsp"},
//         {"Onion": "1 pc"},
//         {"Red bell pepper": "1 pc"},
//         {"Garlic cloves": "3 cloves"},
//         {"Eggs": "4 large"},
//       ],
//       timeOverview: {
//         "Total Time": "50 min",
//         "Prep Time": "20 min",
//         "Cook Time": "30 min",
//       },
//       skills: [
//         "Chopping Vegetables Evenly",
//         "Sautéing Aromatics",
//         "Layering Spices & Seasoning",
//         "Poaching Eggs in Sauce"
//       ],
//       instructions: [
//         "Heat oil and sauté onions.",
//         "Add spices and peppers.",
//         "Crack eggs into the sauce.",
//         "Simmer until eggs are cooked.",
//       ],
//       nutrition: {
//         "Energy": "970 kJ / 230 kcal",
//         "Fat": "13 g",
//         "Carbs": "14 g",
//         "Protein": "9 g",
//       },
//       notes: [
//         {
//           "name": "Olivia Afje",
//           "note":
//           "This recipe was amazing! I added extra chili powder for more spice.",
//         },
//         {
//           "name": "David Ro",
//           "note":
//           "Turned out great! Served it with pita bread and feta cheese.",
//         }
//       ],
//     );
//   }
//
//   void toggleExpand(String key) {
//     isExpanded[key] = !(isExpanded[key] ?? false);
//   }
//
//   void increaseServings() => servings.value++;
//   void decreaseServings() {
//     if (servings.value > 1) servings.value--;
//   }
// }
