import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var recipes = <HomeRecepieModel>[].obs;
  var prepList = <HomeRecepieModel>[].obs;
  var shoppingList = <HomeRecepieModel>[].obs;

  final String assignedText = "Assigned to Aljoscha, on January 18, 2025";

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
    fetchPrepList();
    fetchShoppingList();
  }

  void fetchRecipes() {
    recipes.value = [
      HomeRecepieModel(
        title: "Poutine",
        category: "Newly added",
        image: AppImages.poutine,
        description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum.",
      ),
      HomeRecepieModel(
        title: "Everyday",
        category: "Everyday Meals",
        image: AppImages.everyday,
        description: "Quick daily dishes to enjoy easily.",
      ),
      HomeRecepieModel(
        title: "Meal Prep",
        category: "Weekly Prep",
        image: AppImages.everyday,
        description: "Prepare your meals ahead of time.",
      ),
      HomeRecepieModel(
        title: "Emergency",
        category: "Fast Food",
        image: AppImages.everyday,
        description: "Quick and easy emergency meals.",
      ),
    ];
  }

  void fetchPrepList() {
    prepList.value = [
      HomeRecepieModel(
        title: "Regular meal plan",
        category: "",
        image: "",
        description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
      ),
    ];
  }

  void fetchShoppingList() {
    shoppingList.value = [
      HomeRecepieModel(
        title: "Title of Shopping List",
        category: "",
        image: AppImages.everyday,
        description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry...",
      ),
    ];
  }
}
