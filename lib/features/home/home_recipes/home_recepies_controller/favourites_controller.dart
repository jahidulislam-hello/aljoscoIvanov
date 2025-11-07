// import 'package:get/get.dart';
// import '../../../core/constants/app_images.dart';
// import '../models/favorite_model.dart';
//
// class FavoritesController extends GetxController {
//   var favorites = <FavoriteModel>[].obs;
//   var collections = <CollectionModel>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadFavorites();
//     loadCollections();
//   }
//
//   void loadFavorites() {
//     favorites.value = [
//       FavoriteModel(
//         title: 'Crème Brulé',
//         image: AppImages.cremeBrule,
//         duration: '45 min',
//         rating: 4.0,
//         isFavorite: true,
//       ),
//       FavoriteModel(
//         title: 'Tomato Soup',
//         image: AppImages.tomatoSoup,
//         duration: '45 min',
//         rating: 4.5,
//         isFavorite: true,
//       ),
//     ];
//   }
//
//   void loadCollections() {
//     collections.value = [
//       CollectionModel(title: 'My Recipes', image: AppImages.myRecipes),
//       CollectionModel(title: 'Anniversary Dinner', image: AppImages.anniversaryDinner),
//       CollectionModel(title: 'Healthy Lunch', image: AppImages.healthyLunch),
//       CollectionModel(title: 'Dessert Time', image: AppImages.dessertTime),
//     ];
//   }
// }
