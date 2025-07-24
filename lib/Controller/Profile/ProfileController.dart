import 'package:get/get.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class ProfileController extends GetxController {
  RxString fullName = ''.obs;
  RxString avatar = ''.obs;
  RxString banner = ''.obs;

  @override
  void onInit() {
    super.onInit();
    Utils.getStringValueWithKey(Constant.AVATAR_USER).then((value) {
      avatar.value = value;
    });
    Utils.getStringValueWithKey(Constant.BANNER).then((value) {
      banner.value = value;
    });
    Utils.getStringValueWithKey(Constant.FULL_NAME).then((value) {
      fullName.value = value;
    });
  }

  updateName(String name) {
    fullName.value = name;
  }

  updateBanner(String banner) {
    this.banner.value = banner;
  }

  updateAvatar(String avatar) {
    this.avatar.value = avatar;
  }
}