import 'package:freshbite/features/shopping_list/shopping_list/shopping_list_model/shopping_list_model.dart';
import 'package:get/get.dart';

class ShoppingListController extends GetxController {
  RxList<ShoppingCategory> categories = <ShoppingCategory>[].obs;
  RxString note = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadShoppingList();
  }

  void loadShoppingList() {
    categories.value = [
      ShoppingCategory(
        title: 'Produce',
        items: [
          ShoppingItem(name: 'Fresh produce', quantity: '1/2 cup', isChecked: true),
          ShoppingItem(name: 'Herbs', quantity: '103 g'),
          ShoppingItem(name: 'Salad greens', quantity: '32 g'),
          ShoppingItem(name: 'Roots', quantity: '140 g', isChecked: true),
          ShoppingItem(name: 'Citrus', quantity: '90 g'),
          ShoppingItem(name: 'Berries', quantity: '40 g'),
        ],
      ),
      ShoppingCategory(
        title: 'Meat, Fish, Tofu, Alternatives',
        items: [
          ShoppingItem(name: 'Milk', quantity: '1/2 cup'),
          ShoppingItem(name: 'Cheese', quantity: '103 g', isChecked: true),
          ShoppingItem(name: 'Yogurt', quantity: '32 g'),
          ShoppingItem(name: 'Butter', quantity: '140 g'),
          ShoppingItem(name: 'Vegan cheese', quantity: '90 g'),
          ShoppingItem(name: 'Eggs', quantity: '12 p'),
        ],
      ),
      ShoppingCategory(
        title: 'Others',
        items: [
          ShoppingItem(name: 'Bread', quantity: '5 P', isChecked: true),
          ShoppingItem(name: 'Salt', quantity: '500 g'),
          ShoppingItem(name: 'Soda', quantity: '800 g', isChecked: true),
          ShoppingItem(name: 'Energy drinks', quantity: '1 L'),
          ShoppingItem(name: 'Oil', quantity: '2 L'),
          ShoppingItem(name: 'Garlic powder', quantity: '500 g'),
        ],
      ),
    ];
  }

  void toggleItem(ShoppingCategory category, ShoppingItem item) {
    item.isChecked = !item.isChecked;
    categories.refresh();
  }

  void toggleCategoryExpansion(ShoppingCategory category) {
    category.isExpanded = !category.isExpanded;
    categories.refresh();
  }

  void updateNote(String newNote) {
    note.value = newNote;
  }
}
