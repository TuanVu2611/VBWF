import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Component/Register/CustomTextField.dart';
import '../../Component/Register/LoginPromptText.dart';
import '../../Component/Register/OTPCustom.dart';
import '../../Controller/Register/RegisterController.dart';
import '../../Global/ColorHex.dart';
import '../../Route/AppPage.dart';
import '../../Service/Auth.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController(), tag: 'registerController');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            if (controller.isOtpStep.value) {
              controller.isOtpStep.value = false; // Quay lại giao diện đăng ký
            } else {
              Get.offAllNamed(Routes.login); // Quay lại màn hình login
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
              if (!controller.isOtpStep.value) ...[
                // Giao diện đăng ký
                Image.asset('assets/images/logo.png', width: 70, height: 70),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Đăng kí thành viên',
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
                    'Nhập đầy đủ thông tin để tham gia cộng đồng',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text4,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: controller.textEmail,
                  hintText: 'Email',
                  iconPath: 'assets/icons/email.svg',
                  onChanged: (value) => controller.validateForm(),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: controller.textPass,
                  hintText: 'Mật khẩu',
                  iconPath: 'assets/icons/lock.svg',
                  obscureText: controller.isHidePassword.value,
                  onChanged: (value) => controller.validateForm(),
                  onTapSuffix: () {
                    controller.isHidePassword.value =
                        !controller.isHidePassword.value;
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: controller.textConfirmPass,
                  hintText: 'Nhập lại mật khẩu',
                  iconPath: 'assets/icons/lock.svg',
                  obscureText: controller.isHidePassword.value,
                  onChanged: (value) => controller.validateForm(),
                  onTapSuffix: () {
                    controller.isHidePassword.value =
                        !controller.isHidePassword.value;
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap:
                      controller.isFormValid.value &&
                              !controller.isLoading.value
                          ? () {
                            controller.register();
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
                              'Đăng ký',
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
                const SizedBox(height: 12),
                const LoginPromptText(),
              ] else ...[
                // Giao diện OTP
                OtpView(
                  email: controller.emailForOtp!,
                  destinationRoute: Routes.registerMember,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
