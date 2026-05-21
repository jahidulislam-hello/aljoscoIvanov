// lib/features/subscription/payment/iap_service.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class IAPService extends GetxService {
  static IAPService get to => Get.find();

  final InAppPurchase _iap = InAppPurchase.instance;

  // ✅ Must match EXACTLY with App Store Connect & Google Play Console
  static const Map<String, String> productIds = {
    'family':   'com.freshbite.family_monthly',    // CHF 24.00
    'premium':  'com.freshbite.premium_monthly',   // CHF 19.00
    'trial':    'com.freshbite.premium_trial',     // Free trial
  };

  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool isAvailable = false.obs;
  final RxBool isPremium = false.obs;
  final RxBool isLoading = false.obs;
  final RxString activeProductId = ''.obs;

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<IAPService> init() async {
    isAvailable.value = await _iap.isAvailable();
    if (!isAvailable.value) {
      debugPrint('[IAP] Store not available');
      return this;
    }

    // iOS: handle pending transactions (Ask to Buy, etc.)
    if (Platform.isIOS) {
      final iosAddition = _iap
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosAddition.setDelegate(_IosPaymentDelegate());
    }

    // Listen to purchase stream
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (e) => debugPrint('[IAP] Stream error: $e'),
    );

    await fetchProducts();
    await restorePurchases();
    return this;
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    final response = await _iap.queryProductDetails(productIds.values.toSet());

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint('[IAP] Not found: ${response.notFoundIDs}');
    }

    products.value = response.productDetails;
    isLoading.value = false;
  }

  /// Call this with plan index from SubscriptionController
  Future<void> buyPlan(int planIndex) async {
    if (!isAvailable.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Store Unavailable',
          'Google Play is not available on this device/emulator.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
      return;
    }

    final String? key = {1: 'family', 2: 'premium', 3: 'trial'}[planIndex];
    if (key == null) return;

    final String? productId = productIds[key];
    final ProductDetails? product =
    products.firstWhereOrNull((p) => p.id == productId);

    if (product == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Error',
          'Product not found. Check Play Console setup.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
      return;
    }

    final param = PurchaseParam(productDetails: product);
    try {
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Error', 'Could not start purchase: $e',
            backgroundColor: Colors.red, colorText: Colors.white);
      });
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> list) async {
    for (final purchase in list) {
      debugPrint('[IAP] Status: ${purchase.status} | ${purchase.productID}');

      switch (purchase.status) {
        case PurchaseStatus.pending:
          isLoading.value = true;
          break;

        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          isLoading.value = false;
          final valid = _verifyPurchase(purchase);
          if (valid) _unlockPlan(purchase.productID);
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;

        case PurchaseStatus.error:
          isLoading.value = false;
          Get.snackbar(
            'Payment Failed',
            purchase.error?.message ?? 'Something went wrong',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          break;

        case PurchaseStatus.canceled:
          isLoading.value = false;
          break;
      }
    }
  }

  bool _verifyPurchase(PurchaseDetails purchase) {
    // ⚠️ In production: send purchase.verificationData to your backend
    // and verify with Apple/Google Receipt Validation APIs
    return purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored;
  }

  void _unlockPlan(String productId) {
    activeProductId.value = productId;
    isPremium.value = true;

    Get.snackbar(
      'Success 🎉',
      'Your subscription is now active!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}

// Required iOS delegate
class _IosPaymentDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper t, SKStorefrontWrapper s) =>
      true;

  @override
  bool shouldShowPriceConsent() => false;
}