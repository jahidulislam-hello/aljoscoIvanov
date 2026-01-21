import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/appbar/custom_appbar.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/new/model/new_recipe_model.dart';
import 'package:freshbite/features/new/widgets/allerjon_chip.dart';
import 'package:freshbite/features/new/widgets/image_cursor.dart';
import 'package:freshbite/features/new/widgets/ingrediant_item.dart';
import 'package:freshbite/features/new/widgets/instruction_step.dart';
import 'package:freshbite/features/new/widgets/nutrition_info_card.dart';
import 'package:freshbite/features/new/widgets/primary_button.dart';
import 'package:freshbite/features/new/widgets/personal_notes.dart';
import 'package:freshbite/features/new/controller/new_recipe_controller.dart';
import 'package:freshbite/features/new/widgets/skills_chip.dart';
import 'package:freshbite/features/new/widgets/time_info_chip.dart';
import 'package:freshbite/features/new/widgets/title_chip.dart';
import 'package:freshbite/features/new/popup/popup_screen/personal_notes_popup.dart';
import 'package:freshbite/features/new/popup/popup_screen/rating_popup.dart';
import 'package:freshbite/features/video/instruction_video.dart';
import 'package:get/get.dart';

class NewRecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const NewRecipeDetailScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  State<NewRecipeDetailScreen> createState() => _NewRecipeDetailScreenState();
}

class _NewRecipeDetailScreenState extends State<NewRecipeDetailScreen> {
  late NewRecipeDetailController controller;
  late List<bool> _checkedIngredients;

  List<String> _personalNotes = [];

  // Expandable toggles
  bool _expDescription = true;
  bool _expTime = true;
  bool _expAllergens = true;
  bool _expIngredients = true;
  bool _expInstructions = true;
  bool _expNutrition = true;
  bool _expNotes = true;
  bool _expSkills = true;

  @override
  void initState() {
    super.initState();
    controller = Get.find<NewRecipeDetailController>();
    _checkedIngredients = List.filled(widget.recipe.ingredients.length, false);
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}min';
    }
    return '${duration.inMinutes}min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: CustomAppBar(
            title: 'Favourites',
            titleAlignment: AppBarTitleAlignment.center,
            showBackButton: true,
            actionButtons: [
              AppBarAction(imagePath: 'assets/icons/share.png', onPressed: () {}),
              AppBarAction(imagePath: 'assets/icons/calender.png', onPressed: () {}),
              AppBarAction(imagePath: 'assets/icons/charm_menu.png', onPressed: () {}),
            ],
          ),
        ),
      ),

      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                // Image Carousel
            ImageCarousel(images: widget.recipe.images),

            // Content
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Title Chips
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: widget.recipe.titlechip
                        .map((titlechip) => TitleChip(titlechip: titlechip))
                        .toList(),
                  ),
                  SizedBox(height: 12.h),

                  /// Title + Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          widget.recipe.title,
                          style: AppTextStyles.H4_Regular.copyWith(fontSize: 20.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: AppColors.pureWhite,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.rateborder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: AppColors.buttonColor, size:18.sp),
                            SizedBox(width: 4.w),
                            Text(widget.recipe.rating.toString(), style: AppTextStyles.labelBold),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // ==============================
                  // EXPANDABLE: DESCRIPTION
                  // ==============================
                  _expandableHeader(
                    'Description',
                    _expDescription,
                        () => setState(() => _expDescription = !_expDescription),
                  ),
                  if (_expDescription)
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Text(
                        widget.recipe.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                  SizedBox(height: 24.h),

                  // ==============================
                  // EXPANDABLE: ALLERGENS
                  // ==============================
                  _expandableHeader(
                    'Allergens (Include)',
                    _expAllergens,
                        () => setState(() => _expAllergens = !_expAllergens),
                  ),
                  if (_expAllergens)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: widget.recipe.allergens
                            .map((allergen) => AllergenChip(allergen: allergen))
                            .toList(),
                      ),
                    ),
                  SizedBox(height: 24.h),


                  // ==============================
                  // EXPANDABLE: INGREDIENTS
                  // ==============================
                  _expandableHeader(
                    'Ingredients',
                    _expIngredients,
                        () => setState(() => _expIngredients = !_expIngredients),
                  ),

                  if (_expIngredients)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),

                        /// INGREDIENTS LIST
                        ...widget.recipe.ingredients.asMap().entries.map((entry) {
                          int index = entry.key;
                          Ingredient ingredient = entry.value;
                          return IngredientItem(
                            ingredient: ingredient,
                            isChecked: _checkedIngredients[index],
                            onChanged: (value) {
                              setState(() {
                                _checkedIngredients[index] = value ?? false;
                              });
                            },
                          );
                        }).toList(),

                        SizedBox(height: 20.h),

                        CustomTextButton(
                          text: 'ADD TO SHOPPING LIST',
                          onTap: () {},
                        ),
                      ],
                    ),
                  SizedBox(height: 24.h),

                  // ==============================
                  // EXPANDABLE: TIME OVERVIEW
                  // ==============================
                  _expandableHeader(
                    'Time Overview',
                    _expTime,
                        () => setState(() => _expTime = !_expTime),
                  ),
                  if (_expTime)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: TimeInfoChip(
                              totalTime: _formatDuration(widget.recipe.totalTime),
                              prepTime: _formatDuration(widget.recipe.prepTime),
                              cookTime: _formatDuration(widget.recipe.cookTime),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          PrimaryButton(
                            text: 'Start Timer',
                            onPressed: () {
                              Get.to(() => RecipeInstructionsScreen(
                                skills: [], // TODO: Add skills data from recipe
                              ));
                            },
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  SizedBox(height: 20.h),


                  // ==============================
                  // EXPANDABLE: Skills Required
                  // ==============================
                  _expandableHeader(
                    'Skills Required',
                    _expSkills,
                        () => setState(() => _expSkills = !_expSkills),
                  ),
                  if (_expSkills)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: widget.recipe.skills
                            .map((skills) => SkillsChip(skills: skills))
                            .toList(),
                      ),
                    ),
                  SizedBox(height: 24.h),

                  // ==============================
                  // EXPANDABLE: INSTRUCTIONS
                  // ==============================
                  _expandableHeader(
                    'Instructions',
                    _expInstructions,
                        () => setState(() => _expInstructions = !_expInstructions),
                  ),
                  if (_expInstructions)
                    Column(
                      children: [
                        SizedBox(height: 12.h),
                        ...widget.recipe.instructions.asMap().entries.map((entry) {
                          return InstructionStep(
                            stepNumber: entry.key + 1,
                            instruction: entry.value,
                          );
                        }).toList(),
                        SizedBox(height: 12.h),
                        CustomTextButton(
                          text: 'START COOKING',
                          onTap: () {},
                        ),
                      ],
                    ),
                  SizedBox(height: 24.h),

                   // ==============================
                   // EXPANDABLE: Nutritional Values
                  // ==============================
                  _expandableHeader(
                    'Nutritional Values (1 serving=500g)',
                    _expNutrition,
                        () => setState(() => _expNutrition = !_expNutrition),
                  ),

                  if (_expNutrition)
                    Column(
                      children: [
                        SizedBox(height: 10.h),
                        /// Just ONE card (because nutritionInfo is SINGLE object)
                        NutritionInfoCard(
                          nutritionInfo: widget.recipe.nutritionInfo,
                        ),

                        SizedBox(height: 12.h),
                        CustomTextButton(
                          text: 'START COOKING',
                          onTap: () {},
                        ),
                      ],
                    ),

                  SizedBox(height: 24.h),

                  // ==============================
// EXPANDABLE: Personal Notes
// ==============================
                  _expandableHeader(
                    'Personal Notes (${widget.recipe.personalNotes.length})',
                    _expNotes,
                        () {
                      setState(() => _expNotes = !_expNotes);
                      print('Personal Notes section expanded: $_expNotes');
                    },
                  ),

                  if (_expNotes)
                    Padding(
                      padding: EdgeInsets.only(top: 12.h),
                      child: Column(
                        children: [
                          SizedBox(height: 12.h),
                          // Personal Notes List
                          ...widget.recipe.personalNotes.map(
                                (note) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: PersonalNotesCard(personalNotes: note),
                            ),
                          ),
                          // Two buttons inline
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomTextButton(
                                    text: 'Note',
                                    filled: false,
                                    onTap: () {
                                      print('Note button tapped!');
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext dialogContext) => PersonalNotesModal(
                                          recipeId: widget.recipe.id,
                                          onSave: (note) {
                                            print('Note saved: $note');
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: PrimaryButton(
                                    text: 'Review',
                                    onPressed: () {
                                      print('Review button tapped!');
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext dialogContext) => RecipeRatingModal(
                                          recipeName: widget.recipe.title,
                                          recipeId: widget.recipe.id,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 34.h),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  // ================================
  // EXPANDABLE HEADER WIDGET
  // ================================
  Widget _expandableHeader(String title, bool expanded, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.H3_Regular.copyWith(fontSize: 16.sp)),
          Icon(
            expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: AppColors.mainTextColor,
            size: 22.sp,
          ),
        ],
      ),
    );
  }
}