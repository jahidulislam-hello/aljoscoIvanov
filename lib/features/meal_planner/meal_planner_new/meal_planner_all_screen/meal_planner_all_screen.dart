
// ============================================
// SCREEN CLASS
// ============================================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/navbar/controller/navbar_controller.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/core/widgets/custom_text_field.dart';
import 'package:freshbite/core/widgets/button.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/selact_meal_popup_screen/select_meal_popup_screen.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/select_meal_popup/select_meal_popup_model/select_meal_popup_model.dart';
import 'package:freshbite/features/meal_planner/meal_planner_new/widget/meal_planner_popup_add.dart';
import 'package:freshbite/features/meal_planner/reused_meal_plan/reused_meal_plan_screen/reused_meal_plan_screen.dart';
import 'package:freshbite/features/shopping_list/shopping/shopping_screen/shopping_screen.dart';
import 'package:freshbite/features/meal_planner/dialog/add_comment.dart';
import 'package:freshbite/features/meal_planner/dialog/multiple_dialog.dart';
import 'package:confetti/confetti.dart';
import 'package:get/get.dart';
import 'package:freshbite/features/splash/create_account/create_account_prompt.dart';
import 'package:freshbite/core/utils/shared_preference_helper.dart';

import '../meal_planner_all_controller/meal_planner_all_controller.dart';
import '../meal_planner_all_model/meal_planner_all_model.dart';

class AddMealPlanningScreen extends StatefulWidget {
  @override
  _MealPlanningScreenState createState() => _MealPlanningScreenState();
}

class _MealPlanningScreenState extends State<AddMealPlanningScreen> {
  late final MealPlanController _controller;
  late ConfettiController _confettiController;

  // Multi-select mode
  bool _isMultiSelectMode = false;
  List<int> _selectedDateIndices = [];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    // Ensure we use existing controller or create new one
    _controller = Get.isRegistered<MealPlanController>()
        ? Get.find<MealPlanController>()
        : Get.put(MealPlanController());
    _initializeDates();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Load meal plans from local storage for today's date
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Wait a bit for controller to finish loading from storage
      await Future.delayed(Duration(milliseconds: 300));

      final todayStr = _weekDates[_selectedDateIndex].toIso8601String().split('T')[0];
      print("📅 Initial date: $todayStr");

      // Fetch today's meal plans from API
      await _controller.fetchMealPlansForDate(todayStr);

      // Fetch meal plan and prep list status for all visible dates (for calendar icons)
      await _controller.fetchMealPlanStatusForDates(_weekDates);
      await _controller.fetchPrepListStatusForDates(_weekDates);

      print("✅ Loaded meal plans and prep lists for today and status for all dates");

      // Force UI refresh
      if (mounted) {
        setState(() {});
      }
    });
  }

  // Selected date index
  int _selectedDateIndex = 3; // Middle (today)
  late List<DateTime> _weekDates;
  late String _currentMonth;

  // Selected tab index (0 = MEAL PLAN, 1 = PREP LIST)
  int _selectedTab = 0;

  // Comment text controller
  final TextEditingController _commentController = TextEditingController();

  void _initializeDates() {
    final today = DateTime.now();
    _weekDates = List.generate(7, (index) {
      return today.add(Duration(days: index - 3)); // -3 to +3 from today
    });
    _currentMonth = _getMonthYear(_weekDates[_selectedDateIndex]);
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1].tr} ${date.year}';
  }

  String _getDayOfWeek(DateTime date) {
    const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return days[date.weekday - 1].tr;
  }

  @override
  void dispose() {
    _commentController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _showFullCalendar() {
    showDatePicker(
      context: context,
      initialDate: _weekDates[_selectedDateIndex],
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.buttonColor,
              onPrimary: Colors.white,
              surface: AppColors.background,
              onSurface: AppColors.text,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) async {
      if (pickedDate != null) {
        // Update week dates to center around the picked date
        final newWeekDates = List.generate(7, (index) {
          return pickedDate.add(Duration(days: index - 3));
        });

        setState(() {
          _weekDates = newWeekDates;
          // Set selected index to middle (the picked date)
          _selectedDateIndex = 3;
          // Update month display
          _currentMonth = _getMonthYear(pickedDate);
        });

        // Fetch meal plans for the selected date
        final selectedDateStr = pickedDate.toIso8601String().split('T')[0];
        print("📅 Calendar picked date: $selectedDateStr");
        await _controller.fetchMealPlansForDate(selectedDateStr);

        // Fetch meal plan and prep list status for all new week dates (for calendar icons)
        await _controller.fetchMealPlanStatusForDates(newWeekDates);
        await _controller.fetchPrepListStatusForDates(newWeekDates);

        // Fetch prep list if on prep list tab
        if (_selectedTab == 1) {
          await _controller.fetchPrepList(pickedDate.toIso8601String());
        }

        // Force UI refresh after fetch
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  // Variable to store the current meal plan ID for commenting
  String? _currentMealPlanId;
  bool _isPostingComment = false;

  void _showAddCommentPopup({String? mealPlanId}) {
    _commentController.clear();
    _currentMealPlanId = mealPlanId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: AppColors.background,
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
                  'Add a comment to your planned Meal.'.tr,
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
                  hintText: 'Write anything here...'.tr,
                  keyboardType: 'multiline',
                  boxHeight: 12,
                ),
                SizedBox(height: 16.h),
                // Post button
                CustomButton(
                  text: _isPostingComment ? 'Posting...'.tr : 'Post'.tr,
                  color: AppColors.buttonColor,
                  onTap: () async {
                    if (_isPostingComment) return;

                    if (_commentController.text.trim().isEmpty) {
                      Get.snackbar(
                        'Error'.tr,
                        'Please enter a comment'.tr,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    if (_currentMealPlanId == null) {
                      Get.snackbar(
                        'Error'.tr,
                        'No meal plan selected'.tr,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      return;
                    }

                    setDialogState(() => _isPostingComment = true);

                    final success = await _controller.addCommentToMealPlan(
                      mealPlanId: _currentMealPlanId!,
                      comment: _commentController.text.trim(),
                    );

                    setDialogState(() => _isPostingComment = false);

                    if (success) {
                      Navigator.pop(context);
                      Get.snackbar(
                        'Success'.tr,
                        'Comment added successfully'.tr,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.snackbar(
                        'Error'.tr,
                        'Failed to add comment'.tr,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                ),
                SizedBox(height: 12.h),
                // Info text
                Text(
                  'Your comment will be visible to all family members. Only you can remove it.'.tr,
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
                'Are you done cooking this recipe?'.tr,
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
                            'Not Yet'.tr,
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
                            'Finished'.tr,
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
        onAddToMealPlan: (mealItems, prepItems, cookPerson) async {
          print("🔄 Starting meal plan creation...");
          print("   Selected Recipe: ${selectedRecipe.title} (${selectedRecipe.id})");
          print("   Meal Items: ${mealItems.length}");
          print("   Prep Items: ${prepItems.length}");
          print("   Cook Person: $cookPerson");

          // Call API to create meal plan
          final success = await _controller.createMealPlan(
            recipeId: selectedRecipe.id,
            mealItems: mealItems,
            prepItems: prepItems,
            cookPerson: cookPerson,
          );

          if (success) {
            print("✅ SUCCESS: Meal plan created");

            // The controller's createMealPlan already calls fetchMealPlansForDate
            // which refreshes the data from API with full recipe details.
            // We just need to force a UI refresh here.
            if (mounted) {
              setState(() {});
            }
          } else {
            print("❌ FAILED: Could not create meal plan. Check logs above for details.");
          }

          return success;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8EAE6),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Meal Planner'.tr,
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            onLeadingPressed: () {
              Get.find<BottomNavbarController>().changeIndex(0);
            },
            actionButtons: [
              AppBarAction(
                imagePath: 'assets/icons/charm_menu.png',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
          children: [
            // Calendar Header Section

            _buildCalendarHeader(),

            // Tab Buttons or Create Meal Plan Button
            if (_isMultiSelectMode)
              _buildCreateMealPlanButton()
            else
              _buildTabButtons(),

            SizedBox(height: 12.h),

            // Content based on selected tab
            if (_selectedTab == 0) ...[
              // MEAL PLAN Tab Content
              Expanded(
                child: Obx(() {
                  if (_controller.isLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.buttonColor,
                      ),
                    );
                  }

                  print("🔄 Building meal sections, meals count: ${_controller.meals.length}");
                  for (var meal in _controller.meals) {
                    print("   - ${meal.title}: recipe=${meal.recipe?.name ?? 'null'}");
                  }

                  return ListView(
                    children: [
                      // Meal Sections
                      ..._controller.meals.map((meal) => _buildMealSection(meal)),

                      // Nutritional Values
                      _buildNutritionalSection(),
                    ],
                  );
                }),
              ),
            ] else ...[
              // PREP LIST Tab Content
              Expanded(
                child: Column(
                  children: [
                    _buildPrepListHeader(),
                    Expanded(
                      child: _buildPrepListContent(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
          // Confetti widget for celebration
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
              ],
              numberOfParticles: 30,
              gravity: 0.2,
              emissionFrequency: 0.05,
              maxBlastForce: 20,
              minBlastForce: 10,
            ),
          ),
        ],
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
                onTap: () => _showFullCalendar(),
                child: Row(
                  children: [
                    Text(
                      _currentMonth,
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
                onSelected: (value) async {
                  switch (value) {
                    case 0:
                      // Apply Saved Meal Plan
                      bool isGuest = await SharedPreferencesHelper.isGuest();
                      if (isGuest) {
                        Get.dialog(const CreateAccountPromptPage(), barrierDismissible: true);
                        return;
                      }
                      Get.to(() => const ReusedMealPlanScreen());
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
                      'Apply Saved Meal Plan'.tr,
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
                      'Create Meal Plan'.tr,
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
                      'Invite Family'.tr,
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
            children: List.generate(7, (i) {
              return SizedBox(
                width: 26.w,
                child: Center(
                  child: Text(
                    _getDayOfWeek(_weekDates[i]),
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 8.h),

          // Dates row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              bool isSelected = i == _selectedDateIndex;
              bool isToday = i == 3; // Middle is always today

              return GestureDetector(
                onTap: () async {
                  setState(() {
                    _selectedDateIndex = i;
                    _currentMonth = _getMonthYear(_weekDates[i]);
                  });

                  // Fetch meal plans for the selected date from API
                  final selectedDateStr = _weekDates[i].toIso8601String().split('T')[0];
                  print("📅 Selected date: $selectedDateStr");
                  await _controller.fetchMealPlansForDate(selectedDateStr);

                  // Fetch prep list for new date if on prep list tab
                  if (_selectedTab == 1) {
                    await _controller.fetchPrepList(_weekDates[i].toIso8601String());
                  }

                  // Force UI refresh after fetch
                  if (mounted) {
                    setState(() {});
                  }
                },
                onLongPress: () {
                  // Enter multi-select mode
                  setState(() {
                    _isMultiSelectMode = true;
                    _selectedDateIndices = [i];
                    _selectedDateIndex = i;
                    _currentMonth = _getMonthYear(_weekDates[i]);
                  });
                },
                child: Container(
                  width: 26.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.buttonColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(24.r),
                    border: isToday && !isSelected
                        ? Border.all(color: AppColors.buttonColor, width: 1)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${_weekDates[i].day}',
                    style: AppTextStyles.body.copyWith(
                      fontSize: 14.sp,
                      color: isSelected ? Colors.white : AppColors.text,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 8.h),

          // Icons row under dates OR circle indicators in multi-select mode
          if (_isMultiSelectMode) ...[
            // Circle indicators in multi-select mode
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                bool isSelected = _selectedDateIndices.contains(i);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedDateIndices.remove(i);
                        if (_selectedDateIndices.isEmpty) {
                          _isMultiSelectMode = false;
                        }
                      } else {
                        _selectedDateIndices.add(i);
                      }
                    });
                  },
                  child: SizedBox(
                    width: 26.w,
                    child: Center(
                      child: Container(
                        width: 16.w,
                        height: 16.h,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.buttonColor : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.buttonColor,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Icon(Icons.check, color: Colors.white, size: 10)
                            : null,
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 8.h),
            // Clear button
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isMultiSelectMode = false;
                    _selectedDateIndices.clear();
                  });
                },
                child: Text(
                  'Clear'.tr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Color(0xFF757575),
                  ),
                ),
              ),
            ),
          ] else ...[
            // Normal icons row under dates
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final dateStr = _weekDates[i].toIso8601String().split('T')[0];
                final hasMealPlan = _controller.dateHasMealPlan(dateStr);
                final hasShoppingList = _controller.dateHasShoppingList(dateStr);
                final hasPrepList = _controller.dateHasPrepList(dateStr);

                return SizedBox(
                  width: 26.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (hasMealPlan) ...[
                        Image.asset(AppImages.recipe_icon, width: 10.w, height: 10.h),
                        if (hasPrepList || hasShoppingList) SizedBox(width: 2.w),
                      ],
                      if (hasPrepList) ...[
                        Image.asset(AppImages.shopping_icon, width: 10.w, height: 10.h),
                        if (hasShoppingList) SizedBox(width: 2.w),
                      ],
                      if (hasShoppingList) ...[
                        Image.asset(AppImages.shopping_icon, width: 10.w, height: 10.h),
                      ],
                    ],
                  ),
                );
              }),
            )),
          ],

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
                    "MEAL PLAN".tr,
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
              onTap: () async {
                setState(() {
                  _selectedTab = 1;
                });
                // Fetch prep list for selected date when switching to prep list tab
                await _controller.fetchPrepList(_weekDates[_selectedDateIndex].toIso8601String());
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
                    "PREP LIST".tr,
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

  // Create Meal Plan Button (shown in multi-select mode)
  Widget _buildCreateMealPlanButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          _showMultipleDialogSheet();
        },
        child: Container(
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.buttonColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              "Create Meal Plan".tr,
              style: AppTextStyles.H6_Regular.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Multiple Dialog Sheet for multi-select mode
  void _showMultipleDialogSheet() {
    // Collect selected dates with their meal plan IDs
    List<Map<String, dynamic>> plansData = [];

    for (int index in _selectedDateIndices) {
      final date = _weekDates[index];
      final dateStr = date.toIso8601String().split('T')[0];
      final isoDate = DateTime.utc(date.year, date.month, date.day, 8, 0, 0).toIso8601String();

      // Get meal plan IDs for this date
      final mealPlans = _controller.mealPlansByDate[dateStr] ?? [];
      List<String> mealIds = [];

      for (var plan in mealPlans) {
        if (plan.id.isNotEmpty) {
          mealIds.add(plan.id);
        }
      }

      if (mealIds.isNotEmpty) {
        plansData.add({
          'date': isoDate,
          'meals': mealIds,
        });
      }
    }

    print("📋 Selected plans data: $plansData");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MultipleDialogSheet(plansData: plansData),
    );
  }

  Widget _buildMealSection(MealSection meal) {
    // Get the meal plan ID for this section
    final dateStr = _weekDates[_selectedDateIndex].toIso8601String().split('T')[0];
    final mealPlanId = _controller.getMealPlanIdForSection(meal.id, dateStr);

    // Get comments for this meal plan
    final comments = mealPlanId != null
        ? _controller.getCommentsForMealPlan(mealPlanId)
        : <Comment>[];

    return Container(
      margin: EdgeInsets.only(bottom: 1),
      color: Color(0xFFE8EAE6),
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
                        meal.title.tr,
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
                              tag.tr + (meal.tags.last != tag ? ', ' : ''),
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
                if (_isMultiSelectMode)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.toggleMealExpansion(meal.id);
                      });
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: meal.isExpanded ? AppColors.buttonColor : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.buttonColor, width: 2),
                      ),
                      child: meal.isExpanded
                          ? Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                  )
                else
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

                  // Comments from API
                  if (comments.isNotEmpty) ...[
                    ...comments.map((comment) => Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: _buildCommentCard(comment),
                    )),
                  ],

                  // Comment Icon (aligned to left) - always show
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddCommentSheet(),
                        );
                      },
                      child: Image.asset(
                        AppImages.chatIcon,
                        height: 24,
                        width: 24,
                        color: AppColors.buttonColor,
                      ),
                    ),
                  ),

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
                      child: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                          ? Image.network(
                              recipe.imageUrl!,
                              fit: BoxFit.cover,
                              width: 100.w,
                              height: 72.h,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Color(0xFFFF8C42),
                                  child: Icon(Icons.restaurant, color: Colors.white, size: 28),
                                );
                              },
                            )
                          : Container(
                              color: Color(0xFFFF8C42),
                              child: Icon(Icons.restaurant, color: Colors.white, size: 28),
                            ),
                    ),
                  ),
                  // Edit icon
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: Container(
                      width: 20.w,
                      height: 20.h,
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
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Image.asset(
                          AppImages.edit_icon,
                          fit: BoxFit.contain,
                        ),
                      ),
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

        // Add Button (smaller size)
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
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.buttonColor, width: 1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.add, color: Color(0xFF757575), size: 20),
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
        width: 133,
        decoration: BoxDecoration(
          color: Colors.white, // 👈 background color added
          border: Border.all(
            color: AppColors.buttonColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  color: Color(0xFF757575),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Add Recipe'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
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
    return Obx(() => Container(
      margin: EdgeInsets.only(top: 1),
      color: Color(0xFFE8EAE6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nutritional Values'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                if (_isMultiSelectMode)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.toggleNutritionExpansion();
                      });
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _controller.nutritionExpanded.value ? AppColors.buttonColor : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.buttonColor, width: 2),
                      ),
                      child: _controller.nutritionExpanded.value
                          ? Icon(Icons.check, color: Colors.white, size: 14)
                          : null,
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => _controller.toggleNutritionExpansion(),
                    child: Icon(
                      _controller.nutritionExpanded.value ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF757575),
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),

          if (_controller.nutritionExpanded.value) ...[
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${'Total of 1 serving of each recipe on'.tr} ${_weekDates[_selectedDateIndex].day}.${_weekDates[_selectedDateIndex].month}.${_weekDates[_selectedDateIndex].year.toString().substring(2)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildNutritionRow('Energy (kJ / kcal)'.tr, '970 kJ / 230 kcal'),
                  _buildNutritionRow('Fat'.tr, '103 g'),
                  _buildNutritionRow('- of which Saturates'.tr, '32 g'),
                  _buildNutritionRow('Carbohydrate'.tr, '140 g'),
                  _buildNutritionRow('- of which Sugars'.tr, '90 g'),
                  _buildNutritionRow('Fibre'.tr, '40 g'),
                  _buildNutritionRow('Protein'.tr, '110 g'),
                  _buildNutritionRow('Salt'.tr, '9 g'),
                ],
              ),
            ),
          ],
        ],
      ),
    ));
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
    final selectedDate = _weekDates[_selectedDateIndex];
    final formattedDate = '${selectedDate.day}.${selectedDate.month}.${selectedDate.year.toString().substring(2)}';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${'Recipes to prepare on'.tr} $formattedDate',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          Obx(() {
            final hasPrepList = _controller.prepListItems.isNotEmpty;
            final cooker = hasPrepList ? _controller.prepListItems.first.cooker : '';

            return Row(
              children: [
                if (cooker.isNotEmpty)
                  Text(
                    '${'Cooked by'.tr} $cooker  ',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textLight,
                    ),
                  ),
                GestureDetector(
                  onTap: () => _showFinishedPopup(),
                  child: Text(
                    'Finished?'.tr,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.buttonColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // ---------------- PREP LIST CONTENT ----------------
  Widget _buildPrepListContent() {
    final selectedDate = _weekDates[_selectedDateIndex];
    final formattedDate = '${selectedDate.day}.${selectedDate.month}.${selectedDate.year.toString().substring(2)}';

    return Obx(() {
      if (_controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.buttonColor,
          ),
        );
      }

      final hasPrepList = _controller.prepListItems.isNotEmpty &&
                          _controller.prepListItems.first.recipes.isNotEmpty;

      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        children: [
          // Show message if no prep list
          if (!hasPrepList) ...[
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Text(
                  'No prep list for this date'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ),
          ] else ...[
            // Prep list items from API
            ...List.generate(_controller.prepListItems.first.recipes.length, (index) {
              final recipeItem = _controller.prepListItems.first.recipes[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildPrepListItemFromApi(
                  index,
                  recipeItem,
                  _controller.prepListItems.first.serving,
                ),
              );
            }),

            SizedBox(height: 16.h),
          ],

          // Comments section for Prep List
          if (_controller.prepListComments.isNotEmpty) ...[
            ..._controller.prepListComments.map((comment) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildCommentCard(comment),
            )),
          ],

          // Comment Icon (aligned to left) - only show if there's a prep list
          if (hasPrepList && _controller.prepListItems.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  // Get the prep list ID for commenting
                  final prepListId = _controller.prepListItems.first.id;
                  _showAddCommentPopup(mealPlanId: prepListId);
                },
                child: Image.asset(
                  AppImages.chatIcon,
                  height: 24,
                  width: 24,
                  color: AppColors.buttonColor,
                ),
              ),
            ),

          SizedBox(height: 16.h),

          // Create/View shopping list button (show only when there's prep list data)
          if (hasPrepList)
            Obx(() {
              final hasShoppingList = _controller.prepListHasShoppingList.value;
              final isLoading = _controller.isLoading.value;

              return CustomButton(
                text: isLoading
                    ? 'Creating...'.tr
                    : hasShoppingList
                        ? 'View shopping list'.tr
                        : '${'Create shopping list for'.tr} $formattedDate',
                color: isLoading
                    ? AppColors.buttonColor.withOpacity(0.6)
                    : AppColors.buttonColor,
                onTap: () async {
                  if (isLoading) return;
                  
                  bool isGuest = await SharedPreferencesHelper.isGuest();
                  if (isGuest) {
                    Get.dialog(const CreateAccountPromptPage(), barrierDismissible: true);
                    return;
                  }

                  if (hasShoppingList) {
                    // Navigate to shopping list screen
                    Get.to(() => ShoppingScreen());
                  } else {
                    // Create new shopping list
                    final success = await _controller.createShoppingListFromPrepList(selectedDate);
                    if (success) {
                      print("✅ Shopping list created for $formattedDate");
                    }
                  }
                },
              );
            }),
        ],
      );
    });
  }

  // Build prep list item from API data
  Widget _buildPrepListItemFromApi(int index, PrepListRecipe recipeItem, int serving) {
    final isDone = recipeItem.isDone;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Recipe image and details
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
              // Recipe image with edit icon
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
                      child: recipeItem.recipeImage != null && recipeItem.recipeImage!.isNotEmpty
                          ? Image.network(
                              recipeItem.recipeImage!,
                              fit: BoxFit.cover,
                              width: 100.w,
                              height: 72.h,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Color(0xFFFF8C42),
                                  child: Icon(Icons.restaurant, color: Colors.white, size: 28),
                                );
                              },
                            )
                          : Container(
                              color: Color(0xFFFF8C42),
                              child: Icon(Icons.restaurant, color: Colors.white, size: 28),
                            ),
                    ),
                  ),
                  // Edit icon
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: Container(
                      width: 20.w,
                      height: 20.h,
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
                      child: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: Image.asset(
                          AppImages.edit_icon,
                          fit: BoxFit.contain,
                        ),
                      ),
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
                        recipeItem.recipeTitle ?? recipeItem.recipeId ?? 'Recipe',
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
                        '$serving servings',
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
            // Check icon (clickable) - Rounded filled button
            GestureDetector(
              onTap: () {
                _controller.togglePrepItemDone(index);
                // Check if all items are done and trigger confetti
                if (_controller.areAllPrepItemsDone()) {
                  _confettiController.play();
                }
              },
              child: Container(
                width: 28.w,
                height: 28.h,
                decoration: BoxDecoration(
                  color: isDone ? AppColors.buttonColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone ? AppColors.buttonColor : Color(0xFFBDBDBD),
                    width: 2,
                  ),
                ),
                child: isDone
                    ? Icon(Icons.check_rounded, color: Colors.white, size: 18)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
