import 'package:get/get.dart';
import 'shopping_model.dart';

class ShoppingController extends GetxController {
  var selectedDate = DateTime.now().obs;

  var shoppingLists = <ShoppingModel>[
    ShoppingModel(
      title: "Title of Shopping List",
      description: "Lorem Ipsum is simply dummy text of the Lorem Ipsum is simply...",
      image: "assets/images/food1.png",
      createdBy: "User Name",
      date: "18.1.25",
      isFinished: true,
    ),
    ShoppingModel(
      title: "Title of Shopping List",
      description: "Lorem Ipsum is simply dummy text of the Lorem Ipsum is simply...",
      image: "assets/images/food2.png",
      createdBy: "User Name",
      date: "18.1.25",
      isFinished: false,
    ),
  ].obs;

  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  void toggleFinished(int index) {
    shoppingLists[index] = ShoppingModel(
      title: shoppingLists[index].title,
      description: shoppingLists[index].description,
      image: shoppingLists[index].image,
      createdBy: shoppingLists[index].createdBy,
      date: shoppingLists[index].date,
      isFinished: !shoppingLists[index].isFinished,
    );
  }
}
