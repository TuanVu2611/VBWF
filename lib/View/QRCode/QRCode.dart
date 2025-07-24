import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Component/DialogCustom.dart';
import 'package:thehinhvn/Controller/QRCode/QRCodeController.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/GlobalValue.dart';
import 'package:thehinhvn/Route/AppPage.dart';
// import 'package:qr_flutter/qr_flutter.dart';

class Qrcode extends StatelessWidget {
  Qrcode({super.key});

  final controller = Get.put(QRCodeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: controller.qrKey,
            onQRViewCreated: controller.onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.greenAccent,
              borderRadius: 12,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: Get.width - 100,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: ColorHex.primary,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              child: SafeArea(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.chevron_left_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: const Text(
                        'Quét mã QR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 50),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Quét mã QR để tìm kiếm hoặc kết bạn',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.width - 60),
                const Text(
                  'Căn chỉnh QR-Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: ColorHex.primary,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
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
                    Get.toNamed(Routes.myQR);
                  }
                },
                child: const Text(
                  'Chia sẻ mã QR của tôi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    color: ColorHex.text1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
