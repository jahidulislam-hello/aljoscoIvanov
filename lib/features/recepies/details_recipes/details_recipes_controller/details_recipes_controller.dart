import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/features/recepies/details_recipes/details_recipes_model/details_recipes_model.dart';
import 'package:get/get.dart';


class RecipeDetailsController extends GetxController {
  late RecipeDetailsModel recipe;

  var isDescriptionExpanded = false.obs;
  var isIngredientsExpanded = true.obs;
  var isInstructionExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecipe();
  }

  void loadRecipe() {
    recipe = RecipeDetailsModel(
      title: "Shakshuka",
      description:
      "Saeem upsum dolor sit amet, consectetur adipiscing elit. Nam vulputate leo ex volutpat tincidunt.",
      image: AppImages.sasuka,
      rating: 4.8,
      gallery: [
        AppImages.sasuka,
        AppImages.sasuka,
        AppImages.sasuka,
      ],
      ingredients: [
        {"Olive oil": "2 tbsp"},
        {"Onion": "1 pc"},
        {"Ground cumin": "1 tsp"},
        {"Paprika": "1 can"},
        {"Parsley": "1/4 cup"},
        {"Eggs": "4 large"},
      ],
      totalTime: "50 min",
      prepTime: "20 min",
      cookTime: "30 min",
      instructionVideo: AppImages.cook,
      instructions: [
        "Chop vegetables finely.",
        "Cook onions and spices until fragrant.",
        "Add tomatoes and simmer.",
        "Crack eggs on top and cook until set."
      ],
    );
  }
}
