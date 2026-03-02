import 'package:flutter/material.dart';
import 'package:freshbite/features/meal_planner/dialog/controller/add_comment_controller.dart';
import 'package:get/get.dart';


class AddCommentSheet extends StatelessWidget {
  AddCommentSheet({super.key});

  final controller = Get.put(AddCommentController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      decoration: const BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          const Center(
            child: Text(
              "Add a comment to your planned\nMeal.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(height: 26),

          /// LABEL
          const Text(
            "Comment",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          /// INPUT FIELD
          TextField(
            controller: controller.commentController,
            decoration: InputDecoration(
              hintText: 'e.g. "Please eat leftovers first"',
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide(
                  color: Color(0xFF1C3B0A),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// POST BUTTON
          Obx(
                () => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.postComment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C3B0A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "POST",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// FOOTER TEXT
          const Center(
            child: Text(
              "Your comment will be visible to all family members. Only you can remove it.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}