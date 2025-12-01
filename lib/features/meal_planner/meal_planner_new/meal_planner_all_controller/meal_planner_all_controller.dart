
// ============================================
// CONTROLLER CLASS
// ============================================


import 'package:flutter/foundation.dart';

import '../meal_planner_all_model/meal_planner_all_model.dart';

class MealPlanController extends ChangeNotifier {
  List<MealSection> _meals = [];
  bool _nutritionExpanded = true;
  List<Comment> _prepListComments = [];

  MealPlanController() {
    _initializeMeals();
    _initializePrepListComments();
  }

  List<MealSection> get meals => _meals;
  bool get nutritionExpanded => _nutritionExpanded;
  List<Comment> get prepListComments => _prepListComments;

  void _initializeMeals() {
    _meals = [
      MealSection(
        id: 'breakfast',
        title: 'Breakfast',
        tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
        recipe: MealRecipe(
          name: 'Tomato Soup',
          servings: '4 servings',
          imageUrl: 'assets/tomato_soup.jpg',
        ),
        comments: [
          Comment(
            userName: 'Olivia elgv',
            date: 'May 18, 2025',
            message: 'This is dinner recipe please make it Less day. Lorem ipsum dolor sit amet, consectetur adipiscing elit class.',
            avatarUrl: 'assets/avatar.jpg',
          ),
        ],
        isExpanded: true,
      ),
      MealSection(
        id: 'snack1',
        title: 'Snack',
        tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
        comments: [
          Comment(
            userName: 'Olivia elgv',
            date: 'May 18, 2025',
            message: 'Eat leftover today, please.',
            avatarUrl: 'assets/avatar.jpg',
          ),
          Comment(
            userName: 'Olivia elgv',
            date: 'May 18, 2025',
            message: 'OK, we will.',
            avatarUrl: 'assets/avatar.jpg',
          ),
        ],
        isExpanded: true,
      ),
      MealSection(
        id: 'lunch',
        title: 'Lunch',
        tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
        recipe: MealRecipe(
          name: 'Tomato Soup',
          servings: '4 servings',
          imageUrl: 'assets/tomato_soup.jpg',
        ),
        isExpanded: true,
      ),
      MealSection(
        id: 'snack2',
        title: 'Snack',
        tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
        isExpanded: false,
      ),
      MealSection(
        id: 'dinner',
        title: 'Dinner',
        tags: ['Base', 'Vegetable', 'Protein', 'Connector', 'Topping'],
        recipe: MealRecipe(
          name: 'Tomato Soup',
          servings: '4 servings',
          imageUrl: 'assets/tomato_soup.jpg',
        ),
        isExpanded: true,
      ),
    ];
  }

  void toggleMealExpansion(String mealId) {
    final index = _meals.indexWhere((meal) => meal.id == mealId);
    if (index != -1) {
      _meals[index].isExpanded = !_meals[index].isExpanded;
      notifyListeners();
    }
  }

  void toggleNutritionExpansion() {
    _nutritionExpanded = !_nutritionExpanded;
    notifyListeners();
  }

  void addRecipeToMeal(String mealId, MealRecipe recipe) {
    final index = _meals.indexWhere((meal) => meal.id == mealId);
    if (index != -1) {
      _meals[index].recipe = recipe;
      notifyListeners();
    }
  }

  void _initializePrepListComments() {
    _prepListComments = [
      Comment(
        userName: 'Olivia elgv',
        date: 'May 18, 2025',
        message: 'Please prepare these recipes before dinner time.',
        avatarUrl: 'assets/avatar.jpg',
      ),
    ];
  }

  void addPrepListComment(Comment comment) {
    _prepListComments.add(comment);
    notifyListeners();
  }
}