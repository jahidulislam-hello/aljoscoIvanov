import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCommentController extends GetxController {
  final commentController = TextEditingController();
  final isLoading = false.obs;

  void postComment() {
    final comment = commentController.text.trim();

    if (comment.isEmpty) {
      Get.snackbar(
        "Error",
        "Please write a comment",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    /// Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.back();

      Get.snackbar(
        "Success",
        "Comment Posted Successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}