import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/features/home/favourites/favourites_model.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/select_meal_popup_model/select_meal_popup_model.dart';
import 'package:get/get.dart';


class SelectMealPopupController extends GetxController {
  var searchQuery = ''.obs;

  var recentFavorites = <SelectMealPopupModel>[
    SelectMealPopupModel(
        title: 'Crème Brulé',
        image: 'assets/icons/01.png',
        timeMinutes: 45,
        isFavorite: true),
    SelectMealPopupModel(
        title: 'Tomato Soup',
        image: 'assets/icons/02.png',
        timeMinutes: 45,
        isFavorite: true),
    SelectMealPopupModel(
        title: 'Tomato Soup',
        image: 'assets/icons/02.png',
        timeMinutes: 45,
        isFavorite: true),
  ].obs;

  void updateSearch(String value) {
    searchQuery.value = value;
  }

}







