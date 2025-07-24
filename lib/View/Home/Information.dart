import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Home/InformationController.dart';
import 'package:thehinhvn/Utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Global/ColorHex.dart';

class Information extends StatelessWidget {
  const Information({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InformationController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          'Thông tin liên đoàn',
          style: TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: ColorHex.text5),
        ),
      ),
      body: Obx(
        () =>
            controller.isLoading.value
                ? Scaffold(body: Center(child: CircularProgressIndicator()))
                : Container(
                  color: Color.fromRGBO(254, 254, 254, 1),
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Text(
                        'Địa chỉ:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        '${controller.profileInformation.addressInfo!.address1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Giới thiệu:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        controller.profileInformation.introduce ?? '--',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Thông tin liên hệ:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 7),
                      StaggeredGrid.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        children: [
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/facebook.svg',
                              isData:
                                  controller.profileInformation.facebook !=
                                      null &&
                                  controller
                                      .profileInformation
                                      .facebook!
                                      .isNotEmpty,
                              onTap: () {
                                if (controller.profileInformation.facebook !=
                                        null &&
                                    controller
                                        .profileInformation
                                        .facebook!
                                        .isNotEmpty) {
                                  Utils.openURL(
                                    controller.profileInformation.facebook!,
                                  );
                                }
                              },
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: _itemAction(
                              icon: '',
                              image: 'assets/icons/zalo.png',
                              isData:
                                  controller.profileInformation.zalo != null &&
                                  controller
                                      .profileInformation
                                      .zalo!
                                      .isNotEmpty,
                              onTap: () {
                                if (controller.profileInformation.zalo !=
                                        null &&
                                    controller
                                        .profileInformation
                                        .zalo!
                                        .isNotEmpty) {
                                  Utils.openURL(
                                    'https://zalo.me/${controller.profileInformation.zalo!}',
                                  );
                                }
                              },
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/whatsapp.svg',
                              isData:
                                  controller.profileInformation.phoneNumber !=
                                      null &&
                                  controller
                                      .profileInformation
                                      .phoneNumber!
                                      .isNotEmpty,
                              onTap: () {
                                if (controller.profileInformation.phoneNumber !=
                                        null &&
                                    controller
                                        .profileInformation
                                        .phoneNumber!
                                        .isNotEmpty) {
                                  _showPhonePicker(
                                    context,
                                    controller.profileInformation.phoneNumber!,
                                  );
                                }
                              },
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/gmail.svg',
                              isData:
                                  controller.profileInformation.email != null &&
                                  controller
                                      .profileInformation
                                      .email!
                                      .isNotEmpty,
                              onTap: () {
                                if (controller.profileInformation.email !=
                                        null &&
                                    controller
                                        .profileInformation
                                        .email!
                                        .isNotEmpty) {
                                  _launchEmail(
                                    controller.profileInformation.email!,
                                  );
                                }
                              },
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/tiktok.svg',
                              isData:
                                  controller.profileInformation.facebook !=
                                      null &&
                                  controller
                                      .profileInformation
                                      .tiktok!
                                      .isNotEmpty,
                              onTap: () {
                                if (controller.profileInformation.facebook !=
                                        null &&
                                    controller
                                        .profileInformation
                                        .tiktok!
                                        .isNotEmpty) {
                                  Utils.openURL(
                                    controller.profileInformation.tiktok!,
                                  );
                                }
                              },
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/instagram.svg',
                              isData:
                                  controller.profileInformation.instagram !=
                                      null &&
                                  controller
                                      .profileInformation
                                      .instagram!
                                      .isNotEmpty,
                              onTap: () {
                                if (controller.profileInformation.instagram !=
                                        null &&
                                    controller
                                        .profileInformation
                                        .instagram!
                                        .isNotEmpty) {
                                  Utils.openURL(
                                    controller.profileInformation.instagram!,
                                  );
                                }
                              },
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/linked_in.svg',
                              isData:
                                  controller.profileInformation.linkedIn !=
                                      null &&
                                  controller
                                      .profileInformation
                                      .linkedIn!
                                      .isNotEmpty,
                              onTap: () {
                                if (controller.profileInformation.linkedIn !=
                                        null &&
                                    controller
                                        .profileInformation
                                        .linkedIn!
                                        .isNotEmpty) {
                                  Utils.openURL(
                                    controller.profileInformation.linkedIn!,
                                  );
                                }
                              },
                            ),
                          ),
                          StaggeredGridTile.count(
                            crossAxisCellCount: 1,
                            mainAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/youtube.svg',
                              isData:
                                  controller.profileInformation.youtube !=
                                      null &&
                                  controller
                                      .profileInformation
                                      .youtube!
                                      .isNotEmpty,
                              onTap: () {
                                if (controller.profileInformation.youtube !=
                                        null &&
                                    controller
                                        .profileInformation
                                        .youtube!
                                        .isNotEmpty) {
                                  Utils.openURL(
                                    controller.profileInformation.youtube!,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  _itemAction({
    required String icon,
    required GestureTapCallback onTap,
    String? image,
    bool isData = false,
  }) {
    return Opacity(
      opacity: isData ? 1 : 0.5,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color.fromRGBO(241, 244, 249, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: image != null ? Image.asset(image) : SvgPicture.asset(icon),
        ),
      ),
    );
  }

  void _showPhonePicker(BuildContext context, String phoneString) {
    List<String> phoneNumbers = phoneString.split(RegExp(r'\s*-\s*'));

    showModalBottomSheet(
      context: context,
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Chọn số để gọi',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ...phoneNumbers.map(
                (phone) => ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(phone),
                  onTap: () {
                    Navigator.pop(context); // đóng sheet
                    _launchPhone(phone);
                  },
                ),
              ),
            ],
          ),
    );
  }

  void _launchPhone(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: 'Không thể gọi đến $phone',
      );
    }
  }

  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Liên đoàn Cử tạ, Thể hình Việt Nam',
      }),
    );

    launchUrl(emailLaunchUri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}
