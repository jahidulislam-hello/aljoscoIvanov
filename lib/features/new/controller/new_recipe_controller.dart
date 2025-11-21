import 'package:freshbite/features/new/model/new_recipe_model.dart';


class SampleData {
  static Recipe getSampleRecipe() {
    return Recipe(
      id: '1',
      title: 'Shakshuka',
      description:
      'Shakshuka is a classic Middle Eastern and North African dish consisting of eggs poached in a spicy tomato and pepper sauce. It\'s traditionally served in a cast-iron skillet and makes for a hearty, flavorful meal.',
      imageUrl: 'assets/images/shasuka.png',
      images: [
        'assets/images/shasuka.png',
        'assets/images/shasuka.png',
        'assets/images/shasuka.png',
      ],
      rating: 4.5,
      reviewCount: 248,
      prepTime: Duration(minutes: 10),
      cookTime: Duration(minutes: 20),
      difficulty: 'Medium',
      servings: 4,
      allergens: ['Egg', 'Lactose', 'Fish', 'Lactose'],
      ingredients: [
        Ingredient(name: 'For 4 people', quantity: ''),
        Ingredient(name: 'Onion', quantity: '1pc'),
        Ingredient(name: 'Green pepper', quantity: '1pc'),
        Ingredient(name: 'Tomato', quantity: '4-5pcs'),
        Ingredient(name: 'Egg', quantity: '4-5pcs'),
        Ingredient(name: 'Food coloring', quantity: '1/4-cup'),
        Ingredient(name: 'Salt', quantity: 'To taste'),
        Ingredient(name: 'Ghee', quantity: '2-3 tsps'),
      ],
      instructions: [
        'If using sun-dried tomatoes, place them in a small bowl and cover with hot water. Let them soak for 5-10 minutes until softened, then drain and roughly chop.',
        'Heat the olive oil in a large, deep skillet or frying pan over medium heat. Add the chopped onion and cook for about 5 minutes, stirring occasionally, until softened.',
        'Add the minced garlic, diced bell pepper, cumin, paprika, and cayenne pepper (if using). Cook for another 2-3 minutes, stirring frequently, until the vegetables are tender and fragrant.',
        'Stir in the diced tomatoes, sun-dried tomatoes (if using), tomato paste, salt, and black pepper. Reduce the heat to low and let the sauce simmer for about 10 minutes, stirring occasionally, until it has thickened slightly.',
        'Using the back of a spoon, make 4-6 small wells in the sauce. Carefully crack an egg into each well. Season the eggs with a pinch of salt and pepper.',
        'Cover the skillet with a lid and cook for 5-8 minutes, or until the eggs are cooked to your desired level of doneness. For runny yolks, cook for about 5 minutes; for firmer yolks, cook for 7-8 minutes.',
        'Remove the skillet from heat and garnish with chopped fresh parsley or cilantro and crumbled feta cheese, if desired. Serve hot with crusty bread or pita for dipping.',
      ],
      nutritionInfo: NutritionInfo(
        calories: 218.8,
        protein: 13.3,
        carbs: 7.8,
        fat: 9.6,
      ),
      reviews: [
        Review(
          userName: 'Alanna D.',
          userImage: 'assets/images/profil.png',
          rating: 5.0,
          comment:
          'This was delicious! I used whole eggs instead of just egg whites and it was perfect. Will definitely make again.',
          date: DateTime.now().subtract(Duration(days: 2)),
        ),
      ],
    );
  }
}