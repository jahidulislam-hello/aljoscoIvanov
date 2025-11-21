import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshbite/core/themes/app_colors.dart';
import 'package:freshbite/core/themes/text_styles.dart';
import 'package:freshbite/features/new/model/new_recipe_model.dart';
import 'package:freshbite/features/new/widgets/allerjon_chip.dart';
import 'package:freshbite/features/new/widgets/image_cursor.dart';
import 'package:freshbite/features/new/widgets/ingrediant_item.dart';
import 'package:freshbite/features/new/widgets/instruction_step.dart';
import 'package:freshbite/features/new/widgets/new_appbar.dart';
import 'package:freshbite/features/new/widgets/nutrition_info_card.dart';
import 'package:freshbite/features/new/widgets/primary_button.dart';
import 'package:freshbite/features/new/widgets/rating_display.dart';
import 'package:freshbite/features/new/widgets/review_card.dart';
import 'package:freshbite/features/new/widgets/time_info_chip.dart';


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
  late List<bool> _checkedIngredients;
  int _servings = 4;

  @override
  void initState() {
    super.initState();
    _checkedIngredients = List.filled(widget.recipe.ingredients.length, false);
    _servings = widget.recipe.servings;
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
      backgroundColor: Colors.white,
      appBar: NewAppbar(
        title: 'Recipe',
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite_border,
              color: AppColors.textPrimary,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              color: AppColors.textPrimary,
              size: 24.sp,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                  // Title
                  Text(
                    widget.recipe.title,
                    style: AppTextStyles.h1,
                  ),
                  SizedBox(height: 12.h),

                  // Rating
                  RatingDisplay(
                    rating: widget.recipe.rating,
                    reviewCount: widget.recipe.reviewCount,
                  ),
                  SizedBox(height: 20.h),

                  // Description Section
                  _buildSectionTitle('Description'),
                  SizedBox(height: 12.h),
                  Text(
                    widget.recipe.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Time Information
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TimeInfoChip(
                          icon: Icons.access_time,
                          label: 'Prep time',
                          value: _formatDuration(widget.recipe.prepTime),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TimeInfoChip(
                          icon: Icons.timer_outlined,
                          label: 'Cook time',
                          value: _formatDuration(widget.recipe.cookTime),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TimeInfoChip(
                          icon: Icons.bar_chart,
                          label: 'Difficulty',
                          value: widget.recipe.difficulty,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Allergens
                  _buildSectionTitle('Allergens'),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: widget.recipe.allergens
                        .map((allergen) => AllergenChip(allergen: allergen))
                        .toList(),
                  ),
                  SizedBox(height: 24.h),

                  // Ingredients
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Ingredients'),
                      _buildServingsSelector(),
                    ],
                  ),
                  SizedBox(height: 12.h),
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
                  SizedBox(height: 24.h),

                  // Add to Shopping List Button
                  PrimaryButton(
                    text: 'ADD TO SHOPPING LIST',
                    onPressed: () {},
                  ),
                  SizedBox(height: 24.h),

                  // Instructions
                  _buildSectionTitle('Instructions'),
                  SizedBox(height: 16.h),
                  ...widget.recipe.instructions.asMap().entries.map((entry) {
                    return InstructionStep(
                      stepNumber: entry.key + 1,
                      instruction: entry.value,
                    );
                  }).toList(),
                  SizedBox(height: 8.h),

                  // Start Cooking Button
                  PrimaryButton(
                    text: 'START COOKING',
                    onPressed: () {},
                  ),
                  SizedBox(height: 24.h),

                  // Nutrition Information
                  _buildSectionTitle('Nutrition (Typical Values Per Serving)'),
                  SizedBox(height: 12.h),
                  NutritionInfoCard(nutritionInfo: widget.recipe.nutritionInfo),
                  SizedBox(height: 24.h),

                  // Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('Reviews (${widget.recipe.reviewCount})'),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View All',
                          style: AppTextStyles.labelBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ...widget.recipe.reviews
                      .map((review) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: ReviewCard(review: review),
                  ))
                      .toList(),
                  SizedBox(height: 24.h),

                  // Write Review Button
                  PrimaryButton(
                    text: 'WRITE',
                    backgroundColor: Colors.white,
                    textColor: AppColors.primary,
                    onPressed: () {},
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h3,
    );
  }

  Widget _buildServingsSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildServingsButton(Icons.remove, () {
            if (_servings > 1) {
              setState(() {
                _servings--;
              });
            }
          }),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              _servings.toString(),
              style: AppTextStyles.labelBold,
            ),
          ),
          _buildServingsButton(Icons.add, () {
            setState(() {
              _servings++;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildServingsButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}