// personal_notes_controller.dart
import 'package:flutter/material.dart';
import 'package:freshbite/features/new/services/recipe_review_service.dart';

class PersonalNotesController {
  final TextEditingController noteController;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  PersonalNotesController({String? initialNote})
      : noteController = TextEditingController(text: initialNote ?? '');

  String get note => noteController.text.trim();

  bool get hasNote => note.isNotEmpty;

  Future<void> saveNote(
      BuildContext context,
      String recipeId,
      Function(String)? onSave,
      ) async {
    if (!hasNote) {
      _showSnackBar(context, 'Please write a note before saving', isError: true);
      return;
    }

    isLoading.value = true;

    try {
      final result = await RecipeReviewService.addNote(
        note: note,
        recipeId: recipeId,
      );

      isLoading.value = false;

      if (result['success'] == true) {
        // Call the callback if provided
        if (onSave != null) {
          onSave(note);
        }

        _showSnackBar(context, 'Note saved successfully!');

        // Close the modal after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          Navigator.of(context).pop(note);
        }
      } else {
        _showSnackBar(
          context,
          result['message'] ?? 'Failed to save note',
          isError: true,
        );
      }
    } catch (e) {
      isLoading.value = false;
      _showSnackBar(context, 'An error occurred. Please try again.', isError: true);
      print('Error saving note: $e');
    }
  }

  void clearNote() {
    noteController.clear();
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red : const Color(0xFF374151),
      ),
    );
  }

  void dispose() {
    noteController.dispose();
    isLoading.dispose();
  }
}