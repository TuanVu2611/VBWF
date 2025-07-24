import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Component/DialogCustom.dart';
import 'package:thehinhvn/Controller/DashboardController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/GlobalValue.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/View/Home/Home.dart';
import 'package:thehinhvn/View/Profile/Profile.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _showDialog(context);
      },
      child: Scaffold(
        backgroundColor: ColorHex.background,
        resizeToAvoidBottomInset: false,
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorHex.primary,
          elevation: 0,
          shape: const CircleBorder(),
          onPressed: () => Get.toNamed(Routes.qrCode),
          child: SvgPicture.asset(
            "assets/icons/scan-barcode.svg",
            height: 32,
            width: 32,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        body: Obx(() {
          switch (controller.currentIndex.value) {
            case 0:
              return const Home();
            case 1:
              return Profile();
            default:
              return Container();
          }
        }),
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,
          children: [
            // Bóng đổ phía trên
            Positioned(
              top: -1,
              left: 0,
              right: 0,
              child: Container(
                height: kBottomNavigationBarHeight,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: ColorHex.text1.withAlpha(30),
                      offset: const Offset(0, -2), // Hướng lên trên
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
            BottomAppBar(
              elevation: 0,
              color: Colors.white,
              shape: const CircularNotchedRectangle(),
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Trang chủ
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changePage(0),
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/home_hashtag.svg',
                                height: 20,
                                width: 20,
                                colorFilter:
                                    controller.currentIndex.value == 0
                                        ? const ColorFilter.mode(
                                          ColorHex.primary,
                                          BlendMode.srcIn,
                                        )
                                        : null,
                              ),
                              Text(
                                'Trang chủ',
                                textAlign: TextAlign.center,
                                style:
                                    controller.currentIndex.value == 0
                                        ? const TextStyle(
                                          fontSize: 12,
                                          color: ColorHex.primary,
                                          fontWeight: FontWeight.w700,
                                        )
                                        : const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
        
                    const SizedBox(width: 100),
        
                    // Trang Cá nhân
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (GlobalValue.getInstance().getToken() == "") {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => DialogCustom(
                                    svgColor: ColorHex.primary,
                                    btnColor: ColorHex.primary,
                                    svg: "assets/icons/question_mark.svg",
                                    title: 'Thông báo',
                                    description:
                                        'Tính năng này cần đăng nhập, bạn có muốn tới đăng nhập không?',
                                    onTap: () {
                                      Get.back();
                                      Get.toNamed(Routes.login);
                                    },
                                  ),
                            );
                          } else {
                            controller.changePage(1);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/user_octagon.svg',
                                height: 20,
                                width: 20,
                                colorFilter:
                                    controller.currentIndex.value == 1
                                        ? const ColorFilter.mode(
                                          ColorHex.primary,
                                          BlendMode.srcIn,
                                        )
                                        : null,
                              ),
                              Text(
                                'Cá nhân',
                                textAlign: TextAlign.center,
                                style:
                                    controller.currentIndex.value == 1
                                        ? const TextStyle(
                                          fontSize: 12,
                                          color: ColorHex.primary,
                                          fontWeight: FontWeight.w700,
                                        )
                                        : const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                              ),
                            ],
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
    );
  }

  _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Đóng ứng dụng",
              style: TextStyle(
                fontSize: 22,
                color: ColorHex.text1,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Bạn có chắc muốn đóng ứng dụng không?",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    side: BorderSide(
                      color: ColorHex.primary,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 24,
                    ),
                  ),
                  child: const Text(
                    "Hủy bỏ",
                    style: TextStyle(
                      fontSize: 15,
                      color: ColorHex.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHex.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 24,
                    ),
                  ),
                  child: const Text(
                    "Xác nhận",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
}
