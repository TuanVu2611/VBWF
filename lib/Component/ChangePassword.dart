import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:thehinhvn/Controller/ForgotPassword/ChangePasswordController.dart';

import '../Global/ColorHex.dart';
import '../Route/AppPage.dart';
import 'Register/CustomTextField.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorHex.background,
        scrolledUnderElevation: 0,
        foregroundColor: const Color.fromRGBO(106, 111, 128, 1),
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed(Routes.forgotPassword);
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
                  'Mật khẩu của bạn phải dài ít nhật 6 ký tự, chứa ít nhất một chữ cái và 1 số.',
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
                controller: controller.textPass,
                hintText: 'Mật khẩu',
                iconPath: 'assets/icons/lock.svg',
                obscureText: controller.isHidePassword.value,
                onChanged: (value) => controller.validateInput(),
                onTapSuffix: () {
                  controller.isHidePassword.value =
                      !controller.isHidePassword.value;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: controller.textConfirmPass,
                hintText: 'Nhập lại mật khẩu',
                iconPath: 'assets/icons/lock.svg',
                obscureText: controller.isHidePassword.value,
                onChanged: (value) => controller.validateInput(),
                onTapSuffix: () {
                  controller.isHidePassword.value =
                      !controller.isHidePassword.value;
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap:
                    controller.isButtonEnabled.value && !controller.isLoading.value
                        ? () {}
                        : null,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: controller.isButtonEnabled.value
                        ? ColorHex.main
                        : const Color.fromRGBO(0, 183, 196, 0.5),
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
          ),
        ),
      ),
    );
  }
}
