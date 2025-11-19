// import 'package:get/get.dart';
// import '../../../core/utils/app_images.dart';
// import '../model/recipe_details_model.dart';
//
// class RecipeDetailsController extends GetxController {
//   late RecipeDetailsModel recipe;
//
//   var isDescriptionExpanded = false.obs;
//   var isIngredientsExpanded = true.obs;
//   var isInstructionExpanded = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadRecipe();
//   }
//
//   void loadRecipe() {
//     recipe = RecipeDetailsModel(
//       title: "Shakshuka",
//       description:
//       "Saeem upsum dolor sit amet, consectetur adipiscing elit. Nam vulputate leo ex volutpat tincidunt.",
//       image: AppImages.shakshukaMain,
//       rating: 4.8,
//       gallery: [
//         AppImages.shakshukaMain,
//         AppImages.shakshukaThumb1,
//         AppImages.shakshukaThumb2,
//       ],
//       ingredients: [
//         {"Olive oil": "2 tbsp"},
//         {"Onion": "1 pc"},
//         {"Ground cumin": "1 tsp"},
//         {"Paprika": "1 can"},
//         {"Parsley": "1/4 cup"},
//         {"Eggs": "4 large"},
//       ],
//       totalTime: "50 min",
//       prepTime: "20 min",
//       cookTime: "30 min",
//       instructionVideo: AppImages.instructionVideo,
//       instructions: [
//         "Chop vegetables finely.",
//         "Cook onions and spices until fragrant.",
//         "Add tomatoes and simmer.",
//         "Crack eggs on top and cook until set."
//       ],
//     );
//   }
// }
