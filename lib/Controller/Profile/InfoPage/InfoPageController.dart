import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Home/HomeController.dart';
import 'package:thehinhvn/Controller/Profile/Individual/IndividualController.dart';
import 'package:thehinhvn/Controller/Profile/ProfileController.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Model/District.dart';
import 'package:thehinhvn/Model/Individual.dart';
import 'package:thehinhvn/Model/Province.dart';
import 'package:thehinhvn/Model/Town.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class InfoPageController extends GetxController {
  Timer? debounceTimer;
  // Avatar
  RxBool isEditAvatar = false.obs;
  Rx<File> avatar = Rx<File>(File(""));
  RxString avatarLocal = ''.obs;
  // Banner
  RxBool isEditBanner = false.obs;
  Rx<File> banner = Rx<File>(File(""));
  RxString bannerLocal = ''.obs;
  // Field
  Rx<Individual> info = Individual().obs;
  TextEditingController name = TextEditingController();
  TextEditingController slogan = TextEditingController();
  TextEditingController hobby = TextEditingController();
  TextEditingController expertiseName = TextEditingController();
  TextEditingController expertiseDate = TextEditingController();
  TextEditingController address1 = TextEditingController();
  // Province
  RxBool isWaitProvinces = true.obs;
  bool isFirstFetchProvince = true;
  RxList<Province> provinces = RxList<Province>();
  TextEditingController provincesName = TextEditingController();
  RxString matp = ''.obs;
  // District
  RxBool isWaitDistrict = true.obs;
  bool isFirstFetchDistrict = true;
  RxList<District> districts = RxList<District>();
  TextEditingController districtsName = TextEditingController();
  RxString maqh = ''.obs;
  // Town
  RxBool isWaitTown = true.obs;
  bool isFirstFetchTown = true;
  RxList<Town> towns = RxList<Town>();
  TextEditingController townsName = TextEditingController();
  RxString xaid = ''.obs;

  @override
  void onInit() {
    super.onInit();
    info.value = Get.arguments;
    name.text = info.value.name ?? '';
    slogan.text = info.value.slogan ?? '';
    hobby.text = info.value.hobby ?? '';
    hobby.text = info.value.hobby ?? '';
    expertiseName.text = info.value.infoExpertise?.expertiseName ?? '';
    matp.value = info.value.infoExpertise?.tp?.uuid ?? "";
    provincesName.text = info.value.infoExpertise?.tp?.name ?? "";
    maqh.value = info.value.infoExpertise?.qh?.uuid ?? "";
    districtsName.text = info.value.infoExpertise?.qh?.name ?? "";
    xaid.value = info.value.infoExpertise?.xa?.uuid ?? "";
    townsName.text = info.value.infoExpertise?.xa?.name ?? "";
    expertiseDate.text = convertDateFormat(
      info.value.infoExpertise?.expertiseDate,
      false,
    );
    address1.text = info.value.infoExpertise?.addressInfo ?? '';
    Utils.getStringValueWithKey(Constant.AVATAR_USER).then((value) {
      avatarLocal.value = value;
    });
    Utils.getStringValueWithKey(Constant.BANNER).then((value) {
      bannerLocal.value = value;
    });
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

  cancelEditAvatar() {
    avatar.value = File("");
    isEditAvatar.value = false;
  }

  cancelEditBanner() {
    banner.value = File("");
    isEditBanner.value = false;
  }

  updateAvatar() {
    if (avatar.value.path.isEmpty) {
      Utils.showSnackBar(
        title: 'Thông báo!',
        message: 'Ảnh chưa có gì thay đổi, không cần lưu lại!',
      );
    }
    try {
      APICaller.getInstance()
          .putFile(
            endpoint: 'v1/Upload/upload-single-image',
            filePath: avatar.value,
            type: 3,
          )
          .then((response) {
            if (response != null) {
              var param = {"imagePath": response["data"]};
              APICaller.getInstance()
                  .post('v1/Profile/update-avatar-profile-app', param)
                  .then((value) {
                    if (value != null) {
                      if (Get.isRegistered<IndividualController>()) {
                        Get.find<IndividualController>().getIndividual();
                      }
                      // Dùng để cập nhật lại ảnh đại diện ở trang cá nhân khi thay đổi
                      if (Get.isRegistered<HomeController>()) {
                        Get.find<HomeController>().avatar.value =
                            response["data"] ?? '';
                      }
                      if (Get.isRegistered<ProfileController>()) {
                        Get.find<ProfileController>().updateAvatar(
                          response["data"],
                        );
                      }
                      info.value.avatar = response["data"] ?? '';
                      info.refresh();
                      Utils.saveStringWithKey(
                        Constant.AVATAR_USER,
                        response["data"] ?? '',
                      );
                      Utils.showSnackBar(
                        title: 'Thông báo!',
                        message: 'Đã cập nhật ảnh đại diện thành công!',
                      );
                    }
                  });
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateBanner() {
    if (banner.value.path.isEmpty) {
      Utils.showSnackBar(
        title: 'Thông báo!',
        message: 'Ảnh chưa có gì thay đổi, không cần lưu lại!',
      );
    }
    try {
      APICaller.getInstance()
          .putFile(
            endpoint: 'v1/Upload/upload-single-image',
            filePath: banner.value,
            type: 8,
          )
          .then((response) {
            if (response != null) {
              var param = {"imagePath": response["data"]};
              APICaller.getInstance()
                  .post('v1/Banner/update-banner-profile-app', param)
                  .then((value) {
                    if (value != null) {
                      info.value.banner = response["data"] ?? '';
                      info.refresh();
                      if (Get.isRegistered<IndividualController>()) {
                        Get.find<IndividualController>().getIndividual();
                      }
                      if (Get.isRegistered<ProfileController>()) {
                        Get.find<ProfileController>().updateBanner(
                          response["data"],
                        );
                      }
                      Utils.saveStringWithKey(
                        Constant.BANNER,
                        response["data"] ?? '',
                      );
                      Utils.showSnackBar(
                        title: 'Thông báo!',
                        message: 'Đã cập nhật ảnh bìa thành công!',
                      );
                    }
                  });
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateName() {
    try {
      var param = {"name": name.text};
      APICaller.getInstance()
          .post('v1/Profile/update-name-profile-app', param)
          .then((response) {
            if (response != null) {
              if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().fullName.value = name.text;
              }
              if (Get.isRegistered<IndividualController>()) {
                Get.find<IndividualController>().getIndividual();
              }
              if (Get.isRegistered<ProfileController>()) {
                Get.find<ProfileController>().updateName(name.text);
              }
              // Get.back();
              info.value.name = name.text;
              info.refresh();
              Utils.saveStringWithKey(Constant.FULL_NAME, name.text);
              Utils.showSnackBar(
                title: 'Thông báo',
                message: 'Chỉnh sửa tên hiển thị thành công!',
              );
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateSlogan() {
    try {
      var param = {"slogan": slogan.text};
      APICaller.getInstance()
          .post('v1/Profile/update-slogan-profile-app', param)
          .then((response) {
            if (response != null) {
              if (Get.isRegistered<IndividualController>()) {
                Get.find<IndividualController>().getIndividual();
              }
              // Get.back();
              info.value.slogan = slogan.text;
              info.refresh();
              Utils.showSnackBar(
                title: 'Thông báo',
                message: 'Chỉnh sửa slogan thành công!',
              );
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateHobby() {
    try {
      var param = {"hobby": hobby.text};
      APICaller.getInstance()
          .post('v1/Profile/update-hobby-profile-app', param)
          .then((response) {
            if (response != null) {
              if (Get.isRegistered<IndividualController>()) {
                Get.find<IndividualController>().getIndividual();
              }
              // Get.back();
              info.value.hobby = hobby.text;
              info.refresh();
              Utils.showSnackBar(
                title: 'Thông báo',
                message: 'Chỉnh sửa sở thích thành công!',
              );
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  updateExpertise() {
    try {
      var param = {
        "expertiseName": expertiseName.text,
        "expertiseDate": convertDateFormat(expertiseDate.text, true),
        "addressExpertise": {
          "matp": matp.value,
          "maqh": maqh.value,
          "xaid": xaid.value,
          "address1": address1.text,
        },
      };
      APICaller.getInstance()
          .post('v1/Profile/update-expertise-profile-app', param)
          .then((response) {
            if (response != null) {
              if (Get.isRegistered<IndividualController>()) {
                Get.find<IndividualController>().getIndividual();
              }
              // Get.back();
              info.value.infoExpertise?.expertiseName = expertiseName.text;
              info.refresh();
              Utils.showSnackBar(
                title: 'Thông báo',
                message: 'Chỉnh sửa đơn vị công tác thành công!',
              );
            }
          });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  getProvinces() async {
    try {
      if (!isFirstFetchProvince) {
        return;
      }
      var param = {'keyword': ""};
      var response = await APICaller.getInstance().post(
        'v1/Province/get-list-province',
        param,
      );
      if (response != null && response['error']?['code'] == 0) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => Province.fromJson(json)).toList();
        provinces.addAll(listItem);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isWaitProvinces.value = false;
      isFirstFetchProvince = false;
    }
  }

  getDistrict() async {
    try {
      if (!isFirstFetchDistrict) {
        return;
      }
      districts.clear();
      var param = {'keyword': "", 'idParent': matp.value};
      var response = await APICaller.getInstance().post(
        'v1/Province/get-list-district',
        param,
      );
      if (response != null && response['error']?['code'] == 0) {
        List<dynamic> list = response['data'];
        var listItem =
            list.map((dynamic json) => District.fromJson(json)).toList();
        districts.addAll(listItem);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isWaitDistrict.value = false;
      isFirstFetchDistrict = false;
    }
  }

  getTown() async {
    try {
      if (!isFirstFetchTown) {
        return;
      }
      towns.clear();
      var param = {'keyword': "", 'idParent': maqh.value};
      var response = await APICaller.getInstance().post(
        'v1/Province/get-list-town',
        param,
      );
      if (response != null && response['error']?['code'] == 0) {
        List<dynamic> list = response['data'];
        var listItem = list.map((dynamic json) => Town.fromJson(json)).toList();
        towns.addAll(listItem);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isWaitTown.value = false;
      isFirstFetchTown = false;
    }
  }
}
