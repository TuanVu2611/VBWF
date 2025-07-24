import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thehinhvn/Controller/Video/VideoListController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class VideoList extends StatelessWidget {
  const VideoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VideoListController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        title: Text(
          "Video",
          style: const TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() => Container(
        color: Colors.white,
        child: RefreshIndicator(
          onRefresh: () => controller.refreshData(),
          child: controller.isVideoLoading.value ? Center(
            child: CircularProgressIndicator(),
          ) : controller.videoList.isEmpty ? ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: [
              Container(
                width: Get.width,
                height: Get.height * 0.4,
                child: Text(
                  'Không có dữ liệu',
                  style: TextStyle(
                      fontWeight: FontWeight.w700
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ) : ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller.scrollController,
            itemCount: controller.videoList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12,),
            itemBuilder: (context, index) {
              if (index == controller.videoList.length - 1 && controller.totalPage != controller.page) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
              }
              return GestureDetector(
                onTap: () {
                  Utils.openURL(controller.videoList[index].videoLink ?? "");
                },
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(188, 192, 196, 0.25),
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
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            '${controller.videoList[index].thumbnail}',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: CircularProgressIndicator(
                                color: ColorHex.primary,
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
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.8)),
                          child: Icon(Icons.play_arrow,
                              color: Colors.red.withOpacity(0.8), size: 30),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      )),
    );
  }

}