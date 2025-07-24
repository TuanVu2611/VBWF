import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Component/DialogCustom.dart';
import 'package:thehinhvn/Controller/DashboardController.dart';
import 'package:thehinhvn/Controller/Profile/ProfileController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Service/Auth.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Get.width * 0.55),
        child: Obx(
          () => Image.network(
            "${Constant.BASE_URL_IMAGE}${controller.banner.value}",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/bg.png', fit: BoxFit.cover);
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 62),
            Obx(
              () => Text(
                controller.fullName.value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: ColorHex.text1,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 0), // Bóng đổ xuống dưới
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _itemRow(
                    title: "Trang cá nhân",
                    icon: "assets/icons/user_octagon.svg",
                    onTap: () => Get.toNamed(Routes.individual),
                  ),
                  _itemRow(
                    title: "Hồ sơ cá nhân",
                    icon: "assets/icons/user-edit.svg",
                    onTap: () => Get.toNamed(Routes.editProfile),
                  ),
                  _itemRow(
                    title: "Quản lý CV",
                    icon: "assets/icons/personalcard.svg",
                    onTap: () => Get.toNamed(Routes.cv),
                  ),
                  _itemRow(
                    title: "Phát hành thẻ",
                    icon: "assets/icons/card.svg",
                    onTap: () => Get.toNamed(Routes.cardissuance),
                  ),
                  _itemRow(
                    title: "Thống kê",
                    icon: "assets/icons/status-up.svg",
                    onTap: () => Get.toNamed(Routes.statistical),
                  ),
                  _itemRow(
                    title: "Lịch sử",
                    icon: "assets/icons/document-text.svg",
                    onTap: () => Get.toNamed(Routes.history),
                  ),
                  _itemRow(
                    title: "Đổi mật khẩu",
                    icon: "assets/icons/shield-security.svg",
                    onTap: () => Get.toNamed(Routes.changePass),
                  ),
                  _itemRow(
                    title: "Đăng xuất",
                    icon: "assets/icons/logout.svg",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => DialogCustom(
                              svgColor: const Color(0xffD95656),
                              btnColor: const Color(0xffD95656),
                              svg: "assets/icons/question_mark.svg",
                              title: 'Đăng xuất',
                              description: 'Bạn muốn đăng xuất khỏi ứng dụng?',
                              onTap: () async {
                                Navigator.pop(context);
                                if (Get.isRegistered<DashboardController>()) {
                                  Get.find<DashboardController>().changePage(0);
                                }
                                Auth.backLogin(true, isGetOffAll: false);
                              },
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 150),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        backgroundColor: ColorHex.background,
        elevation: 0,
        shape: const CircleBorder(),
        onPressed: null,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Obx(
            () => ClipOval(
              child: Image.network(
                height: 96,
                width: 96,
                Constant.BASE_URL_IMAGE + controller.avatar.value,
                fit: BoxFit.cover,
                errorBuilder: (
                  BuildContext context,
                  Object exception,
                  StackTrace? stackTrace,
                ) {
                  return Image.asset(
                    "assets/images/avatar_default.png",
                    height: 96,
                    width: 96,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _itemRow({
    required String title,
    required String icon,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2, color: ColorHex.background),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgPicture.asset(
                    icon,
                    height: 18,
                    width: 18,
                    colorFilter: const ColorFilter.mode(
                      ColorHex.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorHex.text2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Color(0xFF7D8591),
            ),
          ],
        ),
      ),
    );
  }
}
