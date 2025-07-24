import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thehinhvn/Component/DialogCustom2.dart';
import 'package:thehinhvn/Controller/Home/HomeController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Obx(
      () =>
          controller.isLoading.value
              ? Scaffold(body: Center(child: CircularProgressIndicator()))
              : Scaffold(
                appBar:
                    controller.accessToken.value.isEmpty
                        ? null
                        : AppBar(
                          automaticallyImplyLeading: false,
                          title: GestureDetector(
                            onTap: () {},
                            child: Obx(
                              () => Row(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      Constant.BASE_URL_IMAGE +
                                          controller.avatar.value,
                                      height: 38,
                                      width: 38,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace,
                                      ) {
                                        return Container(
                                          height: 38,
                                          width: 38,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromRGBO(
                                              153,
                                              162,
                                              179,
                                              1,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Chào mừng',
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                              177,
                                              181,
                                              195,
                                              1,
                                            ),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          controller.fullName.value,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            Stack(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications_rounded),
                                  color: const Color.fromRGBO(177, 181, 195, 1),
                                  tooltip: 'Thông báo',
                                  onPressed: () {
                                    controller.isHaveNewNoti.value = false;
                                    Get.toNamed(Routes.notification);
                                  },
                                ),
                                Obx(
                                  () =>
                                      controller.isHaveNewNoti.value
                                          ? Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: ColorHex.primary,
                                              ),
                                            ),
                                          )
                                          : const SizedBox(height: 0, width: 0),
                                ),
                              ],
                            ),
                          ],
                        ),
                body: Container(
                  color: Color.fromRGBO(254, 254, 254, 1),
                  child: ListView(
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 160,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              viewportFraction: 1.0,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                controller.currentIndex.value = index;
                              },
                            ),
                            items:
                                (controller.banner.banners ?? []).map((url) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        '${Constant.BASE_URL_IMAGE}$url',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (
                                          BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace,
                                        ) {
                                          return Container(
                                            color: Color.fromRGBO(
                                              153,
                                              162,
                                              179,
                                              1,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                            carouselController: controller.carouselController,
                          ),
                          Positioned(
                            bottom: 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  (controller.banner.banners ?? [])
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                        return Container(
                                          width:
                                              controller.currentIndex.value ==
                                                      entry.key
                                                  ? 16.0
                                                  : 8.0,
                                          height: 8.0,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            color: Colors.white,
                                          ),
                                        );
                                      })
                                      .toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          ClipOval(
                            child: Image.network(
                              '${Constant.BASE_URL_IMAGE}${controller.banner.avatarPath}',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (
                                BuildContext context,
                                Object exception,
                                StackTrace? stackTrace,
                              ) {
                                return Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(153, 162, 179, 1),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chào mừng bạn đến với',
                                  style: TextStyle(
                                    color: Color.fromRGBO(177, 181, 195, 1),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${controller.banner.name}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.information);
                            },
                            child: Icon(
                              Icons.contact_mail_rounded,
                              color: Color.fromRGBO(177, 181, 195, 1),
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      SizedBox(height: 16),
                      StaggeredGrid.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        children: [
                          StaggeredGridTile.fit(
                            crossAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/congdong.svg',
                              title: 'Cộng đồng',
                              onTap: () {
                                if (controller.accessToken.isEmpty) {
                                  Get.toNamed(Routes.login);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => DialogCustom2(
                                          svg: 'assets/icons/coming_soon.svg',
                                          title: 'Cộng đồng',
                                          description:
                                              'Tính năng này đang được phát triển. Vui lòng quay lại sau!',
                                        ),
                                  );
                                }
                              },
                            ),
                          ),
                          StaggeredGridTile.fit(
                            crossAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/khoahoc.svg',
                              title: 'Khóa học',
                              onTap: () {
                                if (controller.accessToken.isEmpty) {
                                  Get.toNamed(Routes.login);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => DialogCustom2(
                                          svg: 'assets/icons/coming_soon.svg',
                                          title: 'Khóa học',
                                          description:
                                              'Tính năng này đang được phát triển. Vui lòng quay lại sau!',
                                        ),
                                  );
                                }
                              },
                            ),
                          ),
                          StaggeredGridTile.fit(
                            crossAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/giaidau.svg',
                              title: 'Giải đấu',
                              onTap: () {
                                if (controller.accessToken.isEmpty) {
                                  Get.toNamed(Routes.login);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => DialogCustom2(
                                          svg: 'assets/icons/coming_soon.svg',
                                          title: 'Giải đấu',
                                          description:
                                              'Tính năng này đang được phát triển. Vui lòng quay lại sau!',
                                        ),
                                  );
                                }
                              },
                            ),
                          ),
                          StaggeredGridTile.fit(
                            crossAxisCellCount: 1,
                            child: _itemAction(
                              icon: 'assets/icons/briefcase.svg',
                              title: 'Việc làm',
                              onTap: () {
                                if (controller.accessToken.isEmpty) {
                                  Get.toNamed(Routes.login);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => DialogCustom2(
                                          svg: 'assets/icons/coming_soon.svg',
                                          title: 'Việc làm',
                                          description:
                                              'Tính năng này đang được phát triển. Vui lòng quay lại sau!',
                                        ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      SizedBox(height: 16),
                      _titleAction(
                        title: 'Nổi bật',
                        onTap: () {
                          Get.toNamed(
                            '${Routes.blogList}?title=Nổi bật&type=1',
                          );
                        },
                      ),
                      SizedBox(height: 2),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate(controller.blogOutstandingList.length, (
                                index,
                              ) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      '${Routes.blogDetail}?id=${controller.blogOutstandingList[index].uuid}',
                                    );
                                  },
                                  child: Container(
                                    width: 270,
                                    height: 200,
                                    margin: EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                            188,
                                            192,
                                            196,
                                            0.25,
                                          ),
                                          offset: Offset(0, 1),
                                          blurRadius: 10,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(8),
                                          ),
                                          child: SizedBox(
                                            height: 100,
                                            width: 270,
                                            child: Image.network(
                                              '${Constant.BASE_URL_IMAGE}${controller.blogOutstandingList[index].imagePath}',
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace,
                                              ) {
                                                return Container(
                                                  height: 100,
                                                  color: Color.fromRGBO(
                                                    153,
                                                    162,
                                                    179,
                                                    1,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 7,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${controller.blogOutstandingList[index].title}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  '${controller.blogOutstandingList[index].title}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        DateFormat(
                                                          'dd/MM/yyyy',
                                                        ).format(
                                                          DateFormat(
                                                            'yyyy-MM-ddTHH:mm:ss',
                                                          ).parse(
                                                            controller
                                                                .blogOutstandingList[index]
                                                                .timePublic!,
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 6,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                            75,
                                                            201,
                                                            240,
                                                            1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          controller
                                                              .getCategoryName(
                                                                controller
                                                                    .blogOutstandingList[index]
                                                                    .catalog!,
                                                              ),
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).expand((widget) sync* {
                                yield widget;
                                yield const SizedBox(width: 8); // separator
                              }).toList(),
                        ).paddingOnly(left: 16, right: 8),
                      ),
                      SizedBox(height: 16),
                      _titleAction(
                        title: 'Video',
                        onTap: () {
                          Get.toNamed(Routes.videoList);
                        },
                      ),
                      SizedBox(height: 2),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                            controller.isVideoLoading.value
                                ? SizedBox(height: 140)
                                : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      List.generate(controller.videoList.length, (
                                        index,
                                      ) {
                                        return GestureDetector(
                                          onTap: () {
                                            Utils.openURL(
                                              controller
                                                      .videoList[index]
                                                      .videoLink ??
                                                  "",
                                            );
                                          },
                                          child: Container(
                                            height: 140,
                                            width: 270,
                                            margin: EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color.fromRGBO(
                                                    188,
                                                    192,
                                                    196,
                                                    0.25,
                                                  ),
                                                  offset: Offset(0, 1),
                                                  blurRadius: 10,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8.0,
                                                        ),
                                                    child: Image.network(
                                                      '${controller.videoList[index].thumbnail}',
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) => const Center(
                                                            child: CircularProgressIndicator(
                                                              color:
                                                                  ColorHex
                                                                      .primary,
                                                              strokeWidth: 2,
                                                            ),
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  left: 12,
                                                  right: 12,
                                                  child: Text(
                                                    '${controller.videoList[index].title}',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    height: 40,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white
                                                          .withOpacity(0.8),
                                                    ),
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      color: Colors.red
                                                          .withOpacity(0.8),
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).expand((widget) sync* {
                                        yield widget;
                                        yield const SizedBox(
                                          width: 8,
                                        ); // separator
                                      }).toList(),
                                ).paddingOnly(left: 16, right: 8),
                      ),
                      SizedBox(height: 16),
                      _titleAction(
                        title: 'Tin tức',
                        onTap: () {
                          Get.toNamed(
                            '${Routes.blogList}?title=Tin tức&type=0',
                          );
                        },
                      ),
                      SizedBox(height: 2),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              List.generate(controller.blogList.length, (
                                index,
                              ) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      '${Routes.blogDetail}?id=${controller.blogList[index].uuid}',
                                    );
                                  },
                                  child: Container(
                                    width: 270,
                                    height: 200,
                                    margin: EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                            188,
                                            192,
                                            196,
                                            0.25,
                                          ),
                                          offset: Offset(0, 1),
                                          blurRadius: 10,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(8),
                                          ),
                                          child: SizedBox(
                                            height: 100,
                                            width: 270,
                                            child: Image.network(
                                              '${Constant.BASE_URL_IMAGE}${controller.blogList[index].imagePath}',
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace,
                                              ) {
                                                return Container(
                                                  height: 100,
                                                  color: Color.fromRGBO(
                                                    153,
                                                    162,
                                                    179,
                                                    1,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 7,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${controller.blogList[index].title}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  '${controller.blogList[index].title}',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        DateFormat(
                                                          'dd/MM/yyyy',
                                                        ).format(
                                                          DateFormat(
                                                            'yyyy-MM-ddTHH:mm:ss',
                                                          ).parse(
                                                            controller
                                                                .blogList[index]
                                                                .timePublic!,
                                                          ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 6,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Color.fromRGBO(
                                                            75,
                                                            201,
                                                            240,
                                                            1,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          controller
                                                              .getCategoryName(
                                                                controller
                                                                    .blogList[index]
                                                                    .catalog!,
                                                              ),
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).expand((widget) sync* {
                                yield widget;
                                yield const SizedBox(width: 8); // separator
                              }).toList(),
                        ).paddingOnly(left: 16, right: 8),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
    );
  }

  _titleAction({required String title, required GestureTapCallback onTap}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: ColorHex.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Xem thêm',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: ColorHex.secondary,
              ),
            ),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  _itemAction({
    required String title,
    required String icon,
    required GestureTapCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color.fromRGBO(250, 250, 250, 1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Color.fromRGBO(241, 244, 249, 1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: Color.fromRGBO(177, 181, 195, 1),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
