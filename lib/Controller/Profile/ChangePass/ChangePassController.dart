import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class ChangePassController extends GetxController {
  RxBool isWaitSubmit = false.obs;
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();
  RxBool isHidePass = true.obs;
  RxBool isHideNew = true.obs;
  RxBool isHideConfirm = true.obs;

  submit() async {
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(newPassword.text.trim())) {
      Utils.showSnackBar(
        title: 'Lỗi',
        message: 'Mật khẩu mới phải chứa cả chữ cái và số!',
      );
      return;
    }
    isWaitSubmit.value = true;
    try {
      var param = {
        "uuid": await Utils.getStringValueWithKey(Constant.UUID_USER_ACC),
        "oldPassword": Utils.generateMd5(oldPassword.text.trim()),
        "newPassword": Utils.generateMd5(newPassword.text.trim())
      };
      APICaller.getInstance()
          .post('v1/Account/change-pass', param)
          .then((response) {
        isWaitSubmit.value = false;
        if (response != null) {
          Get.back();
          Utils.showSnackBar(
              title: 'Thông báo!', message: 'Đã đổi mật khẩu thành công!');
        }
      });
    } catch (e) {
debugPrint(e.toString());
      isWaitSubmit.value = false;
    }
  }
}
