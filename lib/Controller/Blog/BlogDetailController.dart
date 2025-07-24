import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Model/Blog/BlogDetail.dart';
import 'package:thehinhvn/Model/Blog/BlogItem.dart';
import 'package:thehinhvn/Model/Blog/CommentItem.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class BlogDetailController extends GetxController {
  DateTime timeNow = DateTime.now();
  RxBool isLoading = true.obs;
  String uuid = '';
  BlogDetail blogDetail = BlogDetail();
  List<BlogItem> blogList = <BlogItem>[];
  RxList<CommentItem> commentList = RxList<CommentItem>();
  RxInt isFilterComment = 0.obs;
  RxInt totalCountComment = 0.obs;
  int pageComment = 1;
  int pageSizeComment = 5;
  int totalPageComment = 0;
  RxBool isCommentLoading = false.obs;
  TextEditingController textComment = TextEditingController();
  String accessToken = '';

  @override
  void onInit() async {
    accessToken = await Utils.getStringValueWithKey(Constant.ACCESS_TOKEN);
    uuid = Get.parameters['id']!;
    await getBlogDetail();
    await getComment();
    await getRelatedBlog();
    isLoading.value = false;
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getBlogDetail() async {
    try {
      var param = {
        "uuid": uuid,
      };
      var data = await APICaller.getInstance().post('v1/Blog/view-blog-app', param);
      if (data != null) {
        blogDetail = BlogDetail.fromJson(data['data']);
      } else {
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

  getRelatedBlog() async {
    try {
      var param = {
        "pageSize": 3,
        "page": 1,
        "catalog": blogDetail.catalog,
        "ignoreUuid": uuid
      };
      var data = await APICaller.getInstance().post('v1/Blog/get-page-list-related-blog-app', param);
      if (data != null) {
        List<dynamic> list = data['data']['items'];
        var listItem = list.map((dynamic json) => BlogItem.fromJson(json)).toList();
        blogList.addAll(listItem);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

  getComment() async {
    try {
      if (pageComment == 1) {
        isCommentLoading.value = true;
      }
      var param = {
        "pageSize": pageSizeComment,
        "page": pageComment,
        "uuid": uuid,
        "sort": isFilterComment.value
      };
      var data = await APICaller.getInstance().post('v1/Comment/get-page-list-comment-app', param);
      if (data != null) {
        totalCountComment.value = data['data']['pagination']['totalCount'];
        totalPageComment = data['data']['pagination']['totalPage'];
        List<dynamic> list = data['data']['items'];
        var listItem = list.map((dynamic json) => CommentItem.fromJson(json)).toList();
        commentList.addAll(listItem);
        if (pageComment == 1) {
          isCommentLoading.value = false;
        }
      }
      else {
        isCommentLoading.value = false;
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
      isCommentLoading.value = false;
    }
  }

  uploadComment() async {
    try {
      var param = {
        "blogUuid": uuid,
        "content": textComment.text.trim()
      };
      var data = await APICaller.getInstance().post('v1/Comment/create-comment', param);
      if (data != null) {
        await refreshDataComment();
        textComment.clear();
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

  refreshDataComment() async {
    pageComment = 1;
    commentList.clear();
    await getComment();
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