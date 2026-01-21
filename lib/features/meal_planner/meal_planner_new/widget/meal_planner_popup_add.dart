import 'package:flutter/material.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_all_model/meal_planner_all_model.dart';

// ============================================
// ADD PLANNING POPUP
// ============================================
class AddPlanningPopup extends StatefulWidget {
  final String recipeName;
  final String? recipeImage;
  final Future<bool> Function(List<MealPlanningItem>, List<PreparationItem>, String) onAddToMealPlan;

  AddPlanningPopup({
    required this.recipeName,
    this.recipeImage,
    required this.onAddToMealPlan,
  });

  @override
  _AddPlanningPopupState createState() => _AddPlanningPopupState();
}

class _AddPlanningPopupState extends State<AddPlanningPopup> {
  List<MealPlanningItem> mealItems = [
    MealPlanningItem(day: '', meal: '', servings: ''),
    MealPlanningItem(day: '', meal: '', servings: ''),
  ];

  List<PreparationItem> prepItems = [
    PreparationItem(day: '', servings: ''),
  ];

  String cookPerson = '';
  bool isLoading = false;

  /// Validate meal items for duplicates
  String? _validateMealItems() {
    // Filter out empty items
    final validItems = mealItems.where((item) =>
    item.day.isNotEmpty && item.meal.isNotEmpty
    ).toList();

    if (validItems.isEmpty) {
      return 'Please add at least one meal with a day and meal type.';
    }

    // Check for duplicates (same day + same meal type)
    final seen = <String>{};
    for (var item in validItems) {
      final key = '${item.day.trim().toLowerCase()}_${item.meal.trim().toLowerCase()}';
      if (seen.contains(key)) {
        return 'Duplicate meal detected: "${item.meal}" on "${item.day}". Please use different meal types or dates.';
      }
      seen.add(key);
    }

    return null;
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Validation Error', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w700)),
        content: Text(message, style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adjust Planning Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                            fontFamily: 'Rubik',
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'for "${widget.recipeName}"',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF757575),
                            fontFamily: 'Rubik',
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF5252),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // When will you eat this
                    Text(
                      'When will you eat this and how much?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        fontFamily: 'Rubik',
                      ),
                    ),
                    SizedBox(height: 12),

                    // Meal Items
                    ...mealItems.asMap().entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildTextField('Day', 'e.g. Mo, 22.1.26', (val) {
                                mealItems[entry.key].day = val;
                              }),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: _buildTextField('Meal', 'e.g. Breakfast', (val) {
                                mealItems[entry.key].meal = val;
                              }),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: _buildTextField('Servings', 'e.g. 2', (val) {
                                mealItems[entry.key].servings = val;
                              }),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Add More Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          mealItems.add(MealPlanningItem(day: '', meal: '', servings: ''));
                        });
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xFFE0E0E0)),
                        ),
                        child: Icon(Icons.add, color: Color(0xFF757575), size: 24),
                      ),
                    ),

                    SizedBox(height: 24),

                    // When are you going to prepare
                    Text(
                      'When are you going to prepare this?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        fontFamily: 'Rubik',
                      ),
                    ),
                    SizedBox(height: 12),

                    // Prep Items
                    ...prepItems.asMap().entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildTextField('Day', 'e.g. Mo, 20.1.26', (val) {
                                prepItems[entry.key].day = val;
                              }),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: _buildTextField('Servings', 'e.g. 4', (val) {
                                prepItems[entry.key].servings = val;
                              }),
                            ),
                          ],
                        ),
                      );
                    }),

                    SizedBox(height: 24),

                    // Who will cook
                    Text(
                      'Who will cook this?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                        fontFamily: 'Rubik',
                      ),
                    ),
                    SizedBox(height: 12),

                    _buildTextField('Person', 'Alejandra rv nov', (val) {
                      cookPerson = val;
                    }),

                    SizedBox(height: 24),

                    // Add to Meal Plan Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                          // Validate before submitting
                          final validationError = _validateMealItems();
                          if (validationError != null) {
                            _showErrorDialog(validationError);
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          final success = await widget.onAddToMealPlan(
                              mealItems, prepItems, cookPerson);

                          setState(() {
                            isLoading = false;
                          });

                          if (success) {
                            Navigator.pop(context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Failed to Add Meal Plan', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w700)),
                                content: Text(
                                  'This recipe already exists in the meal plan for the selected date. Please choose a different date or recipe.',
                                  style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w700),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('OK', style: TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D4A2B),
                          disabledBackgroundColor: Color(0xFF2D4A2B).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : Text(
                          'ADD TO MEAL PLAN',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontFamily: 'Rubik',
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Delete Button
                    GestureDetector(
                      onTap: () {
                        // Handle delete
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline, color: Color(0xFFFF5252), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Delete this recipe from Meal Plan, Prep List and Shopping List',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFF5252),
                              fontFamily: 'Rubik',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF757575),
            fontFamily: 'Rubik',
          ),
        ),
        SizedBox(height: 6),
        Container(
          height: 40,
          child: TextField(
            onChanged: onChanged,
            style: TextStyle(fontSize: 13, color: Color(0xFF1A1A1A), fontFamily: 'Rubik', fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD), fontFamily: 'Rubik', fontWeight: FontWeight.w700),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF2D4A2B), width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}