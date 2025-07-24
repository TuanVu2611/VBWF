import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Profile/CVManagement/CVManagementController.dart';
import 'package:thehinhvn/Model/DetailCV.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class UpsertCVController extends GetxController {
  Rx<DetailCV> detail = DetailCV().obs;
  late String title;
  late bool isCreate;
  RxBool isWaitSubmit = false.obs;
  Rx<File> image = Rx<File>(File(""));
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  RxInt gender = 0.obs;
  TextEditingController birthday = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController introduce = TextEditingController();
  TextEditingController skill = TextEditingController();
  TextEditingController hobby = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    detail.value = Get.arguments;
    isCreate = (detail.value.isHasCv ?? false) == false;
    if (isCreate) {
      title = "Khởi tạo CV";
    } else {
      title = "Chỉnh sửa CV";
    }
    _setForm();
  }

  String convertDateFormat(String? inputDate, bool isRquest) {
    if (inputDate == null) return '';
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

  _setForm() {
    email.text = detail.value.email ?? "";
    phoneNumber.text = detail.value.phoneNumber ?? "";
    gender.value = detail.value.gender ?? 0;
    birthday.text = convertDateFormat(detail.value.birthday, false);
    height.text = "${detail.value.height ?? 0}";
    weight.text = "${detail.value.weight ?? 0}";
    address.text = detail.value.address ?? "";
    introduce.text = detail.value.introduce ?? "";
    skill.text = detail.value.skill ?? "";
    hobby.text = detail.value.hobby ?? "";
  }

  getDetail() {
    isWaitSubmit.value = true;
    try {
      APICaller.getInstance().post('v1/Cv/get-detail-cv', {}).then((response) {
        isWaitSubmit.value = false;
        if (response != null) {
          detail.value = DetailCV.fromJson(response["data"]);
          _setForm();
        }
      });
    } catch (e) {
debugPrint(e.toString());
      isWaitSubmit.value = false;
    }
  }

  submit() {
    isWaitSubmit.value = true;
    try {
      if (image.value.path == "") {
        var param = {
          "uuid": detail.value.uuid ?? "",
          "name": detail.value.name ?? "",
          "email": email.text,
          "address": address.text,
          "gender": gender.value,
          "birthday": convertDateFormat(birthday.text, true),
          "height": int.parse(height.text),
          "weight": int.parse(weight.text),
          "phoneNumber": phoneNumber.text,
          "introduce": introduce.text,
          "skill": skill.text,
          "hobby": hobby.text,
          "imagePath": detail.value.imagePath ?? "",
        };
        APICaller.getInstance().post('v1/Cv/upsert-cv', param).then((value) {
          isWaitSubmit.value = false;
          if (value != null) {
            if (Get.isRegistered<CVManagementController>()) {
              Get.find<CVManagementController>().getDetail();
            }
            Get.back();
            Utils.showSnackBar(
              title: 'Thông báo!',
              message:
                  'Đã ${isCreate ? "khởi tạo" : "chỉnh sửa"} CV thành công!',
            );
          }
        });
      } else {
        APICaller.getInstance()
            .putFile(
              endpoint: 'v1/Upload/upload-single-image',
              filePath: image.value,
              type: 9,
            )
            .then((response) {
              if (response != null) {
                var param = {
                  "uuid": detail.value.uuid ?? "",
                  "name": detail.value.name ?? "",
                  "email": email.text,
                  "address": address.text,
                  "gender": gender.value,
                  "birthday": convertDateFormat(birthday.text, true),
                  "height": int.parse(height.text),
                  "weight": int.parse(weight.text),
                  "phoneNumber": phoneNumber.text,
                  "introduce": introduce.text,
                  "skill": skill.text,
                  "hobby": hobby.text,
                  "imagePath": response["data"],
                };
                APICaller.getInstance().post('v1/Cv/upsert-cv', param).then((
                  value,
                ) {
                  isWaitSubmit.value = false;
                  if (value != null) {
                    if (Get.isRegistered<CVManagementController>()) {
                      Get.find<CVManagementController>().getDetail();
                    }
                    Get.back();
                    Utils.showSnackBar(
                      title: 'Thông báo!',
                      message:
                          'Đã ${isCreate ? "khởi tạo" : "chỉnh sửa"} CV thành công!',
                    );
                  }
                });
              }
            });
      }
      isWaitSubmit.value = false;
    } catch (e) {
debugPrint(e.toString());
      isWaitSubmit.value = false;
    }
  }
}
