import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:freshbite/features/recepies/create_recipes/create_recipes_service/create_recipes_service.dart';
import 'package:freshbite/features/home/cooking_skill/cooking_skill_service.dart';

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
    NutritionalValue(name: '', quantity: '', unit: 'kcal'),
    NutritionalValue(name: '', quantity: '', unit: 'g'),
  ];

  List<Map<String, dynamic>> availableSkills = [];
  List<String> selectedSkillIds = [];
  String recipeVideoUrl = '';
  File? recipeVideoFile;

  String allergens = '';
  String tagsInput = '';

  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  RecipeController() {
    fetchSkills();
  }

  Future<void> fetchSkills() async {
    try {
      final response = await CookingSkillService.getAllSkills();
      if (response['success'] == true && response['data'] != null) {
        availableSkills = List<Map<String, dynamic>>.from(response['data']);
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error fetching skills: $e');
    }
  }

  Future<void> pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      recipeVideoFile = File(video.path);
      notifyListeners();
    }
  }

  void toggleSkill(String skillId) {
    if (selectedSkillIds.contains(skillId)) {
      selectedSkillIds.remove(skillId);
    } else {
      selectedSkillIds.add(skillId);
    }
    notifyListeners();
  }

  void updateRecipeName(String value) {
    recipeName = value;
    notifyListeners();
  }

  Future<void> pickImage(int index) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
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

  Future<void> pickInstructionVideo(int index) async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      instructions[index].videoFile = File(video.path);
      notifyListeners();
    }
  }

  void addIngredient() {
    ingredients.add(Ingredient());
    notifyListeners();
  }

  void updateIngredient(int index, {String? name, String? quantity, String? quantity2, String? unit, String? unit2, String? category, String? manualInput}) {
    if (name != null) ingredients[index].name = name;
    if (quantity != null) ingredients[index].quantity = quantity;
    if (quantity2 != null) ingredients[index].quantity2 = quantity2;
    if (unit != null) ingredients[index].unit = unit;
    if (unit2 != null) ingredients[index].unit2 = unit2;
    if (category != null) ingredients[index].category = category;
    if (manualInput != null) ingredients[index].manualInput = manualInput;
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
    if (nutritionalValues.length > 2) {
      nutritionalValues.removeAt(index);
      notifyListeners();
    }
  }

  String _normalizeUnit(String unit) {
    final u = unit.trim().toLowerCase();
    if (u == 'piece' || u == 'pcs' || u == 'pcs.') return 'pcs';
    if (u == 'cloves') return 'cloves';
    if (u == 'g' || u == 'gram' || u == 'grams') return 'g';
    if (u == 'ml' || u == 'milliliter' || u == 'milliliters') return 'ml';
    if (u == 'tbsp' || u == 'tablespoon' || u == 'tablespoons') return 'tbsp';
    if (u == 'tsp' || u == 'teaspoon' || u == 'teaspoons') return 'tsp';
    if (u == 'pinch') return 'pinch';
    if (u == 'slice') return 'slice';
    if (u == 'handful') return 'handful';
    if (u == 'can') return 'can';
    if (u == 'cup') return 'cup';
    if (u.isEmpty) return 'g';
    return unit;
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

      // Get only non-null images
      final validImages =
          recipeImages.where((img) => img != null).cast<File>().toList();

      if (validImages.isEmpty) {
        print('❌ At least one image is required');
        return false;
      }

      isLoading = true;
      notifyListeners();

      // 1. Upload Images
      List<String> imageUrls = [];
      if (validImages.length == 1) {
        final url = await CreateRecipesService.uploadImage(validImages[0]);
        if (url != null) imageUrls.add(url);
      } else {
        final urls =
            await CreateRecipesService.uploadMultipleImages(validImages);
        if (urls != null) imageUrls = urls;
      }

      if (imageUrls.isEmpty) {
        print('❌ Image upload failed');
        isLoading = false;
        notifyListeners();
        return false;
      }

      // 2. Prepare data
      // Parse allergens (comma separated)
      final allergensList = allergens
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Parse tags (comma separated)
      final tagsList = tagsInput
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .take(10) // Maximum 10 tags
          .toList();

      // Build ingredients list matching API structure
      final ingredientsList =
          ingredients.where((ing) => ing.name.isNotEmpty).map((ing) {
        String unit = ing.unit.isNotEmpty ? ing.unit : 'g';
        if (unit == 'piece') unit = 'pcs';

        String unit2 = ing.unit2.isNotEmpty ? ing.unit2 : 'cup';
        if (unit2 == 'piece') unit2 = 'pcs';

        return {
          'name': ing.name,
          'unit': unit,
          'value': ing.quantity.isNotEmpty ? ing.quantity : '0',
          'categories': ing.category.isNotEmpty ? ing.category : 'Other',
          'household': {
            'unit': unit2,
            'value': ing.quantity2.isNotEmpty ? ing.quantity2 : '0',
          },
        };
      }).toList();

      // Build nutrition values list matching API structure
      final nutritionList =
          nutritionalValues.where((nutr) => nutr.name.isNotEmpty).map((nutr) => {
                'name': nutr.name,
                'unit': nutr.unit.isNotEmpty ? nutr.unit : 'g',
                'value': nutr.quantity.isNotEmpty ? nutr.quantity : '0',
              }).toList();

      // Build instructions list matching API structure
      // First, upload all instruction videos
      final finalInstructions = <Map<String, dynamic>>[];
      for (var inst in instructions) {
        if (inst.text.trim().isEmpty) continue;

        String? vUrl = inst.videoUrl;
        if (inst.videoFile != null) {
          final uploadedUrl =
              await CreateRecipesService.uploadVideo(inst.videoFile!);
          if (uploadedUrl != null) {
            vUrl = uploadedUrl;
          }
        }

        finalInstructions.add({
          'title': inst.text.trim(),
          'videoUrl': vUrl ?? '', // Server requires this
        });
      }

      // Build time object matching API structure
      final timeData = {
        'totalTime': totalTime.replaceAll(RegExp(r'[^0-9]'), ''),
        'prepTime': prepTime.replaceAll(RegExp(r'[^0-9]'), ''),
        'cookTime': cookTime.replaceAll(RegExp(r'[^0-9]'), ''),
      };

      // Map cooking mode to lowercase
      String cookingModeLower = selectedCookingMode.toLowerCase();
      if (cookingModeLower == 'mealprep') cookingModeLower = 'meal-prep';

      // 3. Call Create Recipe API
      await CreateRecipesService.createRecipe(
        title: recipeName.trim(),
        description: description.trim(),
        allergens: allergensList,
        tags: tagsList,
        serving: int.tryParse(servings.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1,
        ingredients: ingredientsList,
        nutritionValue: nutritionList,
        required_skill: selectedSkillIds,
        instruction: finalInstructions,
        time: timeData,
        cookingMode: cookingModeLower,
        images: imageUrls,
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
  File? videoFile;
  bool isBold = false;
  bool isItalic = false;
  bool isUnderline = false;
  Color textColor = Colors.black;
}

class Ingredient {
  String name = '';
  String quantity = '';
  String quantity2 = '';
  String unit = '';
  String unit2 = '';
  String category = '';
  String manualInput = '';
}

class NutritionalValue {
  String name = '';
  String quantity = '';
  String unit = '';

  NutritionalValue({this.name = '', this.quantity = '', this.unit = ''});
}