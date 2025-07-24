import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Model/DetailCV.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Service/APICaller.dart';

class CVManagementController extends GetxController {
  RxBool isLoading = false.obs;
  DetailCV detail = DetailCV();
  RxString uuid = "".obs;

  @override
  void onInit() {
    getDetail();
    super.onInit();
  }

  String convertDateFormat(String? inputDate, bool isRquest) {
    if (inputDate == null) return '--';
    if (isRquest) {
      final parts = inputDate.split('/');
      final day = parts[0].padLeft(2, '0');
      final month = parts[1].padLeft(2, '0');
      final year = parts[2];
      return '$year-$month-$day';
    } else {
      final parts = inputDate.split('-');
      final year = parts[0];
      final month = parts[1].padLeft(2, '0');
      final day = parts[2].padLeft(2, '0');
      return '$day/$month/$year';
    }
  }

  getDetail() {
    isLoading.value = true;
    uuid.value = "";
    try {
      APICaller.getInstance().post('v1/Cv/get-detail-cv', {}).then((response) {
        isLoading.value = false;
        if (response != null) {
          detail = DetailCV.fromJson(response["data"]);
          uuid.value = detail.uuid ?? "";
          if (!(detail.isHasCv ?? false)) {
            Get.toNamed(Routes.upsertCV, arguments: detail);
          }
        }
      });
    } catch (e) {
      debugPrint(e.toString());
      isLoading.value = false;
    }
  }
}
