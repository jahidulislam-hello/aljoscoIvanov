// recipe_rating_controller.dart
import 'package:flutter/material.dart';
import 'package:freshbite/features/new/services/recipe_review_service.dart';

class RecipeRatingController {
  final ValueNotifier<int> ratingNotifier = ValueNotifier<int>(0);
  final TextEditingController feedbackController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  void setRating(int rating) {
    ratingNotifier.value = rating;
  }

  int get rating => ratingNotifier.value;
  String get feedback => feedbackController.text;

  Future<void> submitRating(BuildContext context, String recipeId) async {
    if (rating == 0) {
      _showSnackBar(context, 'Please select a rating', isError: true);
      return;
    }

    isLoading.value = true;

    try {
      final result = await RecipeReviewService.addReview(
        rating: rating.toDouble(),
        comment: feedback.trim().isEmpty ? 'No comment' : feedback.trim(),
        recipeId: recipeId,
      );

      isLoading.value = false;

      if (result['success'] == true) {
        _showSnackBar(context, 'Thank you for your feedback!');

        // Close the modal after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } else {
        _showSnackBar(
          context,
          result['message'] ?? 'Failed to submit review',
          isError: true,
        );
      }
    } catch (e) {
      isLoading.value = false;
      _showSnackBar(context, 'An error occurred. Please try again.', isError: true);
      print('Error submitting rating: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void dispose() {
    ratingNotifier.dispose();
    feedbackController.dispose();
    isLoading.dispose();
  }
}