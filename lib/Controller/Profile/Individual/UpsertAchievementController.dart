import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Profile/Individual/IndividualController.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Model/DetailAchievement.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class UpsertAchievementController extends GetxController {
  String title = "";
  String id = "";
  RxBool isWaitSubmit = false.obs;
  DetailAchievement detail = DetailAchievement();
  TextEditingController titleAchievement = TextEditingController();
  // RxString sort = "1".obs;
  TextEditingController sort = TextEditingController(text: "1");
  RxInt privacy = 0.obs;
  TextEditingController content = TextEditingController();
  TextEditingController date = TextEditingController();
  Rx<File> file = Rx<File>(File(""));
  Rx<File> fileResponse = Rx<File>(File(""));
  String fileNetwork = "";
  RxString fileSize = "".obs;

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id'] ?? "";
    if (id.isEmpty) {
      title = "Thêm thành tích";
    } else {
      title = "Chỉnh sửa thành tích";
      getDetail();
    }
  }

  String convertDateFormat(String inputDate, bool isRquest) {
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
    isWaitSubmit.value = true;
    try {
      var param = {"uuid": id};
      APICaller.getInstance()
          .post('v1/Achievement/get-detail-achievement-app', param)
          .then((response) {
        isWaitSubmit.value = false;
        if (response != null) {
          print("response: $response");
          detail = DetailAchievement.fromJson(response["data"]);
          titleAchievement.text = detail.title ?? "";
          fileNetwork = "${Constant.BASE_URL_IMAGE}${detail.filePath}";
          APICaller.getInstance()
              .downloadAndGetFile1(fileNetwork)
              .then((value) {
            if (value != null) {
              file.value = value;
              file.value.length().then((data) {
                fileSize.value = "$data bytes";
              });
            }
          });
          // sort.value = "${detail.sort ?? 1}";
          sort.text = detail.sort != null ? "${detail.sort}" : "1";
          privacy.value = detail.privacy ?? 0;
          content.text = detail.content ?? "";
          date.text = convertDateFormat(detail.date!, false);
        }
      });
    } catch (e) {
debugPrint(e.toString());
      isWaitSubmit.value = false;
    }
  }

  submit() {
    isWaitSubmit.value = true;
    if (file.value.path == "" && fileNetwork == "") {
      isWaitSubmit.value = false;
      Utils.showSnackBar(
          title: 'Error!', message: 'Thiếu file cho thành tích này!');
      return;
    }
    try {
      if (fileNetwork != "") {
        var param = {
          "uuid": id,
          "title": titleAchievement.text,
          "content": content.text,
          // "sort": int.parse(sort.value),
          "sort": int.parse(sort.text),
          "date": convertDateFormat(date.text, true),
          "privacy": privacy.value,
          "filePath": detail.filePath,
        };
        APICaller.getInstance()
            .post('v1/Achievement/upsert-achievement-app', param)
            .then((value) {
          isWaitSubmit.value = false;
          if (value != null) {
            if (Get.isRegistered<IndividualController>()) {
              Get.find<IndividualController>().refreshDataAchievement();
            }
            Get.back();
            Utils.showSnackBar(
                title: 'Thông báo!',
                message:
                    'Đã ${id.isEmpty ? "thêm" : "sửa"} thành tích thành công!');
          }
        });
      } else {
        APICaller.getInstance()
            .putFile(
                endpoint: 'v1/Upload/upload-file',
                filePath: file.value,
                type: 7)
            .then((response) {
          if (response != null) {
            var param = {
              "uuid": id,
              "title": titleAchievement.text,
              "content": content.text,
              // "sort": int.parse(sort.value),
              "sort": int.parse(sort.text),
              "date": convertDateFormat(date.text, true),
              "privacy": privacy.value,
              "filePath": response["data"],
            };
            APICaller.getInstance()
                .post('v1/Achievement/upsert-achievement-app', param)
                .then((value) {
              isWaitSubmit.value = false;
              if (value != null) {
                if (Get.isRegistered<IndividualController>()) {
                  Get.find<IndividualController>().refreshDataAchievement();
                }
                Get.back();
                Utils.showSnackBar(
                    title: 'Thông báo!',
                    message:
                        'Đã ${id.isEmpty ? "thêm" : "sửa"} thành tích thành công!');
              }
            });
          }
        });
      }
    } catch (e) {
debugPrint(e.toString());
      isWaitSubmit.value = false;
    }
  }
}
