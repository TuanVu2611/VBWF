import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Notification/NotificationController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';

import '../../Component/DialogCustom.dart';

class Notification extends StatelessWidget {
  Notification({super.key});

  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          'Thông báo',
          style: TextStyle(fontSize: 20, color: ColorHex.text1, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: ColorHex.text5),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder:
                    (context) => DialogCustom(
                      svgColor: ColorHex.primary,
                      btnColor: ColorHex.primary,
                      svg: "assets/icons/question_mark.svg",
                      title: 'Thông báo',
                      description: 'Bạn có muốn đánh dấu là đã đọc tất cả không?',
                      onTap: () async {
                        Get.back();
                        bool success = await controller.updateMultiNotifyState("");
                        if (success) {
                          for (var item in controller.collection) {
                            item.state = 1;
                          }
                          controller.collection.refresh();
                        }
                      },
                    ),
              );
            },
            icon: const Icon(Icons.check, color: ColorHex.text5, size: 24),
          ),
        ],
      ),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: ColorHex.primary))
                : controller.collection.isEmpty
                ? SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [SvgPicture.asset('assets/icons/empty notify.svg'),
                      const SizedBox(height: 12),
                      const Text(
                        'Không có thông báo nào',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: ColorHex.text5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Hiện tại không có thông báo nào, bạn vui lòng trở lại sau',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: ColorHex.text2,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.2),
                    ],
                  ),
                )
                : RefreshIndicator(
                  onRefresh: () => controller.refreshData(),
                  child: Obx(
                    () => ListView.builder(
                      controller: controller.scrollController,
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: controller.collection.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            // Gọi API để cập nhật trạng thái thông báo
                            bool success = await controller.updateNotifyState(
                              controller.collection[index].uuid.toString(),
                            );
                            if (success) {
                              // Cập nhật trạng thái trực tiếp
                              controller.collection[index].state = 1;
                              controller.collection.refresh();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                            decoration: const BoxDecoration(
                              border: Border(top: BorderSide(width: 1, color: ColorHex.grey)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 8,
                                  width: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: controller.collection[index].state == 0 ? ColorHex.primary : ColorHex.grey,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.collection[index].title ?? "--",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorHex.text1,
                                        ),
                                      ),
                                      const SizedBox(height: 6.5),
                                      Text(
                                        controller.collection[index].content ?? "--",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: ColorHex.text3,
                                        ),
                                      ),
                                      const SizedBox(height: 6.5),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time_rounded, size: 12, color: ColorHex.text9),
                                          const SizedBox(width: 6),
                                          Text(
                                            controller.collection[index].timeAgo ?? "--",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: ColorHex.text9,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
      ),
    );
  }
}
