import 'package:get/get.dart';
import 'create_shopping_model.dart';

class CreateShoppingController extends GetxController {
  var shoppingItems = <ShoppingItemModel>[
    ShoppingItemModel(name: "Olive oil", amount: "2", unit: "tbsp"),
    ShoppingItemModel(name: "Onion", amount: "1", unit: "ps"),
    ShoppingItemModel(name: "Red bell pepper", amount: "1", unit: "ps", isChecked: true),
    ShoppingItemModel(name: "Garlic cloves", amount: "3", unit: "Cloves"),
    ShoppingItemModel(name: "Ground cumin", amount: "1", unit: "tsp"),
    ShoppingItemModel(name: "Smoked paprika", amount: "1", unit: "can (28 oz)", isChecked: true),
    ShoppingItemModel(name: "Fresh parsley", amount: "1/4", unit: "cup"),
    ShoppingItemModel(name: "Eggs", amount: "4", unit: "large"),
    ShoppingItemModel(name: "Chili powder", amount: "1/2", unit: "tsp"),
  ].obs;

  var description = ''.obs;
  var selectedUser = 'Aljoscha Ivanov'.obs;
  var selectedDate = DateTime.now().obs;

  void toggleItem(int index) {
    shoppingItems[index].isChecked = !shoppingItems[index].isChecked;
    shoppingItems.refresh();
  }

  void updateItem(int index, String name, String amount, String unit) {
    shoppingItems[index]
      ..name = name
      ..amount = amount
      ..unit = unit;
    shoppingItems.refresh();
  }

  void addNewItem(String name, String amount, String unit) {
    if (name.isNotEmpty && amount.isNotEmpty && unit.isNotEmpty) {
      shoppingItems.add(ShoppingItemModel(name: name, amount: amount, unit: unit));
    }
  }

  void saveList() {
    // TODO: handle API call or local save logic
    Get.back();
  }
}
