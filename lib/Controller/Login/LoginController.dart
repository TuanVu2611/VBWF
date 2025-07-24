import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class LoginController extends GetxController {
  TextEditingController textUserName = TextEditingController();
  TextEditingController textPass = TextEditingController();
  RxBool isHidePassword = true.obs;
  RxBool isLoading = false.obs;
  RxBool isFormValid = false.obs;
  DateTime timeNow = DateTime.now();
  String? token = '';

  @override
  void onInit() async {
    super.onInit();
    textUserName.addListener(validateForm);
    textPass.addListener(validateForm);
    await firebaseMessaging();
  }

  firebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    token = await messaging.getToken();
    await Utils.saveStringWithKey(Constant.FCMTOKEN, token ?? "");
  }

  void validateForm() {
    isFormValid.value = textUserName.text.isNotEmpty && textPass.text.isNotEmpty;
  }

  @override
  void onClose() {
    // textUserName.dispose();
    // textPass.dispose();
    super.onClose();
  }

}
