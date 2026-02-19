import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShoppingItem {
  String name;
  String amount;
  String unit;
  String? singleValue;
  String? categories;
  String? houseHoldUnit;
  String? householdValue;
  String? houseHoldForSingleValue;
  RxBool checked;

  ShoppingItem({
    required this.name,
    required this.amount,
    required this.unit,
    this.singleValue,
    this.categories,
    this.houseHoldUnit,
    this.householdValue,
    this.houseHoldForSingleValue,
    bool checked = false,
  }) : checked = checked.obs;

  /// Get display value based on unit selection
  String getDisplayValue(String selectedUnit) {
    if (selectedUnit == "HouseHold") {
      return householdValue ?? amount;
    }
    return amount;
  }

  /// Get display unit based on unit selection
  String getDisplayUnit(String selectedUnit) {
    if (selectedUnit == "HouseHold") {
      return houseHoldUnit ?? unit;
    }
    return unit;
  }
}

class RecipeSection {
  String title;

  /// IMPORTANT: items must be reactive so UI updates instantly
  RxList<ShoppingItem> items;

  // Unique controllers per section
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();
  TextEditingController unitCtrl = TextEditingController();

  RecipeSection({
    required this.title,
    required List<ShoppingItem> items,
  }) : items = items.obs; // convert list to RxList
}
