import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../edit_shopping_list_model.dart';
import 'package:freshbite/features/shopping_list/select_prep_list/select_prep_list_model/prep_list_model.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_service/shopping_service.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_model/shopping_model.dart';

class EditShoppingController extends GetxController {
  // ========= TABS =========
  RxInt selectedTab = 0.obs;
  void switchTab(int index) => selectedTab.value = index;


  // ========= DESCRIPTION =========
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();


  // ========= PLAN SHOPPING =========
  RxString selectedPerson = "me".obs;
  List<String> people = ["me", "Partner", "Family Member", "Other"];
  void changePerson(String? value) => selectedPerson.value = value!;

  RxString selectedDate = "Select date".obs;

  RxString selectedUnit = "g/ml".obs;

  // ========= RECIPE IDs FOR SAVING =========
  List<String> recipeIds = [];

  // ========= LOADING STATE =========
  var isSaving = false.obs;
  var isLoading = false.obs;

  // ========= SHOPPING LIST ID (for edit mode) =========
  String? shoppingListId;
  RxBool isEditMode = false.obs;

  // ========= TITLE =========
  RxString listTitle = "".obs;

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate.value =
      "${picked.day}/${picked.month}/${picked.year}";
    }
  }


  // ========= RECIPE SECTIONS (REACTIVE) =========
  RxList<RecipeSection> recipeSections = <RecipeSection>[].obs;

  // ========= CATEGORY SECTIONS (for BY CATEGORY tab) =========
  RxList<RecipeSection> categorySections = <RecipeSection>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDataFromArguments();
  }

  /// Load data based on arguments (either from prep lists or from existing shopping list)
  void _loadDataFromArguments() {
    final args = Get.arguments;
    if (args != null) {
      if (args['shoppingListId'] != null) {
        // Edit mode - load from single shopping list API
        shoppingListId = args['shoppingListId'];
        isEditMode.value = true;
        _loadSingleShoppingList(shoppingListId!);
      } else if (args['selectedPrepLists'] != null) {
        // Create mode - load from prep lists
        _loadRecipesFromPrepLists(args);
      }
    }
  }

  /// Load single shopping list from API
  Future<void> _loadSingleShoppingList(String id) async {
    try {
      isLoading.value = true;
      debugPrint('📤 Loading shopping list: $id');

      final response = await ShoppingService.getSingleShoppingList(id);
      final data = response['data'];

      if (data != null) {
        // Parse shopping model from response
        final shoppingModel = ShoppingModel.fromJson(data);

        // Set title
        listTitle.value = shoppingModel.title;
        titleController.text = shoppingModel.title;

        // Set description
        descriptionController.text = shoppingModel.description;

        // Set coocker/person
        selectedPerson.value = shoppingModel.coocker.isNotEmpty ? shoppingModel.coocker : "me";
        if (!people.contains(selectedPerson.value)) {
          people.add(selectedPerson.value);
        }

        // Set date
        if (shoppingModel.date.isNotEmpty) {
          try {
            final dateTime = DateTime.parse(shoppingModel.date);
            selectedDate.value = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
          } catch (e) {
            debugPrint('❌ Error parsing date: $e');
          }
        }

        // Convert list items to recipe sections (BY RECIPE)
        recipeSections.value = shoppingModel.list.map((listItem) {
          final items = listItem.ingredients.map((ingredient) {
            return ShoppingItem(
              name: ingredient.name,
              amount: ingredient.value,
              unit: ingredient.unit,
              singleValue: ingredient.singleValue,
              categories: ingredient.categories,
              houseHoldUnit: ingredient.houseHoldUnit,
              householdValue: ingredient.householdValue,
              houseHoldForSingleValue: ingredient.houseHoldForSingleValue,
            );
          }).toList();

          return RecipeSection(
            title: listItem.name,
            items: items,
          );
        }).toList();

        // Build category sections (BY CATEGORY)
        _buildCategorySections(shoppingModel);

        debugPrint('✅ Shopping list loaded successfully');
        debugPrint('   Title: ${shoppingModel.title}');
        debugPrint('   Sections: ${recipeSections.length}');
      }
    } catch (e) {
      debugPrint('❌ Error loading shopping list: $e');
      Get.snackbar(
        "Error",
        "Failed to load shopping list",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Build category sections from shopping model
  void _buildCategorySections(ShoppingModel shoppingModel) {
    // Group all ingredients by category
    final Map<String, List<ShoppingItem>> categoryMap = {};

    for (var listItem in shoppingModel.list) {
      for (var ingredient in listItem.ingredients) {
        final category = ingredient.categories ?? 'Other';

        if (!categoryMap.containsKey(category)) {
          categoryMap[category] = [];
        }

        categoryMap[category]!.add(ShoppingItem(
          name: ingredient.name,
          amount: ingredient.value,
          unit: ingredient.unit,
          singleValue: ingredient.singleValue,
          categories: ingredient.categories,
          houseHoldUnit: ingredient.houseHoldUnit,
          householdValue: ingredient.householdValue,
          houseHoldForSingleValue: ingredient.houseHoldForSingleValue,
        ));
      }
    }

    // Convert map to sections
    categorySections.value = categoryMap.entries.map((entry) {
      return RecipeSection(
        title: entry.key,
        items: entry.value,
      );
    }).toList();

    debugPrint('✅ Category sections built: ${categorySections.length}');
  }

  /// Load recipes from selected prep lists
  void _loadRecipesFromPrepLists(Map<String, dynamic> args) {
    if (args['selectedPrepLists'] != null) {
      final List<PrepListModel> selectedPrepLists = args['selectedPrepLists'];

      // Extract all recipes from all selected prep lists
      final List<RecipeDetail> allRecipes = [];
      for (var prepList in selectedPrepLists) {
        // Include all recipes (don't filter by isDeleted)
        allRecipes.addAll(prepList.recipes);
      }

      // Store recipe IDs for saving
      recipeIds = allRecipes.map((recipe) => recipe.id).toList();

      // Convert recipes to recipe sections
      recipeSections.value = allRecipes.map((recipe) {
        // Convert ingredients to shopping items
        final items = recipe.ingredients.map((ingredient) {
          return ShoppingItem(
            name: ingredient.name,
            amount: ingredient.value,
            unit: ingredient.unit,
            singleValue: ingredient.singleValue,
            categories: ingredient.categories,
            houseHoldUnit: ingredient.houseHoldUnit,
            householdValue: ingredient.householdValue,
            houseHoldForSingleValue: ingredient.houseHoldForSingleValue,
          );
        }).toList();

        return RecipeSection(
          title: recipe.title,
          items: items,
        );
      }).toList();

      // Build category sections from prep list recipes
      _buildCategorySectionsFromPrepLists(allRecipes);

      debugPrint('✅ Loaded ${recipeSections.length} recipes with ingredients');
      debugPrint('✅ Recipe IDs: $recipeIds');
    }
  }

  /// Build category sections from prep list recipes
  void _buildCategorySectionsFromPrepLists(List<RecipeDetail> recipes) {
    final Map<String, List<ShoppingItem>> categoryMap = {};

    for (var recipe in recipes) {
      for (var ingredient in recipe.ingredients) {
        final category = ingredient.categories ?? 'Other';

        if (!categoryMap.containsKey(category)) {
          categoryMap[category] = [];
        }

        categoryMap[category]!.add(ShoppingItem(
          name: ingredient.name,
          amount: ingredient.value,
          unit: ingredient.unit,
          singleValue: ingredient.singleValue,
          categories: ingredient.categories,
          houseHoldUnit: ingredient.houseHoldUnit,
          householdValue: ingredient.householdValue,
          houseHoldForSingleValue: ingredient.houseHoldForSingleValue,
        ));
      }
    }

    categorySections.value = categoryMap.entries.map((entry) {
      return RecipeSection(
        title: entry.key,
        items: entry.value,
      );
    }).toList();

    debugPrint('✅ Category sections from prep lists: ${categorySections.length}');
  }

  /// Get current sections based on selected tab
  RxList<RecipeSection> get currentSections {
    return selectedTab.value == 0 ? recipeSections : categorySections;
  }


  // ========= ADD CUSTOM ITEM PER SECTION =========
  void addCustomItem(RecipeSection section) {
    if (section.nameCtrl.text.trim().isEmpty) return;

    section.items.add(
      ShoppingItem(
        name: section.nameCtrl.text.trim(),
        amount: section.amountCtrl.text.trim(),
        unit: section.unitCtrl.text.trim(),
      ),
    );

    // Clear after adding
    section.nameCtrl.clear();
    section.amountCtrl.clear();
    section.unitCtrl.clear();

    // NO update() needed – using RxList + Obx()
    section.items.refresh();
  }


  // ========= UPDATE AN EXISTING ITEM =========
  void updateItem(RecipeSection section, int index, String name,
      String amount, String unit) {
    section.items[index]
      ..name = name
      ..amount = amount
      ..unit = unit;

    section.items.refresh(); // notify UI
  }


  // ========= SAVE LIST =========
  Future<void> saveList() async {
    // Validate date selection
    if (selectedDate.value == "Select date") {
      Get.snackbar(
        "Error",
        "Please select a date for the grocery list",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validate recipe IDs
    if (recipeIds.isEmpty) {
      Get.snackbar(
        "Error",
        "No recipes available to save",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSaving.value = true;

      // Convert selected date to ISO format
      final dateParts = selectedDate.value.split('/');
      if (dateParts.length != 3) {
        throw Exception('Invalid date format');
      }

      final day = dateParts[0].padLeft(2, '0');
      final month = dateParts[1].padLeft(2, '0');
      final year = dateParts[2];
      final isoDate = '$year-$month-${day}T00:00:00.000Z';

      debugPrint('📤 Saving grocery list with date: $isoDate');
      debugPrint('📤 Recipe IDs: $recipeIds');

      await ShoppingService.createGroceryList(
        date: isoDate,
        recipeIds: recipeIds,
      );

      debugPrint('✅ Grocery list saved successfully');

      Get.snackbar(
        "Success",
        "Grocery list saved successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back after successful save
      await Future.delayed(Duration(seconds: 1));
      Get.back();
    } catch (e) {
      debugPrint('❌ Error saving grocery list: $e');

      Get.snackbar(
        "Error",
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } finally {
      isSaving.value = false;
    }
  }
}
