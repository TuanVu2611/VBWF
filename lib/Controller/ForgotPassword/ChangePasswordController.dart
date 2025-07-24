import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Service/APICaller.dart';
import '../../Utils/Utils.dart';
import '../../Route/AppPage.dart';

class ChangePasswordController extends GetxController {
  TextEditingController textPass = TextEditingController();
  TextEditingController textConfirmPass = TextEditingController();
  RxBool isHidePassword = true.obs;
  RxBool isLoading = false.obs;
  RxBool isButtonEnabled = false.obs;
  String? email;

  @override
  void onInit() {
    super.onInit();
    textPass.addListener(validateInput);
    textConfirmPass.addListener(validateInput);
  }

  void validateInput() {
    // Chỉ cần người dùng nhập cả 2 ô là nút sẽ bật lên
    isButtonEnabled.value =
        textPass.text.trim().isNotEmpty && textConfirmPass.text.trim().isNotEmpty;
  }

  Future changePassForget(String email, String otp) async {
    if (!isButtonEnabled.value || isLoading.value) return;

    final password = textPass.text;
    final confirmPassword = textConfirmPass.text;
    final hasMinLength = password.length >= 6;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);

    if (!hasMinLength || !hasLetter || !hasNumber) {
      Utils.showSnackBar(
        title: 'Lỗi',
        message:
        'Mật khẩu phải có ít nhất 6 ký tự, chứa ít nhất một chữ cái và một số.',
      );
      return;
    }

    if (password != confirmPassword) {
      Utils.showSnackBar(
        title: 'Lỗi',
        message: 'Mật khẩu xác nhận không khớp.',
      );
      return;
    }

    isLoading.value = true;

    try {
      var param = {
        "email": email.trim(),
        "otp": otp.trim(),
        "newPass": Utils.generateMd5(password.trim()),
      };

      var response = await APICaller.getInstance()
          .post('v1/Account/change-pass-forget', param);

      if (response != null && response['error']?['code'] == 0) {
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Đổi mật khẩu thành công!',
        );
        Get.offAllNamed(Routes.login);
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: response['error']?['message'] ?? 'Đổi mật khẩu thất bại!',
        );
      }
    } catch (e) {
      Utils.showSnackBar(
        title: 'Lỗi',
        message: 'Đã có lỗi xảy ra: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    textPass.dispose();
    textConfirmPass.dispose();
    super.onClose();
  }
}
