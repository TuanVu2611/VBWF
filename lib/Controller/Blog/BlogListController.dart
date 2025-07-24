import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Model/Blog/BlogItem.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class BlogListController extends GetxController {
  RxBool isLoading = true.obs;
  String title = '';
  String type = '';
  RxInt catalog = 0.obs;
  List<BlogItem> blogList = <BlogItem>[];
  RxBool isBlogLoading = false.obs;
  int page = 1;
  int pageSize = 10;
  int totalPage = 0;
  TextEditingController textSearch = TextEditingController();
  Timer? _debounce;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    title = Get.parameters['title']!;
    type = Get.parameters['type']!;

    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (totalPage > page) {
          page++;
          if (type == '0') {
            getBlogList();
          } else {
            getBlogOutstandingList();
          }
        }
      }
    });

    if (type == '0') {
      await getBlogList();
    } else {
      await getBlogOutstandingList();
    }

    isLoading.value = false;
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
    blogList.clear();
    if (type == '0') {
      await getBlogList();
    } else {
      await getBlogOutstandingList();
    }
  }

  getBlogOutstandingList() async {
    if (page == 1) {
      isBlogLoading.value = true;
    }
    try {
      var param = {
        "pageSize": pageSize,
        "page": page,
        "keyword": textSearch.text,
        "status": 1,
        "catalog": catalog.value != 0 ? catalog.value : null
      };
      var data = await APICaller.getInstance().post('v1/Blog/get-page-list-special-blog-app', param);
      if (data != null) {
        totalPage = data['data']['pagination']['totalPage'];
        List<dynamic> list = data['data']['items'];
        var listItem = list.map((dynamic json) => BlogItem.fromJson(json)).toList();
        blogList.addAll(listItem);
        if (page == 1) {
          isBlogLoading.value = false;
        }
      } else {
        isBlogLoading.value = false;
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
      isBlogLoading.value = false;
    }
  }

  getBlogList() async {
    if (page == 1) {
      isBlogLoading.value = true;
    }
    try {
      var param = {
        "pageSize": pageSize,
        "page": page,
        "keyword": textSearch.text,
        "status": 1,
        "catalog": catalog.value != 0 ? catalog.value : null
      };
      var data = await APICaller.getInstance().post('v1/Blog/get-page-list-blog-app', param);
      if (data != null) {
        totalPage = data['data']['pagination']['totalPage'];
        List<dynamic> list = data['data']['items'];
        var listItem = list.map((dynamic json) => BlogItem.fromJson(json)).toList();
        blogList.addAll(listItem);
        if (page == 1) {
          isBlogLoading.value = false;
        }
      } else {
        isBlogLoading.value = false;
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
      isBlogLoading.value = false;
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
        return 'Tất cả';
    }
  }
}