import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Home/HomeController.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Global/GlobalValue.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class Auth {
  static backLogin(bool isRun, {bool isGetOffAll = true}) async {
    if (!isRun) {
      return null;
    }

    GlobalValue.getInstance().setToken("");
    await Utils.saveStringWithKey(Constant.ACCESS_TOKEN, '');
    await Utils.saveStringWithKey(Constant.USERNAME, '');
    await Utils.saveStringWithKey(Constant.PASSWORD, '');
    await Utils.saveStringWithKey(Constant.AVATAR_USER, '');
    await Utils.saveStringWithKey(Constant.BANNER, '');
    await Utils.saveStringWithKey(Constant.UUID_PROFILE, '');
    await Utils.saveStringWithKey(Constant.UUID_USER, '');
    await Utils.saveStringWithKey(Constant.UUID_USER_ACC, '');
    await Utils.saveStringWithKey(Constant.FULL_NAME, '');
    await Utils.saveStringWithKey(Constant.FCMTOKEN, '');
    // Xóa token ở màn home
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().accessToken.value = "";
    }
    if (Get.currentRoute != Routes.login) {
      isGetOffAll ? Get.offAllNamed(Routes.login) : Get.toNamed(Routes.login);
    }
  }

  static login({String? userName, String? password}) async {
    String userNamePreferences = await Utils.getStringValueWithKey(
      Constant.USERNAME,
    );
    String passwordPreferences = await Utils.getStringValueWithKey(
      Constant.PASSWORD,
    );
    String fcmToken = await Utils.getStringValueWithKey(Constant.FCMTOKEN);
    // print("Fcm token: $fcmToken");

    var param = {
      "username": userName ?? userNamePreferences,
      "password": Utils.generateMd5(password ?? passwordPreferences),
      "fcmToken": fcmToken,
      "type": 1,
    };
    if (userName?.trim() == '' && userNamePreferences == '') {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: 'Vui lòng nhập tên đăng nhâp!',
      );
      return;
    }
    if (password?.trim() == '' && passwordPreferences == '') {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: 'Vui lòng nhập mật khẩu!',
      );
      return;
    }
    try {
      var data = await APICaller.getInstance().post('v1/Auth/login', param);
      if (data != null) {
        GlobalValue.getInstance().setToken('Bearer ${data['data']['token']}');
        Utils.saveStringWithKey(Constant.ACCESS_TOKEN, data['data']['token']);
        Utils.saveStringWithKey(
          Constant.UUID_USER,
          data['data']['userUuid'] ?? '',
        );
        Utils.saveStringWithKey(
          Constant.UUID_USER_ACC,
          data['data']['uuid'] ?? '',
        );
        Utils.saveStringWithKey(
          Constant.USERNAME,
          data['data']['userName'] ?? '',
        );
        Utils.saveStringWithKey(
          Constant.FULL_NAME,
          data['data']['fullname'] ?? '',
        );
        Utils.saveStringWithKey(
          Constant.AVATAR_USER,
          data['data']['avatar'] ?? '',
        );
        Utils.saveStringWithKey(
          Constant.UUID_PROFILE,
          data['data']['profileUuid'] ?? '',
        );
        Utils.saveStringWithKey(Constant.BANNER, data['data']['banner'] ?? '');
        Utils.saveStringWithKey(
          Constant.PASSWORD,
          password ?? passwordPreferences,
        );
        int? registerStatus = data['data']['registerStatus'];
        if (registerStatus == null ||
            registerStatus == 0 ||
            registerStatus == 1) {
          Get.toNamed(
            Routes.registerMember,
            arguments: {"registerStatus": registerStatus},
          );
        } else {
          Get.offAllNamed(Routes.dashboard);
        }
      } else {
        backLogin(true);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

  static loginWeb({String? userName, String? password}) async {
    String userNamePreferences = await Utils.getStringValueWithKey(
      Constant.USERNAME,
    );
    String passwordPreferences = await Utils.getStringValueWithKey(
      Constant.PASSWORD,
    );
    var param = {
      "username": userName ?? userNamePreferences,
      "password": Utils.generateMd5(password ?? passwordPreferences),
      "type": 1,
    };
    if (userName?.trim() == '' && userNamePreferences == '') {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: 'Vui lòng nhập tên đăng nhâp!',
      );
      return;
    }
    if (password?.trim() == '' && passwordPreferences == '') {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: 'Vui lòng nhập mật khẩu!',
      );
      return;
    }
    try {
      var data = await APICaller.getInstance().post('v1/Auth/login', param);
      if (data != null) {
        GlobalValue.getInstance().setToken('Bearer ${data['data']['token']}');
        Utils.saveStringWithKey(Constant.ACCESS_TOKEN, data['data']['token']);
        Utils.saveStringWithKey(
          Constant.UUID_USER,
          data['data']['userUuid'] ?? '',
        );
        Utils.saveStringWithKey(
          Constant.UUID_USER_ACC,
          data['data']['uuid'] ?? '',
        );
        Utils.saveStringWithKey(
          Constant.USERNAME,
          data['data']['userName'] ?? '',
        );
        Utils.saveStringWithKey(
          Constant.FULL_NAME,
          data['data']['fullname'] ?? '',
        );
        Utils.saveStringWithKey(
          Constant.AVATAR_USER,
          data['data']['avatar'] ?? '',
        );
        Utils.saveStringWithKey(
          Constant.UUID_PROFILE,
          data['data']['profileUuid'] ?? '',
        );
        Utils.saveStringWithKey(Constant.BANNER, data['data']['banner'] ?? '');
        Utils.saveStringWithKey(
          Constant.PASSWORD,
          password ?? passwordPreferences,
        );
        int? registerStatus = data['data']['registerStatus'];
        if (registerStatus == null ||
            registerStatus == 0 ||
            registerStatus == 1) {
          Get.toNamed(
            Routes.registerMember,
            arguments: {"registerStatus": registerStatus},
          );
        } else {
          Get.offAllNamed(Routes.dashboard);
        }
      } else {
        backLogin(true);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }
}
