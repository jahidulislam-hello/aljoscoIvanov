import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shopping_model/shopping_model.dart';
import '../shopping_service/shopping_service.dart';

class ShoppingController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var shoppingLists = <ShoppingModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShoppingLists();
  }

  /// Fetch all shopping lists
  Future<void> fetchShoppingLists() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ShoppingService.getMyShoppingLists();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        shoppingLists.value = data
            .map((item) => ShoppingModel.fromJson(item))
            .toList();

        debugPrint('✅ Loaded ${shoppingLists.length} shopping lists');
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      debugPrint('❌ Error fetching shopping lists: $e');

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

  /// Change selected date and optionally filter lists
  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
    // You can add date filtering logic here if needed
  }

  /// Toggle finished status of a shopping list
  Future<void> toggleFinished(int index) async {
    try {
      final item = shoppingLists[index];
      final newStatus = !item.isDone;

      // Optimistic update
      shoppingLists[index] = item.copyWith(isDone: newStatus);

      // Call API to update
      await ShoppingService.updateShoppingList(
        id: item.id,
        isDone: newStatus,
      );

      debugPrint('✅ Shopping list status updated');
    } catch (e) {
      // Revert on error
      shoppingLists[index] = shoppingLists[index].copyWith(
        isDone: !shoppingLists[index].isDone,
      );

      debugPrint('❌ Error updating shopping list: $e');

      Get.snackbar(
        'Error',
        'Failed to update shopping list status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Refresh shopping lists
  Future<void> refreshShoppingLists() async {
    await fetchShoppingLists();
  }

  /// Get shopping lists filtered by selected date (optional)
  List<ShoppingModel> getFilteredLists() {
    // If you want to filter by date, implement logic here
    // For now, return all lists
    return shoppingLists;
  }
}
