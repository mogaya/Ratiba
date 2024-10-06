import 'package:get/get.dart';

class SignInController extends GetxController {
  var isHidden = true.obs;
  toggleHide() {
    isHidden.value = !isHidden.value;
  }

  var userId = 0.obs;
  var userName = ''.obs;
  var userPhone = ''.obs;
  var userEmail = ''.obs;

  void updateUserId(int id) => userId.value = id;
  void updateUserName(String name) => userName.value = name;
  void updateUserPhone(String phone) => userName.value = phone;
  void updateUserEmail(String email) => userName.value = email;
}
