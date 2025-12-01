
// ============================================
// SCREEN CLASS
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/core/widgets/custom_text_field.dart';
import 'package:freshbite/core/widgets/button.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/selact_meal_popup_screen/select_meal_popup_screen.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/select_meal_popup_model/select_meal_popup_model.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/widget/meal_planner_popup_add.dart';
import 'package:get/get.dart';

import '../meal_planner_all_controller/meal_planner_all_controller.dart';
import '../meal_planner_all_model/meal_planner_all_model.dart';

class AddMealPlanningScreen extends StatefulWidget {
  @override
  _MealPlanningScreenState createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<AddMealPlanningScreen> {
  final MealPlanController _controller = MealPlanController();

  // Selected date index
  int _selectedDateIndex = 3; // Default to 18th (index 3)
  final List<String> _days = ["15", "16", "17", "18", "19", "20", "21"];

  // Selected tab index (0 = BY RECIPE, 1 = BY CATEGORY)
  int _selectedTab = 0;

  // Comment text controller
  final TextEditingController _commentController = TextEditingController();

  // Prep list items checked state
  List<bool> _prepItemsChecked = [false, false, false];

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _showAddCommentPopup() {
    _commentController.clear();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.pureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Add a comment to your planned Meal.',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainTextColor,
                ),
              ),
              SizedBox(height: 16.h),
              // Comment text field
              CustomTextField(
                controller: _commentController,
                hintText: 'Write anything here...',
                keyboardType: 'multiline',
                boxHeight: 12,
              ),
              SizedBox(height: 16.h),
              // Post button
              CustomButton(
                text: 'Post',
                color: AppColors.buttonColor,
                onTap: () {
                  // Handle post comment
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 12.h),
              // Info text
              Text(
                'Your comment will be visible to all family members. Only you can remove it.',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFinishedPopup() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.pureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close icon - right corner
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: Color(0xFF757575),
                    size: 24,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Question text
              Text(
                'Are you done cooking this recipe?',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              // Buttons row
              Row(
                children: [
                  // Not Yet button (outline)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: AppColors.buttonColor, width: 1.5),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            'Not Yet',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.buttonColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Finished button (filled)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Handle finished action
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Text(
                            'Finished',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPlanningPopupWithRecipe(String mealId, SelectMealPopupModel selectedRecipe) {
    showDialog(
      context: context,
      builder: (context) => AddPlanningPopup(
        recipeName: selectedRecipe.title,
        recipeImage: selectedRecipe.image,
        onAddToMealPlan: (mealItems, prepItems, cookPerson) {
          // Add recipe to meal plan
          _controller.addRecipeToMeal(
            mealId,
            MealRecipe(
              name: selectedRecipe.title,
              servings: '${mealItems.first.servings} servings',
              imageUrl: selectedRecipe.image,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Meal Planner',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(
                imagePath: 'assets/icons/charm_menu.png',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Calendar Header Section
            _buildCalendarHeader(),

            // Tab Buttons
            _buildTabButtons(),

            SizedBox(height: 12.h),

            // Content based on selected tab
            if (_selectedTab == 0) ...[
              // MEAL PLAN Tab Content
              Expanded(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return ListView(
                      children: [
                        // Meal Sections
                        ..._controller.meals.map((meal) => _buildMealSection(meal)),

                        // Nutritional Values
                        _buildNutritionalSection(),
                      ],
                    );
                  },
                ),
              ),
            ] else ...[
              // PREP LIST Tab Content
              _buildPrepListHeader(),
              Expanded(
                child: _buildPrepListContent(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------- CALENDAR HEADER ----------------
  Widget _buildCalendarHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month selector row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      "January 2025",
                      style: AppTextStyles.heading1.copyWith(fontSize: 16.sp),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
                  ],
                ),
              ),
              PopupMenuButton<int>(
                icon: Icon(Icons.more_vert, color: AppColors.grey),
                color: AppColors.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      // Apply Saved Meal Plan
                      break;
                    case 1:
                      // Create Meal Plan
                      break;
                    case 2:
                      // Invite Family
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      'Apply Saved Meal Plan',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                  PopupMenuDivider(height: 1),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(
                      'Create Meal Plan',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                  PopupMenuDivider(height: 1),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text(
                      'Invite Family',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Weekday labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
                .map(
                  (e) => SizedBox(
                    width: 36.w,
                    child: Center(
                      child: Text(
                        e,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          SizedBox(height: 8.h),

          // Dates row (15–21)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              bool isSelected = i == _selectedDateIndex;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedDateIndex = i;
                  });
                },
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.buttonColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _days[i],
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14.sp,
                      color: isSelected ? Colors.white : AppColors.text,
                    ),
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 8.h),

          // Icons row under dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              return SizedBox(
                width: 36.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (i == _selectedDateIndex) ...[
                      Image.asset(AppImages.recipe_icon, width: 12.w, height: 12.h),
                      SizedBox(width: 2.w),
                      Image.asset(AppImages.shopping_icon, width: 12.w, height: 12.h),
                    ],
                  ],
                ),
              );
            }),
          ),

          SizedBox(height: 16.h),

        ],
      ),
    );
  }

  // ---------------- TAB BUTTONS ----------------
  Widget _buildTabButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                });
              },
              child: Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? AppColors.buttonColor
                      : Colors.transparent,
                  border: Border.all(color: AppColors.buttonColor),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.r),
                    bottomLeft: Radius.circular(8.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    "MEAL PLAN",
                    style: AppTextStyles.H6_Regular.copyWith(
                      color: _selectedTab == 0
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 1;
                });
              },
              child: Container(
                height: 42.h,
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? AppColors.buttonColor
                      : Colors.transparent,
                  border: Border.all(color: AppColors.buttonColor),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    "PREP LIST",
                    style: AppTextStyles.H6_Regular.copyWith(
                      color: _selectedTab == 1
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(MealSection meal) {
    return Container(
      margin: EdgeInsets.only(bottom: 1),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        meal.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: Wrap(
                          spacing: 4,
                          children: meal.tags.map((tag) {
                            return Text(
                              tag + (meal.tags.last != tag ? ', ' : ''),
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF757575),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _controller.toggleMealExpansion(meal.id),
                  child: Icon(
                    meal.isExpanded ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF757575),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Expandable Content
          if (meal.isExpanded) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe or Add Button
                  if (meal.recipe != null)
                    _buildRecipeCard(meal.recipe!, meal.id)
                  else
                    _buildAddRecipeButton(meal.id),

                  SizedBox(height: 16),

                  // Comments
                  if (meal.comments.isNotEmpty) ...[
                    ...meal.comments.map((comment) => Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: _buildCommentCard(comment),
                    )),
                  ],

                  // Comment Icon
                  GestureDetector(
                    onTap: () => _showAddCommentPopup(),
                    child: Image.asset(
                      AppImages.chatIcon, // your asset path
                      height: 24,
                      width: 24,
                      color: AppColors.buttonColor, // optional tint
                    ),
                  )

                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecipeCard(MealRecipe recipe, String mealId) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recipe Card with vertical layout
        Container(
          width: 100.w,
          height: 109.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with edit icon
              Stack(
                children: [
                  Container(
                    width: 100.w,
                    height: 72.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(8.r),
                      ),
                      color: Color(0xFFE0E0E0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(8.r),
                      ),
                      child: Image.asset(
                        recipe.imageUrl ?? '',
                        fit: BoxFit.cover,
                        width: 100.w,
                        height: 72.h,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Color(0xFFFF8C42),
                            child: Icon(Icons.restaurant, color: Colors.white, size: 28),
                          );
                        },
                      ),
                    ),
                  ),
                  // Edit icon
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: Container(
                      width: 18.w,
                      height: 18.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.edit, size: 10, color: Color(0xFF757575)),
                    ),
                  ),
                ],
              ),
              // Title and Servings
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        recipe.name,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        recipe.servings,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Color(0xFF757575),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 12.w),

        // Add Button
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            barrierColor: Colors.black54,
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: SelectMealPopup(
                onRecipeSelected: (selectedRecipe) {
                  _showAddPlanningPopupWithRecipe(mealId, selectedRecipe);
                },
              ),
            ),
          ),
          child: Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.buttonColor, width: 1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.add, color: Color(0xFF757575), size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildAddRecipeButton(String mealId) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (_) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: SelectMealPopup(
            onRecipeSelected: (selectedRecipe) {
              _showAddPlanningPopupWithRecipe(mealId, selectedRecipe);
            },
          ),
        ),
      ),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.buttonColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Color(0xFF757575), size: 20),
            SizedBox(width: 8),
            Text(
              'Add Recipe',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentCard(Comment comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: Color(0xFFE0E0E0),
            shape: BoxShape.circle,
          ),
          child: comment.avatarUrl != null
              ? ClipOval(
                  child: Image.asset(
                    comment.avatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, color: Color(0xFF9E9E9E), size: 16);
                    },
                  ),
                )
              : Icon(Icons.person, color: Color(0xFF9E9E9E), size: 16),
        ),
        SizedBox(width: 8.w),
        // Name and Date column
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.userName,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              comment.date,
              style: TextStyle(
                fontSize: 10.sp,
                color: Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
        SizedBox(width: 10.w),
        // Comment text box
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Color(0xFFE0E0E0), width: 1),
            ),
            child: Text(
              comment.message,
              style: TextStyle(
                fontSize: 12.sp,
                color: Color(0xFF424242),
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalSection() {
    return Container(
      margin: EdgeInsets.only(top: 1),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nutritional Values',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                GestureDetector(
                  onTap: () => _controller.toggleNutritionExpansion(),
                  child: Icon(
                    _controller.nutritionExpanded ? Icons.visibility : Icons.visibility_off,
                    color: Color(0xFF757575),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          if (_controller.nutritionExpanded) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total of 1 serving of each recipe on ${_days[_selectedDateIndex]}.1.25',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildNutritionRow('Energy (kJ / kcal)', '970 kJ / 230 kcal'),
                  _buildNutritionRow('Fat', '103 g'),
                  _buildNutritionRow('- of which Saturates', '32 g'),
                  _buildNutritionRow('Carbohydrate', '140 g'),
                  _buildNutritionRow('- of which Sugars', '90 g'),
                  _buildNutritionRow('Fibre', '40 g'),
                  _buildNutritionRow('Protein', '110 g'),
                  _buildNutritionRow('Salt', '9 g'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF424242),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PREP LIST HEADER ----------------
  Widget _buildPrepListHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recipes to prepare on ${_days[_selectedDateIndex]}.1.25',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Row(
            children: [
              Text(
                'Cooked by  ',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textLight,
                ),
              ),
              GestureDetector(
                onTap: () => _showFinishedPopup(),
                child: Text(
                  'Finished?',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.buttonColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- PREP LIST CONTENT ----------------
  Widget _buildPrepListContent() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      children: [
        // Prep list items
        _buildPrepListItem(0, 'Tomato Soup', '4 servings', 'assets/icons/02.png'),
        SizedBox(height: 12.h),
        _buildPrepListItem(1, 'Grilled Chicken', '2 servings', 'assets/icons/02.png'),
        SizedBox(height: 12.h),
        _buildPrepListItem(2, 'Caesar Salad', '3 servings', 'assets/icons/02.png'),
        SizedBox(height: 16.h),

        // Comments section for Prep List
        if (_controller.prepListComments.isNotEmpty) ...[
          ..._controller.prepListComments.map((comment) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _buildCommentCard(comment),
          )),
        ],

        // Comment Icon
        GestureDetector(
          onTap: () => _showAddCommentPopup(),
          child: Image.asset(
            AppImages.chatIcon, // your asset path
            height: 24,
            width: 24,
            color: AppColors.buttonColor, // optional tint
          ),
        ),

        SizedBox(height: 16.h),

        // Create shopping list button
        CustomButton(
          text: 'Create shopping list for ${_days[_selectedDateIndex]}.1.25',
          color: AppColors.buttonColor,
          onTap: () {
            // Handle create shopping list
          },
        ),
      ],
    );
  }

  // ---------------- PREP LIST ITEM ----------------
  Widget _buildPrepListItem(int index, String name, String servings, String imageUrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image Card
        Container(
          width: 100.w,
          height: 109.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with edit icon
              Stack(
                children: [
                  Container(
                    width: 100.w,
                    height: 72.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(8.r),
                      ),
                      color: Color(0xFFE0E0E0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(8.r),
                      ),
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: 100.w,
                        height: 72.h,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Color(0xFFFF8C42),
                            child: Icon(Icons.restaurant, color: Colors.white, size: 28),
                          );
                        },
                      ),
                    ),
                  ),
                  // Edit icon
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: Container(
                      width: 18.w,
                      height: 18.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.edit, size: 10, color: Color(0xFF757575)),
                    ),
                  ),
                ],
              ),
              // Title and Servings
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        servings,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Color(0xFF757575),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Spacer(),

        // Profile icon and Check icon
        Row(
          children: [
            // Profile icon
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, color: Color(0xFF9E9E9E), size: 18),
            ),
            SizedBox(width: 16.w),
            // Check icon (toggleable)
            GestureDetector(
              onTap: () {
                setState(() {
                  _prepItemsChecked[index] = !_prepItemsChecked[index];
                });
              },
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: _prepItemsChecked[index] ? AppColors.buttonColor : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _prepItemsChecked[index] ? AppColors.buttonColor : Color(0xFFE0E0E0),
                    width: 2,
                  ),
                ),
                child: _prepItemsChecked[index]
                    ? Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
