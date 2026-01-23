// personal_notes_modal.dart
import 'package:flutter/material.dart';
import 'package:freshbite/core/widgets/custom_text_button.dart';
import 'package:freshbite/features/new/popup/popup_controller/personal_notes_popup_controller.dart';


class PersonalNotesModal extends StatefulWidget {
  final String? initialNote;
  final Function(String)? onSave;
  final String recipeId;

  const PersonalNotesModal({
    Key? key,
    this.initialNote,
    this.onSave,
    required this.recipeId,
  }) : super(key: key);

  @override
  State<PersonalNotesModal> createState() => _PersonalNotesModalState();
}

class _PersonalNotesModalState extends State<PersonalNotesModal> {
  late final PersonalNotesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersonalNotesController(
      initialNote: widget.initialNote,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with grey background
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFE5E7EB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Personal Notes',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Personal Notes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Note Label
                  const Text(
                    'Note',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Note TextField
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _controller.noteController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF111827),
                        height: 1.5,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Write a personal note (only visible to you)',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                          height: 1.5,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Save Button
                  ValueListenableBuilder<bool>(
                    valueListenable: _controller.isLoading,
                    builder: (context, isLoading, _) {
                      return CustomTextButton(
                        text: isLoading ? 'SAVING...' : 'SAVE',
                        onTap: isLoading ? () {} : () => _controller.saveNote(
                          context,
                          widget.recipeId,
                          widget.onSave,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}