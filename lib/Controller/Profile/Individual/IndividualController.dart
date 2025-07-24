import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Model/Achievement.dart';
import 'package:thehinhvn/Model/Activity.dart';
import 'package:thehinhvn/Model/Individual.dart';
import 'package:thehinhvn/Model/Video.dart' as model_video;
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class IndividualController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  String uuid = '';
  String code = '';
  RxString fullName = ''.obs;
  RxString avatar = ''.obs;
  RxBool isShowFloatingButton = true.obs;
  int limit = 12;
  // Hoạt động
  RxList<Activity> collectionActivity = RxList<Activity>();
  RxBool isLoadingAcivity = true.obs;
  int totalCountAcivity = 0;
  int totalPageAcivity = 0;
  int pageActivity = 1;
  ScrollController scrollControllerActivity = ScrollController();
  // Thành tích
  RxList<Achievement> collectionAchievement = RxList<Achievement>();
  RxBool isLoadingAchievement = true.obs;
  int totalCountAchievement = 0;
  int totalPageAchievement = 0;
  int pageAchievement = 1;
  ScrollController scrollControllerAchievement = ScrollController();
  // Video
  RxList<model_video.Video> collectionVideo = RxList<model_video.Video>();
  RxBool isLoadingVideo = true.obs;
  int totalCountVideo = 0;
  int totalPageVideo = 0;
  int pageVideo = 1;
  ScrollController scrollControllerVideo = ScrollController();
  TextEditingController videoUrl = TextEditingController();
  // Cá nhân
  Rx<Individual> info = Individual().obs;

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      if (tabController.index == 3) {
        isShowFloatingButton.value = false;
      } else {
        isShowFloatingButton.value = true;
      }
    });
    if (Get.arguments?["uuid"] != null) {
      uuid = Get.arguments?["uuid"];
    }
    if (Get.arguments?["code"] != null) {
      code = Get.arguments?["code"];
    }
    Utils.getStringValueWithKey(Constant.AVATAR_USER).then((value) {
      avatar.value = value;
    });
    Utils.getStringValueWithKey(Constant.FULL_NAME).then((value) {
      fullName.value = value;
    });
    // Hoạt động
    getActivity(isRefresh: true);
    scrollControllerActivity.addListener(() {
      if (scrollControllerActivity.position.pixels ==
          scrollControllerActivity.position.maxScrollExtent) {
        if (totalPageAcivity > pageActivity) {
          pageActivity++;
          getActivity(isClearData: false);
        }
      }
    });
    // Thành tích
    getAchievement(isRefresh: true);
    scrollControllerAchievement.addListener(() {
      if (scrollControllerAchievement.position.pixels ==
          scrollControllerAchievement.position.maxScrollExtent) {
        if (totalPageAchievement > pageAchievement) {
          pageAchievement++;
          getAchievement(isClearData: false);
        }
      }
    });
    // Video
    getVideo(isRefresh: true);
    scrollControllerVideo.addListener(() {
      if (scrollControllerVideo.position.pixels ==
          scrollControllerVideo.position.maxScrollExtent) {
        if (totalPageVideo > pageVideo) {
          pageVideo++;
          getVideo(isClearData: false);
        }
      }
    });
    // Cá nhân
    getIndividual();
    super.onInit();
  }

  // Hoạt động
  refreshDataActivity() async {
    pageActivity = 1;
    await getActivity(isRefresh: true);
  }

  Future getActivity({bool isRefresh = false, bool isClearData = true}) async {
    if (isRefresh) isLoadingAcivity.value = true;
    if (isClearData) collectionActivity.clear();
    try {
      var param = {
        "pageSize": limit,
        "page": pageActivity,
        "uuid": uuid,
        "code": code,
      };

      var response = await APICaller.getInstance().post(
        'v1/Activity/get-page-list-activity-app',
        param,
      );
      if (response != null) {
        totalCountAcivity = response['data']['pagination']['totalCount'];
        totalPageAcivity = response['data']['pagination']['totalPage'];
        List<dynamic> list = response['data']['items'];
        var listItem =
            list.map((dynamic json) => Activity.fromJson(json)).toList();
        collectionActivity.addAll(listItem);
      } else {
        Utils.showSnackBar(
          title: 'Thông báo',
          message: response['error']['message'],
        );
      }
    } catch (e) {
debugPrint(e.toString());
      return null;
    } finally {
      isLoadingAcivity.value = false;
    }
  }

  String getTextTypeActivity(int type) {
    switch (type) {
      case 1:
        return "Học vấn";
      case 2:
        return "Kinh nghiệm";
      case 3:
        return "Chứng chỉ";
      case 4:
        return "Hoạt động";
      case 5:
        return "Xã hội";
      case 6:
        return "Mục tiêu";
      case 7:
        return "Lịch sử";
      case 8:
        return "Kỹ năng";
      case 9:
        return "Hệ thống";
      case 10:
        return "Hỗ trợ";
      case 11:
        return "Đối tác";
      case 12:
        return "Ban lãnh đạo";
      default:
        return "Không xác định";
    }
  }

  Future deleteActivity(int index) async {
    try {
      var param = {"uuid": collectionActivity[index].uuid, "status": 0};

      var response = await APICaller.getInstance().post(
        'v1/Activity/update-status-activity-app',
        param,
      );
      if (response != null) {
        Get.back();
        collectionActivity.removeAt(index);
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Xóa hoạt động thành công!',
        );
      }
    } catch (e) {
debugPrint(e.toString());
    }
  }

  // Thành tích
  refreshDataAchievement() async {
    pageActivity = 1;
    await getAchievement(isRefresh: true);
  }

  Future getAchievement({
    bool isRefresh = false,
    bool isClearData = true,
  }) async {
    if (isRefresh) isLoadingAchievement.value = true;
    if (isClearData) collectionAchievement.clear();
    try {
      var param = {
        "pageSize": limit,
        "page": pageAchievement,
        "uuid": uuid,
        "code": code,
      };

      var response = await APICaller.getInstance().post(
        'v1/Achievement/get-page-list-achievement-app',
        param,
      );
      if (response != null) {
        totalCountAchievement = response['data']['pagination']['totalCount'];
        totalPageAchievement = response['data']['pagination']['totalPage'];
        List<dynamic> list = response['data']['items'];
        var listItem =
            list.map((dynamic json) => Achievement.fromJson(json)).toList();
        collectionAchievement.addAll(listItem);
      } else {
        Utils.showSnackBar(
          title: 'Thông báo',
          message: response['error']['message'],
        );
      }
    } catch (e) {
debugPrint(e.toString());
      return null;
    } finally {
      isLoadingAchievement.value = false;
    }
  }

  Future deleteAchievement(int index) async {
    try {
      var param = {"uuid": collectionAchievement[index].uuid, "status": 0};

      var response = await APICaller.getInstance().post(
        'v1/Achievement/update-status-achievement-app',
        param,
      );
      if (response != null) {
        Get.back();
        collectionAchievement.removeAt(index);
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Xóa thành tích thành công!',
        );
      }
    } catch (e) {
debugPrint(e.toString());
    }
  }

  // Video
  refreshDataVideo() async {
    pageVideo = 1;
    await getVideo(isRefresh: true);
  }

  Future getVideo({bool isRefresh = false, bool isClearData = true}) async {
    if (isRefresh) isLoadingVideo.value = true;
    if (isClearData) collectionVideo.clear();
    try {
      var param = {
        "pageSize": limit,
        "page": pageAchievement,
        "uuid": uuid,
        "code": code,
      };

      var response = await APICaller.getInstance().post(
        'v1/Video/get-page-list-video-app',
        param,
      );
      if (response != null) {
        totalCountAchievement = response['data']['pagination']['totalCount'];
        totalPageAchievement = response['data']['pagination']['totalPage'];
        List<dynamic> list = response['data']['items'];

        var yt = YoutubeExplode();

        List<Future<model_video.Video>> futureList =
            list.map<Future<model_video.Video>>((json) async {
              var item = model_video.Video.fromJson(json);

              try {
                var video = await yt.videos.get(item.videoLink);
                item.thumbnail =
                    'https://img.youtube.com/vi/${video.id.value}/0.jpg';
                item.title = video.title;
              } catch (e) {
                Utils.showSnackBar(
                  title: 'Thông báo',
                  message: 'Lỗi khi lấy video: ${item.videoLink}\nError: $e',
                );
              }

              return item;
            }).toList();

        var listItem = await Future.wait(futureList);

        collectionVideo.addAll(listItem);
        yt.close();
      } else {
        Utils.showSnackBar(
          title: 'Thông báo',
          message: response['error']['message'],
        );
      }
    } catch (e) {
debugPrint(e.toString());
      return null;
    } finally {
      isLoadingVideo.value = false;
    }
  }

  Future upsertVideo() async {
    try {
      var param = {"uuid": "", "videoLink": videoUrl.text};

      var response = await APICaller.getInstance().post(
        'v1/Video/upsert-video-app',
        param,
      );
      if (response != null) {
        refreshDataVideo();
        Get.back();
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Thêm video thành công!',
        );
      }
    } catch (e) {
debugPrint(e.toString());
    } finally {
      videoUrl.text = "";
    }
  }

  Future deleteVideo(int index) async {
    try {
      var param = {"uuid": collectionVideo[index].uuid, "status": 0};

      var response = await APICaller.getInstance().post(
        'v1/Video/update-status',
        param,
      );
      if (response != null) {
        Get.back();
        collectionVideo.removeAt(index);
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Xóa video thành công!',
        );
      }
    } catch (e) {
debugPrint(e.toString());
    }
  }

  // Cá nhân
  Future getIndividual() async {
    try {
      var param = {"uuid": uuid, "code": code};
      var response = await APICaller.getInstance().post(
        'v1/Profile/get-personal-profile-detail-app',
        param,
      );
      if (response != null) {
        info.value = Individual.fromJson(response['data']);
        info.refresh();
      }
    } catch (e) {
debugPrint(e.toString());
    }
  }
}
