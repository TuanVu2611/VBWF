import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thehinhvn/Controller/Profile/InfoPage/InfoPageController.dart';
import 'package:thehinhvn/Controller/Profile/InfoPage/SocialController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class InfoPage extends StatelessWidget {
  InfoPage({super.key});

  final controller = Get.put(InfoPageController());
  final socialController = Get.put(SocialController());
  final _formKey = GlobalKey<FormState>();

  bool isValidDate(String date) {
    try {
      DateFormat('dd/MM/yyyy').parseStrict(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  DateTime? stringToDate(String dateText) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateText);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.chevron_left_sharp, size: 30),
        ),
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        title: Text(
          "Chỉnh sửa trang cá nhân",
          style: const TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: [
          _item(
            child: Column(
              children: [
                _label(
                  title: "Ảnh đại diện",
                  onTap: () => controller.isEditAvatar.value = true,
                ),
                GestureDetector(
                  onTap: () {
                    if (!controller.isEditAvatar.value) {
                      return;
                    }
                    Utils.getImagePicker(2).then((value) {
                      if (value != null) {
                        controller.avatar.value = value;
                        controller.updateAvatar(); // Tự động lưu ảnh đại diện
                      }
                    });
                  },
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50), // Đảm bảo hình tròn
                          child: Container(
                            height: 100,
                            width: 100,
                            child: Obx(
                                  () => controller.avatar.value.path != ""
                                  ? Image.file(
                                controller.avatar.value,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                "${Constant.BASE_URL_IMAGE}${controller.avatarLocal.value}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/avatar_default.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Obx(
                              () => controller.isEditAvatar.value
                              ? const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 40,
                          )
                              : const SizedBox(height: 0),
                        ),
                      ],
                    ),
                  ),
                ).marginOnly(top: 16),
              ],
            ),
          ),
          _item(
            child: Column(
              children: [
                _label(
                  title: "Ảnh bìa",
                  onTap: () => controller.isEditBanner.value = true,
                ),
                GestureDetector(
                  onTap: () {
                    if (!controller.isEditBanner.value) {
                      return;
                    }
                    Utils.getImagePicker(2).then((value) {
                      if (value != null) {
                        controller.banner.value = value;
                        controller.updateBanner(); // Tự động lưu ảnh bìa
                      }
                    });
                  },
                  child: SizedBox(
                    height: Get.width * 0.55,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Obx(
                                () => controller.banner.value.path != ""
                                ? Image.file(
                              controller.banner.value,
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              "${Constant.BASE_URL_IMAGE}${controller.bannerLocal.value}",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/bg.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        Obx(
                              () => controller.isEditBanner.value
                              ? const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 40,
                          )
                              : const SizedBox(height: 0),
                        ),
                      ],
                    ),
                  ),
                ).marginOnly(top: 16),
              ],
            ),
          ),
          _item(
            child: Column(
              children: [
                _label(
                  title: "Tên hiển thị",
                  onTap: () => _showModalBottomSheet(context, "name"),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                        () => Text(
                      controller.info.value.name ?? "--",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: ColorHex.text1,
                      ),
                    ).marginOnly(top: 16),
                  ),
                ),
              ],
            ),
          ),
          _item(
            child: Column(
              children: [
                _label(
                  title: "Slogan",
                  onTap: () => _showModalBottomSheet(context, "slogan"),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                        () => Text(
                      controller.info.value.slogan ?? "--",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: ColorHex.text1,
                      ),
                    ).marginOnly(top: 16),
                  ),
                ),
              ],
            ),
          ),
          _item(
            child: Column(
              children: [
                _label(
                  title: "Sở thích",
                  onTap: () => _showModalBottomSheet(context, "hobby"),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                        () => Text(
                      controller.info.value.hobby ?? "--",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: ColorHex.text1,
                      ),
                    ).marginOnly(top: 16),
                  ),
                ),
              ],
            ),
          ),
          _item(
            child: Column(
              children: [
                _label(
                  title: "Đơn vị công tác",
                  onTap: () => _showModalBottomSheet(context, "expertise"),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                        () => Text(
                      controller.info.value.infoExpertise?.expertiseName ?? "--",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        color: ColorHex.text1,
                      ),
                    ).marginOnly(top: 16),
                  ),
                ),
              ],
            ),
          ),
          _item(
            child: Column(
              children: [
                _label(
                  title: "Thông tin liên hệ",
                  onTap: () => Get.toNamed(Routes.social),
                ),
                Obx(
                      () {
                    // Kiểm tra xem có trường nào có dữ liệu không
                    bool hasData = socialController.facebookS.value.isNotEmpty &&
                        socialController.facebookS.value != '--' ||
                        socialController.zaloS.value.isNotEmpty &&
                            socialController.zaloS.value != '--' ||
                        socialController.phoneNumberS.value.isNotEmpty &&
                            socialController.phoneNumberS.value != '--' ||
                        socialController.emailS.value.isNotEmpty &&
                            socialController.emailS.value != '--' ||
                        socialController.tiktokS.value.isNotEmpty &&
                            socialController.tiktokS.value != '--' ||
                        socialController.instagramS.value.isNotEmpty &&
                            socialController.instagramS.value != '--' ||
                        socialController.linkedInS.value.isNotEmpty &&
                            socialController.linkedInS.value != '--' ||
                        socialController.youtubeS.value.isNotEmpty &&
                            socialController.youtubeS.value != '--';

                    if (!hasData) {
                      return Text(
                        "Chưa có thông tin liên hệ",
                        style: TextStyle(
                          fontSize: 13,
                          color: ColorHex.text1,
                          fontWeight: FontWeight.w400,
                        ),
                      ).marginOnly(top: 16);
                    }

                    return Column(
                      children: [
                        if (socialController.facebookS.value.isNotEmpty &&
                            socialController.facebookS.value != '--')
                          rowInfo(
                            context: context,
                            type: "facebook",
                            label: socialController.facebookS.value,
                          ),
                        if (socialController.zaloS.value.isNotEmpty &&
                            socialController.zaloS.value != '--')
                          rowInfo(
                            context: context,
                            type: "zalo",
                            label: socialController.zaloS.value,
                          ),
                        if (socialController.phoneNumberS.value.isNotEmpty &&
                            socialController.phoneNumberS.value != '--')
                          rowInfo(
                            context: context,
                            type: "phonenumber",
                            label: socialController.phoneNumberS.value,
                          ),
                        if (socialController.emailS.value.isNotEmpty &&
                            socialController.emailS.value != '--')
                          rowInfo(
                            context: context,
                            type: "email",
                            label: socialController.emailS.value,
                          ),
                        if (socialController.tiktokS.value.isNotEmpty &&
                            socialController.tiktokS.value != '--')
                          rowInfo(
                            context: context,
                            type: "tiktok",
                            label: socialController.tiktokS.value,
                          ),
                        if (socialController.instagramS.value.isNotEmpty &&
                            socialController.instagramS.value != '--')
                          rowInfo(
                            context: context,
                            type: "instagram",
                            label: socialController.instagramS.value,
                          ),
                        if (socialController.linkedInS.value.isNotEmpty &&
                            socialController.linkedInS.value != '--')
                          rowInfo(
                            context: context,
                            type: "linkedin",
                            label: socialController.linkedInS.value,
                          ),
                        if (socialController.youtubeS.value.isNotEmpty &&
                            socialController.youtubeS.value != '--')
                          rowInfo(
                            context: context,
                            type: "youtube",
                            label: socialController.youtubeS.value,
                          ),
                      ],
                    ).marginOnly(top: 16);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container _item({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: ColorHex.grey)),
      ),
      child: child,
    );
  }

  Row _label({required String title, void Function()? onTap}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: ColorHex.text1,
            ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "Chỉnh sửa",
            style: const TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              color: ColorHex.primary,
            ),
          ),
        ),
      ],
    );
  }

  Container rowInfo({
    required BuildContext context,
    required String type,
    required String label,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
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
                  fit: BoxFit.scaleDown,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 12),
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
          const SizedBox(width: 20),
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

  _showModalBottomSheet(BuildContext context, String type) {
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
          child: SingleChildScrollView(
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
                  child: _contentModalBottomSheet(context, type),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _contentModalBottomSheet(BuildContext context, String type) {
    switch (type) {
      case "name":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Tên hiển thị",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorHex.text1,
              ),
            ),
            const SizedBox(height: 6),
            _labelForm(
              label: "Tên hiển thị",
            ).marginSymmetric(horizontal: 20, vertical: 6),
            TextFormField(
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorHex.text1,
              ),
              controller: controller.name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                hintStyle: const TextStyle(
                  color: ColorHex.text7,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Nhập tên hiển thị',
                contentPadding: const EdgeInsets.only(left: 16, right: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập tên hiển thị";
                }
                return null;
              },
            ).marginSymmetric(horizontal: 20),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.updateName();
                    Get.back();
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
        );
      case "slogan":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Slogan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorHex.text1,
              ),
            ),
            const SizedBox(height: 6),
            _labelForm(
              label: "Slogan",
            ).marginSymmetric(horizontal: 20, vertical: 6),
            TextFormField(
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorHex.text1,
              ),
              controller: controller.slogan,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                hintStyle: const TextStyle(
                  color: ColorHex.text7,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Nhập slogan',
                contentPadding: const EdgeInsets.only(left: 16, right: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập slogan";
                }
                return null;
              },
            ).marginSymmetric(horizontal: 20),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.updateSlogan();
                    Get.back();
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
        );
      case "hobby":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Sở thích",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorHex.text1,
              ),
            ),
            const SizedBox(height: 6),
            _labelForm(
              label: "Sở thích",
            ).marginSymmetric(horizontal: 20, vertical: 6),
            TextFormField(
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorHex.text1,
              ),
              controller: controller.hobby,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                hintStyle: const TextStyle(
                  color: ColorHex.text7,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Nhập sở thích',
                contentPadding: const EdgeInsets.only(left: 16, right: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập sở thích";
                }
                return null;
              },
            ).marginSymmetric(horizontal: 20),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.updateHobby();
                    Get.back();
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
        );
      case "expertise":
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Chỉnh sửa đơn vị công tác",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ColorHex.text1,
              ),
            ),
            const SizedBox(height: 6),
            _labelForm(
              label: "Đơn vị công tác",
            ).marginSymmetric(horizontal: 20, vertical: 6),
            TextFormField(
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorHex.text1,
              ),
              controller: controller.expertiseName,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                hintStyle: const TextStyle(
                  color: ColorHex.text7,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Nhập tên đơn vị công tác',
                contentPadding: const EdgeInsets.only(left: 16, right: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập tên đơn vị công tác";
                }
                return null;
              },
            ).marginSymmetric(horizontal: 20),
            _labelForm(
              label: "Ngày công tác",
            ).marginSymmetric(horizontal: 20, vertical: 6),
            TextFormField(
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: Color(0xFF202939),
              ),
              controller: controller.expertiseDate,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9\/]*$')),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  String text = newValue.text;
                  if (newValue.text.length == 2 && oldValue.text.length != 3) {
                    text += '/';
                  }
                  if (newValue.text.length == 5 && oldValue.text.length != 6) {
                    text += '/';
                  }
                  return newValue.copyWith(
                    text: text,
                    selection: TextSelection.collapsed(offset: text.length),
                  );
                }),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                hintStyle: const TextStyle(
                  color: ColorHex.text7,
                  fontSize: 13,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'dd/mm/yyyy',
                contentPadding: const EdgeInsets.only(left: 16, right: 16),
                suffixIcon: GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: ColorHex.main,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                      context: context,
                      initialDate: stringToDate(controller.expertiseDate.text) ??
                          DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      controller.expertiseDate.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                    }
                  },
                  child: SvgPicture.asset(
                    "assets/icons/calendar.svg",
                    fit: BoxFit.scaleDown,
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
              onChanged: (value) => {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ngày công tác không được để trống";
                } else if (!isValidDate(value)) {
                  return 'Ngày tháng không hợp lệ. Xin kiểm tra lại';
                }
                return null;
              },
            ).marginSymmetric(horizontal: 20),
            _labelForm(
              label: "Địa chỉ - Tỉnh/ TP",
            ).marginSymmetric(horizontal: 20, vertical: 6),
            _showPickAddress().marginSymmetric(horizontal: 20),
            _labelForm(
              label: "Địa chỉ - Quận/ Huyện",
            ).marginSymmetric(horizontal: 20, vertical: 6),
            _showPickDistrict().marginSymmetric(horizontal: 20),
            _labelForm(
              label: "Địa chỉ - Thị trấn/ Xã",
            ).marginSymmetric(horizontal: 20, vertical: 6),
            _showPickTown().marginSymmetric(horizontal: 20),
            _labelForm(
              label: "Địa chỉ chi tiết",
            ).marginSymmetric(horizontal: 20, vertical: 6),
            TextFormField(
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                color: ColorHex.text1,
              ),
              controller: controller.address1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(width: 1, color: ColorHex.grey),
                ),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                hintStyle: const TextStyle(
                  color: ColorHex.text7,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                hintText: 'Nhập địa chỉ chi tiết',
                contentPadding: const EdgeInsets.only(left: 16, right: 16),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập địa chỉ chi tiết";
                }
                return null;
              },
            ).marginSymmetric(horizontal: 20),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.updateExpertise();
                    Get.back();
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
        );
      default:
        return Container();
    }
  }

  GestureDetector _showPickAddress() {
    return GestureDetector(
      onTap: () {
        controller.getProvinces();
        Get.bottomSheet(
          backgroundColor: Colors.white,
          Container(
            height: Get.height * 0.7,
            width: Get.width,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Container(
                  height: 5,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                Expanded(
                  child: Obx(
                        () => controller.isWaitProvinces.value
                        ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorHex.primary,
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.provinces.length,
                      itemBuilder: (context, index) {
                        final item = controller.provinces[index];
                        final String view = item.name ?? '';
                        return GestureDetector(
                          onTap: () {
                            if (item.matp != controller.matp.value) {
                              controller.isFirstFetchDistrict = true;
                              controller.isWaitDistrict.value = true;
                              controller.districts.clear();
                              controller.maqh.value = "";
                              controller.districtsName.text = "";
                              controller.isFirstFetchTown = true;
                              controller.isWaitTown.value = true;
                              controller.towns.clear();
                              controller.xaid.value = "";
                              controller.townsName.text = "";
                              controller.matp.value = item.matp ?? '';
                              controller.provincesName.text = view;
                            }
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color: Color(0xFFECEFF3),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(view),
                                item.matp == controller.matp.value
                                    ? const Icon(
                                  Icons.check,
                                  color: Color(0xff83BF6E),
                                  size: 20,
                                )
                                    : const SizedBox(
                                  width: 20,
                                  height: 20,
                                ),
                              ],
                            ).paddingSymmetric(vertical: 6),
                          ),
                        );
                      },
                    ).marginSymmetric(horizontal: 20, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: TextFormField(
        enabled: false,
        style: TextStyle(
          fontSize: 13,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: ColorHex.text1,
        ),
        controller: controller.provincesName,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(width: 1, color: ColorHex.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(width: 1, color: ColorHex.grey),
          ),
          filled: false,
          fillColor: const Color(0xFFF4F5F6),
          hintStyle: TextStyle(
            color: ColorHex.text7,
            fontSize: 13,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
          ),
          hintText: "Chọn Tỉnh/TP",
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF777E90),
          ).marginOnly(right: 8),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Vui lòng chọn Tỉnh/TP";
          }
          return null;
        },
      ),
    );
  }

  GestureDetector _showPickDistrict() {
    return GestureDetector(
      onTap: () {
        controller.getDistrict();
        Get.bottomSheet(
          backgroundColor: Colors.white,
          Container(
            height: Get.height * 0.7,
            width: Get.width,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Container(
                  height: 5,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                Expanded(
                  child: Obx(
                        () => controller.isWaitDistrict.value
                        ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorHex.primary,
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.districts.length,
                      itemBuilder: (context, index) {
                        final item = controller.districts[index];
                        final String view = item.name ?? '';
                        return GestureDetector(
                          onTap: () {
                            if (item.maqh != controller.maqh.value) {
                              controller.isFirstFetchTown = true;
                              controller.isWaitTown.value = true;
                              controller.towns.clear();
                              controller.xaid.value = "";
                              controller.townsName.text = "";
                              controller.maqh.value = item.maqh ?? '';
                              controller.districtsName.text = view;
                            }
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color: Color(0xFFECEFF3),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(view),
                                item.maqh == controller.maqh.value
                                    ? const Icon(
                                  Icons.check,
                                  color: Color(0xff83BF6E),
                                  size: 20,
                                )
                                    : const SizedBox(
                                  width: 20,
                                  height: 20,
                                ),
                              ],
                            ).paddingSymmetric(vertical: 6),
                          ),
                        );
                      },
                    ).marginSymmetric(horizontal: 20, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: TextFormField(
        enabled: false,
        style: TextStyle(
          fontSize: 13,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: ColorHex.text1,
        ),
        controller: controller.districtsName,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(width: 1, color: ColorHex.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(width: 1, color: ColorHex.grey),
          ),
          filled: false,
          fillColor: const Color(0xFFF4F5F6),
          hintStyle: TextStyle(
            color: ColorHex.text7,
            fontSize: 13,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
          ),
          hintText: "Chọn Quận/Huyện",
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF777E90),
          ).marginOnly(right: 8),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Vui lòng chọn Quận/Huyện";
          }
          return null;
        },
      ),
    );
  }

  GestureDetector _showPickTown() {
    return GestureDetector(
      onTap: () {
        controller.getTown();
        Get.bottomSheet(
          backgroundColor: Colors.white,
          Container(
            height: Get.height * 0.7,
            width: Get.width,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Container(
                  height: 5,
                  width: 50,
                  decoration: const BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                Expanded(
                  child: Obx(
                        () => controller.isWaitTown.value
                        ? const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ColorHex.primary,
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.towns.length,
                      itemBuilder: (context, index) {
                        final item = controller.towns[index];
                        final String view = item.name ?? '';
                        return GestureDetector(
                          onTap: () {
                            if (item.xaid != controller.xaid.value) {
                              controller.xaid.value = item.xaid ?? '';
                              controller.townsName.text = view;
                            }
                            Get.back();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 8,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1,
                                  color: Color(0xFFECEFF3),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(view),
                                item.xaid == controller.xaid.value
                                    ? const Icon(
                                  Icons.check,
                                  color: Color(0xff83BF6E),
                                  size: 20,
                                )
                                    : const SizedBox(
                                  width: 20,
                                  height: 20,
                                ),
                              ],
                            ).paddingSymmetric(vertical: 6),
                          ),
                        );
                      },
                    ).marginSymmetric(horizontal: 20, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: TextFormField(
        enabled: false,
        style: TextStyle(
          fontSize: 13,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
          color: ColorHex.text1,
        ),
        controller: controller.townsName,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(width: 1, color: ColorHex.grey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(width: 1, color: ColorHex.grey),
          ),
          filled: false,
          fillColor: const Color(0xFFF4F5F6),
          hintStyle: TextStyle(
            color: ColorHex.text7,
            fontSize: 13,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w500,
          ),
          hintText: "Chọn Thị trấn/Xã",
          contentPadding: const EdgeInsets.only(left: 16, right: 16),
          suffixIcon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF777E90),
          ).marginOnly(right: 8),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Vui lòng chọn Thị trấn/Xã";
          }
          return null;
        },
      ),
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
        const Text(
          "*",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ColorHex.red,
          ),
        ),
      ],
    );
  }
}
