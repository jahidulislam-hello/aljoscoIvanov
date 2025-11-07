import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_model.dart';
import 'package:get/get.dart';


class HomeController extends GetxController {
  var recipes = <HomeRecepieModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
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
        image: AppImages.meal,
        description: "Prepare your meals ahead of time.",
      ),
      HomeRecepieModel(
        title: "Emergency",
        category: "Fast Food",
        image: AppImages.emergency,
        description: "Quick and easy emergency meals.",
      ),
    ];
  }
}
