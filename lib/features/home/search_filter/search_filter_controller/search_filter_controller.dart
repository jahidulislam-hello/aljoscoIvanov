import 'package:get/get.dart';

class SearchFilterController extends GetxController {
  // Expandable section states
  RxBool mealTypeExpanded = true.obs;
  RxBool recipeComponentsExpanded = false.obs;
  RxBool cookingModeExpanded = false.obs;
  RxBool flavorProfileExpanded = false.obs;
  RxBool cuisineTypeExpanded = false.obs;
  RxBool seasonExpanded = false.obs;
  RxBool dietTypeExpanded = false.obs;
  RxBool allergensExpanded = false.obs;

  // Multi select filter states
  RxList<String> selectedMealTypes = <String>[].obs;
  RxList<String> selectedRecipeComponents = <String>[].obs;
  RxList<String> selectedCookingModes = <String>[].obs;
  RxList<String> selectedFlavors = <String>[].obs;
  RxList<String> selectedCuisines = <String>[].obs;
  RxList<String> selectedSeasons = <String>[].obs;
  RxList<String> selectedDietTypes = <String>[].obs;
  RxList<String> selectedAllergens = <String>[].obs;

  void toggleItem(RxList<String> list, String item) {
    if (list.contains(item)) {
      list.remove(item);
    } else {
      list.add(item);
    }
  }
}
