import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/ForgotPassword/ChangePasswordController.dart';
import '../../Component/Register/CustomTextField.dart';
import '../../Controller/ForgotPassword/ForgotPasswordController.dart';
import '../../Global/ColorHex.dart';
import '../../Route/AppPage.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController(email: ''));
    final controllerChangePass = Get.put(ChangePasswordController());
    final isChangePasswordStep = false.obs; // Quản lý trạng thái cục bộ

    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      //   backgroundColor: Colors.white,
      //   shadowColor: ColorHex.text1,
      //   foregroundColor: ColorHex.text1,
      //   scrolledUnderElevation: 0,
      //   leading: IconButton(
      //     onPressed: () {
      //       if (isChangePasswordStep.value) {
      //         isChangePasswordStep.value = false; // Quay lại OTP
      //         controller.isOtpStep.value = true;
      //       } else if (controller.isOtpStep.value) {
      //         controller.isOtpStep.value = false; // Quay lại nhập email
      //       } else {
      //         Get.offAllNamed(Routes.login); // Quay lại màn hình login
      //       }
      //     },
      //     icon: const Icon(Icons.arrow_back),
      //   ),
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            if (isChangePasswordStep.value) {
              isChangePasswordStep.value = false; // Quay lại OTP
              controller.isOtpStep.value = true;
            } else if (controller.isOtpStep.value) {
              controller.isOtpStep.value = false; // Quay lại nhập email
              controller.textOTP.clear(); // Xóa nội dung TextField OTP
              controller.otpText.value = '';
            } else {
              Get.toNamed(Routes.login); // Quay lại màn hình login
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Obx(
        () => Container(
          color: Colors.white,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (!controller.isOtpStep.value &&
                  !isChangePasswordStep.value) ...[
                // Giao diện nhập email
                Image.asset(
                  'assets/images/logo_security.png',
                  width: 72,
                  height: 72,
                ),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Quên mật khẩu',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: ColorHex.text4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Chúng tôi sẽ gửi mã OTP đến địa chỉ email bạn cung cấp.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 19),
                CustomTextField(
                  controller: controller.textEmail,
                  hintText: 'Email',
                  iconPath: 'assets/icons/email.svg',
                  onChanged: (value) => controller.validateForm(),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap:
                      controller.isFormValid.value &&
                              !controller.isLoading.value
                          ? () async {
                            controller.emailForOtp = controller.textEmail.text;
                            await controller.sendOTP(); // Gọi API gửi OTP
                          }
                          : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color:
                          controller.isFormValid.value
                              ? ColorHex.primary
                              : ColorHex.primary.withOpacity(0.5),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Gửi OTP',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (controller.isOtpStep.value) ...[
                // Giao diện nhập OTP
                Column(
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
                      'Chúng tôi đã gửi mã xác thực qua địa chỉ email: ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: ColorHex.text4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      controller.emailForOtp!,
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: ColorHex.grey,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: ColorHex.primary,
                              width: 1,
                            ),
                          ),
                          counterText: '',
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
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
                                : () async {
                                  bool isOtpValid = await controller.enterOTP();
                                  if (isOtpValid) {
                                    controller.isOtpStep.value = false;
                                    isChangePasswordStep.value =
                                        true; // Chuyển sang đổi mật khẩu
                                  }
                                },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
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
                ),
              ] else if (isChangePasswordStep.value) ...[
                // Giao diện đổi mật khẩu
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Tạo mật khẩu mới',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: ColorHex.text4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Mật khẩu của bạn phải dài ít nhất 6 ký tự, chứa ít nhất một chữ cái và 1 số.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 19),
                CustomTextField(
                  controller: controllerChangePass.textPass,
                  hintText: 'Mật khẩu',
                  iconPath: 'assets/icons/lock.svg',
                  obscureText: controllerChangePass.isHidePassword.value,
                  onChanged: (value) => controllerChangePass.validateInput(),
                  onTapSuffix: () {
                    controllerChangePass.isHidePassword.value =
                        !controllerChangePass.isHidePassword.value;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: controllerChangePass.textConfirmPass,
                  hintText: 'Nhập lại mật khẩu',
                  iconPath: 'assets/icons/lock.svg',
                  obscureText: controllerChangePass.isHidePassword.value,
                  onChanged: (value) => controllerChangePass.validateInput(),
                  onTapSuffix: () {
                    controllerChangePass.isHidePassword.value =
                        !controllerChangePass.isHidePassword.value;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap:
                      controllerChangePass.isButtonEnabled.value &&
                              !controllerChangePass.isLoading.value
                          ? () async {
                            await controllerChangePass.changePassForget(
                              controller.emailForOtp!,
                              controller.otpText.value,
                            ); // Gọi API đổi mật khẩu
                          }
                          : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color:
                          controllerChangePass.isButtonEnabled.value
                              ? ColorHex.primary
                              : ColorHex.primary.withOpacity(0.5),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Đổi mật khẩu',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
