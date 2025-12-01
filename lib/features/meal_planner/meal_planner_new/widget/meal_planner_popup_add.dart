import 'package:flutter/material.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/meal_planner_all_model/meal_planner_all_model.dart';




// ============================================
// ADD PLANNING POPUP
// ============================================
class AddPlanningPopup extends StatefulWidget {
  final String recipeName;
  final String? recipeImage;
  final Function(List<MealPlanningItem>, List<PreparationItem>, String) onAddToMealPlan;

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
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'for "${widget.recipeName}"',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF757575),
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
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
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
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
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
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
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
                        onPressed: () {
                          widget.onAddToMealPlan(mealItems, prepItems, cookPerson);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2D4A2B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'ADD TO MEAL PLAN',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
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
                              color: Color(0xFFFF5252),
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
            fontWeight: FontWeight.w500,
            color: Color(0xFF757575),
          ),
        ),
        SizedBox(height: 6),
        Container(
          height: 40,
          child: TextField(
            onChanged: onChanged,
            style: TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: 12, color: Color(0xFFBDBDBD)),
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
