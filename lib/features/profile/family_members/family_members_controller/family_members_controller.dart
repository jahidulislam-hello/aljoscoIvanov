import 'package:freshbite/features/profile/family_members/family_member_model.dart';
import 'package:get/get.dart';


class FamilyMemberController extends GetxController {
  var members = <FamilyMemberModel>[].obs;

  var isLoading = false.obs;

  void addMember(String name, String img) {
    members.add(FamilyMemberModel(name: name, image: img));
  }
}
