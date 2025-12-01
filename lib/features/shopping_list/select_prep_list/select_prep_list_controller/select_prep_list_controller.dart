import 'package:freshbite/features/shopping_list/edit_shopping_list/edit_shopping_list_screen/edit_shopping_list_screen.dart';
import 'package:get/get.dart';

class PrepListController extends GetxController {
  // MULTIPLE SELECTED INDEXES
  RxList<int> selectedIndexes = <int>[].obs;

  // STATIC DUMMY DATA
  List<Map<String, String>> prepLists = [
    {
      "title": "Prep List from Sunday, 18.1.25",
      "includes": "Recipe Name, Recipe Name, Recipe Name..."
    },
    {
      "title": "Prep List from Monday, 19.1.25",
      "includes": "Recipe A, Recipe B, Recipe C..."
    },
    {
      "title": "Prep List from Tuesday, 20.1.25",
      "includes": "Item 1, Item 2, Item 3..."
    },
    {
      "title": "Prep List from Wednesday, 21.1.25",
      "includes": "Stuff A, Stuff B, Stuff C..."
    },
    {
      "title": "Prep List from Thursday, 22.1.25",
      "includes": "More items..."
    },
    {
      "title": "Prep List from Friday, 23.1.25",
      "includes": "Ingredients list..."
    },
    {
      "title": "Prep List from Saturday, 24.1.25",
      "includes": "Everything you need..."
    },
  ];

  // MULTI SELECT TOGGLE
  void toggleSelect(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
  }

  // NEXT ACTION
  void onNext() {
    if (selectedIndexes.isEmpty) {
      Get.snackbar("Error", "Please select at least one list!");
      return;
    }

    // Navigate to EditShoppingListScreen with selected lists
    Get.to(() => EditShoppingListScreen());
  }

  void onCancel() {
    Get.back();
  }


}
