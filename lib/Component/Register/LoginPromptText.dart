import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../Global/ColorHex.dart';
import '../../Route/AppPage.dart';
import 'package:get/get.dart';

class LoginPromptText extends StatelessWidget {
  const LoginPromptText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: 'Bạn đã có tài khoản, ',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: ColorHex.text2,
          ),
          children: [
            TextSpan(
              text: 'Đăng nhập ngay',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ColorHex.primary,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.offAllNamed(Routes.login);
                },
            ),
          ],
        ),
      ),
    );
  }
}
