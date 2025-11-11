import 'package:get/get.dart';

class BottomNavbarController extends GetxController {
  var currentIndex = 0.obs;

  BottomNavbarController([int initialIndex = 0]) {
    currentIndex.value = initialIndex;
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}