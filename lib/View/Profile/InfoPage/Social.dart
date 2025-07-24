import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Profile/InfoPage/SocialController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';

class Social extends StatelessWidget {
  Social({super.key});

  final controller = Get.put(SocialController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        title: Text(
          "Thông tin liên hệ",
          style: const TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: [
          Obx(
            () => rowInfo(
              context: context,
              type: "facebook",
              label: controller.facebookS.value,
            ),
          ),
          Obx(
            () => rowInfo(
              context: context,
              type: "zalo",
              label: controller.zaloS.value,
            ),
          ),
          Obx(
            () => rowInfo(
              context: context,
              type: "phonenumber",
              label: controller.phoneNumberS.value,
            ),
          ),
          Obx(
            () => rowInfo(
              context: context,
              type: "email",
              label: controller.emailS.value,
            ),
          ),
          Obx(
            () => rowInfo(
              context: context,
              type: "tiktok",
              label: controller.tiktokS.value,
            ),
          ),
          Obx(
            () => rowInfo(
              context: context,
              type: "instagram",
              label: controller.instagramS.value,
            ),
          ),
          Obx(
            () => rowInfo(
              context: context,
              type: "linkedin",
              label: controller.linkedInS.value,
            ),
          ),
          Obx(
            () => rowInfo(
              context: context,
              type: "youtube",
              label: controller.youtubeS.value,
            ),
          ),
        ],
      ),
    );
  }

  Container rowInfo({
    required BuildContext context,
    required String type,
    required String label,
  }) {
    // Determine if the label is empty or default ('--') to fade the icon
    bool isEmpty = label.isEmpty || label == '--';
    double iconOpacity = isEmpty ? 0.3 : 1.0; // Fade icon if no data

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: ColorHex.grey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Opacity(
                  opacity: iconOpacity, // Apply opacity based on label
                  child: type == "zalo"
                      ? Image.asset(
                    "assets/icons/zalo.png",
                    fit: BoxFit.scaleDown,
                    height: 24,
                    width: 24,
                  )
                      : SvgPicture.asset(
                    _switchIconByType(type),
                    fit: BoxFit.scaleDown,
                    height: 24,
                    width: 24,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: ColorHex.text1,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _showModalBottomSheet(context, type, label),
            child: SvgPicture.asset(
              "assets/icons/edit.svg",
              fit: BoxFit.scaleDown,
              height: 20,
              width: 20,
            ),
          ),
        ],
      ),
    );
  }

  String _switchIconByType(String type) {
    switch (type) {
      case "facebook":
        return "assets/icons/facebook.svg";
      case "zalo":
        return "assets/icons/zalo.png";
      case "phonenumber":
        return "assets/icons/whatsapp.svg";
      case "email":
        return "assets/icons/gmail.svg";
      case "tiktok":
        return "assets/icons/tiktok.svg";
      case "instagram":
        return "assets/icons/instagram.svg";
      case "linkedin":
        return "assets/icons/linked_in.svg";
      case "youtube":
        return "assets/icons/youtube.svg";
      default:
        return "";
    }
  }

  String _switchTextByType(String type) {
    switch (type) {
      case "facebook":
        return "Facebook";
      case "zalo":
        return "Zalo";
      case "phonenumber":
        return "Điện thoại";
      case "email":
        return "Email";
      case "tiktok":
        return "Tiktok";
      case "instagram":
        return "Instagram";
      case "linkedin":
        return "Linked In";
      case "youtube":
        return "Youtube";
      default:
        return "";
    }
  }

  TextEditingController _switchControllerByType(String type) {
    switch (type) {
      case "facebook":
        return controller.facebook;
      case "zalo":
        return controller.zalo;
      case "phonenumber":
        return controller.phoneNumber;
      case "email":
        return controller.email;
      case "tiktok":
        return controller.tiktok;
      case "instagram":
        return controller.instagram;
      case "linkedin":
        return controller.linkedIn;
      case "youtube":
        return controller.youtube;
      default:
        return TextEditingController();
    }
  }

  _showModalBottomSheet(BuildContext context, String type, String label) {
    controller.setValue();
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: ColorHex.text3,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 15),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Thêm liên kết",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorHex.text1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _labelForm(
                      label: "Mạng liên kết",
                    ).marginSymmetric(horizontal: 20),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 17,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: ColorHex.grey),
                        color: ColorHex.background,
                      ),
                      child: Row(
                        children: [
                          type == "zalo"
                              ? Image.asset(
                                "assets/icons/zalo.png",
                                fit: BoxFit.scaleDown,
                                height: 24,
                                width: 24,
                              )
                              : SvgPicture.asset(
                                _switchIconByType(type),
                                height: 24,
                                width: 24,
                                fit: BoxFit.scaleDown,
                              ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _switchTextByType(type),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: ColorHex.text1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _labelForm(
                      label: "URL",
                    ).marginSymmetric(horizontal: 20, vertical: 6),
                    TextFormField(
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        color: ColorHex.text1,
                      ),
                      controller: _switchControllerByType(type),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            width: 1,
                            color: ColorHex.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            width: 1,
                            color: ColorHex.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            width: 1,
                            color: ColorHex.grey,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFFFFFF),
                        hintStyle: const TextStyle(
                          color: ColorHex.text7,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Nhập URL',
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Vui lòng nhập URL';
                      //   }
                      //   // if (!RegExp(
                      //   //   r'^(https?:\/\/)?(www\.)?([a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,}\/?.*$',
                      //   // ).hasMatch(value)) {
                      //   //   return 'Vui lòng nhập URL hợp lệ';
                      //   // }
                      //   return null;
                      // },
                    ).marginSymmetric(horizontal: 20),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            controller.updateSocial(type);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorHex.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                        ),
                        child: const Text(
                          "Lưu lại",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Row _labelForm({required String label}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ColorHex.text1,
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
