import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freshbite/features/shopping_list/create_shopping/create_shopping_model/create_shopping_model.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_service/shopping_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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

  // ========= TITLE =========
  TextEditingController titleController = TextEditingController();

  // ========= DESCRIPTION =========
  TextEditingController descriptionController = TextEditingController();

  // ========= COVER IMAGE =========
  Rx<File?> coverImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  // ========= PLAN (Who?) =========
  RxString selectedPerson = "me".obs;
  List<String> people = ["me", "Aljoscha Ivanov", "John Doe", "Emma Watson"];
  void changePerson(String? value) => selectedPerson.value = value!;

  // ========= PLAN (When?) =========
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // ========= LOADING STATE =========
  var isLoading = false.obs;

  // ========= ADD NEW SECTION =========
  void addNewSection(String sectionTitle) {
    if (sectionTitle.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a section name',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    shoppingSections.add(
      RecipeSection(
        title: sectionTitle.trim(),
        items: [],
      ),
    );

    debugPrint('✅ Added new section: $sectionTitle');
  }

  // ========= REMOVE SECTION =========
  void removeSection(int index) {
    if (shoppingSections.length <= 1) {
      Get.snackbar(
        'Error',
        'You must have at least one section',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    shoppingSections.removeAt(index);
    debugPrint('✅ Removed section at index $index');
  }

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

  // ========= REMOVE ITEM =========
  void removeItem(RecipeSection section, int index) {
    section.items.removeAt(index);
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

  // ========= IMAGE PICKER =========
  Future<void> pickCoverImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        coverImage.value = File(image.path);
        debugPrint('✅ Cover image selected: ${image.path}');
      }
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ========= REMOVE COVER IMAGE =========
  void removeCoverImage() {
    coverImage.value = null;
  }

  // ========= VALIDATE INPUTS =========
  bool _validateInputs() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a title',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a description',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedDate.value == null) {
      Get.snackbar(
        'Error',
        'Please select a date',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Check if at least one section has items
    bool hasItems = false;
    for (var section in shoppingSections) {
      if (section.items.isNotEmpty) {
        hasItems = true;
        break;
      }
    }

    if (!hasItems) {
      Get.snackbar(
        'Error',
        'Please add at least one item to your shopping list',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  // ========= TRANSFORM DATA TO API FORMAT =========
  List<Map<String, dynamic>> _transformToApiFormat() {
    List<Map<String, dynamic>> apiList = [];

    for (var section in shoppingSections) {
      if (section.items.isEmpty) continue;

      List<Map<String, dynamic>> ingredients = [];

      for (var item in section.items) {
        ingredients.add({
          "name": item.name,
          "unit": item.unit,
          "value": item.amount,
          "category": "shop",
        });
      }

      apiList.add({
        "name": section.title,
        "ingredient": ingredients,
      });
    }

    return apiList;
  }

  // ========= SAVE =========
  Future<void> saveList() async {
    // Validate inputs
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      // Transform data to API format
      final apiList = _transformToApiFormat();

      // Format date to ISO 8601
      final dateString = selectedDate.value!.toUtc().toIso8601String();

      debugPrint('📤 Creating shopping list...');
      debugPrint('   Title: ${titleController.text.trim()}');
      debugPrint('   Description: ${descriptionController.text.trim()}');
      debugPrint('   Date: $dateString');
      debugPrint('   Coocker: ${selectedPerson.value}');
      debugPrint('   Sections: ${apiList.length}');
      debugPrint('   Has cover image: ${coverImage.value != null}');

      // Call API
      final response = await ShoppingService.createShoppingList(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        date: dateString,
        list: apiList,
        coocker: selectedPerson.value,
        coverImage: coverImage.value,
      );

      if (response['success'] == true) {
        debugPrint('✅ Shopping list created successfully');

        Get.snackbar(
          'Success',
          'Shopping list created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Go back to previous screen
        Get.back(result: true);
      }
    } catch (e) {
      debugPrint('❌ Error creating shopping list: $e');

      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
