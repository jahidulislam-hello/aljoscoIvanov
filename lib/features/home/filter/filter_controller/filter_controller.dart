import 'package:freshbite/features/home/filter/filter_model.dart';
import 'package:get/get.dart';


class FilterController extends GetxController {
  // Each filter category as observable list
  var mealTypes = <FilterOption>[
    FilterOption(name: "Breakfast"),
    FilterOption(name: "Main Meal"),
    FilterOption(name: "Snack"),
    FilterOption(name: "Drink"),
  ].obs;

  var recipeComponents = <FilterOption>[
    FilterOption(name: "Base"),
    FilterOption(name: "Vegetables"),
    FilterOption(name: "Protein"),
    FilterOption(name: "Connector"),
    FilterOption(name: "Topping"),
  ].obs;

  var cookingModes = <FilterOption>[
    FilterOption(name: "Everyday"),
    FilterOption(name: "Emergency"),
    FilterOption(name: "Meal Prep"),
  ].obs;

  var flavorProfiles = <FilterOption>[
    FilterOption(name: "Sweet"),
    FilterOption(name: "Savory"),
    FilterOption(name: "Warm"),
    FilterOption(name: "Cold"),
    FilterOption(name: "Spicy"),
  ].obs;

  var cuisineTypes = <FilterOption>[
    FilterOption(name: "Mediterranean"),
    FilterOption(name: "Balkan"),
    FilterOption(name: "Asian"),
    FilterOption(name: "Fusion"),
    FilterOption(name: "Oriental"),
    FilterOption(name: "Latin American"),
    FilterOption(name: "Traditional"),
  ].obs;

  var seasons = <FilterOption>[
    FilterOption(name: "All Year"),
    FilterOption(name: "Spring"),
    FilterOption(name: "Summer"),
    FilterOption(name: "Autumn"),
    FilterOption(name: "Winter"),
  ].obs;

  var dietTypes = <FilterOption>[
    FilterOption(name: "Vegetarian"),
    FilterOption(name: "Lactose-free"),
    FilterOption(name: "Gluten-free"),
    FilterOption(name: "Vegan"),
  ].obs;

  var allergens = <FilterOption>[
    FilterOption(name: "Peanuts"),
    FilterOption(name: "Soy"),
    FilterOption(name: "Mustard"),
    FilterOption(name: "Crustaceans"),
    FilterOption(name: "Sesame"),
    FilterOption(name: "Molluscs"),
    FilterOption(name: "Sulphites"),
    FilterOption(name: "Lupins"),
    FilterOption(name: "Cereals containing gluten"),
    FilterOption(name: "Celery"),
    FilterOption(name: "Eggs"),
    FilterOption(name: "Fish"),
    FilterOption(name: "Milk"),
    FilterOption(name: "Tree Nuts"),
  ].obs;

  // For expansion state tracking
  var expandedSections = <String, bool>{
    'Meal Type': true,
    'Recipe Components': true,
    'Cooking Mode': false,
    'Flavor Profile': false,
    'Cuisine Type': false,
    'Season': false,
    'Diet Type': false,
    'Allergens': false,
  }.obs;

  void toggleSelection(FilterOption option) {
    option.isSelected = !option.isSelected;
    update();
  }

  void toggleSection(String key) {
    expandedSections[key] = !(expandedSections[key] ?? false);
    update();
  }

  void applyFilters() {
    // Add your filtering logic or API call here
    print("Filters applied!");
  }
}
