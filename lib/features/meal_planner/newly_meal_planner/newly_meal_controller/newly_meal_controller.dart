import 'package:freshbite/features/meal_planner/newly_meal_planner/model.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class NewlyMealController extends GetxController {
  final uuid = Uuid();

  /// Map of mealKey -> RxBool expanded
  final expanded = <String, RxBool>{
    'breakfast': true.obs,
    'snack1': false.obs,
    'lunch': true.obs,
    'snack2': false.obs,
    'dinner': true.obs,
  };

  /// mealKey -> list of recipes (for demo one item each)
  final meals = <String, RxList<NewMealModel>>{
    'breakfast': <NewMealModel>[
      NewMealModel(
        id: 'm1',
        title: 'Tomato Soup',
        subtitle: '2 servings • Base, Protein, Topping',
        imageAsset: 'assets/images/tomato_soup.png',
      )
    ].obs,
    'snack1': <NewMealModel>[].obs,
    'lunch': <NewMealModel>[
      NewMealModel(
        id: 'm2',
        title: 'Tomato Soup',
        subtitle: '2 servings • Base, Protein, Topping',
        imageAsset: 'assets/images/tomato_soup.png',
      ),
    ].obs,
    'snack2': <NewMealModel>[].obs,
    'dinner': <NewMealModel>[
      NewMealModel(
        id: 'm3',
        title: 'Tomato Soup',
        subtitle: '2 servings • Base, Protein, Topping',
        imageAsset: 'assets/images/tomato_soup.png',
      ),
    ].obs,
  };

  bool isExpanded(String key) => expanded[key]?.value ?? false;

  void toggleExpand(String key) {
    expanded[key]?.value = !(expanded[key]?.value ?? false);
  }

  void addRecipe(String mealKey, NewMealModel recipe) {
    meals[mealKey]?.add(recipe);
    update(); // optional: GetX reactive lists update themselves but update() is fine
  }

  void editRecipe(String mealKey, String recipeId, NewMealModel newValue) {
    final list = meals[mealKey];
    if (list == null) return;
    final idx = list.indexWhere((e) => e.id == recipeId);
    if (idx >= 0) list[idx] = newValue;
  }

  void removeRecipe(String mealKey, String recipeId) {
    meals[mealKey]?.removeWhere((r) => r.id == recipeId);
  }

  NewMealModel createNewRecipe({String? title, String? subtitle, String? imageAsset}) {
    return NewMealModel(
      id: uuid.v4(),
      title: title ?? 'New Recipe',
      subtitle: subtitle ?? '',
      imageAsset: imageAsset ?? 'assets/images/tomato_soup.png',
    );
  }
}
