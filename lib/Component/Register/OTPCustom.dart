import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../Controller/Register/OtpController.dart';
import '../../Global/ColorHex.dart';
import '../../Route/AppPage.dart';

class OtpView extends StatelessWidget {
  final String email;
  final String destinationRoute;
  final VoidCallback? onOtpVerified; // Callback cho ForgotPassword

  const OtpView({
    super.key,
    required this.email,
    required this.destinationRoute,
    this.onOtpVerified,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController(email: email));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset('assets/images/logo_mess.png'),
        const SizedBox(height: 20),
        const Text(
          'Xác thực OTP',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: ColorHex.text4,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Chúng tôi đã gửi mã xác thực đã được gửi cho bạn qua địa chỉ email: ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: ColorHex.text4,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          email,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: ColorHex.text6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Obx(
          () => TextField(
            controller: controller.textOTP,
            onChanged: (value) => controller.otpText.value = value,
            decoration: InputDecoration(
              hintText: 'Nhập mã OTP',
              hintStyle: const TextStyle(
                color: ColorHex.text5,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: SvgPicture.asset(
                  'assets/icons/shield-tick.svg',
                  fit: BoxFit.scaleDown,
                ),
              ),
              suffixIcon:
                  controller.otpText.value.length == 6
                      ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/tick-circle.svg',
                          height: 20,
                          width: 20,
                          fit: BoxFit.scaleDown,
                        ),
                      )
                      : null,
              contentPadding:
              // const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: ColorHex.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: ColorHex.primary, width: 1),
              ),
              counterText: '',
            ),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            keyboardType: TextInputType.number,
            maxLength: 6,
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => GestureDetector(
            onTap:
                controller.isLoading.value ||
                        controller.otpText.value.length != 6
                    ? null
                    : () {
                      controller.verifyOtp(
                        destinationRoute: destinationRoute,
                        onOtpVerified: onOtpVerified,
                      );
                    },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                color:
                    controller.otpText.value.length == 6 &&
                            !controller.isLoading.value
                        ? ColorHex.primary
                        : ColorHex.primary.withOpacity(0.5),
              ),
              child: const Center(
                child: Text(
                  'Xác nhận',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
