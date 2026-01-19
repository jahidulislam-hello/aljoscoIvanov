import 'dart:async';
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

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  var isSearching = false.obs;
  var isSearchLoading = false.obs;
  var searchResults = <HomeRecepieModel>[].obs;
  var searchQuery = ''.obs;
  var searchPage = 1.obs;
  var searchLimit = 10.obs;
  var totalSearchResults = 0.obs;
  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    setFeaturedRecipe(); // Set static data immediately
    _fetchAllData(); // Fetch all data in parallel

    // Listen to search text changes with debounce
    searchController.addListener(_onSearchChanged);
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  /// Debounced search listener
  void _onSearchChanged() {
    final query = searchController.text.trim();

    // Cancel previous timer
    _debounceTimer?.cancel();

    if (query.isEmpty) {
      // Clear search results and show default view
      isSearching.value = false;
      searchResults.clear();
      searchQuery.value = '';
      return;
    }

    // Set debounce timer (500ms delay)
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      searchQuery.value = query;
      isSearching.value = true;
      searchPage.value = 1;
      searchRecipes(query);
    });
  }

  /// Search recipes from API
  Future<void> searchRecipes(String query, {bool loadMore = false}) async {
    if (query.isEmpty) return;

    try {
      isSearchLoading.value = true;

      if (!loadMore) {
        searchPage.value = 1;
        searchResults.clear();
      }

      debugPrint("🔍 Searching recipes: $query (page: ${searchPage.value})");

      final queryParams = {
        'search': query,
        'page': searchPage.value.toString(),
        'limit': searchLimit.value.toString(),
      };

      final uri = Uri.parse("${Urls.baseUrl}/recipe/get-all-recipe")
          .replace(queryParameters: queryParams);

      final response = await HttpClient.get(uri);

      debugPrint("📥 Search response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> recipesJson = responseData['data'];

          final recipes = recipesJson
              .map((json) => HomeRecepieModel.fromJson(json))
              .toList();

          if (loadMore) {
            searchResults.addAll(recipes);
          } else {
            searchResults.value = recipes;
          }

          // Update total from meta
          if (responseData['meta'] != null) {
            totalSearchResults.value = responseData['meta']['totalDocument'] ?? 0;
          }

          debugPrint("✅ Search results: ${searchResults.length} / ${totalSearchResults.value}");

          searchResults.refresh();
        }
      }
    } catch (e) {
      debugPrint("❌ Search error: $e");
    } finally {
      isSearchLoading.value = false;
    }
  }

  /// Load more search results
  Future<void> loadMoreSearchResults() async {
    if (isSearchLoading.value) return;
    if (searchResults.length >= totalSearchResults.value) return;

    searchPage.value++;
    await searchRecipes(searchQuery.value, loadMore: true);
  }

  /// Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    isSearching.value = false;
    searchResults.clear();
    searchPage.value = 1;
  }

  /// Fetch all data in parallel for faster loading
  Future<void> _fetchAllData() async {
    isLoading.value = true;
    try {
      // Run all API calls in parallel
      await Future.wait([
        fetchUserProfile(),
        fetchRecipes(),
        fetchPrepList(),
        fetchShoppingList(),
      ]);
    } catch (e) {
      debugPrint('❌ Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
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
