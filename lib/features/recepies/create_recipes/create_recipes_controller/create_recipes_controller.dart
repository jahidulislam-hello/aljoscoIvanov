import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

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
  List<String> tags = [];

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

  void updateInstruction(int index, String text) {
    instructions[index].text = text;
    notifyListeners();
  }

  void addIngredient() {
    ingredients.add(Ingredient());
    notifyListeners();
  }

  void updateIngredient(int index, {String? name, String? quantity, String? unit}) {
    if (name != null) ingredients[index].name = name;
    if (quantity != null) ingredients[index].quantity = quantity;
    if (unit != null) ingredients[index].unit = unit;
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

  void saveRecipe() {
    // Implement save logic
    print('Recipe saved!');
    print('Name: $recipeName');
    print('Servings: $servings');
    print('Cooking Mode: $selectedCookingMode');
  }
}

class InstructionStep {
  String text = '';
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  Color textColor = Colors.black;
}

class Ingredient {
  String name = '';
  String quantity = '';
  String unit = 'Unit';
}

class NutritionalValue {
  String name = '';
  String quantity = '';
  String unit = 'Unit';

  NutritionalValue({this.name = '', this.quantity = '', this.unit = 'Unit'});
}