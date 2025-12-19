// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:freshbite/core/themes/app_colors.dart';
// // import 'package:freshbite/core/themes/text_styles.dart';
// // import 'package:freshbite/features/recepies/details_recipes/details_recipes_controller/details_recipes_controller.dart';
// // import 'package:get/get.dart';
// //
// //
// // class RecipeDetailsScreen extends StatelessWidget {
// //   final RecipeDetailsController controller = Get.put(RecipeDetailsController());
// //
// //   RecipeDetailsScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.background,
// //       appBar: AppBar(
// //         backgroundColor: AppColors.background,
// //         elevation: 0,
// //         leading: Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
// //         title: Text("Recipe Details", style: AppTextStyles.H6_Regular),
// //         centerTitle: true,
// //         actions: [
// //           Icon(Icons.share_outlined, color: AppColors.textPrimary),
// //           SizedBox(width: 10.w),
// //           Icon(Icons.favorite_border, color: AppColors.textPrimary),
// //           SizedBox(width: 12.w),
// //         ],
// //       ),
// //       body: SingleChildScrollView(
// //         padding: EdgeInsets.symmetric(horizontal: 16.w),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             _buildImageSection(),
// //             SizedBox(height: 12.h),
// //             _buildTitleSection(),
// //             _buildDescriptionSection(),
// //             SizedBox(height: 16.h),
// //             _buildIngredientsSection(),
// //             SizedBox(height: 16.h),
// //             _buildPreparationSection(),
// //             SizedBox(height: 16.h),
// //             _buildInstructionSection(),
// //             SizedBox(height: 16.h),
// //             _buildNutritionalSection(),
// //             SizedBox(height: 32.h),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildImageSection() {
// //     return Column(
// //       children: [
// //         ClipRRect(
// //           borderRadius: BorderRadius.circular(12.r),
// //           child: Image.asset(controller.recipe.image, height: 180.h, width: double.infinity, fit: BoxFit.cover),
// //         ),
// //         SizedBox(height: 8.h),
// //         SizedBox(
// //           height: 60.h,
// //           child: ListView.separated(
// //             scrollDirection: Axis.horizontal,
// //             itemCount: controller.recipe.gallery.length,
// //             separatorBuilder: (_, __) => SizedBox(width: 8.w),
// //             itemBuilder: (_, index) {
// //               return ClipRRect(
// //                 borderRadius: BorderRadius.circular(8.r),
// //                 child: Image.asset(
// //                   controller.recipe.gallery[index],
// //                   width: 60.w,
// //                   height: 60.h,
// //                   fit: BoxFit.cover,
// //                 ),
// //               );
// //             },
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildTitleSection() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Text(controller.recipe.title, style: AppTextStyles.H5_Regular),
// //         Row(
// //           children: [
// //             Icon(Icons.star, color: AppColors.secondary, size: 18.sp),
// //             SizedBox(width: 4.w),
// //             Text(controller.recipe.rating.toString(), style: AppTextStyles.H6_Regular),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildDescriptionSection() {
// //     return Obx(() {
// //       return Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text("Description", style: AppTextStyles.H5_Regular),
// //           SizedBox(height: 4.h),
// //           Text(
// //             controller.recipe.description,
// //             maxLines: controller.isDescriptionExpanded.value ? null : 2,
// //             overflow: TextOverflow.fade,
// //             style: AppTextStyles.H6_Regular.copyWith(color: AppColors.textSecondary),
// //           ),
// //           TextButton(
// //             onPressed: () => controller.isDescriptionExpanded.toggle(),
// //             child: Text(
// //               controller.isDescriptionExpanded.value ? "Show less" : "Read more",
// //               style: AppTextStyles.H6_Regular.copyWith(color: AppColors.primary),
// //             ),
// //           ),
// //         ],
// //       );
// //     });
// //   }
// //
// //   Widget _buildIngredientsSection() {
// //     return Obx(() {
// //       return ExpansionTile(
// //         initiallyExpanded: controller.isIngredientsExpanded.value,
// //         onExpansionChanged: (val) => controller.isIngredientsExpanded(val),
// //         title: Text("Ingredients", style: AppTextStyles.H5_Regular),
// //         children: [
// //           Column(
// //             children: [
// //               ...controller.recipe.ingredients.map((item) {
// //                 final key = item.keys.first;
// //                 final value = item.values.first;
// //                 return Padding(
// //                   padding: EdgeInsets.symmetric(vertical: 4.h),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       Text(key, style: AppTextStyles.H6_Regular),
// //                       Text(value, style: AppTextStyles.H5_Regular),
// //                     ],
// //                   ),
// //                 );
// //               }).toList(),
// //               SizedBox(height: 12.h),
// //               ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: AppColors.primary,
// //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
// //                   minimumSize: Size(double.infinity, 40.h),
// //                 ),
// //                 onPressed: () {},
// //                 child: Text("Sign Up To Add Grocery", style: AppTextStyles.H6_Regular.copyWith(color: Colors.white)),
// //               ),
// //             ],
// //           ),
// //         ],
// //       );
// //     });
// //   }
// //
// //   Widget _buildPreparationSection() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text("Preparation", style: AppTextStyles.H6_Regular),
// //         SizedBox(height: 8.h),
// //         Container(
// //           padding: EdgeInsets.all(12.w),
// //           decoration: BoxDecoration(
// //             color: Colors.white,
// //             borderRadius: BorderRadius.circular(12.r),
// //             boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
// //           ),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               _buildPrepItem("Total Time", controller.recipe.totalTime),
// //               _buildPrepItem("Prep Time", controller.recipe.prepTime),
// //               _buildPrepItem("Cook Time", controller.recipe.cookTime),
// //             ],
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildPrepItem(String title, String value) {
// //     return Column(
// //       children: [
// //         Text(title, style: AppTextStyles.H6_Regular.copyWith(color: AppColors.textSecondary)),
// //         SizedBox(height: 4.h),
// //         Text(value, style: AppTextStyles.H5_Regular),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildInstructionSection() {
// //     return Obx(() {
// //       return ExpansionTile(
// //         initiallyExpanded: controller.isInstructionExpanded.value,
// //         onExpansionChanged: (val) => controller.isInstructionExpanded(val),
// //         title: Text("Instructions", style: AppTextStyles.H5_Regular),
// //         children: [
// //           Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildVideoPreview(),
// //               SizedBox(height: 8.h),
// //               ...controller.recipe.instructions.map(
// //                     (text) => Padding(
// //                   padding: EdgeInsets.only(bottom: 8.h),
// //                   child: Text("• $text", style: AppTextStyles.H6_Regular),
// //                 ),
// //               ),
// //               SizedBox(height: 12.h),
// //               ElevatedButton(
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: AppColors.primary,
// //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
// //                   minimumSize: Size(double.infinity, 40.h),
// //                 ),
// //                 onPressed: () {},
// //                 child: Text("SIGN UP TO SEE", style: AppTextStyles.H5_Regular.copyWith(color: Colors.white)),
// //               ),
// //             ],
// //           ),
// //         ],
// //       );
// //     });
// //   }
// //
// //   Widget _buildVideoPreview() {
// //     return Stack(
// //       alignment: Alignment.center,
// //       children: [
// //         ClipRRect(
// //           borderRadius: BorderRadius.circular(12.r),
// //           child: Image.asset(controller.recipe.instructionVideo,
// //               height: 180.h, width: double.infinity, fit: BoxFit.cover),
// //         ),
// //         Container(
// //           decoration: BoxDecoration(
// //             color: Colors.black45,
// //             shape: BoxShape.circle,
// //           ),
// //           child: Icon(Icons.play_arrow, size: 48.sp, color: Colors.white),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildNutritionalSection() {
// //     return ExpansionTile(
// //       title: Text("Nutritional Values", style: AppTextStyles.H5_Regular),
// //       children: [
// //         Padding(
// //           padding: EdgeInsets.all(8.w),
// //           child: Text(
// //             "Nutritional information about the recipe will appear here.",
// //             style: AppTextStyles.H5_Regular.copyWith(color: AppColors.textSecondary),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:freshbite/core/themes/app_colors.dart';
// import 'package:freshbite/core/themes/app_images.dart';
// import 'package:freshbite/core/themes/text_styles.dart';
// import 'package:freshbite/features/home/home_new/controller/recipe_controller.dart';
// import 'package:freshbite/features/recepies/recipes_details/recipes_details_controller/recipes_details_controller.dart';
// import 'package:get/get.dart';
//
//
// class RecipesDetailsScreen extends StatelessWidget {
//   final controller = Get.put(RecipesDetailsController());
//
//   RecipesDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         elevation: 0,
//         leading: Icon(Icons.arrow_back, color: AppColors.textPrimary),
//         title: Text('Recipe', style: AppTextStyles.bodySmall),
//         actions: [
//           Icon(Icons.share, color: AppColors.textPrimary),
//           SizedBox(width: 12.w),
//           Icon(Icons.favorite_border, color: AppColors.textPrimary),
//           SizedBox(width: 12.w),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         child: Obx(() {
//           final recipe = controller.recipe.value;
//           if (recipe == null) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(16.r),
//                 child: Image.asset(AppImages.sashuka, fit: BoxFit.cover),
//               ),
//               SizedBox(height: 16.h),
//
//               // Title + Rating
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(recipe.title ?? '', style: AppTextStyles.body),
//                   Row(children: [
//                     Icon(Icons.star, color: Colors.amber, size: 18.sp),
//                     Text("${recipe.rating}", style: AppTextStyles.bodySmall),
//                   ]),
//                 ],
//               ),
//               SizedBox(height: 8.h),
//
//               Text(recipe.description ?? '', style: AppTextStyles.bodyLarge),
//               SizedBox(height: 16.h),
//
//               // Allergens
//               _buildExpandableSection(
//                 title: "Allergens",
//                 key: "allergens",
//                 content: Wrap(
//                   spacing: 8.w,
//                   children: recipe.allergens
//                       .map((a) => Chip(
//                     label: Text(a, style: AppTextStyles.bodySmall),
//                     backgroundColor: AppColors.background,
//                   ))
//                       .toList(),
//                 ),
//               ),
//
//               // Ingredients
//               _buildExpandableSection(
//                 title: "Ingredients",
//                 key: "ingredients",
//                 content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: recipe.ingredients
//                       .map((item) => Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(item.keys.first, style: AppTextStyles.body),
//                       Text(item.values.first,
//                           style: AppTextStyles.bodyLarge),
//                     ],
//                   ))
//                       .toList(),
//                 ),
//               ),
//
//               SizedBox(height: 16.h),
//               _buildTimerSection(),
//               SizedBox(height: 16.h),
//
//               // Skills
//               _buildExpandableSection(
//                 title: "Skills Required",
//                 key: "skills",
//                 content: Column(
//                   children: recipe.skills
//                       .map((skill) => ListTile(
//                     title: Text(skill, style: AppTextStyles.body),
//                     dense: true,
//                   ))
//                       .toList(),
//                 ),
//               ),
//
//               // Instructions
//               _buildExpandableSection(
//                 title: "Instructions",
//                 key: "instructions",
//                 content: Column(
//                   children: recipe.instructions
//                       .asMap()
//                       .entries
//                       .map((entry) => Card(
//                     margin: EdgeInsets.symmetric(vertical: 4.h),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.r)),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: AppColors.primary,
//                         child: Text("${entry.key + 1}",
//                             style: AppTextStyles.bodyLarge
//                                 .copyWith(color: Colors.white)),
//                       ),
//                       title: Text(entry.value,
//                           style: AppTextStyles.body),
//                     ),
//                   ))
//                       .toList(),
//                 ),
//               ),
//
//               SizedBox(height: 16.h),
//               _buildNotesSection(),
//               SizedBox(height: 32.h),
//             ],
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _buildExpandableSection({
//     required String title,
//     required String key,
//     required Widget content,
//   }) {
//     return Obx(() {
//       final expanded = controller.isExpanded[key] ?? false;
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ListTile(
//             title: Text(title, style: AppTextStyles.bioText),
//             trailing: Icon(
//               expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//               color: AppColors.textPrimary,
//             ),
//             onTap: () => controller.toggleExpand(key),
//           ),
//           if (expanded)
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//               child: content,
//             ),
//         ],
//       );
//     });
//   }
//
//   Widget _buildTimerSection() {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(12.w),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12.r),
//             color: AppColors.background,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: controller.recipe.value?.timeOverview.entries
//                 .map((e) => Column(
//               children: [
//                 Text(e.key, style: AppTextStyles.bodySmall),
//                 Text(e.value, style: AppTextStyles.bodyLarge),
//               ],
//             ))
//                 .toList() ?? [],
//           ),
//         ),
//         SizedBox(height: 10.h),
//         ElevatedButton(
//           onPressed: () {},
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             minimumSize: Size(double.infinity, 46.h),
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
//           ),
//           child:
//           Text("START TIMER", style: AppTextStyles.button.copyWith(color: Colors.white)),
//         )
//       ],
//     );
//   }
//
//   Widget _buildNotesSection() {
//     return _buildExpandableSection(
//       title: "Personal Notes",
//       key: "notes",
//       content: Column(
//         children: controller.recipe.value?.notes
//             .map((note) => ListTile(
//           leading: CircleAvatar(
//               backgroundImage: AssetImage(AppImages.appLogo)),
//           title: Text(note["name"]!, style: AppTextStyles.button),
//           subtitle: Text(note["note"]!, style: AppTextStyles.bodyLarge),
//         ))
//             .toList() ?? [],
//       ),
//     );
//   }
// }


















// // class RecipeDetailsModel {
// //   final String title;
// //   final String description;
// //   final String image;
// //   final double rating;
// //   final List<String> gallery;
// //   final List<Map<String, String>> ingredients;
// //   final String totalTime;
// //   final String prepTime;
// //   final String cookTime;
// //   final String instructionVideo;
// //   final List<String> instructions;
// //
// //   RecipeDetailsModel({
// //     required this.title,
// //     required this.description,
// //     required this.image,
// //     required this.rating,
// //     required this.gallery,
// //     required this.ingredients,
// //     required this.totalTime,
// //     required this.prepTime,
// //     required this.cookTime,
// //     required this.instructionVideo,
// //     required this.instructions,
// //   });
// // }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// class RecipesDetailsModel {
//   final String title;
//   final String description;
//   final List<String> tags;
//   final double rating;
//   final List<String> allergens;
//   final List<Map<String, String>> ingredients;
//   final Map<String, String> timeOverview;
//   final List<String> skills;
//   final List<String> instructions;
//   final Map<String, dynamic> nutrition;
//   final List<Map<String, String>> notes;
//
//   RecipesDetailsModel({
//     required this.title,
//     required this.description,
//     required this.tags,
//     required this.rating,
//     required this.allergens,
//     required this.ingredients,
//     required this.timeOverview,
//     required this.skills,
//     required this.instructions,
//     required this.nutrition,
//     required this.notes,
//   });
// }


















// // import 'package:freshbite/core/themes/app_images.dart';
// // import 'package:freshbite/features/recepies/details_recipes/details_recipes_model/details_recipes_model.dart';
// // import 'package:get/get.dart';
// //
// //
// // class RecipeDetailsController extends GetxController {
// //   late RecipeDetailsModel recipe;
// //
// //   var isDescriptionExpanded = false.obs;
// //   var isIngredientsExpanded = true.obs;
// //   var isInstructionExpanded = false.obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     loadRecipe();
// //   }
// //
// //   void loadRecipe() {
// //     recipe = RecipeDetailsModel(
// //       title: "Shakshuka",
// //       description:
// //       "Saeem upsum dolor sit amet, consectetur adipiscing elit. Nam vulputate leo ex volutpat tincidunt.",
// //       image: AppImages.sasuka,
// //       rating: 4.8,
// //       gallery: [
// //         AppImages.sasuka,
// //         AppImages.sasuka,
// //         AppImages.sasuka,
// //       ],
// //       ingredients: [
// //         {"Olive oil": "2 tbsp"},
// //         {"Onion": "1 pc"},
// //         {"Ground cumin": "1 tsp"},
// //         {"Paprika": "1 can"},
// //         {"Parsley": "1/4 cup"},
// //         {"Eggs": "4 large"},
// //       ],
// //       totalTime: "50 min",
// //       prepTime: "20 min",
// //       cookTime: "30 min",
// //       instructionVideo: AppImages.cook,
// //       instructions: [
// //         "Chop vegetables finely.",
// //         "Cook onions and spices until fragrant.",
// //         "Add tomatoes and simmer.",
// //         "Crack eggs on top and cook until set."
// //       ],
// //     );
// //   }
// // }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// import 'package:freshbite/features/recepies/recipes_details/recipes_details_model/recipes_details_model.dart';
// import 'package:get/get.dart';
//
//
// class RecipesDetailsController extends GetxController {
//   var servings = 4.obs;
//   var isExpanded = {
//     'allergens': false,
//     'ingredients': true,
//     'skills': false,
//     'instructions': true,
//     'notes': false,
//   }.obs;
//
//   var recipe = Rxn<RecipesDetailsModel>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     recipe.value = RecipesDetailsModel(
//       title: "Shakshuka",
//       description:
//       "A traditional North African and Middle Eastern dish with poached eggs in a spicy tomato sauce.",
//       tags: ["Lactose-free", "Protein", "Tomato", "Meal Prep", "Spring"],
//       rating: 4.5,
//       allergens: ["Peanuts", "Soy", "Mustard", "Milk (Lactose)"],
//       ingredients: [
//         {"Olive oil": "2 tbsp"},
//         {"Onion": "1 pc"},
//         {"Red bell pepper": "1 pc"},
//         {"Garlic cloves": "3 cloves"},
//         {"Eggs": "4 large"},
//       ],
//       timeOverview: {
//         "Total Time": "50 min",
//         "Prep Time": "20 min",
//         "Cook Time": "30 min",
//       },
//       skills: [
//         "Chopping Vegetables Evenly",
//         "Sautéing Aromatics",
//         "Layering Spices & Seasoning",
//         "Poaching Eggs in Sauce"
//       ],
//       instructions: [
//         "Heat oil and sauté onions.",
//         "Add spices and peppers.",
//         "Crack eggs into the sauce.",
//         "Simmer until eggs are cooked.",
//       ],
//       nutrition: {
//         "Energy": "970 kJ / 230 kcal",
//         "Fat": "13 g",
//         "Carbs": "14 g",
//         "Protein": "9 g",
//       },
//       notes: [
//         {
//           "name": "Olivia Afje",
//           "note":
//           "This recipe was amazing! I added extra chili powder for more spice.",
//         },
//         {
//           "name": "David Ro",
//           "note":
//           "Turned out great! Served it with pita bread and feta cheese.",
//         }
//       ],
//     );
//   }
//
//   void toggleExpand(String key) {
//     isExpanded[key] = !(isExpanded[key] ?? false);
//   }
//
//   void increaseServings() => servings.value++;
//   void decreaseServings() {
//     if (servings.value > 1) servings.value--;
//   }
// }









