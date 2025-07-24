import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Route/AppPage.dart';
import '../../Service/APICaller.dart';
import '../../Utils/Utils.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController textEmail = TextEditingController();
  TextEditingController textOTP = TextEditingController();
  RxBool isHidePassword = true.obs;
  final String email;
  RxBool isLoading = false.obs;
  RxBool isFormValid = false.obs;
  RxBool isOtpStep = false.obs; // Thêm biến để kiểm soát bước OTP
  String? emailForOtp; // Lưu email cho OTP
  RxString otpText = ''.obs;
  DateTime timeNow = DateTime.now();

  ForgotPasswordController({
    required this.email,
  });

  @override
  void onInit() {
    super.onInit();
    textEmail.addListener(validateForm);
    textOTP.addListener(() {
      otpText.value = textOTP.text;
    });
  }

  void validateForm() {
    isFormValid.value = textEmail.text.isNotEmpty;
  }

  void updateOtp(String value, int index) {
    if (value.isEmpty && otpText.value.length > index) {
      otpText.value = otpText.value.substring(0, index);
    } else if (value.isNotEmpty) {
      if (otpText.value.length > index) {
        otpText.value = otpText.value.substring(0, index) +
            value +
            otpText.value.substring(index + 1);
      } else {
        otpText.value = otpText.value.padRight(index, ' ') + value;
      }
    }

    if (otpText.value.length > 6) {
      otpText.value = otpText.value.substring(0, 6);
      textOTP.text = otpText.value;
      textOTP.selection = TextSelection.fromPosition(
        TextPosition(offset: textOTP.text.length),
      );
    }
  }

  Future sendOTP() async {
    if (!isFormValid.value || isLoading.value) return;

    isLoading.value = true;

    try {
      var param = {"email": textEmail.text.trim()};
      var response =
          await APICaller.getInstance().post('v1/Account/send-otp', param);

      if (response != null && response['error']?['code'] == 0) {
        emailForOtp = textEmail.text.trim();
        isOtpStep.value = true;
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Vui lòng kiểm tra email để nhận mã OTP!',
        );
      } else {
        // Utils.showSnackBar(
        //   title: 'Lỗi',
        //   message: response['error']?['message'] ?? 'Gửi OTP thất bại!',
        // );
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

  Future<bool> enterOTP() async {
    if (otpText.value.length != 6 || isLoading.value) return false;

    isLoading.value = true;

    try {
      var param = {
        "email": emailForOtp,
        "otp": otpText.value.trim(),
      };

      var response =
          await APICaller.getInstance().post('v1/Account/enter-otp', param);

      if (response != null && response['error']?['code'] == 0) {
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Xác thực OTP thành công!',
        );
        return true; // Trả về true nếu OTP hợp lệ
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: response['error']?['message'] ?? 'Mã OTP không hợp lệ!',
        );
        return false;
      }
    } catch (e) {
      Utils.showSnackBar(
        title: 'Lỗi',
        message: 'Đã có lỗi xảy ra: $e',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    textEmail.dispose();
    textOTP.dispose();
    super.onClose();
  }
}
