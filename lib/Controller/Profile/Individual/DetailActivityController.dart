import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Model/DetailActivity.dart';
import 'package:thehinhvn/Service/APICaller.dart';

class DetailActivityController extends GetxController {
  RxBool isLoading = false.obs;
  String id = "";
  DetailActivity detail = DetailActivity();

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id'] ?? "";
    getDetail();
  }

  getDetail() {
    isLoading.value = true;
    try {
      var param = {"uuid": id};
      APICaller.getInstance()
          .post('v1/Activity/get-detail-activity-app', param)
          .then((response) {
            isLoading.value = false;
            if (response != null) {
              detail = DetailActivity.fromJson(response["data"]);
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      isLoading.value = false;
    }
  }

  String getTextTypeActivity(int type) {
    switch (type) {
      case 1:
        return "Học vấn";
      case 2:
        return "Kinh nghiệm";
      case 3:
        return "Chứng chỉ";
      case 4:
        return "Hoạt động";
      case 5:
        return "Xã hội";
      case 6:
        return "Mục tiêu";
      case 7:
        return "Lịch sử";
      case 8:
        return "Kỹ năng";
      case 9:
        return "Hệ thống";
      case 10:
        return "Hỗ trợ";
      case 11:
        return "Đối tác";
      case 12:
        return "Ban lãnh đạo";
      default:
        return "Không xác định";
    }
  }
}
