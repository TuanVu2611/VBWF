import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm import
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class RegisterController extends GetxController {
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPass = TextEditingController();
  TextEditingController textConfirmPass = TextEditingController();
  RxBool isHidePassword = true.obs;
  RxBool isLoading = false.obs;
  RxBool isFormValid = false.obs;
  RxBool isOtpStep = false.obs;
  String? emailForOtp;

  @override
  void onInit() {
    super.onInit();
    textEmail.addListener(validateForm);
    textPass.addListener(validateForm);
    textConfirmPass.addListener(validateForm);
  }

  void validateForm() {
    isFormValid.value =
        textEmail.text.trim().isNotEmpty &&
        CheckMailValid(textEmail.text.trim()) &&
        textPass.text.isNotEmpty &&
        textConfirmPass.text.isNotEmpty &&
        textPass.text == textConfirmPass.text;
  }

  Future register() async {
    if (!isFormValid.value || isLoading.value) return;

    if (textPass.text != textConfirmPass.text) {
      Utils.showSnackBar(
        title: 'Lỗi',
        message: 'Mật khẩu và nhập lại mật khẩu không khớp!',
      );
      return;
    }

    isLoading.value = true;

    try {
      var param = {
        "email": textEmail.text.trim(),
        "password": Utils.generateMd5(textPass.text.trim()),
      };

      var response = await APICaller.getInstance().post(
        'v1/Account/verify-email',
        param,
      );
      if (response != null && response['error']?['code'] == 0) {
        emailForOtp = textEmail.text;
        // Lưu email vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_email', textEmail.text.trim());
        isOtpStep.value = true;
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Vui lòng kiểm tra email để nhận mã OTP!',
        );
      } else {
        String errorMessage =
            response['error']?['message'] ??
            response['message'] ??
            'Đăng ký thất bại!';
        Utils.showSnackBar(title: 'Lỗi', message: errorMessage);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool CheckMailValid(String mail) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(mail);
  }

  @override
  void onClose() {
    textEmail.dispose();
    textPass.dispose();
    textConfirmPass.dispose();
    super.onClose();
  }
}
