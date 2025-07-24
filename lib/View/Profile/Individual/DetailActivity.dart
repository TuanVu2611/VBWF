import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Profile/Individual/DetailActivityController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class DetailActivity extends StatelessWidget {
  DetailActivity({super.key});

  final controller = Get.put(DetailActivityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        title: const Text(
          "Chi tiết hoạt động",
          style: TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorHex.primary,
                  ),
                )
                : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(height: 10),
                          Image.network(
                            Constant.BASE_URL_IMAGE +
                                controller.detail.imagePath!,
                            fit: BoxFit.fitWidth,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 21,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.detail.title ?? "",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: ColorHex.text1,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/clock.svg",
                                      height: 14,
                                      width: 14,
                                      fit: BoxFit.scaleDown,
                                      colorFilter: const ColorFilter.mode(
                                        ColorHex.text7,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      Utils.formatDate(
                                        controller.detail.created,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: ColorHex.text7,
                                      ),
                                    ),
                                    const SizedBox(width: 43),
                                    SvgPicture.asset(
                                      "assets/icons/privacy_${controller.detail.privacy}.svg",
                                      height: 12,
                                      width: 12,
                                      fit: BoxFit.scaleDown,
                                      colorFilter: const ColorFilter.mode(
                                        ColorHex.text3,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      controller.detail.privacy == 1
                                          ? "Công khai"
                                          : "Riêng tư",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: ColorHex.text3,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Text(
                                      "Loại hoạt động:",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: ColorHex.text2,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      controller.getTextTypeActivity(
                                        controller.detail.type ?? 0,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: ColorHex.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    controller.detail.content ?? "",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: ColorHex.text2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.detail.link != null &&
                        controller.detail.link!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, -4),
                              blurRadius: 6,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorHex.primary,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed:
                              () => Utils.openURL(
                                controller.detail.link ?? "",
                              ),
                          child: const Text(
                            'Xem hoạt động',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
      ),
    );
  }
}
