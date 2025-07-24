import 'package:get/get.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Service/Auth.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    String accessToken =
        await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);
    if (accessToken.isEmpty) {
      Get.offAllNamed(Routes.introduce);
    } else {
      await Auth.login();
    }
  }
}
