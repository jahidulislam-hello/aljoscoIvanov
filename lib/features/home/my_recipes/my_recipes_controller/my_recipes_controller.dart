import 'package:freshbite/features/home/my_recipes/model.dart';
import 'package:get/get.dart';


class MyRecipesController extends GetxController {
  var searchQuery = ''.obs;

  var myRecipes = <MyRecipeModel>[
    MyRecipeModel(
        title: 'Crème Brulé',
        image: 'assets/icons/01.png',
        timeMinutes: 45,
        rating: 4.5,
        isFavorite: true),
    MyRecipeModel(
        title: 'Tomato Soup',
        image: 'assets/icons/02.png',
        timeMinutes: 30,
        rating: 4.0,
        isFavorite: true),
    MyRecipeModel(
        title: 'Tacos',
        image: 'assets/icons/03.png',
        timeMinutes: 25,
        rating: 5.0,
        isFavorite: true),
    MyRecipeModel(
        title: 'Mac And Cheese',
        image: 'assets/icons/04.png',
        timeMinutes: 40,
        rating: 4.0,
        isFavorite: true),
    MyRecipeModel(
        title: 'Tacos',
        image: 'assets/icons/03.png',
        timeMinutes: 25,
        rating: 5.0,
        isFavorite: true),
    MyRecipeModel(
        title: 'Tacos',
        image: 'assets/icons/03.png',
        timeMinutes: 25,
        rating: 5.0,
        isFavorite: true),
  ].obs;

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  List<MyRecipeModel> get filteredRecipes {
    if (searchQuery.isEmpty) return myRecipes;
    return myRecipes
        .where((r) => r.title.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
}
