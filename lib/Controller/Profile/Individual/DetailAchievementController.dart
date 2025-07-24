import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Model/DetailAchievement.dart';
import 'package:thehinhvn/Service/APICaller.dart';

class DetailAchievementController extends GetxController {
  RxBool isLoading = false.obs;
  String id = "";
  DetailAchievement detail = DetailAchievement();

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
          .post('v1/Achievement/get-detail-achievement-app', param)
          .then((response) {
            isLoading.value = false;
            if (response != null) {
              detail = DetailAchievement.fromJson(response["data"]);
            }
          });
    } catch (e) {
      debugPrint(e.toString());
      isLoading.value = false;
    }
  }
}
