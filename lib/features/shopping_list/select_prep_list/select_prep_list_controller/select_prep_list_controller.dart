import 'package:flutter/material.dart';
import 'package:freshbite/features/shopping_list/edit_shopping_list/edit_shopping_list_screen/edit_shopping_list_screen.dart';
import 'package:freshbite/features/shopping_list/select_prep_list/select_prep_list_model/prep_list_model.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_service/shopping_service.dart';
import 'package:get/get.dart';

class PrepListController extends GetxController {
  // MULTIPLE SELECTED INDEXES
  RxList<int> selectedIndexes = <int>[].obs;

  // PREP LISTS FROM API
  RxList<PrepListModel> prepLists = <PrepListModel>[].obs;

  // Loading state
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPrepLists();
  }

  /// Fetch all prep lists from API
  Future<void> fetchPrepLists() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ShoppingService.getAllPrepLists();

      if (response['success'] == true) {
        // Handle both single object and array responses
        if (response['data'] is List) {
          // If API returns an array of prep lists
          final List<dynamic> data = response['data'];
          prepLists.value = data
              .map((item) => PrepListModel.fromJson(item))
              .where((prep) => !prep.isDeleted) // Filter out deleted ones
              .toList();
        } else if (response['data'] is Map) {
          // If API returns a single prep list object
          final prepList = PrepListModel.fromJson(response['data']);
          if (!prepList.isDeleted) {
            prepLists.value = [prepList];
          }
        }

        // Sort by date (most recent first)
        prepLists.sort((a, b) {
          try {
            final dateA = DateTime.parse(a.date);
            final dateB = DateTime.parse(b.date);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });

        debugPrint('✅ Loaded ${prepLists.length} prep lists');
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      debugPrint('❌ Error fetching prep lists: $e');

      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh prep lists
  Future<void> refreshPrepLists() async {
    await fetchPrepLists();
  }

  // MULTI SELECT TOGGLE
  void toggleSelect(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
  }

  // Get selected prep lists
  List<PrepListModel> getSelectedPrepLists() {
    return selectedIndexes.map((index) => prepLists[index]).toList();
  }

  // NEXT ACTION
  void onNext() {
    if (selectedIndexes.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select at least one list!",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Get selected prep lists
    final selectedLists = getSelectedPrepLists();

    debugPrint('✅ Selected ${selectedLists.length} prep list(s)');

    // Navigate to EditShoppingListScreen with selected lists
    Get.to(() => EditShoppingListScreen(), arguments: {
      'selectedPrepLists': selectedLists,
    });
  }

  void onCancel() {
    Get.back();
  }
}
