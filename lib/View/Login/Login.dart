import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Login/LoginController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Service/Auth.dart';
import '../../Route/AppPage.dart';

// Widget tùy chỉnh để thêm hiệu ứng tỏa lên cho SVG
class AnimatedSvg extends StatefulWidget {
  final String assetPath;
  final double delay; // Độ trễ để các logo xuất hiện lần lượt

  const AnimatedSvg({required this.assetPath, this.delay = 0.0, super.key});

  @override
  _AnimatedSvgState createState() => _AnimatedSvgState();
}

class _AnimatedSvgState extends State<AnimatedSvg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Hiệu ứng mờ dần (opacity)
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Hiệu ứng di chuyển lên trên
    _translateAnimation = Tween<double>(
      begin: 20.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Bắt đầu animation với độ trễ
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) {
        _controller.repeat(reverse: true); // Lặp lại để tạo cảm giác liên tục
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _translateAnimation.value),
            child: SvgPicture.asset(widget.assetPath),
          ),
        );
      },
    );
  }
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        controller.textUserName.clear();
        controller.textPass.clear();
        Get.toNamed(Routes.home);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          foregroundColor: const Color.fromRGBO(106, 111, 128, 1),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.textUserName.clear();
              controller.textPass.clear();
              Get.toNamed(Routes.home);
            },
          ),
        ),
        body: Obx(
          () => Container(
            color: Colors.white,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedSvg(
                            assetPath: 'assets/icons/logo_farther_1.svg',
                            delay: 0.0,
                          ),
                          AnimatedSvg(
                            assetPath: 'assets/icons/logo_farther_2.svg',
                            delay: 0.3,
                          ),
                          AnimatedSvg(
                            assetPath: 'assets/icons/logo_farther_3.svg',
                            delay: 0.6,
                          ),
                          Image.asset(
                            'assets/images/logo.png',
                            width: 70,
                            height: 70,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 200),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Xin chào!',
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
                          'Đăng nhập vào tài khoản của bạn',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: ColorHex.text4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(228, 230, 236, 1),
                          ),
                        ),
                        child: TextField(
                          controller: controller.textUserName,
                          onChanged: (value) => controller.validateForm(),
                          decoration: InputDecoration(
                            hintText: 'Tài khoản',
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
                                'assets/icons/user_login.svg',
                                height: 20,
                                width: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: ColorHex.primary,
                                width: 1,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 1,
                            color: const Color.fromRGBO(228, 230, 236, 1),
                          ),
                        ),
                        child: TextField(
                          obscureText: controller.isHidePassword.value,
                          controller: controller.textPass,
                          onChanged: (value) => controller.validateForm(),
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu',
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
                                'assets/icons/lock.svg',
                                height: 20,
                                width: 20,
                                fit: BoxFit.cover,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: ColorHex.primary,
                                width: 1,
                              ),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                controller.isHidePassword.value =
                                    !controller.isHidePassword.value;
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                child: SvgPicture.asset(
                                  controller.isHidePassword.value
                                      ? 'assets/icons/eye_slash.svg'
                                      : 'assets/icons/eye.svg',
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.forgotPassword);
                          },
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: ColorHex.text4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap:
                            controller.isFormValid.value &&
                                    !controller.isLoading.value
                                ? () async {
                                  controller.isLoading.value = true;
                                  await Auth.login(
                                    userName: controller.textUserName.text,
                                    password: controller.textPass.text,
                                  );
                                  controller.isLoading.value = false;
                                }
                                : null,
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
                                controller.isFormValid.value
                                    ? ColorHex.primary
                                    : ColorHex.primary.withOpacity(0.5),
                          ),
                          child: const Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Đăng nhập',
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
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: 'Bạn chưa có tài khoản, ',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: ColorHex.text2,
                            ),
                            children: [
                              TextSpan(
                                text: 'Đăng ký ngay',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: ColorHex.primary,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.offAllNamed(Routes.register);
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
