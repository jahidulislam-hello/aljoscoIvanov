class ShoppingItemModel {
  String name;
  String amount;
  String unit;
  bool isChecked;

  ShoppingItemModel({
    required this.name,
    required this.amount,
    required this.unit,
    this.isChecked = false,
  });
}
