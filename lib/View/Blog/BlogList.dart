import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thehinhvn/Controller/Blog/BlogListController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';

class BlogList extends StatelessWidget {
  const BlogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BlogListController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        title: Text(
          controller.title,
          style: const TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() => Container(
        color: Colors.white,
        child: controller.isLoading.value ? Center(
          child: CircularProgressIndicator(),
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      controller.catalog.value = index;
                      controller.refreshData();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color:  controller.catalog.value != index ? Color.fromRGBO(244, 246, 249, 1) : ColorHex.primary,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text(
                        controller.getCategoryName(index),
                        style: TextStyle(
                          color: controller.catalog.value != index ? null : Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  );
                },).expand((widget) sync* {
                  yield widget;
                  yield const SizedBox(width: 8); // separator
                }).toList(),
              ).paddingSymmetric(horizontal: 16, vertical: 12),
            ),
            Container(
              height: 44,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: 1,
                      color: Color.fromRGBO(225, 229, 237, 1))),
              child: TextField(
                controller: controller.textSearch,
                onChanged: (value) => controller.onSearchChanged(),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm',
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(119, 126, 144, 1)),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(10),
                    child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        fit: BoxFit.fitHeight),
                  ),
                ),
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
            ).paddingSymmetric(horizontal: 16),
            SizedBox(height: 12,),
            Expanded(child: RefreshIndicator(
              onRefresh: () => controller.refreshData(),
              child: controller.isBlogLoading.value ? Center(
                child: CircularProgressIndicator(),
              ) : controller.blogList.isEmpty ? ListView(
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
                itemCount: controller.blogList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12,),
                itemBuilder: (context, index) {
                  if (index == controller.blogList.length - 1 && controller.totalPage != controller.page) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('${Routes.blogDetail}?id=${controller.blogList[index].uuid}');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                            child: Image.network(
                              '${Constant.BASE_URL_IMAGE}${controller.blogList[index].imagePath}',
                              height: 100,
                              width: Get.size.width,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object exception,
                                  StackTrace? stackTrace) {
                                return Container(
                                  height: 100,
                                  color: Color.fromRGBO(153, 162, 179, 1),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${controller.blogList[index].title}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2,),
                                Text(
                                  '${controller.blogList[index].title}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(child: Text(
                                      DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(controller.blogList[index].timePublic!)),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    GestureDetector(
                                      onTap: () {

                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(75, 201, 240, 1),
                                            borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Text(
                                          controller.getCategoryName(controller.blogList[index].catalog!),
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ))
          ],
        ),
      )),
    );
  }

}