import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Component/MyTabView.dart';
import 'package:thehinhvn/Controller/Profile/History/HistoryController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class History extends StatelessWidget {
  History({super.key});

  final controller = Get.put(HistoryController());

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
          "Lịch sử",
          style: TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelColor: ColorHex.primary,
              dividerColor: ColorHex.background,
              isScrollable: true,
              indicatorColor: ColorHex.primary,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              tabs: const [
                Tab(child: Text("Quét danh thiếp")),
                Tab(child: Text("Ghé thăm")),
              ],
              controller: controller.tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              tabAlignment: TabAlignment.center,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                MyTabView(child: _visitorNFC()),
                MyTabView(child: _visitor()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _visitorNFC() {
    return Column(
      children: [
        Obx(
          () => TextFormField(
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              color: ColorHex.text1,
            ),
            controller: controller.searchVNFC.value,
            onChanged:
                (value) => {
                  controller.isClearVNFC.value = value.isNotEmpty,
                  if (controller.debounceTimer != null)
                    {controller.debounceTimer!.cancel()},
                  controller.debounceTimer = Timer(
                    const Duration(milliseconds: 500),
                    () {
                      controller.getVisitorNFC(isRefresh: true);
                    },
                  ),
                },
            decoration: InputDecoration(
              prefixIcon: SvgPicture.asset(
                "assets/icons/search.svg",
                fit: BoxFit.scaleDown,
                height: 20,
                width: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(width: 1, color: ColorHex.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(width: 1, color: ColorHex.grey),
              ),
              errorBorder: OutlineInputBorder(
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
                fontWeight: FontWeight.w400,
              ),
              hintText: 'Nhập từ khóa tìm kiếm',
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              suffix:
                  controller.isClearVNFC.value
                      ? GestureDetector(
                        onTap: () {
                          controller.isClearVNFC.value = false;
                          controller.searchVNFC.value.clear();
                          if (controller.debounceTimer != null) {
                            controller.debounceTimer!.cancel();
                          }
                          controller.debounceTimer = Timer(
                            const Duration(milliseconds: 500),
                            () {
                              controller.getVisitorNFC(isRefresh: true);
                            },
                          );
                        },
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: ColorHex.text7,
                        ),
                      )
                      : null,
            ),
          ).marginSymmetric(horizontal: 16, vertical: 12),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () =>
                  controller.isLoadingVNFC.value
                      ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorHex.primary,
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: () => controller.refreshDataVNFC(),
                        child: Obx(
                          () =>
                              controller.collectionVNFC.isEmpty
                                  ? Center(
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          SizedBox(height: Get.height * 0.2),
                                          SvgPicture.asset(
                                            "assets/icons/nodata.svg",
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Không có dữ liệu',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: ColorHex.text7,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  : ListView.separated(
                                    controller: controller.scrollControllerVNFC,
                                    padding: const EdgeInsets.only(bottom: 20),
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    separatorBuilder:
                                        (context, index) =>
                                            const SizedBox(height: 10),
                                    itemCount: controller.collectionVNFC.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap:
                                            () => Get.toNamed(
                                              Routes.detailHistory,
                                              arguments: {
                                                "id":
                                                    controller
                                                        .collectionVNFC[index]
                                                        .profile
                                                        ?.uuid ??
                                                    "",
                                                "isNFC": true,
                                              },
                                            ),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: ColorHex.grey,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image.network(
                                                    '${Constant.BASE_URL_IMAGE}${controller.collectionVNFC[index].profile?.imagePath}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .collectionVNFC[index]
                                                              .profile
                                                              ?.name ??
                                                          "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: ColorHex.text1,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      Utils.formatDate(
                                                        controller
                                                            .collectionVNFC[index]
                                                            .created,
                                                        isSorted: false,
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: ColorHex.text7,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Icon(
                                                Icons.chevron_right_rounded,
                                                size: 20,
                                                color: ColorHex.text3,
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
          ),
        ),
      ],
    );
  }

  _visitor() {
    return Column(
      children: [
        Obx(
          () => TextFormField(
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              color: ColorHex.text1,
            ),
            controller: controller.search.value,
            onChanged:
                (value) => {
                  controller.isClear.value = value.isNotEmpty,
                  if (controller.debounceTimer != null)
                    {controller.debounceTimer!.cancel()},
                  controller.debounceTimer = Timer(
                    const Duration(milliseconds: 500),
                    () {
                      controller.getVisitor(isRefresh: true);
                    },
                  ),
                },
            decoration: InputDecoration(
              prefixIcon: SvgPicture.asset(
                "assets/icons/search.svg",
                fit: BoxFit.scaleDown,
                height: 20,
                width: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(width: 1, color: ColorHex.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(width: 1, color: ColorHex.grey),
              ),
              errorBorder: OutlineInputBorder(
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
                fontWeight: FontWeight.w400,
              ),
              hintText: 'Nhập từ khóa tìm kiếm',
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              suffix:
                  controller.isClear.value
                      ? GestureDetector(
                        onTap: () {
                          controller.isClear.value = false;
                          controller.search.value.clear();
                          if (controller.debounceTimer != null) {
                            controller.debounceTimer!.cancel();
                          }
                          controller.debounceTimer = Timer(
                            const Duration(milliseconds: 500),
                            () {
                              controller.getVisitorNFC(isRefresh: true);
                            },
                          );
                        },
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: ColorHex.text7,
                        ),
                      )
                      : null,
            ),
          ).marginSymmetric(horizontal: 16, vertical: 12),
        ),
        Expanded(
          child: Container(
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
                          () =>
                              controller.collection.isEmpty
                                  ? Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: Get.height * 0.2),
                                        SvgPicture.asset(
                                          "assets/icons/nodata.svg",
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Không có dữ liệu',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: ColorHex.text7,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : ListView.separated(
                                    controller: controller.scrollController,
                                    padding: const EdgeInsets.only(bottom: 20),
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    separatorBuilder:
                                        (context, index) =>
                                            const SizedBox(height: 10),
                                    itemCount: controller.collection.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap:
                                            () => Get.toNamed(
                                              Routes.detailHistory,
                                              arguments: {
                                                "id":
                                                    controller
                                                        .collection[index]
                                                        .profile
                                                        ?.uuid ??
                                                    "",
                                                "isNFC": false,
                                              },
                                            ),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: ColorHex.grey,
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image.network(
                                                    '${Constant.BASE_URL_IMAGE}${controller.collection[index].profile?.imagePath}',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: ColorHex.text1,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      Utils.formatDate(
                                                        controller
                                                            .collection[index]
                                                            .created,
                                                        isSorted: false,
                                                      ),
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: ColorHex.text7,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Icon(
                                                Icons.chevron_right_rounded,
                                                size: 20,
                                                color: ColorHex.text3,
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
          ),
        ),
      ],
    );
  }
}
