import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';

class QRCodeController extends GetxController {
  final qrKey = GlobalKey(debugLabel: 'QR');
  RxString result = ''.obs;
  // Biến để tránh gọi BottomSheet nhiều lần
  bool isBottomSheetShow = false;

  // Hàm xử lý khi quét được QR Code
  void onQRViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((scanData) {
      String scannedCode = scanData.code ?? '';
      
      if (!isBottomSheetShow) {
        result.value = scannedCode;
        isBottomSheetShow = true;
        // _showBottomSheet(scannedCode);
        if(scannedCode.contains(Constant.QR_MOBILE)) {
          scannedCode = scannedCode.replaceAll(Constant.QR_MOBILE, "");
          Get.back();
          Get.toNamed(Routes.individual, arguments: {"uuid": scannedCode});
        }
        isBottomSheetShow = false;
      }
    });
  }
}