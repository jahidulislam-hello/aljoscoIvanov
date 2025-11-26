import 'package:flutter/material.dart';
import 'package:freshbite/features/shopping_list/create_shopping/create_shopping_model/create_shopping_model.dart';
import 'package:get/get.dart';

class CreateShoppingController extends GetxController {
  /// We wrap everything inside ONE RecipeSection
  var shoppingSections = <RecipeSection>[
    RecipeSection(
      title: "Ingredients",
      items: [
        ShoppingItemModel(name: "Olive oil", amount: "2", unit: "tbsp"),
        ShoppingItemModel(name: "Onion", amount: "1", unit: "ps"),
        ShoppingItemModel(name: "Red bell pepper", amount: "1", unit: "ps"),
        ShoppingItemModel(name: "Garlic cloves", amount: "3", unit: "Cloves"),
        ShoppingItemModel(name: "Ground cumin", amount: "1", unit: "tsp"),
        ShoppingItemModel(name: "Smoked paprika", amount: "1", unit: "can (28 oz)"),
        ShoppingItemModel(name: "Fresh parsley", amount: "1/4", unit: "cup"),
        ShoppingItemModel(name: "Eggs", amount: "4", unit: "large"),
        ShoppingItemModel(name: "Chili powder", amount: "1/2", unit: "tsp"),
      ],
    ),
  ].obs;

  // ========= DESCRIPTION =========
  TextEditingController descriptionController = TextEditingController();

  // ========= PLAN (Who?) =========
  RxString selectedPerson = "Aljoscha Ivanov".obs;
  List<String> people = ["Aljoscha Ivanov", "John Doe", "Emma Watson"];
  void changePerson(String? value) => selectedPerson.value = value!;

  // ========= PLAN (When?) =========
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // ========= ADD CUSTOM ITEM =========
  void addCustomItem(RecipeSection section) {
    if (section.nameCtrl.text.trim().isEmpty) return;

    section.items.add(
      ShoppingItemModel(
        name: section.nameCtrl.text.trim(),
        amount: section.amountCtrl.text.trim(),
        unit: section.unitCtrl.text.trim(),
      ),
    );

    section.nameCtrl.clear();
    section.amountCtrl.clear();
    section.unitCtrl.clear();

    section.items.refresh();
  }

  // ========= UPDATE EXISTING ITEM =========
  void updateItem(
      RecipeSection section,
      int index,
      String name,
      String amount,
      String unit,
      ) {
    section.items[index]
      ..name = name
      ..amount = amount
      ..unit = unit;

    section.items.refresh();
  }

  // ========= DATE PICKER =========
  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  // ========= SAVE =========
  void saveList() {
    // TODO: API or Local DB
    Get.back();
  }
}
