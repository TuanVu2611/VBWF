import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Model/Visitor.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class HistoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  int limit = 12;
  int test = 0;
  Timer? debounceTimer;
  // Visitor NFC
  RxList<Visitor> collectionVNFC = <Visitor>[].obs;
  RxBool isLoadingVNFC = true.obs;
  int totalCountVNFC = 0;
  int totalPageVNFC = 0;
  int pageVNFC = 1;
  ScrollController scrollControllerVNFC = ScrollController();
  Rx<TextEditingController> searchVNFC = TextEditingController().obs;
  RxBool isClearVNFC = true.obs;
  // Visitor
  RxList<Visitor> collection = <Visitor>[].obs;
  RxBool isLoading = true.obs;
  int totalCount = 0;
  int totalPage = 0;
  int page = 1;
  ScrollController scrollController = ScrollController();
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isClear = true.obs;


  @override
  void onInit() {
    super.onInit();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    // Visitor NFC
    getVisitorNFC(isRefresh: true);
    scrollControllerVNFC.addListener(() {
      if (scrollControllerVNFC.position.pixels ==
          scrollControllerVNFC.position.maxScrollExtent) {
        if (totalPageVNFC > pageVNFC) {
          pageVNFC++;
          getVisitorNFC(isClearData: false);
        }
      }
    });
    // Visitor
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

  // Visitor NFC
  refreshDataVNFC() async {
    pageVNFC = 1;
    await getVisitorNFC(isRefresh: true);
  }

  Future getVisitorNFC(
      {bool isRefresh = false, bool isClearData = true}) async {
    if (isRefresh) isLoadingVNFC.value = true;
    if (isClearData) collectionVNFC.clear();
    try {
      var param = {
        "pageSize": limit,
        "page": pageVNFC,
        "keyword": searchVNFC.value.text,
        "status": 1
      };
      var response = await APICaller.getInstance()
          .post('v1/Log/get-page-list-visitor-nfc-app', param);
      if (response != null) {
        totalCountVNFC = response['data']['pagination']['totalCount'];
        totalPageVNFC = response['data']['pagination']['totalPage'];
        List<dynamic> list = response['data']['items'];
        var listItem =
            list.map((dynamic json) => Visitor.fromJson(json)).toList();
        collectionVNFC.addAll(listItem);
      } else {
        Utils.showSnackBar(
            title: 'Thông báo', message: response['error']['message']);
      }
    } catch (e) {
debugPrint(e.toString());
      return null;
    } finally {
      isLoadingVNFC.value = false;
    }
  }

  // Visitor
  refreshData() async {
    page = 1;
    await getVisitor(isRefresh: true);
  }

  Future getVisitor(
      {bool isRefresh = false, bool isClearData = true}) async {
    if (isRefresh) isLoading.value = true;
    if (isClearData) collection.clear();
    try {
      var param = {
        "pageSize": limit,
        "page": page,
        "keyword": search.value.text,
        "status": 1
      };
      var response = await APICaller.getInstance()
          .post('v1/Log/get-page-list-visitor-app', param);
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