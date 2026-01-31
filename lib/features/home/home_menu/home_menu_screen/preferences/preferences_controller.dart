import 'package:get/get.dart';

class PreferencesController extends GetxController {
  // Selected items
  var selectedMealTypes = <String>[].obs;
  var selectedAllergens = <String>[].obs;

  // Expansion states
  var mealTypeExpanded = false.obs;
  var allergensExpanded = false.obs;

  // Toggle item selection
  void toggleItem(RxList<String> list, String item) {
    if (list.contains(item)) {
      list.remove(item);
    } else {
      list.add(item);
    }
  }

  // Toggle section expansion
  void toggleExpansion(RxBool expansionState) {
    expansionState.value = !expansionState.value;
  }

  // Clear all filters
  void clearAllFilters() {
    selectedMealTypes.clear();
    selectedAllergens.clear();
  }

  // Apply filters (you can add your logic here)
  void applyFilters() {
    print("Selected Meal Types: $selectedMealTypes");
    print("Selected Allergens: $selectedAllergens");
    // Add your API call or filtering logic here
    Get.back();
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}