import 'package:freshbite/features/home/favourites/favourites_model.dart';
import 'package:get/get.dart';


class FavoritesController extends GetxController {
  var searchQuery = ''.obs;

  var recentFavorites = <FavouritesModel>[
    FavouritesModel(
        title: 'Crème Brulé',
        image: 'assets/icons/01.png',
        timeMinutes: 45,
        rating: 4.5,
        isFavorite: true),
    FavouritesModel(
        title: 'Tomato Soup',
        image: 'assets/icons/02.png',
        timeMinutes: 45,
        rating: 4.0,
        isFavorite: true),
  ].obs;

  var collections = [
    {'title': 'My Recipes', 'image': 'assets/icons/03.png'},
    {'title': 'Anniversary Dinner', 'image': 'assets/icons/04.png'},
    {'title': 'Family Lunch', 'image': 'assets/icons/05.png'},
    {'title': 'Dessert Lovers', 'image': 'assets/icons/06.png'},
  ].obs;

  void updateSearch(String value) {
    searchQuery.value = value;
  }
}
