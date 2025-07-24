// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import '../../../Controller/Profile/CardIssuance/CardIssuanceController.dart';
// import '../../../Global/ColorHex.dart';
// import '../../../Utils/Utils.dart';
//
// class CardIssuance extends StatelessWidget {
//   const CardIssuance({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(CardIssuanceController());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         scrolledUnderElevation: 0,
//         title: const Text(
//           'Phát hành thẻ',
//           style: TextStyle(
//             fontSize: 20,
//             color: ColorHex.text1,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back, color: ColorHex.text5),
//         ),
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Center(
//                     child: Image.asset(
//                       'assets/images/cardissuance.png',
//                       errorBuilder:
//                           (context, error, stackTrace) =>
//                               const Icon(Icons.error),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Obx(
//                   () => Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: RichText(
//                           text: TextSpan(
//                             children: [
//                               const TextSpan(
//                                 text: 'Trạng thái: ',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: ColorHex.text2,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: controller.getStatusText(),
//                                 style: const TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       if (controller.cardState.value == 0 &&
//                           controller.cardRejected.value.isNotEmpty)
//                         RejectedReasonWidget(
//                           rejectedReason: controller.cardRejected.value,
//                         ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Obx(() {
//               final cardState = controller.cardState.value;
//               final isShowRequestButton = (cardState == null || cardState == 0);
//
//               return isShowRequestButton
//                   ? Positioned(
//                     left: 0,
//                     right: 0,
//                     bottom: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             offset: const Offset(0, -4),
//                             blurRadius: 6,
//                             spreadRadius: 0,
//                           ),
//                         ],
//                       ),
//                       child: GestureDetector(
//                         onTap: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => const ShowSuccessDialog(),
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 18,
//                             vertical: 20,
//                           ),
//                           decoration: BoxDecoration(
//                             color: ColorHex.primary,
//                             borderRadius: const BorderRadius.all(
//                               Radius.circular(12),
//                             ),
//                           ),
//                           child: const Center(
//                             child: Text(
//                               'Yêu cầu phát hành thẻ',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 15,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                   : const SizedBox.shrink();
//             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class RejectedReasonWidget extends StatelessWidget {
//   final String rejectedReason;
//
//   const RejectedReasonWidget({super.key, required this.rejectedReason});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.red.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trái
//         children: [
//           const Text(
//             'Rất tiếc, yêu cầu phát hành thẻ của bạn đã bị từ chối.',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: ColorHex.text2,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Lý do từ chối: $rejectedReason',
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: ColorHex.text2,
//             ),
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Vui lòng cập nhật lại hồ sơ cá nhân và gửi lại yêu cầu.',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: ColorHex.text2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ShowSuccessDialog extends StatelessWidget {
//   const ShowSuccessDialog({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<CardIssuanceController>();
//
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       backgroundColor: Colors.white,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 32),
//       contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             'assets/icons/info-circle.svg',
//             width: 48,
//             height: 48,
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             'Xác nhận đăng ký',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: ColorHex.text14,
//             ),
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'Bạn có chắc chắn muốn đăng ký phát hành thẻ thành viên không?',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: ColorHex.text14,
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: Color(0xFFD0D5DD)),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text(
//                     'Hủy bỏ',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: ColorHex.text14,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: OutlinedButton(
//                   style: OutlinedButton.styleFrom(
//                     backgroundColor: ColorHex.primary,
//                     side: const BorderSide(color: ColorHex.primary),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   onPressed: () async {
//                     Navigator.pop(context);
//                     await controller.cardIssuance();
//                     Get.back();
//                     Utils.showSnackBar(
//                       title: 'Thành công',
//                       message: 'Yêu cầu phát hành thẻ đã được gửi thành công!',
//                     );
//                   },
//                   child: const Text(
//                     'Xác nhận',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../Controller/Profile/CardIssuance/CardIssuanceController.dart';
import '../../../Global/ColorHex.dart';
import '../../../Utils/Utils.dart';

class CardIssuance extends StatelessWidget {
  const CardIssuance({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CardIssuanceController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          'Phát hành thẻ',
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
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/cardissuance.png',
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Trạng thái: ',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: ColorHex.text2,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: controller.getStatusColor(),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                controller.getStatusText(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (controller.cardState.value == 0 &&
                          controller.cardRejected.value.isNotEmpty)
                        RejectedReasonWidget(
                          rejectedReason: controller.cardRejected.value,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(() {
              final cardState = controller.cardState.value;
              final isShowRequestButton = (cardState == null || cardState == 0);

              return isShowRequestButton
                  ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(0, -4),
                            blurRadius: 6,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ShowSuccessDialog(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: ColorHex.primary,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Yêu cầu phát hành thẻ',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

class RejectedReasonWidget extends StatelessWidget {
  final String rejectedReason;

  const RejectedReasonWidget({super.key, required this.rejectedReason});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rất tiếc, yêu cầu phát hành thẻ của bạn đã bị từ chối.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorHex.text2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lý do từ chối: $rejectedReason',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorHex.text2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vui lòng cập nhật lại hồ sơ cá nhân và gửi lại yêu cầu.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorHex.text2,
            ),
          ),
        ],
      ),
    );
  }
}

class ShowSuccessDialog extends StatelessWidget {
  const ShowSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CardIssuanceController>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/info-circle.svg',
            width: 48,
            height: 48,
          ),
          const SizedBox(height: 16),
          const Text(
            'Xác nhận đăng ký',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ColorHex.text14,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Bạn có chắc chắn muốn đăng ký phát hành thẻ thành viên không?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ColorHex.text14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD0D5DD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Hủy bỏ',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColorHex.text14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: ColorHex.primary,
                    side: const BorderSide(color: ColorHex.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await controller.cardIssuance();
                    Get.back();
                    Utils.showSnackBar(
                      title: 'Thành công',
                      message: 'Yêu cầu phát hành thẻ đã được gửi thành công!',
                    );
                  },
                  child: const Text(
                    'Xác nhận',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
