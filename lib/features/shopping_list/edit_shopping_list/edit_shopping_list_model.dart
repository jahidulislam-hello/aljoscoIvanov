class EditShoppingItem {
  String name;
  String amount;
  String unit;
  bool isChecked;
  String category;

  EditShoppingItem({
    required this.name,
    required this.amount,
    required this.unit,
    this.isChecked = false,
    required this.category,
  });
}
