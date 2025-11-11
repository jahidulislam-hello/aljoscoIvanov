class ShoppingItem {
  String name;
  String quantity;
  bool isChecked;

  ShoppingItem({
    required this.name,
    required this.quantity,
    this.isChecked = false,
  });
}

class ShoppingCategory {
  String title;
  List<ShoppingItem> items;
  bool isExpanded;

  ShoppingCategory({
    required this.title,
    required this.items,
    this.isExpanded = false,
  });
}
