import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freshbite/core/network_celler/endpoints.dart';
import 'package:freshbite/core/network_celler/http_client.dart';
import 'package:freshbite/core/themes/app_images.dart';
import 'package:freshbite/routes/routes.dart';

class SubscriptionModel {
  final String id;
  final String plan;
  final int duration;
  final int price;
  final List<String> features;

  SubscriptionModel({
    required this.id,
    required this.plan,
    required this.duration,
    required this.price,
    required this.features,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['_id'] ?? '',
      plan: json['plan'] ?? '',
      duration: json['duration'] ?? 0,
      price: json['price'] ?? 0,
      features: (json['features'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class SubscriptionController extends GetxController {
  var selectedPlan = (-1).obs;
  var isLoading = false.obs;
  var subscriptions = <SubscriptionModel>[].obs;

  /// Current user subscription state (passed from Profile)
  var currentPlanType = ''.obs;
  var currentSubscriptionStatus = ''.obs;

  bool get hasActiveSubscription =>
      currentSubscriptionStatus.value == 'active' &&
      currentPlanType.value.isNotEmpty &&
      currentPlanType.value != 'guest';

  @override
  void onInit() {
    fetchSubscriptions();
    super.onInit();
  }

  void setCurrentSubscription({
    required String planType,
    required String status,
  }) {
    currentPlanType.value = planType;
    currentSubscriptionStatus.value = status;
    _applyCurrentSubscription();
  }

  void _applyCurrentSubscription() {
    if (!hasActiveSubscription) return;
    final idx = subscriptions
        .indexWhere((s) => s.plan == currentPlanType.value);
    if (idx != -1) selectPlan(idx);
  }

  Future<void> fetchSubscriptions() async {
    try {
      isLoading.value = true;
      final response = await HttpClient.get(
        Uri.parse(Urls.getAllSubcription),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          final list = responseData['data'] as List? ?? [];
          subscriptions.value = list
              .map((e) => SubscriptionModel.fromJson(e))
              .toList();
          _applyCurrentSubscription();
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Failed to load subscriptions',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load subscriptions',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Fetch subscriptions error: $e");
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectPlan(int index) {
    selectedPlan.value = index;
  }

  /// ---- ICON LOGIC BASED ON PLAN TYPE (from backend) ----
  static String getIconForPlan(String plan) {
    switch (plan.toLowerCase()) {
      case 'premium':
        return AppImages.pepper_icon;
      case 'family':
        return AppImages.family_icon;
      case 'trial':
        return AppImages.handshake_icon;
      case 'guest':
      default:
        return AppImages.crown_icon;
    }
  }

  /// ---- TITLE LOGIC BASED ON PLAN TYPE ----
  static String getTitleForPlan(String plan) {
    switch (plan.toLowerCase()) {
      case 'premium':
        return 'Premium\nsubscription';
      case 'family':
        return 'Family\nsubscription';
      case 'trial':
        return 'Premium trial (1 week)';
      case 'guest':
      default:
        return 'Guest /\n Free Account';
    }
  }

  /// ---- UNIT LOGIC BASED ON DURATION (7 = week, else month) ----
  static String getUnitForDuration(int duration) {
    if (duration == 7) return '/1 week';
    return '/month';
  }

  /// ---- POST: purchase subscription (google / appstore) ----
  Future<void> purchaseSubscription({
    required String subscriptionId,
    required String purchaseToken,
  }) async {
    try {
      isLoading.value = true;
      final response = await HttpClient.post(
        Uri.parse(Urls.purchaseSubscription),
        body: jsonEncode({
          "subscriptionId": subscriptionId,
          "purchaseToken": purchaseToken,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          Get.snackbar(
            'Success',
            responseData['message'] ?? 'Subscription purchased successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          final purchased = subscriptions
              .firstWhereOrNull((s) => s.id == subscriptionId);
          if (purchased != null) {
            currentPlanType.value = purchased.plan;
            currentSubscriptionStatus.value = 'active';
            final idx = subscriptions
                .indexWhere((s) => s.id == subscriptionId);
            if (idx != -1) selectPlan(idx);
          }
          Get.offAllNamed(AppRoute.getBottomNavbar());
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Purchase failed',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Purchase failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Purchase subscription error: $e");
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
