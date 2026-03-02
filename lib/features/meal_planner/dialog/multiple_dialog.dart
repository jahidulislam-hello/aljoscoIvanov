import 'package:flutter/material.dart';
import 'package:freshbite/features/meal_planner/dialog/controller/multiple_dialog_controller.dart';
import 'package:get/get.dart';



class MultipleDialogSheet extends StatelessWidget {
  final List<Map<String, dynamic>> plansData;

  MultipleDialogSheet({super.key, this.plansData = const []});

  late final MultipleDialogController controller;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(MultipleDialogController());
    controller.setSelectedPlansData(plansData);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Center(
            child: Text(
              "Please add a title and description\nfor your new meal plan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 28),

          /// ADD TITLE LABEL
          const Text(
            "Add Title",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          /// TITLE FIELD
          TextField(
            controller: controller.titleController,
            decoration: InputDecoration(
              hintText: 'e.g. "My Monday Menu"',
              hintStyle: const TextStyle(fontSize: 14),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF1B3B0A)),
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// ADD DESCRIPTION LABEL
          const Text(
            "Add Description",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          /// DESCRIPTION FIELD
          TextField(
            controller: controller.descriptionController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'e.g. "Usual Breakfast and family dinner"',
              hintStyle: const TextStyle(fontSize: 14),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF1B3B0A)),
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// SAVE BUTTON
          Obx(() => SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.saveMealPlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3B0A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: controller.isLoading.value
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text(
                "SAVE MEAL PLAN",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          )),

          const SizedBox(height: 12),

          /// FOOTER TEXT
          const Text(
            "Meal Plan will be saved with connected Prep Lists, but without assigned Chef, Comments or Shopping Lists.",
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}