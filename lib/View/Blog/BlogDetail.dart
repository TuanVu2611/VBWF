import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thehinhvn/Controller/Blog/BlogDetailController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class BlogDetail extends StatelessWidget {
  const BlogDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      BlogDetailController(),
      tag: Get.parameters['id'],
    );
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Chi tiết tin tức'),
      //   actions: [
      //     // IconButton(
      //     //   icon: const Icon(Icons.share_rounded),
      //     //   tooltip: 'Chia sẻ',
      //     //   onPressed: () {
      //     //
      //     //   },
      //     // ),
      //   ],
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        title: Text(
          "Tin tức",
          style: const TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => Container(
          color: Color.fromRGBO(244, 246, 250, 1),
          child:
              controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    Constant.BASE_URL_IMAGE +
                                        controller.blogDetail.imagePath!,
                                    height: 200,
                                    width: Get.size.width,
                                    fit: BoxFit.cover,
                                    errorBuilder: (
                                      BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace,
                                    ) {
                                      return Container();
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    '${controller.blogDetail.title}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ).paddingOnly(left: 16, right: 16),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            size: 16,
                                            color: Color.fromRGBO(
                                              153,
                                              162,
                                              179,
                                              1,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            DateFormat('dd/MM/yyyy').format(
                                              DateFormat(
                                                'yyyy-MM-ddTHH:mm:ss',
                                              ).parse(
                                                controller
                                                    .blogDetail
                                                    .timePublic!,
                                              ),
                                            ),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                153,
                                                162,
                                                179,
                                                1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.remove_red_eye_outlined,
                                            size: 16,
                                            color: Color.fromRGBO(
                                              153,
                                              162,
                                              179,
                                              1,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            '${controller.blogDetail.view} lượt xem',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                153,
                                                162,
                                                179,
                                                1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.mode_comment_outlined,
                                            size: 16,
                                            color: Color.fromRGBO(
                                              153,
                                              162,
                                              179,
                                              1,
                                            ),
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            '${controller.blogDetail.countComment} bình luận',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Color.fromRGBO(
                                                153,
                                                162,
                                                179,
                                                1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ).paddingOnly(left: 16, right: 16),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        'Chuyên mục: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        controller.getCategoryName(
                                          controller.blogDetail.catalog!,
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: ColorHex.main,
                                        ),
                                      ),
                                    ],
                                  ).paddingOnly(left: 16, right: 16),
                                  SizedBox(height: 20),
                                  Html(
                                    data: """
                ${controller.blogDetail.content}
                  """,
                                  ).paddingOnly(left: 9, right: 9),
                                  SizedBox(height: 16),
                                ],
                              ),
                            ),
                            SizedBox(height: 3),
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bình luận (${controller.totalCountComment.value})',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  if (controller.accessToken.isNotEmpty &&
                                      controller.blogDetail.blockComment ==
                                          true) ...[
                                    Card(
                                      color: Color.fromRGBO(252, 252, 253, 1),
                                      child: Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: TextField(
                                          controller: controller.textComment,
                                          maxLines: 3,
                                          decoration: InputDecoration.collapsed(
                                            hintText: 'Chia sẻ ý kiến của bạn',
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (controller.textComment.text
                                                  .trim()
                                                  .isNotEmpty &&
                                              !controller
                                                  .isCommentLoading
                                                  .value) {
                                            controller.uploadComment();
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: ColorHex.primary,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            'Gửi',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _tabFilterComment(
                                        controller: controller,
                                        title: 'Mới nhất',
                                        value: 0,
                                      ),
                                      _tabFilterComment(
                                        controller: controller,
                                        title: 'Cũ nhất',
                                        value: 1,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  controller.isCommentLoading.value
                                      ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : ListView.separated(
                                        itemCount:
                                            controller.commentList.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder:
                                            (context, index) =>
                                                const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipOval(
                                                    child: Image.network(
                                                      '${Constant.BASE_URL_IMAGE}${controller.commentList[index].profileUser!.imagePath}',
                                                      width: 36,
                                                      height: 36,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (
                                                        BuildContext context,
                                                        Object exception,
                                                        StackTrace? stackTrace,
                                                      ) {
                                                        return Container(
                                                          width: 36,
                                                          height: 36,
                                                          color: Color.fromRGBO(
                                                            153,
                                                            162,
                                                            179,
                                                            1,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${controller.commentList[index].profileUser!.name}',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
                                                        '${controller.commentList[index].timeAgo}',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color.fromRGBO(
                                                            153,
                                                            162,
                                                            179,
                                                            1,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 6),
                                              Text(
                                                '${controller.commentList[index].content}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                  SizedBox(height: 8),
                                  Visibility(
                                    visible:
                                        controller.totalPageComment >
                                        controller.pageComment,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.pageComment++;
                                          controller.getComment();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: ColorHex.main,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            'Xem thêm',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            SizedBox(height: 3),
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bài viết liên quan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  ListView.separated(
                                    itemCount: controller.blogList.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    separatorBuilder:
                                        (context, index) =>
                                            const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            '${Routes.blogDetail}?id=${controller.blogList[index].uuid}',
                                            preventDuplicates: false,
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: Color.fromRGBO(
                                                236,
                                                239,
                                                243,
                                                1,
                                              ),
                                            ),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                  188,
                                                  192,
                                                  196,
                                                  0.25,
                                                ),
                                                // Màu với độ mờ
                                                offset: Offset(0, 1),
                                                blurRadius: 10,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  Constant.BASE_URL_IMAGE +
                                                      controller
                                                          .blogList[index]
                                                          .imagePath!,
                                                  width: 120,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (
                                                    BuildContext context,
                                                    Object exception,
                                                    StackTrace? stackTrace,
                                                  ) {
                                                    return Container();
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${controller.blogList[index].title}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .access_time_rounded,
                                                          size: 14,
                                                          color: Color.fromRGBO(
                                                            153,
                                                            162,
                                                            179,
                                                            1,
                                                          ),
                                                        ),
                                                        SizedBox(width: 6),
                                                        Text(
                                                          DateFormat(
                                                            'dd/MM/yyyy',
                                                          ).format(
                                                            DateFormat(
                                                              'yyyy-MM-ddTHH:mm:ss',
                                                            ).parse(
                                                              controller
                                                                  .blogList[index]
                                                                  .timePublic!,
                                                            ),
                                                          ),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 11,
                                                            color:
                                                                Color.fromRGBO(
                                                                  153,
                                                                  162,
                                                                  179,
                                                                  1,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .remove_red_eye_outlined,
                                                              size: 14,
                                                              color:
                                                                  Color.fromRGBO(
                                                                    153,
                                                                    162,
                                                                    179,
                                                                    1,
                                                                  ),
                                                            ),
                                                            SizedBox(width: 6),
                                                            Text(
                                                              '${controller.blogList[index].view} lượt xem',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 11,
                                                                color:
                                                                    Color.fromRGBO(
                                                                      153,
                                                                      162,
                                                                      179,
                                                                      1,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .mode_comment_outlined,
                                                              size: 14,
                                                              color:
                                                                  Color.fromRGBO(
                                                                    153,
                                                                    162,
                                                                    179,
                                                                    1,
                                                                  ),
                                                            ),
                                                            SizedBox(width: 6),
                                                            Text(
                                                              '${controller.blogList[index].countComment} bình luận',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 11,
                                                                color:
                                                                    Color.fromRGBO(
                                                                      153,
                                                                      162,
                                                                      179,
                                                                      1,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
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
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: controller.blogDetail.catalog == 3,
                        child: Container(
                          width: Get.size.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(198, 198, 198, 0.25),
                                offset: Offset(0, -2),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Utils.openURL("${controller.blogDetail.link}");
                            },
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ColorHex.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Đăng ký',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  _tabFilterComment({
    required BlogDetailController controller,
    required String title,
    required int value,
  }) {
    return GestureDetector(
      onTap: () {
        controller.isFilterComment.value = value;
        controller.refreshDataComment();
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration:
            controller.isFilterComment.value != value
                ? null
                : BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ColorHex.primary, width: 1),
                  ),
                ),
        child: Text(
          title,
          style: TextStyle(
            color:
                controller.isFilterComment.value != value
                    ? Color.fromRGBO(153, 162, 179, 1)
                    : ColorHex.primary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
