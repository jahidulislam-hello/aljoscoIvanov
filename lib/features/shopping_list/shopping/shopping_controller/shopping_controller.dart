import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../shopping_model/shopping_model.dart';
import '../shopping_service/shopping_service.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_service/meal_planner_service.dart';

class ShoppingController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var shoppingLists = <ShoppingModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Week dates for calendar
  var weekDates = <DateTime>[].obs;
  var selectedDateIndex = 3.obs; // Middle (today)
  var currentMonth = ''.obs;

  // Track dates with meal plans and shopping lists
  var datesWithMealPlans = <String>{}.obs;
  var datesWithShoppingLists = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeWeekDates();
    fetchShoppingLists();
  }

  /// Initialize week dates (today in the middle)
  void _initializeWeekDates() {
    final today = DateTime.now();
    weekDates.value = List.generate(7, (index) {
      return today.add(Duration(days: index - 3)); // -3 to +3 from today
    });
    currentMonth.value = _getMonthYear(weekDates[selectedDateIndex.value]);
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String getDayOfWeek(DateTime date) {
    const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return days[date.weekday - 1];
  }

  /// Helper to convert date to YYYY-MM-DD format
  String _toDateString(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Check if a date has a meal plan
  bool dateHasMealPlan(String dateStr) {
    return datesWithMealPlans.contains(dateStr);
  }

  /// Check if a date has a shopping list
  bool dateHasShoppingList(String dateStr) {
    return datesWithShoppingLists.contains(dateStr);
  }

  /// Update dates tracking based on shopping lists
  void _updateDatesTracking() {
    datesWithShoppingLists.clear();

    for (var item in shoppingLists) {
      if (item.date.isNotEmpty) {
        try {
          final date = DateTime.parse(item.date);
          final dateStr = _toDateString(date);
          datesWithShoppingLists.add(dateStr);
        } catch (e) {
          debugPrint('Error parsing date: ${item.date}');
        }
      }
    }

    datesWithShoppingLists.refresh();
    debugPrint('📅 Dates with shopping lists: ${datesWithShoppingLists.toList()}');
  }

  /// Select a date from the calendar
  void selectDate(int index) {
    selectedDateIndex.value = index;
    selectedDate.value = weekDates[index];
    currentMonth.value = _getMonthYear(weekDates[index]);
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

        // Update dates tracking
        _updateDatesTracking();

        // Also try to get meal plan dates
        await _fetchMealPlanDates();
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

  /// Fetch meal plan dates for the week
  Future<void> _fetchMealPlanDates() async {
    try {
      debugPrint('📅 Fetching meal plan dates for the week...');
      datesWithMealPlans.clear();

      // Fetch meal plans for all dates in parallel for better performance
      final futures = weekDates.map((date) async {
        final dateStr = _toDateString(date);

        try {
          final response = await MealPlannerService.getMealPlan(dateStr);

          if (response['success'] == true && response['data'] != null) {
            final List<dynamic> mealPlans = response['data'];

            // If there are meal plans for this date, return the date string
            if (mealPlans.isNotEmpty) {
              debugPrint('   ✅ Date $dateStr has ${mealPlans.length} meal plan(s)');
              return dateStr;
            }
          }
        } catch (e) {
          debugPrint('   ⚠️ Could not fetch meal plan for $dateStr: $e');
        }
        return null;
      }).toList();

      // Wait for all requests to complete
      final results = await Future.wait(futures);

      // Add non-null results to the set
      for (var dateStr in results) {
        if (dateStr != null) {
          datesWithMealPlans.add(dateStr);
        }
      }

      datesWithMealPlans.refresh();
      debugPrint('📅 Dates with meal plans: ${datesWithMealPlans.toList()}');
    } catch (e) {
      debugPrint('⚠️ Could not fetch meal plan dates: $e');
    }
  }

  /// Change selected date and optionally filter lists
  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
    // You can add date filtering logic here if needed
  }

  /// Select a date from calendar picker and update week view
  void selectDateFromCalendar(DateTime pickedDate) {
    selectedDate.value = pickedDate;

    // Update week dates to center around the picked date
    weekDates.value = List.generate(7, (index) {
      return pickedDate.add(Duration(days: index - 3)); // -3 to +3 from picked date
    });

    // Set selected index to middle (the picked date)
    selectedDateIndex.value = 3;

    // Update month display
    currentMonth.value = _getMonthYear(pickedDate);

    // Refresh meal plan dates for new week
    _fetchMealPlanDates();
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
