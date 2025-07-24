import 'package:get/get.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class DashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxString fullName = ''.obs;
  RxString avatar = ''.obs;
  String email = '';
  RxBool isLoading = true.obs;

  @override
  void onInit() async {
    fullName.value = await Utils.getStringValueWithKey(Constant.FULL_NAME);
    avatar.value = await Utils.getStringValueWithKey(Constant.AVATAR_USER);
    email = await Utils.getStringValueWithKey(Constant.USERNAME);
    isLoading.value = false;
    super.onInit();
  }

  changePage(int index) {
    currentIndex.value = index;
  }
}
