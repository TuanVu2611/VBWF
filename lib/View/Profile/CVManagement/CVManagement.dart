import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Profile/CVManagement/CVManagementController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
// import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CVManagement extends StatelessWidget {
  CVManagement({super.key});

  final controller = Get.put(CVManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        actions: [
          GestureDetector(
            onTap:
                () =>
                    Get.toNamed(Routes.upsertCV, arguments: controller.detail),
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                color: ColorHex.main.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/icons/edit.svg",
                fit: BoxFit.scaleDown,
                height: 20,
                width: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        title: const Text(
          "Chi tiết CV",
          style: TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // body: Obx(
      //   () =>
      //       controller.isLoading.value
      //           ? const Center(
      //             child: CircularProgressIndicator(
      //               strokeWidth: 2,
      //               color: ColorHex.primary,
      //             ),
      //           )
      //           : ListView(
      //             padding: EdgeInsets.all(16),
      //             children: [
      //               const SizedBox(height: 10),
      //               SizedBox(
      //                 height: Get.width - 32,
      //                 child: ClipRRect(
      //                   borderRadius: BorderRadius.circular(4),
      //                   child: Image.network(
      //                     "${Constant.BASE_URL_IMAGE}${controller.detail.imagePath}",
      //                     fit: BoxFit.cover,
      //                     errorBuilder: (context, error, stackTrace) {
      //                       return Image.asset(
      //                         'assets/images/avatar_default.png',
      //                         fit: BoxFit.cover,
      //                       );
      //                     },
      //                   ),
      //                 ),
      //               ),
      //               Text(
      //                 controller.detail.name ?? "",
      //                 textAlign: TextAlign.left,
      //                 style: const TextStyle(
      //                   fontSize: 24,
      //                   color: ColorHex.text1,
      //                   fontWeight: FontWeight.w600,
      //                 ),
      //               ).marginSymmetric(vertical: 12),
      //               _rowInfo(
      //                 icon: "assets/icons/sms.svg",
      //                 title: controller.detail.email ?? "--",
      //               ),
      //               _rowInfo(
      //                 icon: "assets/icons/user.svg",
      //                 title: controller.detail.gender == 0 ? 'Nam' : 'Nữ',
      //               ),
      //               _rowInfo(
      //                 icon: "assets/icons/cake.svg",
      //                 title: controller.convertDateFormat(
      //                   controller.detail.birthday,
      //                   false,
      //                 ),
      //               ),
      //               _rowInfo(
      //                 icon: "assets/icons/height.svg",
      //                 title: formatHeight(controller.detail.height),
      //               ),
      //               _rowInfo(
      //                 icon: "assets/icons/weigh.svg",
      //                 title:
      //                     controller.detail.weight != null
      //                         ? "${controller.detail.weight} Kg"
      //                         : "--",
      //               ),
      //               _rowInfo(
      //                 icon: "assets/icons/location.svg",
      //                 title: controller.detail.address ?? "--",
      //               ),
      //               _label(title: "HỌC VẤN").marginSymmetric(vertical: 6),
      //               ListView.separated(
      //                 physics: const NeverScrollableScrollPhysics(),
      //                 separatorBuilder:
      //                     (context, index) => const SizedBox(height: 16),
      //                 shrinkWrap: true,
      //                 itemCount: controller.detail.educations?.length ?? 0,
      //                 itemBuilder: (context, index) {
      //                   return Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         "${controller.convertDateFormat(controller.detail.educations?[index].fromDate, false)} - ${controller.convertDateFormat(controller.detail.educations?[index].toDate, false)}",
      //                         style: const TextStyle(
      //                           fontSize: 12,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w400,
      //                           color: ColorHex.text2,
      //                         ),
      //                       ),
      //                       Text(
      //                         controller.detail.educations?[index].title ??
      //                             "--",
      //                         style: const TextStyle(
      //                           fontSize: 13,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w600,
      //                           color: ColorHex.text1,
      //                         ),
      //                       ),
      //                       const SizedBox(height: 2),
      //                       Text(
      //                         controller.detail.educations?[index].content ??
      //                             "--",
      //                         style: const TextStyle(
      //                           fontSize: 12,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w400,
      //                           color: ColorHex.text2,
      //                         ),
      //                       ),
      //                     ],
      //                   );
      //                 },
      //               ),
      //               _label(title: "KINH NGHIỆM").marginSymmetric(vertical: 6),
      //               ListView.separated(
      //                 physics: const NeverScrollableScrollPhysics(),
      //                 separatorBuilder:
      //                     (context, index) => const SizedBox(height: 16),
      //                 shrinkWrap: true,
      //                 itemCount: controller.detail.experiences?.length ?? 0,
      //                 itemBuilder: (context, index) {
      //                   return Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         "${controller.convertDateFormat(controller.detail.experiences?[index].fromDate, false)} - ${controller.convertDateFormat(controller.detail.experiences?[index].toDate, false)}",
      //                         style: const TextStyle(
      //                           fontSize: 12,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w400,
      //                           color: ColorHex.text2,
      //                         ),
      //                       ),
      //                       Text(
      //                         controller.detail.experiences?[index].title ??
      //                             "--",
      //                         style: const TextStyle(
      //                           fontSize: 13,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w600,
      //                           color: ColorHex.text1,
      //                         ),
      //                       ),
      //                       const SizedBox(height: 2),
      //                       Text(
      //                         controller.detail.experiences?[index].content ??
      //                             "--",
      //                         style: const TextStyle(
      //                           fontSize: 12,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w400,
      //                           color: ColorHex.text2,
      //                         ),
      //                       ),
      //                     ],
      //                   );
      //                 },
      //               ),
      //               _label(title: "HOẠT ĐỘNG").marginSymmetric(vertical: 6),
      //               ListView.separated(
      //                 physics: const NeverScrollableScrollPhysics(),
      //                 separatorBuilder:
      //                     (context, index) => const SizedBox(height: 16),
      //                 shrinkWrap: true,
      //                 itemCount: controller.detail.activities?.length ?? 0,
      //                 itemBuilder: (context, index) {
      //                   return Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         "${controller.convertDateFormat(controller.detail.activities?[index].fromDate, false)} - ${controller.convertDateFormat(controller.detail.activities?[index].toDate, false)}",
      //                         style: const TextStyle(
      //                           fontSize: 12,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w400,
      //                           color: ColorHex.text2,
      //                         ),
      //                       ),
      //                       Text(
      //                         controller.detail.activities?[index].title ??
      //                             "--",
      //                         style: const TextStyle(
      //                           fontSize: 13,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w600,
      //                           color: ColorHex.text1,
      //                         ),
      //                       ),
      //                       const SizedBox(height: 2),
      //                       Text(
      //                         controller.detail.activities?[index].content ??
      //                             "--",
      //                         style: const TextStyle(
      //                           fontSize: 12,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w400,
      //                           color: ColorHex.text2,
      //                         ),
      //                       ),
      //                     ],
      //                   );
      //                 },
      //               ),
      //               _label(
      //                 title: "CHỨNG CHỈ VÀ GIẢI THƯỞNG",
      //               ).marginSymmetric(vertical: 6),
      //               ListView.separated(
      //                 physics: const NeverScrollableScrollPhysics(),
      //                 separatorBuilder:
      //                     (context, index) => const SizedBox(height: 16),
      //                 shrinkWrap: true,
      //                 itemCount: controller.detail.awards?.length ?? 0,
      //                 itemBuilder: (context, index) {
      //                   return Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         "${controller.convertDateFormat(controller.detail.awards?[index].fromDate, false)} - ${controller.convertDateFormat(controller.detail.awards?[index].toDate, false)}",
      //                         style: const TextStyle(
      //                           fontSize: 12,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w400,
      //                           color: ColorHex.text2,
      //                         ),
      //                       ),
      //                       Text(
      //                         controller.detail.awards?[index].title ?? "--",
      //                         style: const TextStyle(
      //                           fontSize: 13,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w600,
      //                           color: ColorHex.text1,
      //                         ),
      //                       ),
      //                       const SizedBox(height: 2),
      //                       Text(
      //                         controller.detail.awards?[index].content ?? "--",
      //                         style: const TextStyle(
      //                           fontSize: 12,
      //                           fontStyle: FontStyle.normal,
      //                           fontWeight: FontWeight.w400,
      //                           color: ColorHex.text2,
      //                         ),
      //                       ),
      //                     ],
      //                   );
      //                 },
      //               ),
      //               _label(title: "KỸ NĂNG").marginSymmetric(vertical: 6),
      //               Text(
      //                 controller.detail.skill ?? "--",
      //                 style: const TextStyle(
      //                   fontSize: 12,
      //                   fontStyle: FontStyle.normal,
      //                   fontWeight: FontWeight.w400,
      //                   color: ColorHex.text2,
      //                 ),
      //               ),
      //               _label(title: "SỞ THÍCH").marginSymmetric(vertical: 6),
      //               Text(
      //                 controller.detail.hobby ?? "--",
      //                 style: const TextStyle(
      //                   fontSize: 12,
      //                   fontStyle: FontStyle.normal,
      //                   fontWeight: FontWeight.w400,
      //                   color: ColorHex.text2,
      //                 ),
      //               ),
      //             ],
      //           ),
      // ),
      body: Obx(
        () =>
            controller.uuid.value == ""
                ? SizedBox()
                : WebViewWidget(
                  controller:
                      WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..loadRequest(
                          Uri.parse(
                            "http://vbwf-user.mobiplus.vn/cv?_uuid=${controller.uuid.value}",
                          ),
                        ),
                ),
      ),
    );
  }

  String formatHeight(int? heightCm) {
    if (heightCm == null) return "--";

    final meters = heightCm ~/ 100;
    final centimeters = heightCm % 100;
    return '${meters}m$centimeters';
  }

  // Row _rowInfo({required String icon, required String title}) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Container(
  //         height: 24,
  //         width: 24,
  //         decoration: BoxDecoration(
  //           color: ColorHex.main.withAlpha(50),
  //           shape: BoxShape.circle,
  //         ),
  //         child: SvgPicture.asset(
  //           icon,
  //           fit: BoxFit.scaleDown,
  //           height: 20,
  //           width: 20,
  //         ),
  //       ).marginSymmetric(vertical: 6),
  //       const SizedBox(width: 8),
  //       Expanded(
  //         child: Text(
  //           title,
  //           textAlign: TextAlign.left,
  //           style: const TextStyle(
  //             fontSize: 14,
  //             color: ColorHex.text1,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Row _label({required String title, String? type}) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Expanded(
  //         child: Text(
  //           title,
  //           style: const TextStyle(
  //             fontSize: 18,
  //             fontStyle: FontStyle.normal,
  //             fontWeight: FontWeight.w600,
  //             color: ColorHex.text1,
  //           ),
  //         ),
  //       ),
  //       const SizedBox(width: 20),
  //       if (type != null)
  //         GestureDetector(
  //           onTap:
  //               () => Get.toNamed(
  //                 Routes.upsertActivity,
  //                 parameters: {"id": "", "type": type},
  //               ),
  //           child: Container(
  //             height: 24,
  //             width: 24,
  //             decoration: const BoxDecoration(
  //               color: ColorHex.primary,
  //               shape: BoxShape.circle,
  //             ),
  //             child: const Icon(Icons.add, color: Colors.white, size: 20),
  //           ),
  //         ),
  //     ],
  //   );
  // }
}
