import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thehinhvn/Controller/QRCode/MyQRController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';

class MyQR extends StatelessWidget {
  MyQR({super.key});

  final controller = Get.put(MyQRController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: ColorHex.primary,
        shadowColor: ColorHex.text1,
        foregroundColor: Colors.white,
        title: Text(
          "QR của tôi",
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
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
            const SizedBox(height: 24),
            Obx(
              () => QrImageView(
                data: controller.profile.value,
                size: Get.width - 100,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Quét mã để xem thông tin của tôi',
              style: TextStyle(
                color: ColorHex.text1,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
