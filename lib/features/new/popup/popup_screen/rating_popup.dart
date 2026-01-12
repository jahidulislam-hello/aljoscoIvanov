// recipe_rating_modal.dart
import 'package:flutter/material.dart';
import 'package:freshbite/core/widgets/button.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/new/popup/popup_controller/rating_popup_controller.dart';


class RecipeRatingModal extends StatefulWidget {
  final String recipeName;
  final String recipeId;

  const RecipeRatingModal({
    Key? key,
    required this.recipeName,
    required this.recipeId,
  }) : super(key: key);

  @override
  State<RecipeRatingModal> createState() => _RecipeRatingModalState();
}

class _RecipeRatingModalState extends State<RecipeRatingModal> {
  late final RecipeRatingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RecipeRatingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Review this recipe',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Title
            const Text(
              'Rate this Recipe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 24),

            // Star Rating
            ValueListenableBuilder<int>(
              valueListenable: _controller.ratingNotifier,
              builder: (context, rating, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () => _controller.setRating(index + 1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          index < rating ? Icons.star : Icons.star_border,
                          size: 40,
                          color: index < rating
                              ? const Color(0xFFEAB308)
                              : const Color(0xFFD1D5DB),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),

            const SizedBox(height: 32),

            // Feedback Label
            const Text(
              'Your Feedback to freshbite',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 12),

            // Feedback TextField
            TextField(
              controller: _controller.feedbackController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Share your feedback with us, so we can\nimprove this Recipe',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                  height: 1.6,
                ),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF3B5F3A),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            ValueListenableBuilder<bool>(
              valueListenable: _controller.isLoading,
              builder: (context, isLoading, _) {
                return CustomTextButton(
                  text: isLoading ? 'SUBMITTING...' : 'SUBMIT',
                  onTap: isLoading ? () {} : () => _controller.submitRating(context, widget.recipeId),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}