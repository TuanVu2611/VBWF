import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Profile/CVManagement/UpsertCVController.dart';
import 'package:thehinhvn/Controller/Profile/Individual/IndividualController.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Model/DetailActivity.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class UpsertActivityController extends GetxController {
  String title = "";
  String id = "";
  RxInt privacy = 0.obs;
  RxString type = "0".obs;
  RxBool isIncv = true.obs;
  RxBool isWaitSubmit = false.obs;
  TextEditingController url = TextEditingController();
  TextEditingController titleActivity = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController content = TextEditingController();

  // RxString sort = "1".obs;
  TextEditingController sort = TextEditingController(text: "1");
  Rx<File> image = Rx<File>(File(""));
  RxString imageNetwork = "".obs;
  DetailActivity detail = DetailActivity();
  String? typeAgrument;

  @override
  void onInit() {
    super.onInit();
    id = Get.parameters['id'] ?? "";
    typeAgrument = Get.parameters["type"];
    if (typeAgrument != null) {
      type.value = typeAgrument!;
    }
    if (id.isEmpty) {
      title = "Thêm hoạt động";
    } else {
      title = "Chỉnh sửa hoạt động";
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
          .post('v1/Activity/get-detail-activity-app', param)
          .then((response) {
            isWaitSubmit.value = false;
            if (response != null) {
              detail = DetailActivity.fromJson(response["data"]);
              type.value = detail.type != null ? "${detail.type}" : "1";
              isIncv.value = detail.isIncv ?? true;
              imageNetwork.value =
                  "${Constant.BASE_URL_IMAGE}${detail.imagePath}";
              url.text = detail.link ?? "";
              titleActivity.text = detail.title ?? "";
              fromDate.text = convertDateFormat(detail.fromDate!, false);
              toDate.text = convertDateFormat(detail.toDate!, false);
              // sort.value = detail.sort != null ? "${detail.sort}" : "1";
              sort.text = detail.sort != null ? "${detail.sort}" : "1";
              content.text = detail.content ?? "";
              privacy.value = detail.privacy ?? 0;
            }
          });
    } catch (e) {
debugPrint(e.toString());
      isWaitSubmit.value = false;
    }
  }

  submit() {
    isWaitSubmit.value = true;
    if (image.value.path == "" && imageNetwork.value == "") {
      isWaitSubmit.value = false;
      Utils.showSnackBar(
        title: 'Error!',
        message: 'Thiếu ảnh cho hoạt động này!',
      );
      return;
    }
    try {
      if (imageNetwork.value != "" && image.value.path == "") {
        var param = {
          "uuid": id,
          "title": titleActivity.text,
          "content": content.text,
          "link": url.text,
          "fromDate":
          (type.value == "1" ||
              type.value == "2" ||
              type.value == "3" ||
              type.value == "4" ||
              type.value == "5" ||
              type.value == "6" ||
              type.value == "7" ||
              type.value == "8")
              ? convertDateFormat(fromDate.text, true)
              : null,
          "toDate":
          (type.value == "1" ||
              type.value == "2" ||
              type.value == "5" ||
              type.value == "7")
              ? convertDateFormat(toDate.text, true)
              : null,
          // "sort": int.parse(sort.value),
          "sort": int.parse(sort.text),
          "type": int.parse(type.value),
          "isIncv": isIncv.value,
          "privacy": privacy.value,
          "imagePath": detail.imagePath,
        };
        APICaller.getInstance()
            .post('v1/Activity/upsert-activity-app', param)
            .then((value) {
              isWaitSubmit.value = false;
              if (value != null) {
                if (typeAgrument != null) {
                  if (Get.isRegistered<UpsertCVController>()) {
                    Get.find<UpsertCVController>().getDetail();
                  }
                } else {
                  if (Get.isRegistered<IndividualController>()) {
                    Get.find<IndividualController>().refreshDataActivity();
                  }
                }
                Get.back();
                Utils.showSnackBar(
                  title: 'Thông báo!',
                  message:
                      'Đã ${id.isEmpty ? "thêm" : "sửa"} hoạt động thành công!',
                );
              }
            });
      } else {
        APICaller.getInstance()
            .putFile(
              endpoint: 'v1/Upload/upload-single-image',
              filePath: image.value,
              type: 7,
            )
            .then((response) {
              if (response != null) {
                var param = {
                  "uuid": id,
                  "title": titleActivity.text,
                  "content": content.text,
                  "link": url.text,
                  "fromDate":
                      (type.value == "1" ||
                              type.value == "2" ||
                              type.value == "3" ||
                              type.value == "4" ||
                              type.value == "5" ||
                              type.value == "6" ||
                              type.value == "7" ||
                              type.value == "8")
                          ? convertDateFormat(fromDate.text, true)
                          : null,
                  "toDate":
                      (type.value == "1" ||
                              type.value == "2" ||
                              type.value == "5" ||
                              type.value == "7")
                          ? convertDateFormat(toDate.text, true)
                          : null,
                  // "sort": int.parse(sort.value),
                  "sort": int.parse(sort.text),
                  "type": int.parse(type.value),
                  "isIncv": isIncv.value,
                  "privacy": privacy.value,
                  "imagePath": response["data"],
                };
                print(jsonEncode(param));
                APICaller.getInstance()
                    .post('v1/Activity/upsert-activity-app', param)
                    .then((value) {
                      isWaitSubmit.value = false;
                      if (value != null) {
                        if (typeAgrument != null) {
                          if (Get.isRegistered<UpsertCVController>()) {
                            Get.find<UpsertCVController>().getDetail();
                          }
                        } else {
                          if (Get.isRegistered<IndividualController>()) {
                            Get.find<IndividualController>()
                                .refreshDataActivity();
                          }
                        }
                        Get.back();
                        Utils.showSnackBar(
                          title: 'Thông báo!',
                          message:
                              'Đã ${id.isEmpty ? "thêm" : "sửa"} hoạt động thành công!',
                        );
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
