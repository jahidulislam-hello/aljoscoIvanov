import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../edit_shopping_list_model.dart';

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


  // ========= SAMPLE DATA (REACTIVE) =========
  RxList<RecipeSection> recipeSections = <RecipeSection>[
    RecipeSection(
      title: "Shakshuka",
      items: [
        ShoppingItem(name: "Olive oil", amount: "2", unit: "tbsp"),
        ShoppingItem(name: "Onion", amount: "1", unit: "ps"),
      ],
    ),
    RecipeSection(
      title: "Tomato",
      items: [
        ShoppingItem(name: "Red bell pepper", amount: "1", unit: "ps"),
        ShoppingItem(name: "Garlic cloves", amount: "3", unit: "cloves"),
      ],
    ),
  ].obs;


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
  void saveList() {
    Get.snackbar("Saved", "Shopping list saved successfully.");
  }
}
