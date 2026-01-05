import 'dart:convert';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  // Featured recipe (static Poutine card)
  var featuredRecipe = Rx<HomeRecepieModel?>(null);

  // API recipes for "Let's cook!" section
  var recipes = <HomeRecepieModel>[].obs;
  var prepList = <HomeRecepieModel>[].obs;
  var shoppingList = <HomeRecepieModel>[].obs;
  var isLoading = false.obs;

  final String assignedText = "Assigned to Aljoscha, on January 18, 2025";

  @override
  void onInit() {
    super.onInit();
    setFeaturedRecipe();
    fetchRecipes();
    fetchPrepList();
    fetchShoppingList();
  }

  // Set static featured recipe (Poutine)
  void setFeaturedRecipe() {
    featuredRecipe.value = HomeRecepieModel(
      title: "Poutine",
      category: "Newly added",
      image: AppImages.poutine,
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc vulputate libero et velit interdum.",
    );
  }

  Future<void> fetchRecipes() async {
    try {
      isLoading.value = true;

      // Get token from SharedPreferences
      final token = await SharedPreferencesHelper.getAccessToken();

      print("🔍 Fetching recipes from API...");
      print("   Token: ${token != null ? 'exists' : 'missing'}");

      final response = await http.get(
        Uri.parse(Urls.getAllRecipes),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["success"] == true && responseData["data"] != null) {
          List<dynamic> recipesJson = responseData["data"];

          // Convert API response to HomeRecepieModel list
          recipes.value = recipesJson
              .map((json) => HomeRecepieModel.fromJson(json))
              .toList();

          print("✅ Successfully fetched ${recipes.length} recipes");
        } else {
          print("❌ API returned success=false or no data");
        }
      } else {
        print("❌ Failed to fetch recipes: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching recipes: $e");
      // Keep empty list on error
    } finally {
      isLoading.value = false;
    }
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
