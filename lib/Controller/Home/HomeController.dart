import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Model/Blog/BlogItem.dart';
import 'package:thehinhvn/Model/Home/Banner.dart';
import 'package:thehinhvn/Model/Video.dart' as vd;
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class HomeController extends GetxController {
  RxString fullName = ''.obs;
  RxString avatar = ''.obs;
  RxBool isLoading = true.obs;
  RxBool isHaveNewNoti = false.obs;
  RxBool isVideoLoading = false.obs;
  CarouselSliderController carouselController = CarouselSliderController();
  RxInt currentIndex = 0.obs;
  Banner banner = Banner();
  List<BlogItem> blogOutstandingList = <BlogItem>[];
  List<vd.Video> videoList = <vd.Video>[];
  List<BlogItem> blogList = <BlogItem>[];
  RxString accessToken = ''.obs;
  Timer? refreshTimer;

  @override
  void onInit() async {
    accessToken.value = await Utils.getStringValueWithKey(
      Constant.ACCESS_TOKEN,
    );
    fullName.value = await Utils.getStringValueWithKey(Constant.FULL_NAME);
    avatar.value = await Utils.getStringValueWithKey(Constant.AVATAR_USER);

    // Gọi lần đầu tiên khi init
    await fetchAllContent();

    // Thiết lập lặp lại mỗi 5 phút
    refreshTimer = Timer.periodic(Duration(minutes: 2), (timer) {
      fetchAllContent();
    });

    isLoading.value = false;
    super.onInit();
  }

  Future<void> fetchAllContent() async {
    await getBanner();
    await getBlogOutstandingList();
    await getVideoList();
    await getBlogList();
  }

  @override
  void onClose() {
    refreshTimer?.cancel(); // Hủy timer khi controller bị dispose
    super.onClose();
  }

  getBanner() async {
    try {
      var data = await APICaller.getInstance().post(
        'v1/Profile/get-home-profile-app',
        null,
      );
      if (data != null) {
        banner = Banner.fromJson(data['data']);
      } else {}
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

  getBlogOutstandingList() async {
    try {
      var param = {"pageSize": 5, "page": 1};
      var data = await APICaller.getInstance().post(
        'v1/Blog/get-list-items-special-blog-app',
        param,
      );
      if (data != null) {
        List<dynamic> list = data['data']['items'];
        var listItem =
            list.map((dynamic json) => BlogItem.fromJson(json)).toList();
        blogOutstandingList.clear();
        blogOutstandingList.addAll(listItem);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

  getBlogList() async {
    try {
      var param = {"pageSize": 5, "page": 1};
      var data = await APICaller.getInstance().post(
        'v1/Blog/get-list-items-blog-app',
        param,
      );
      if (data != null) {
        List<dynamic> list = data['data']['items'];
        var listItem =
            list.map((dynamic json) => BlogItem.fromJson(json)).toList();
        blogList.clear();
        blogList.addAll(listItem);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

  getVideoList() async {
    try {
      isVideoLoading.value = true;
      videoList.clear();
      var param = {"pageSize": 5, "page": 1};
      var data = await APICaller.getInstance().post(
        'v1/Video/get-page-list-video-home-app',
        param,
      );
      if (data != null) {
        List<dynamic> list = data['data']['items'];
        var listItem =
            list.map((dynamic json) => vd.Video.fromJson(json)).toList();

        videoList.addAll(listItem);
        await fetchYoutubeMetadata();
        isVideoLoading.value = false;
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

  fetchYoutubeMetadata() async {
    var yt = YoutubeExplode();
    for (var video in videoList) {
      var videoInfo = await yt.videos.get(video.videoLink);
      video.thumbnail =
          'https://img.youtube.com/vi/${videoInfo.id.value}/0.jpg';
      video.title = videoInfo.title;
    }
  }

  String getCategoryName(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'Tin tức';
      case 2:
        return 'Cơ hội';
      case 3:
        return 'Sự kiện';
      case 4:
        return 'Tài liệu';
      default:
        return 'Khác';
    }
  }
}
