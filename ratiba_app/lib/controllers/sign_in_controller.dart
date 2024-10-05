import 'package:get/get.dart';

class SignInController extends GetxController {
  var isHidden = true.obs;
  toggleHide() {
    isHidden.value = !isHidden.value;
  }

  var userId = 0.obs;
  var userName = ''.obs;

  void updateUserId(int num) => userId.value = num;
}
