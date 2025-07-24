import 'package:get/get.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class MyQRController extends GetxController {
  RxString avatar = ''.obs;
  RxString profile = ''.obs;

  @override
  void onInit() {
    super.onInit();
    Utils.getStringValueWithKey(Constant.AVATAR_USER).then((value) {
      avatar.value = value;
    });
    Utils.getStringValueWithKey(Constant.UUID_PROFILE).then((value) {
      profile.value = Constant.QR_MOBILE + value;
    });
  }
}