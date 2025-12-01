import 'package:get/get.dart';

class SubscriptionController extends GetxController {
  var selectedPlan = (-1).obs;

  void selectPlan(int index) {
    selectedPlan.value = index;
  }
}
