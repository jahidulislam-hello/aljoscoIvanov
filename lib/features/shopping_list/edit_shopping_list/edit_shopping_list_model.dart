import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShoppingItem {
  String name;
  String amount;
  String unit;
  RxBool checked;

  ShoppingItem({
    required this.name,
    required this.amount,
    required this.unit,
    bool checked = false,
  }) : checked = checked.obs;
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
