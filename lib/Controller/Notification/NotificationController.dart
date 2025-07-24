import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Model/Notify.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class NotificationController extends GetxController {
  int limit = 50;
  RxList<Notify> collection = RxList<Notify>();
  RxBool isLoading = true.obs;
  int totalCount = 0;
  int totalPage = 0;
  int page = 1;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    getData(isRefresh: true);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (totalPage > page) {
          page++;
          getData(isClearData: false);
        }
      }
    });
    super.onInit();
  }

  // Hoạt động
  refreshData() async {
    page = 1;
    await getData(isRefresh: true);
  }

  Future getData({bool isRefresh = false, bool isClearData = true}) async {
    if (isRefresh) isLoading.value = true;
    if (isClearData) collection.clear();
    try {
      var param = {"pageSize": limit, "page": page};

      var response = await APICaller.getInstance().post('v1/Notify/get-page-list-notify', param);
      if (response != null) {
        totalCount = response['data']['pagination']['totalCount'];
        totalPage = response['data']['pagination']['totalPage'];
        List<dynamic> list = response['data']['items'];
        var listItem = list.map((dynamic json) => Notify.fromJson(json)).toList();
        collection.addAll(listItem);
      } else {
        Utils.showSnackBar(title: 'Thông báo', message: response['error']['message']);
      }
    } catch (e) {
debugPrint(e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future updateNotifyState(String uuid) async {
    try {
      var body = {"uuid": uuid};

      var response = await APICaller.getInstance().post('v1/Notify/update-state-notify', body);

      if (response != null && response['error']['code'] == 0) {
        return true;
      } else {
        Utils.showSnackBar(title: 'Thông báo', message: response['error']['message']);
        return false;
      }
    } catch (e) {
      // Utils.showSnackBar(
      //   title: 'Error!',
      //   message: 'Đã có lỗi xảy ra: $e!',
      // );
      debugPrint('Error: $e');
      return false;
    }
  }

  Future updateMultiNotifyState(String uuid) async {
    try {
      var response = await APICaller.getInstance().post('v1/Notify/update-state-all-notify', null);

      if (response != null && response['error']['code'] == 0) {
        return true;
      } else {
        Utils.showSnackBar(title: 'Thông báo', message: response['error']['message']);
        return false;
      }
    } catch (e) {
      // Utils.showSnackBar(
      //   title: 'Error!',
      //   message: 'Đã có lỗi xảy ra: $e!',
      // );
      debugPrint('Error: $e');
      return false;
    }
  }
}
