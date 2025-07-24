import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Model/Video.dart' as vd;
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoListController extends GetxController {
  RxBool isVideoLoading = false.obs;
  int page = 1;
  int pageSize = 10;
  int totalPage = 0;
  Timer? _debounce;
  ScrollController scrollController = ScrollController();
  List<vd.Video> videoList = <vd.Video>[];

  @override
  void onInit() async {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (totalPage > page) {
          page++;
          getVideoList();
        }
      }
    });
    await getVideoList();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  refreshData() async {
    page = 1;
    videoList.clear();
    await getVideoList();
  }

  getVideoList() async {
    if (page == 1) {
      isVideoLoading.value = true;
    }
    try {
      var param = {
        "pageSize": pageSize,
        "page": page
      };
      var data = await APICaller.getInstance().post('v1/Video/get-page-list-video-home-app', param);
      if (data != null) {
        totalPage = data['data']['pagination']['totalPage'];
        List<dynamic> list = data['data']['items'];
        var listItem = list.map((dynamic json) => vd.Video.fromJson(json)).toList();
        videoList.addAll(listItem);
        await fetchYoutubeMetadata();
        if (page == 1) {
          isVideoLoading.value = false;
        }
      } else {
        isVideoLoading.value = false;
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
      isVideoLoading.value = false;
    }
  }

  fetchYoutubeMetadata() async {
    var yt = YoutubeExplode();
    for (var video in videoList) {
      var videoInfo = await yt.videos.get(video.videoLink);
      video.thumbnail = 'https://img.youtube.com/vi/${videoInfo.id.value}/0.jpg';
      video.title = videoInfo.title;
    }
  }
}