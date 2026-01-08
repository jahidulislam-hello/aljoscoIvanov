import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';
import 'package:freshbite/features/home/home_recipes/home_recepies_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // User profile data
  var userName = 'User'.obs;
  var userProfileImage = ''.obs;

  // Featured recipe (static Poutine card)
  var featuredRecipe = Rx<HomeRecepieModel?>(null);

  // API recipes for "Let's cook!" section
  var recipes = <HomeRecepieModel>[].obs;
  var prepList = <HomeRecepieModel>[].obs;
  var shoppingList = <HomeRecepieModel>[].obs;
  var isLoading = false.obs;

  var assignedText = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    setFeaturedRecipe();
    fetchRecipes();
    fetchPrepList();
    fetchShoppingList();
  }

  /// Fetch user profile from API
  Future<void> fetchUserProfile() async {
    try {
      debugPrint('📤 Fetching user profile...');

      final response = await HttpClient.get(
        Uri.parse('${Urls.baseUrl}/auth/get-my-profile'),
      );

      debugPrint('📥 Profile response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];

          userName.value = data['fullName'] ?? 'User';
          userProfileImage.value = data['profileImage'] ?? '';

          debugPrint('✅ User profile loaded: ${userName.value}');
        }
      }
    } catch (e) {
      debugPrint('❌ Error fetching user profile: $e');
      // Keep default values on error
    }
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

      debugPrint("🔍 Fetching recipes from API...");

      final response = await HttpClient.get(
        Uri.parse(Urls.getAllRecipes),
      );

      debugPrint("📥 Recipes response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData["success"] == true && responseData["data"] != null) {
          List<dynamic> recipesJson = responseData["data"];

          // Convert API response to HomeRecepieModel list
          recipes.value = recipesJson
              .map((json) => HomeRecepieModel.fromJson(json))
              .toList();

          debugPrint("✅ Successfully fetched ${recipes.length} recipes");
        } else {
          debugPrint("❌ API returned success=false or no data");
        }
      } else {
        debugPrint("❌ Failed to fetch recipes: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Error fetching recipes: $e");
      // Keep empty list on error
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch prep list from API
  Future<void> fetchPrepList() async {
    try {
      debugPrint('📤 Fetching prep list...');

      final response = await HttpClient.get(
        Uri.parse('${Urls.baseUrl}/preplist/get-prepList'),
      );

      debugPrint('📥 Prep list response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];

          // Extract prep list info
          final serving = data['serving'] ?? 0;
          final cooker = data['cooker'] ?? 'Unknown';
          final date = data['date'] ?? '';
          final recipes = data['recipes'] as List<dynamic>? ?? [];

          // Format date
          String formattedDate = '';
          if (date.isNotEmpty) {
            try {
              final dateTime = DateTime.parse(date);
              formattedDate = "${dateTime.day}.${dateTime.month}.${dateTime.year}";
            } catch (e) {
              formattedDate = date;
            }
          }

          // Update assigned text
          assignedText.value = "Assigned to $cooker${formattedDate.isNotEmpty ? ', on $formattedDate' : ''}";

          prepList.value = [
            HomeRecepieModel(
              title: "Prep List for $formattedDate",
              category: "",
              image: "",
              description: "Serving: $serving | Cooker: $cooker | Recipes: ${recipes.length}",
            ),
          ];

          debugPrint('✅ Prep list loaded');
        }
      }
    } catch (e) {
      debugPrint('❌ Error fetching prep list: $e');
      prepList.clear();
    }
  }

  /// Fetch shopping list from API
  Future<void> fetchShoppingList() async {
    try {
      debugPrint('📤 Fetching shopping lists...');

      final response = await HttpClient.get(
        Uri.parse('${Urls.baseUrl}/shopping/get-my-shopping-lists'),
      );

      debugPrint('📥 Shopping lists response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> data = responseData['data'];

          if (data.isNotEmpty) {
            // Get the first (most recent) shopping list
            final firstList = data.first;

            final title = firstList['title'] ?? 'Shopping List';
            final description = firstList['description'] ?? '';
            final coocker = firstList['coocker'] ?? 'Unknown';
            final coverImage = firstList['coverImages'] ?? '';
            final date = firstList['date'] ?? '';
            final isDone = firstList['isDone'] ?? false;

            // Format date
            String formattedDate = '';
            if (date.isNotEmpty) {
              try {
                final dateTime = DateTime.parse(date);
                formattedDate = "${dateTime.day}.${dateTime.month}.${dateTime.year}";
              } catch (e) {
                formattedDate = date;
              }
            }

            // Update assigned text for shopping
            if (assignedText.value.isEmpty) {
              assignedText.value = "Assigned to $coocker${formattedDate.isNotEmpty ? ', on $formattedDate' : ''}";
            }

            shoppingList.value = [
              HomeRecepieModel(
                title: title,
                category: isDone ? "Completed" : "Pending",
                image: coverImage.isNotEmpty ? coverImage : AppImages.everyday,
                description: description,
              ),
            ];

            debugPrint('✅ Shopping lists loaded: ${shoppingList.length}');
          } else {
            shoppingList.clear();
            debugPrint('ℹ️ No shopping lists found');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error fetching shopping lists: $e');
      shoppingList.clear();
    }
  }
}
