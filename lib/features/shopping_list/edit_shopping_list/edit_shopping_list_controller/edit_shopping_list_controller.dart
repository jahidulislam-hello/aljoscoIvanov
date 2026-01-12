import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../edit_shopping_list_model.dart';
import 'package:freshbite/features/shopping_list/select_prep_list/select_prep_list_model/prep_list_model.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_service/shopping_service.dart';

class EditShoppingController extends GetxController {
  // ========= TABS =========
  RxInt selectedTab = 0.obs;
  void switchTab(int index) => selectedTab.value = index;


  // ========= DESCRIPTION =========
  TextEditingController descriptionController = TextEditingController();


  // ========= PLAN SHOPPING =========
  RxString selectedPerson = "Aljoscha Ivanov".obs;
  List<String> people = ["Aljoscha Ivanov", "John Doe", "Emma Watson"];
  void changePerson(String? value) => selectedPerson.value = value!;

  RxString selectedDate = "Select date".obs;

  RxString selectedUnit = "g/ml".obs;

  // ========= RECIPE IDs FOR SAVING =========
  List<String> recipeIds = [];

  // ========= LOADING STATE =========
  var isSaving = false.obs;

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

  @override
  void onInit() {
    super.onInit();
    _loadRecipesFromArguments();
  }

  /// Load recipes from selected prep lists
  void _loadRecipesFromArguments() {
    final args = Get.arguments;
    if (args != null && args['selectedPrepLists'] != null) {
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
          );
        }).toList();

        return RecipeSection(
          title: recipe.title,
          items: items,
        );
      }).toList();

      debugPrint('✅ Loaded ${recipeSections.length} recipes with ingredients');
      debugPrint('✅ Recipe IDs: $recipeIds');
    }
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

      final response = await ShoppingService.createGroceryList(
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
