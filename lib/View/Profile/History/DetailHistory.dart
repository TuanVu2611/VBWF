import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Profile/History/DetailHistoryController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class DetailHistory extends StatelessWidget {
  DetailHistory({super.key});

  final controller = Get.put(DetailHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHex.background,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        title: const Text(
          "Chi tiết lịch sử",
          style: TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(
          () =>
              controller.isLoading.value
                  ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorHex.primary,
                    ),
                  )
                  : RefreshIndicator(
                    onRefresh: () => controller.refreshData(),
                    child: Obx(
                      () => ListView.separated(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 10),
                        itemCount: controller.collection.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: ColorHex.grey,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.network(
                                      '${Constant.BASE_URL_IMAGE}${controller.collection[index].profile?.imagePath}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller
                                                .collection[index]
                                                .profile
                                                ?.name ??
                                            "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: ColorHex.text1,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        Utils.formatDate(
                                          controller.collection[index].created,
                                          isSorted: false,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400,
                                          color: ColorHex.text7,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
