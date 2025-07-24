import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Component/DialogCustom.dart';
import 'package:thehinhvn/Component/MyTabView.dart';
import 'package:thehinhvn/Controller/Profile/Individual/IndividualController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Individual extends StatelessWidget {
  Individual({super.key});

  final controller = Get.put(IndividualController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Get.width * 0.55),
        child: Stack(
          children: [
            const SizedBox(width: double.infinity, height: double.infinity),
            SizedBox(
              height: Get.width * 0.55,
              width: double.infinity,
              child: Obx(
                () => Image.network(
                  "${Constant.BASE_URL_IMAGE}${controller.info.value.banner}",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      "assets/images/bg.png",
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: Get.width / 2 - 48,
              child: Obx(
                () => ClipOval(
                  child: Image.network(
                    height: 96,
                    width: 96,
                    "${Constant.BASE_URL_IMAGE}${controller.info.value.avatar}",
                    fit: BoxFit.cover,
                    errorBuilder: (
                      BuildContext context,
                      Object exception,
                      StackTrace? stackTrace,
                    ) {
                      return Image.asset(
                        "assets/images/avatar_default.png",
                        height: 96,
                        width: 96,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: ColorHex.text2,
                  ),
                ),
              ),
            ),
            if (controller.uuid == "" && controller.code == "")
              Positioned(
                top: 50,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      Routes.infoPage,
                      arguments: controller.info.value,
                    );
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/edit.svg",
                      height: 16,
                      width: 16,
                      fit: BoxFit.scaleDown,
                      colorFilter: const ColorFilter.mode(
                        ColorHex.text2,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 4),
          Obx(
            () => Text(
              controller.info.value.name ?? "",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorHex.text1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Text(
              controller.info.value.slogan ?? "--",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: ColorHex.text1,
              ),
            ),
          ),
          TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: ColorHex.primary,
            dividerColor: ColorHex.background,
            isScrollable: true,
            indicatorColor: ColorHex.primary,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: const [
              Tab(child: Text("Hoạt động")),
              Tab(child: Text("Thành tích")),
              Tab(child: Text("Video")),
              Tab(child: Text("Cá nhân")),
            ],
            controller: controller.tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            tabAlignment: TabAlignment.center,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Container(
              color: ColorHex.background,
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  MyTabView(child: _activity()),
                  MyTabView(child: _achievement()),
                  MyTabView(child: _video()),
                  MyTabView(child: _profile()),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          controller.uuid != "" || controller.code != ""
              ? Container()
              : Obx(
                () =>
                    controller.isShowFloatingButton.value
                        ? FloatingActionButton(
                          backgroundColor: ColorHex.primary,
                          elevation: 0,
                          shape: const CircleBorder(),
                          onPressed: () {
                            switch (controller.tabController.index) {
                              case 0:
                                Get.toNamed(
                                  Routes.upsertActivity,
                                  parameters: {"id": ""},
                                );
                                break;
                              case 1:
                                Get.toNamed(
                                  Routes.upsertAchievement,
                                  parameters: {"id": ""},
                                );
                                break;
                              case 2:
                                controller.videoUrl.clear();
                                _showModalBottomSheet(context);
                                break;
                              default:
                                break;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        )
                        : SizedBox(height: 0, width: 0),
              ),
    );
  }

  Container _activity() {
    return Container(
      color: Colors.white,
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () =>
            controller.isLoadingAcivity.value
                ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorHex.primary,
                  ),
                )
                : RefreshIndicator(
                  onRefresh: () => controller.refreshDataActivity(),
                  child: Obx(
                    () =>
                        controller.collectionActivity.isEmpty
                            ? SizedBox(
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: Get.height * 0.2),
                                    SvgPicture.asset("assets/icons/nodata.svg"),
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
                            : Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: ListView.separated(
                                controller: controller.scrollControllerActivity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                physics: const AlwaysScrollableScrollPhysics(),
                                separatorBuilder:
                                    (context, index) =>
                                        const SizedBox(height: 10),
                                itemCount: controller.collectionActivity.length,
                                itemBuilder: (context, index) {
                                  return _collectionItem(
                                    context: context,
                                    index: index,
                                  );
                                },
                              ),
                            ),
                  ),
                ),
      ),
    );
  }

  GestureDetector _collectionItem({
    required BuildContext context,
    required int index,
  }) {
    return GestureDetector(
      onTap:
          () => Get.toNamed(
            Routes.detailActivity,
            parameters: {"id": controller.collectionActivity[index].uuid ?? ""},
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: ColorHex.grey),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: ColorHex.grey),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: Get.width * 0.2,
                        width: Get.width * 0.3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            '${Constant.BASE_URL_IMAGE}${controller.collectionActivity[index].imagePath}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 2,
                        top: 2,
                        child: Container(
                          width: 30,
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          decoration: BoxDecoration(
                            gradient: ColorHex.linear1,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.collectionActivity[index].title ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ColorHex.text1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          controller.collectionActivity[index].content ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: ColorHex.text1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
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
                                      controller
                                          .collectionActivity[index]
                                          .created,
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
                            const SizedBox(width: 6),
                            _typeActivity(
                              controller.collectionActivity[index].type ?? -1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (controller.uuid == "" && controller.code == "")
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => showDialog(
                            context: context,
                            builder:
                                (context) => DialogCustom(
                                  svgColor: const Color(0xffD95656),
                                  btnColor: const Color(0xffD95656),
                                  svg: "assets/icons/question_mark.svg",
                                  title: 'Xóa hoạt động',
                                  description:
                                      'Bạn có chắc chắn muốn xóa hoạt động này không?',
                                  onTap: () {
                                    controller.deleteActivity(index);
                                  },
                                ),
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(width: 0.5, color: ColorHex.grey),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Xóa bỏ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: ColorHex.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => Get.toNamed(
                            Routes.upsertActivity,
                            parameters: {
                              "id":
                                  controller.collectionActivity[index].uuid ??
                                  "",
                            },
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 0.5, color: ColorHex.grey),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Chỉnh sửa",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: ColorHex.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Container _typeActivity(int type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: getColorTypeActivity(type),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/acivity_$type.svg",
            height: 10,
            width: 10,
            fit: BoxFit.scaleDown,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 2),
          Text(
            controller.getTextTypeActivity(type),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Color getColorTypeActivity(int type) {
    switch (type) {
      case 1:
        return const Color(0xFF00B7C4);
      case 2:
        return const Color(0xFF3DC5AA);
      case 3:
        return const Color(0xFFFC7B5A);
      case 4:
        return const Color(0xFF2FA1D5);
      case 5:
        return const Color(0xFF4BC9F0);
      case 6:
        return const Color(0xFF4484FF);
      case 7:
        return const Color(0xFFF24775);
      case 8:
        return const Color(0xFF405189);
      case 9:
        return const Color(0xFF51CC56);
      case 10:
        return const Color(0xFFF95B5B);
      case 11:
        return const Color(0xFF7F62F1);
      case 12:
        return const Color(0xFF6D83CB);
      default:
        return Colors.grey;
    }
  }

  Container _achievement() {
    return Container(
      color: Colors.white,
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () =>
            controller.isLoadingAchievement.value
                ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorHex.primary,
                  ),
                )
                : RefreshIndicator(
                  onRefresh: () => controller.refreshDataAchievement(),
                  child: Obx(
                    () =>
                        controller.collectionAchievement.isEmpty
                            ? SizedBox(
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: Get.height * 0.2),
                                    SvgPicture.asset("assets/icons/nodata.svg"),
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
                            : Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: ListView.separated(
                                controller:
                                    controller.scrollControllerAchievement,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                physics: const AlwaysScrollableScrollPhysics(),
                                separatorBuilder:
                                    (context, index) =>
                                        const SizedBox(height: 10),
                                itemCount:
                                    controller.collectionAchievement.length,
                                itemBuilder: (context, index) {
                                  return _collectionItemAchievement(
                                    context: context,
                                    index: index,
                                  );
                                },
                              ),
                            ),
                  ),
                ),
      ),
    );
  }

  _collectionItemAchievement({
    required BuildContext context,
    required int index,
  }) {
    return GestureDetector(
      onTap:
          () => Get.toNamed(
            Routes.detailAchievement,
            parameters: {
              "id": controller.collectionAchievement[index].uuid ?? "",
            },
          ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: ColorHex.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: ColorHex.grey),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30,
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        decoration: BoxDecoration(
                          gradient: ColorHex.linear1,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        Utils.formatDate(
                          controller.collectionAchievement[index].date ?? "",
                        ),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: ColorHex.text7,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        height: 3,
                        width: 3,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SvgPicture.asset(
                        "assets/icons/privacy_${controller.collectionAchievement[index].privacy}.svg",
                        height: 12,
                        width: 12,
                        fit: BoxFit.scaleDown,
                        colorFilter: const ColorFilter.mode(
                          ColorHex.text3,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.collectionAchievement[index].title ?? "",
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
                    controller.collectionAchievement[index].content ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text1,
                    ),
                  ),
                ],
              ),
            ),
            if (controller.uuid == "" && controller.code == "")
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => showDialog(
                            context: context,
                            builder:
                                (context) => DialogCustom(
                                  svgColor: const Color(0xffD95656),
                                  btnColor: const Color(0xffD95656),
                                  svg: "assets/icons/question_mark.svg",
                                  title: 'Xóa thành tích',
                                  description:
                                      'Bạn có chắc chắn muốn xóa thành tích này không?',
                                  onTap: () {
                                    controller.deleteAchievement(index);
                                  },
                                ),
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(width: 0.5, color: ColorHex.grey),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Xóa bỏ",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: ColorHex.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap:
                          () => Get.toNamed(
                            Routes.upsertAchievement,
                            parameters: {
                              "id":
                                  controller
                                      .collectionAchievement[index]
                                      .uuid ??
                                  "",
                            },
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(width: 0.5, color: ColorHex.grey),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Chỉnh sửa",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: ColorHex.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Container _video() {
    return Container(
      color: Colors.white,
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () =>
            controller.isLoadingVideo.value
                ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorHex.primary,
                  ),
                )
                : RefreshIndicator(
                  onRefresh: () => controller.refreshDataVideo(),
                  child: Obx(
                    () =>
                        controller.collectionVideo.isEmpty
                            ? SizedBox(
                              child: Center(
                                child: Column(
                                  children: [
                                    SizedBox(height: Get.height * 0.2),
                                    SvgPicture.asset("assets/icons/nodata.svg"),
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
                            : Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: ListView.separated(
                                controller: controller.scrollControllerVideo,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                physics: const AlwaysScrollableScrollPhysics(),
                                separatorBuilder:
                                    (context, index) =>
                                        const SizedBox(height: 10),
                                itemCount: controller.collectionVideo.length,
                                itemBuilder: (context, index) {
                                  return _collectionItemVideo(
                                    context: context,
                                    index: index,
                                  );
                                },
                              ),
                            ),
                  ),
                ),
      ),
    );
  }

  _collectionItemVideo({required BuildContext context, required int index}) {
    final item = controller.collectionVideo[index];

    return GestureDetector(
      onTap: () {
        Utils.openURL(item.videoLink ?? "");
      },
      child: Container(
        height: Get.width * 0.35,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            const SizedBox(width: double.infinity, height: double.infinity),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  item.thumbnail ?? "",
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Center(
                        child: CircularProgressIndicator(
                          color: ColorHex.primary,
                          strokeWidth: 2,
                        ),
                      ),
                ),
              ),
            ),
            if (controller.uuid == "" && controller.code == "")
              Positioned(
                top: 8,
                left: 12,
                right: 12,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => DialogCustom(
                                svgColor: const Color(0xffD95656),
                                btnColor: const Color(0xffD95656),
                                svg: "assets/icons/question_mark.svg",
                                title: 'Xóa video',
                                description:
                                    'Bạn có chắc chắn muốn xóa video này không?',
                                onTap: () {
                                  controller.deleteVideo(index);
                                },
                              ),
                        );
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/trash.svg",
                          height: 14,
                          width: 14,
                          fit: BoxFit.scaleDown,
                          colorFilter: const ColorFilter.mode(
                            Colors.red,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Center(
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.8),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.red.withOpacity(0.8),
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _profile() {
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _labalProfile(label: "Chức vụ:"),
            Row(
              children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: ColorHex.main.withAlpha(50),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/cup.svg",
                    fit: BoxFit.scaleDown,
                    height: 20,
                    width: 20,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Obx(
                    () => Text(
                      _getTextExpertise(
                        controller.info.value.expertiseType ?? -1,
                      ),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: ColorHex.text1,
                      ),
                    ),
                  ),
                ),
              ],
            ).marginSymmetric(vertical: 6),
            _labalProfile(label: "Địa chỉ:"),
            Obx(
              () => Text(
                "${controller.info.value.addressInfo?.address1 ?? "--"}, ${controller.info.value.addressInfo?.xa?.name ?? "--"}, ${controller.info.value.addressInfo?.qh?.name ?? "--"}, ${controller.info.value.addressInfo?.tp?.name ?? "--"}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: ColorHex.text1,
                ),
              ).marginSymmetric(vertical: 6),
            ),
            _labalProfile(label: "Thông tin liên hệ:"),
            SizedBox(height: 6),
            StaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Obx(
                    () => _itemAction(
                      icon: 'assets/icons/facebook.svg',
                      isData:
                          controller.info.value.facebook != null &&
                          controller.info.value.facebook!.isNotEmpty,
                      onTap: () {
                        if (controller.info.value.facebook != null &&
                            controller.info.value.facebook!.isNotEmpty) {
                          Utils.openURL(controller.info.value.facebook!);
                        }
                      },
                    ),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Obx(
                    () => _itemAction(
                      icon: '',
                      image: 'assets/icons/zalo.png',
                      isData:
                          controller.info.value.zalo != null &&
                          controller.info.value.zalo!.isNotEmpty,
                      onTap: () {
                        if (controller.info.value.zalo != null &&
                            controller.info.value.zalo!.isNotEmpty) {
                          Utils.openURL(
                            'https://zalo.me/${controller.info.value.zalo!}',
                          );
                        }
                      },
                    ),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Obx(
                    () => _itemAction(
                      icon: 'assets/icons/whatsapp.svg',
                      isData:
                          controller.info.value.phoneNumber != null &&
                          controller.info.value.phoneNumber!.isNotEmpty,
                      onTap: () {
                        if (controller.info.value.phoneNumber != null &&
                            controller.info.value.phoneNumber!.isNotEmpty) {
                          _launchPhone(controller.info.value.phoneNumber!);
                        }
                      },
                    ),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Obx(
                    () => _itemAction(
                      icon: 'assets/icons/gmail.svg',
                      isData:
                          controller.info.value.email != null &&
                          controller.info.value.email!.isNotEmpty,
                      onTap: () {
                        if (controller.info.value.email != null &&
                            controller.info.value.email!.isNotEmpty) {
                          _launchEmail(controller.info.value.email!);
                        }
                      },
                    ),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Obx(
                    () => _itemAction(
                      icon: 'assets/icons/tiktok.svg',
                      isData:
                          controller.info.value.tiktok != null &&
                          controller.info.value.tiktok!.isNotEmpty,
                      onTap: () {
                        if (controller.info.value.tiktok != null &&
                            controller.info.value.tiktok!.isNotEmpty) {
                          Utils.openURL(controller.info.value.tiktok!);
                        }
                      },
                    ),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Obx(
                    () => _itemAction(
                      icon: 'assets/icons/instagram.svg',
                      isData:
                          controller.info.value.instagram != null &&
                          controller.info.value.instagram!.isNotEmpty,
                      onTap: () {
                        if (controller.info.value.instagram != null &&
                            controller.info.value.instagram!.isNotEmpty) {
                          Utils.openURL(controller.info.value.instagram!);
                        }
                      },
                    ),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Obx(
                    () => _itemAction(
                      icon: 'assets/icons/linked_in.svg',
                      isData:
                          controller.info.value.linkedIn != null &&
                          controller.info.value.linkedIn!.isNotEmpty,
                      onTap: () {
                        if (controller.info.value.linkedIn != null &&
                            controller.info.value.linkedIn!.isNotEmpty) {
                          Utils.openURL(controller.info.value.linkedIn!);
                        }
                      },
                    ),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 1,
                  child: Obx(
                    () => _itemAction(
                      icon: 'assets/icons/youtube.svg',
                      isData:
                          controller.info.value.youtube != null &&
                          controller.info.value.youtube!.isNotEmpty,
                      onTap: () {
                        if (controller.info.value.youtube != null &&
                            controller.info.value.youtube!.isNotEmpty) {
                          Utils.openURL(controller.info.value.youtube!);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            _labalProfile(label: "Sở thích:"),
            Obx(
              () => Text(
                controller.info.value.hobby ?? "--",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: ColorHex.text1,
                ),
              ).marginSymmetric(vertical: 6),
            ),
            _labalProfile(label: "Đơn vị công tác:"),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                        controller.info.value.infoExpertise?.expertiseName ??
                            "--",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        " tại ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: ColorHex.text1,
                        ),
                      ),
                      Text(
                        controller.info.value.infoExpertise?.addressInfo ??
                            "--",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: ColorHex.text1,
                        ),
                      ),
                    ],
                  ),
                  // Chỉ hiển thị hàng ngày tháng nếu expertiseDate không rỗng
                  if (controller
                          .info
                          .value
                          .infoExpertise
                          ?.expertiseDate
                          ?.isNotEmpty ??
                      false)
                    Row(
                      children: [
                        Text(
                          convertDateFormat(
                            controller
                                    .info
                                    .value
                                    .infoExpertise
                                    ?.expertiseDate ??
                                "",
                            false,
                          ),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: ColorHex.text3,
                          ),
                        ),
                        Text(
                          " - hiện tại",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: ColorHex.text3,
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
  }

  String convertDateFormat(String inputDate, bool isRequest) {
    if (inputDate.isEmpty) return "--"; // Xử lý chuỗi rỗng

    if (isRequest) {
      final parts = inputDate.split('/');
      if (parts.length != 3) return "--"; // Xử lý định dạng không hợp lệ
      final day = parts[0].padLeft(2, '0');
      final month = parts[1].padLeft(2, '0');
      final year = parts[2];
      return '$year-$month-$day';
    } else {
      final parts = inputDate.split('-');
      if (parts.length != 3) return "--"; // Xử lý định dạng không hợp lệ
      final year = parts[0];
      final month = parts[1].padLeft(2, '0');
      final day = parts[2].padLeft(2, '0');
      return '$day/$month/$year';
    }
  }

  String _getTextExpertise(int type) {
    switch (type) {
      case 1:
        return "Vận động viên";
      case 2:
        return "Huấn luyện viên";
      case 3:
        return "Trọng tài";
      default:
        return "--";
    }
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
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: email);

    launchUrl(emailLaunchUri);
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

  Text _labalProfile({required String label}) {
    return Text(
      label,
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ColorHex.text1,
      ),
    );
  }

  _showModalBottomSheet(BuildContext context) {
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
                      "Thêm video",
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
                          SvgPicture.asset(
                            "assets/icons/youtube.svg",
                            height: 24,
                            width: 24,
                            fit: BoxFit.scaleDown,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              "Youtube",
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
                      controller: controller.videoUrl,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Vui lòng nhập URL";
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
                            controller.upsertVideo();
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
