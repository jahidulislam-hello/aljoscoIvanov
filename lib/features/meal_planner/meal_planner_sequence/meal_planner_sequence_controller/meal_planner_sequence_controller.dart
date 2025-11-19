import 'package:freshbite/features/meal_planner/meal_planner_sequence/meal_planner_sequence_model.dart';
import 'package:get/get.dart';


class MealPlanController extends GetxController {
  // Selected days for meal plan
  RxList<int> selectedDays = <int>[18, 19, 20].obs;

  // Meals by type
  RxList<MealRecipe> breakfastRecipes = <MealRecipe>[
    MealRecipe(
      name: 'Tomato Soup',
      image: 'assets/images/tomato_soup.png',
      servings: 4,
      addedBy: 'Olivia afgv',
      date: 'May 14, 2025',
      note: 'This is dinner recipe please make it class day.',
    ),
  ].obs;

  RxList<MealRecipe> snackRecipes = <MealRecipe>[].obs;

  RxList<MealRecipe> lunchRecipes = <MealRecipe>[
    MealRecipe(
      name: 'Tomato Soup',
      image: 'assets/images/tomato_soup.png',
      servings: 4,
      addedBy: 'Olivia afgv',
      date: 'May 14, 2025',
    ),
  ].obs;

  RxList<MealRecipe> dinnerRecipes = <MealRecipe>[
    MealRecipe(
      name: 'Tomato Soup',
      image: 'assets/images/tomato_soup.png',
      servings: 4,
      addedBy: 'Olivia afgv',
      date: 'May 14, 2025',
    ),
  ].obs;

  void toggleDay(int day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day);
    } else {
      selectedDays.add(day);
    }
  }

  void addRecipe(String type, MealRecipe recipe) {
    switch (type) {
      case 'Breakfast':
        breakfastRecipes.add(recipe);
        break;
      case 'Snack':
        snackRecipes.add(recipe);
        break;
      case 'Lunch':
        lunchRecipes.add(recipe);
        break;
      case 'Dinner':
        dinnerRecipes.add(recipe);
        break;
    }
  }
}
