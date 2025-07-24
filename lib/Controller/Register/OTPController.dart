import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Service/APICaller.dart';
import '../../Utils/Utils.dart';
import '../../Route/AppPage.dart';

class OtpController extends GetxController {
  final String email;
  TextEditingController textOTP = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isHideCheck = true.obs;
  RxString otpText = ''.obs;
  DateTime timeNow = DateTime.now();

  OtpController({
    required this.email,
  });

  @override
  void onInit() {
    super.onInit();
    textOTP.addListener(() {
      otpText.value = textOTP.text;
    });
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

  Future<void> verifyOtp({
    required String destinationRoute, // Sẽ không dùng tham số này nữa
    VoidCallback? onOtpVerified,
  }) async {
    if (otpText.value.length != 6 || isLoading.value) return;

    isLoading.value = true;

    try {
      var param = {
        "email": email,
        "otp": otpText.value.trim(),
      };

      var response = await APICaller.getInstance()
          .post('v1/Account/activate-account', param);

      if (response != null && response['error']?['code'] == 0) {
        Get.snackbar(
          'Thành công',
          'Tạo tài khoản thành công! Vui lòng đăng nhập để tiếp tục.',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        Get.offAllNamed(Routes.login);
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: response['error']?['message'] ?? 'Xác thực OTP thất bại!',
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
    textOTP.dispose();
    super.onClose();
  }
}
