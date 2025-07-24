import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Model/Visitor.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class DetailHistoryController extends GetxController {
  late String id;
  late bool isNFC;
  int limit = 12;
  RxList<Visitor> collection = <Visitor>[].obs;
  RxBool isLoading = true.obs;
  int totalCount = 0;
  int totalPage = 0;
  int page = 1;
  ScrollController scrollController = ScrollController();
  RxBool isClear = true.obs;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments['id'];
    isNFC = Get.arguments['isNFC'];
    getVisitor(isRefresh: true);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (totalPage > page) {
          page++;
          getVisitor(isClearData: false);
        }
      }
    });
  }

  refreshData() async {
    page = 1;
    await getVisitor(isRefresh: true);
  }

  Future getVisitor({bool isRefresh = false, bool isClearData = true}) async {
    if (isRefresh) isLoading.value = true;
    if (isClearData) collection.clear();
    try {
      var param = {
        "pageSize": limit,
        "page": page,
        "uuid": id,
        "status": 1
      };
      var response = await APICaller.getInstance().post(
          'v1/Log/${isNFC ? "get-page-list-detail-visitor-nfc-app" : "get-page-list-detail-visitor-app"}',
          param);
      if (response != null) {
        totalCount = response['data']['pagination']['totalCount'];
        totalPage = response['data']['pagination']['totalPage'];
        List<dynamic> list = response['data']['items'];
        var listItem =
            list.map((dynamic json) => Visitor.fromJson(json)).toList();
        collection.addAll(listItem);
      } else {
        Utils.showSnackBar(
            title: 'Thông báo', message: response['error']['message']);
      }
    } catch (e) {
debugPrint(e.toString());
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
