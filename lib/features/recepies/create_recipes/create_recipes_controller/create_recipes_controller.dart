import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:freshbite/features/recepies/create_recipes/create_recipes_service/create_recipes_service.dart';

// ==================== RECIPE CONTROLLER ====================
class RecipeController extends ChangeNotifier {
  String recipeName = '';
  List<File?> recipeImages = [null, null, null, null];
  String description = '';
  String servings = '';

  List<String> selectedComponents = [];
  String selectedCookingMode = 'Everyday';

  String totalTime = '';
  String prepTime = '';
  String cookTime = '';

  List<InstructionStep> instructions = [InstructionStep()];
  List<Ingredient> ingredients = [Ingredient()];
  List<NutritionalValue> nutritionalValues = [
    NutritionalValue(name: 'Calories'),
    NutritionalValue(name: 'Protein'),
  ];

  String allergens = '';
  String tagsInput = '';

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  void updateRecipeName(String value) {
    recipeName = value;
    notifyListeners();
  }

  Future<void> pickImage(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      recipeImages[index] = File(image.path);
      notifyListeners();
    }
  }

  void toggleComponent(String component) {
    if (selectedComponents.contains(component)) {
      selectedComponents.remove(component);
    } else {
      selectedComponents.add(component);
    }
    notifyListeners();
  }

  void setCookingMode(String mode) {
    selectedCookingMode = mode;
    notifyListeners();
  }

  void addInstruction() {
    instructions.add(InstructionStep());
    notifyListeners();
  }

  void updateInstruction(int index, {String? text, String? videoUrl}) {
    if (text != null) instructions[index].text = text;
    if (videoUrl != null) instructions[index].videoUrl = videoUrl;
    notifyListeners();
  }

  void addIngredient() {
    ingredients.add(Ingredient());
    notifyListeners();
  }

  void updateIngredient(int index, {String? name, String? quantity, String? unit, String? category}) {
    if (name != null) ingredients[index].name = name;
    if (quantity != null) ingredients[index].quantity = quantity;
    if (unit != null) ingredients[index].unit = unit;
    if (category != null) ingredients[index].category = category;
    notifyListeners();
  }

  void removeIngredient(int index) {
    if (ingredients.length > 1) {
      ingredients.removeAt(index);
      notifyListeners();
    }
  }

  void addNutritionalValue() {
    nutritionalValues.add(NutritionalValue());
    notifyListeners();
  }

  void updateNutritionalValue(int index, {String? name, String? quantity, String? unit}) {
    if (name != null) nutritionalValues[index].name = name;
    if (quantity != null) nutritionalValues[index].quantity = quantity;
    if (unit != null) nutritionalValues[index].unit = unit;
    notifyListeners();
  }

  void removeNutritionalValue(int index) {
    if (nutritionalValues.length > 1) {
      nutritionalValues.removeAt(index);
      notifyListeners();
    }
  }

  Future<bool> saveRecipe() async {
    try {
      // Validation
      if (recipeName.trim().isEmpty) {
        print('❌ Recipe name is required');
        return false;
      }

      if (description.trim().isEmpty) {
        print('❌ Description is required');
        return false;
      }

      if (servings.trim().isEmpty) {
        print('❌ Servings is required');
        return false;
      }

      // Get only non-null images
      final validImages = recipeImages.where((img) => img != null).cast<File>().toList();

      if (validImages.isEmpty) {
        print('❌ At least one image is required');
        return false;
      }

      isLoading = true;
      notifyListeners();

      // Parse allergens (comma or space separated)
      final allergensList = allergens
          .split(RegExp(r'[,\s]+'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Parse tags (comma or space separated)
      final tagsList = tagsInput
          .split(RegExp(r'[,\s]+'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .take(10) // Maximum 10 tags
          .toList();

      // Build ingredients list
      final ingredientsList = ingredients
          .where((ing) => ing.name.isNotEmpty)
          .map((ing) => {
                'name': ing.name,
                'unit': ing.unit,
                'value': ing.quantity,
                'category': ing.category,
              })
          .toList();

      // Build nutrition values list
      final nutritionList = nutritionalValues
          .where((nutr) => nutr.name.isNotEmpty)
          .map((nutr) => {
                'name': nutr.name,
                'unit': nutr.unit,
                'value': nutr.quantity,
              })
          .toList();

      // Build instructions list
      final instructionsList = instructions
          .where((inst) => inst.text.isNotEmpty)
          .map((inst) => {
                'title': inst.text,
                'videoUrl': inst.videoUrl ?? '',
              })
          .toList();

      // Build time object
      final timeData = {
        'totalTime': totalTime.replaceAll(RegExp(r'[^0-9]'), ''), // Extract numbers only
        'prepTime': prepTime.replaceAll(RegExp(r'[^0-9]'), ''),
        'cookTime': cookTime.replaceAll(RegExp(r'[^0-9]'), ''),
      };

      // Call API
      final response = await CreateRecipesService.createRecipe(
        title: recipeName.trim(),
        description: description.trim(),
        allergens: allergensList,
        tags: tagsList,
        serving: int.tryParse(servings) ?? 1,
        ingredients: ingredientsList,
        nutritionValue: nutritionList,
        requiredSkill: selectedComponents,
        instruction: instructionsList,
        time: timeData,
        cookingMode: selectedCookingMode,
        images: validImages,
      );

      isLoading = false;
      notifyListeners();

      print('✅ Recipe saved successfully!');
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print('❌ Error saving recipe: $e');
      return false;
    }
  }
}

class InstructionStep {
  String text = '';
  String? videoUrl;
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  Color textColor = Colors.black;
}

class Ingredient {
  String name = '';
  String quantity = '';
  String unit = 'g';
  String category = 'General';
}

class NutritionalValue {
  String name = '';
  String quantity = '';
  String unit = 'Unit';

  NutritionalValue({this.name = '', this.quantity = '', this.unit = 'Unit'});
}