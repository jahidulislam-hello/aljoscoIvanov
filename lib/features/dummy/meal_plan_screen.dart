// import 'package:flutter/material.dart';
//
//
//
// // ============================================
// // MODEL CLASS
// // ============================================
// class Comment {
//   final String userName;
//   final String date;
//   final String message;
//   final String? avatarUrl;
//
//   Comment({
//     required this.userName,
//     required this.date,
//     required this.message,
//     this.avatarUrl,
//   });
// }
//
// class MealRecipe {
//   final String name;
//   final String servings;
//   final String? imageUrl;
//
//   MealRecipe({
//     required this.name,
//     required this.servings,
//     this.imageUrl,
//   });
// }
//
// class MealSection {
//   final String id;
//   final String title;
//   final List<String> tags;
//   final MealRecipe? recipe;
//   final List<Comment> comments;
//   bool isExpanded;
//
//   MealSection({
//     required this.id,
//     required this.title,
//     required this.tags,
//     this.recipe,
//     this.comments = const [],
//     this.isExpanded = true,
//   });
// }
//
// // ============================================
// // CONTROLLER CLASS
// // ============================================
//
//
// class MealPlanController extends ChangeNotifier {
//   List<MealSection> _meals = [];
//   bool _nutritionExpanded = true;
//
//   MealPlanController() {
//     _initializeMeals();
//   }
//
//   List<MealSection> get meals => _meals;
//   bool get nutritionExpanded => _nutritionExpanded;
//
//   void _initializeMeals() {
//     _meals = [
//       MealSection(
//         id: 'breakfast',
//         title: 'Breakfast',
//         tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
//         recipe: MealRecipe(
//           name: 'Tomato Soup',
//           servings: '4 servings',
//           imageUrl: 'assets/tomato_soup.jpg',
//         ),
//         comments: [
//           Comment(
//             userName: 'Olivia elgv',
//             date: 'May 18, 2025',
//             message: 'This is dinner recipe please make it Less day. Lorem ipsum dolor sit amet, consectetur adipiscing elit class.',
//             avatarUrl: 'assets/avatar.jpg',
//           ),
//         ],
//         isExpanded: true,
//       ),
//       MealSection(
//         id: 'snack1',
//         title: 'Snack',
//         tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
//         comments: [
//           Comment(
//             userName: 'Olivia elgv',
//             date: 'May 18, 2025',
//             message: 'Eat leftover today, please.',
//             avatarUrl: 'assets/avatar.jpg',
//           ),
//           Comment(
//             userName: 'Olivia elgv',
//             date: 'May 18, 2025',
//             message: 'OK, we will.',
//             avatarUrl: 'assets/avatar.jpg',
//           ),
//         ],
//         isExpanded: true,
//       ),
//       MealSection(
//         id: 'lunch',
//         title: 'Lunch',
//         tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
//         recipe: MealRecipe(
//           name: 'Tomato Soup',
//           servings: '4 servings',
//           imageUrl: 'assets/tomato_soup.jpg',
//         ),
//         isExpanded: true,
//       ),
//       MealSection(
//         id: 'snack2',
//         title: 'Snack',
//         tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
//         isExpanded: false,
//       ),
//       MealSection(
//         id: 'dinner',
//         title: 'Dinner',
//         tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
//         recipe: MealRecipe(
//           name: 'Tomato Soup',
//           servings: '4 servings',
//           imageUrl: 'assets/tomato_soup.jpg',
//         ),
//         isExpanded: true,
//       ),
//     ];
//   }
//
//   void toggleMealExpansion(String mealId) {
//     final index = _meals.indexWhere((meal) => meal.id == mealId);
//     if (index != -1) {
//       _meals[index].isExpanded = !_meals[index].isExpanded;
//       notifyListeners();
//     }
//   }
//
//   void toggleNutritionExpansion() {
//     _nutritionExpanded = !_nutritionExpanded;
//     notifyListeners();
//   }
// }
//
// // ============================================
// // SCREEN CLASS
// // ============================================
// class MealPlanningScreen extends StatefulWidget {
//   @override
//   _MealPlanningScreenState createState() => _MealPlanningScreenState();
// }
//
// class _MealPlanningScreenState extends State<MealPlanningScreen> {
//   final MealPlanController _controller = MealPlanController();
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF5F5F5),
//       body: SafeArea(
//         child: AnimatedBuilder(
//           animation: _controller,
//           builder: (context, child) {
//             return ListView(
//               children: [
//                 // Meal Sections
//                 ..._controller.meals.map((meal) => _buildMealSection(meal)),
//
//                 // Nutritional Values
//                 _buildNutritionalSection(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMealSection(MealSection meal) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 1),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header
//           Padding(
//             padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Row(
//                     children: [
//                       Text(
//                         meal.title,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                       SizedBox(width: 24),
//                       Expanded(
//                         child: Wrap(
//                           spacing: 4,
//                           children: meal.tags.map((tag) {
//                             return Text(
//                               tag + (meal.tags.last != tag ? ', ' : ''),
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Color(0xFF757575),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => _controller.toggleMealExpansion(meal.id),
//                   child: Icon(
//                     meal.isExpanded ? Icons.visibility : Icons.visibility_off,
//                     color: Color(0xFF757575),
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           // Expandable Content
//           if (meal.isExpanded) ...[
//             Padding(
//               padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Recipe or Add Button
//                   if (meal.recipe != null)
//                     _buildRecipeCard(meal.recipe!)
//                   else
//                     _buildAddRecipeButton(),
//
//                   SizedBox(height: 16),
//
//                   // Comments
//                   if (meal.comments.isNotEmpty) ...[
//                     ...meal.comments.map((comment) => Padding(
//                       padding: EdgeInsets.only(bottom: 12),
//                       child: _buildCommentCard(comment),
//                     )),
//                   ],
//
//                   // Comment Icon
//                   GestureDetector(
//                     onTap: () {},
//                     child: Icon(
//                       Icons.chat_bubble_outline,
//                       color: Color(0xFF757575),
//                       size: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecipeCard(MealRecipe recipe) {
//     return Row(
//       children: [
//         // Image with edit icon
//         Stack(
//           children: [
//             Container(
//               width: 72,
//               height: 72,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Color(0xFFE0E0E0),
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.asset(
//                   recipe.imageUrl ?? '',
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: Color(0xFFFF8C42),
//                       child: Icon(Icons.restaurant, color: Colors.white, size: 32),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 4,
//               right: 4,
//               child: Container(
//                 width: 20,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Icon(Icons.edit, size: 12, color: Color(0xFF757575)),
//               ),
//             ),
//           ],
//         ),
//
//         SizedBox(width: 12),
//
//         // Recipe Info
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 recipe.name,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF1A1A1A),
//                 ),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 recipe.servings,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Color(0xFF757575),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         SizedBox(width: 12),
//
//         // Add Button
//         Container(
//           width: 48,
//           height: 48,
//           decoration: BoxDecoration(
//             border: Border.all(color: Color(0xFFE0E0E0), width: 1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(Icons.add, color: Color(0xFF757575), size: 20),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAddRecipeButton() {
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(
//         border: Border.all(color: Color(0xFFE0E0E0), width: 1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.add, color: Color(0xFF757575), size: 20),
//           SizedBox(width: 8),
//           Text(
//             'Add Recipe',
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF757575),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCommentCard(Comment comment) {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Color(0xFFF9F9F9),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Avatar
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: Color(0xFFE0E0E0),
//               shape: BoxShape.circle,
//             ),
//             child: comment.avatarUrl != null
//                 ? ClipOval(
//               child: Image.asset(
//                 comment.avatarUrl!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Icon(Icons.person, color: Color(0xFF9E9E9E), size: 20);
//                 },
//               ),
//             )
//                 : Icon(Icons.person, color: Color(0xFF9E9E9E), size: 20),
//           ),
//
//           SizedBox(width: 12),
//
//           // Comment Content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       comment.userName,
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1A1A1A),
//                       ),
//                     ),
//                     Text(
//                       comment.date,
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Color(0xFF9E9E9E),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   comment.message,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF424242),
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNutritionalSection() {
//     return Container(
//       margin: EdgeInsets.only(top: 1),
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Nutritional Values',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF1A1A1A),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () => _controller.toggleNutritionExpansion(),
//                   child: Icon(
//                     _controller.nutritionExpanded ? Icons.visibility : Icons.visibility_off,
//                     color: Color(0xFF757575),
//                     size: 20,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           if (_controller.nutritionExpanded) ...[
//             Padding(
//               padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Total of 1 serving of each recipe on 18.1.25',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Color(0xFF9E9E9E),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   _buildNutritionRow('Energy (kJ / kcal)', '970 kJ / 230 kcal'),
//                   _buildNutritionRow('Fat', '103 g'),
//                   _buildNutritionRow('- of which Saturates', '32 g'),
//                   _buildNutritionRow('Carbohydrate', '140 g'),
//                   _buildNutritionRow('- of which Sugars', '90 g'),
//                   _buildNutritionRow('Fibre', '40 g'),
//                   _buildNutritionRow('Protein', '110 g'),
//                   _buildNutritionRow('Salt', '9 g'),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNutritionRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 13,
//               color: Color(0xFF424242),
//             ),
//           ),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }