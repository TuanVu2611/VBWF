import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

import '../Individual/IndividualController.dart';

class SocialController extends GetxController {
  RxString phoneNumberS = ''.obs;
  TextEditingController phoneNumber = TextEditingController();
  RxString emailS = ''.obs;
  TextEditingController email = TextEditingController();
  RxString zaloS = ''.obs;
  TextEditingController zalo = TextEditingController();
  RxString facebookS = ''.obs;
  TextEditingController facebook = TextEditingController();
  RxString youtubeS = ''.obs;
  TextEditingController youtube = TextEditingController();
  RxString instagramS = ''.obs;
  TextEditingController instagram = TextEditingController();
  RxString tiktokS = ''.obs;
  TextEditingController tiktok = TextEditingController();
  RxString linkedInS = ''.obs;
  TextEditingController linkedIn = TextEditingController();
  dynamic response;

  @override
  void onInit() {
    super.onInit();
    getDetail();
  }

  getDetail() {
    try {
      APICaller.getInstance()
          .post('v1/Profile/get-profile-social-detail-app', null)
          .then((res) {
            print("kkk $res");
            if (res != null) {
              response = res;
              phoneNumberS.value = response['data']['phoneNumber'] ?? '--';
              emailS.value = response['data']['email'] ?? '--';
              zaloS.value = response['data']['zalo'] ?? '--';
              facebookS.value = response['data']['facebook'] ?? '--';
              youtubeS.value = response['data']['youtube'] ?? '--';
              instagramS.value = response['data']['instagram'] ?? '--';
              tiktokS.value = response['data']['tiktok'] ?? '--';
              linkedInS.value = response['data']['linkedIn'] ?? '--';
              linkedIn.text = response['data']['linkedIn'] ?? '';
              setValue();
            }
          });
    } catch (e) {
debugPrint(e.toString());
    }
  }

  setValue() {
    phoneNumber.text = response['data']['phoneNumber'] ?? '';
    email.text = response['data']['email'] ?? '';
    zalo.text = response['data']['zalo'] ?? '';
    facebook.text = response['data']['facebook'] ?? '';
    youtube.text = response['data']['youtube'] ?? '';
    instagram.text = response['data']['instagram'] ?? '';
    tiktok.text = response['data']['tiktok'] ?? '';
    linkedIn.text = response['data']['linkedIn'] ?? '';
  }

  String _switchTextByType(String type) {
    switch (type) {
      case "facebook":
        return facebook.text;
      case "zalo":
        return zalo.text;
      case "phonenumber":
        return phoneNumber.text;
      case "email":
        return email.text;
      case "tiktok":
        return tiktok.text;
      case "instagram":
        return instagram.text;
      case "linkedin":
        return linkedIn.text;
      case "youtube":
        return youtube.text;
      default:
        return "";
    }
  }

  updateSocial(String type) {
    try {
      String value = _switchTextByType(type);
      var param = {"platform": type, "link": value == "" ? null : value};
      APICaller.getInstance()
          .post('v1/Profile/update-profile-social-app', param)
          .then((response) {
            if (response != null) {
              if (Get.isRegistered<IndividualController>()) {
                Get.find<IndividualController>().getIndividual();
              }
              if (type == "facebook") {
                facebookS.value = facebook.text  == "" ? "--" : facebook.text;
                this.response['data']['facebook'] = facebook.text  == "" ? null : facebook.text;
              }
              if (type == "zalo") {
                zaloS.value = zalo.text == "" ? "--" : zalo.text;
                this.response['data']['zalo'] = zalo.text == "" ? null : zalo.text;
              }
              if (type == "phonenumber") {
                phoneNumberS.value = phoneNumber.text == "" ? "--" : phoneNumber.text;
                this.response['data']['phoneNumber'] = phoneNumber.text == "" ? null : phoneNumber.text;
              }
              if (type == "email") {
                emailS.value = email.text == "" ? "--" : email.text;
                this.response['data']['email'] = email.text == "" ? null : email.text;
              }
              if (type == "tiktok") {
                tiktokS.value = tiktok.text == "" ? "--" : tiktok.text;
                this.response['data']['tiktok'] = tiktok.text == "" ? null : tiktok.text;
              }
              if (type == "instagram") {
                instagramS.value = instagram.text == "" ? "--" : instagram.text;
                this.response['data']['instagram'] = instagram.text == "" ? null : instagram.text;
              }
              if (type == "linkedin") {
                linkedInS.value = linkedIn.text == "" ? "--" : linkedIn.text;
                this.response['data']['linkedIn'] = linkedIn.text == "" ? null : linkedIn.text;
              }
              if (type == "youtube") {
                youtubeS.value = youtube.text == "" ? "--" : youtube.text;
                this.response['data']['youtube'] = youtube.text == "" ? null : youtube.text;
              }
              Get.back();
              Utils.showSnackBar(
                title: 'Thông báo',
                message: "Thêm liên kết thành công!",
              );
            } else {
              Utils.showSnackBar(
                title: 'Thông báo',
                message: response['error']['message'],
              );
            }
          });
    } catch (e) {
debugPrint(e.toString());
      return null;
    }
  }
}
