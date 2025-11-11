import 'package:freshbite/features/shopping_list/edit_shopping_list/edit_shopping_list_model.dart';
import 'package:get/get.dart';


class ShoppingListController extends GetxController {
  var tabIndex = 0.obs; // 0 = By Recipe, 1 = By Category
  var shoppingList = <EditShoppingItem>[].obs;
  var assignedTo = ''.obs;
  var description = ''.obs;

  void toggleItemCheck(int index) {
    shoppingList[index].isChecked = !shoppingList[index].isChecked;
    shoppingList.refresh();
  }

  void changeTab(int index) {
    tabIndex.value = index;
  }

  void saveShoppingList() {
    // Save logic
    print("Shopping List Saved");
  }

  void cancelShoppingList() {
    // Cancel logic
    print("Shopping List Cancelled");
  }
}
