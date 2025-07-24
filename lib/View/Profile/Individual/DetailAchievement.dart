import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:photo_view/photo_view.dart';
import 'package:thehinhvn/Controller/Profile/Individual/DetailAchievementController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class DetailAchievement extends StatelessWidget {
  DetailAchievement({super.key});

  final controller = Get.put(DetailAchievementController());

  // Hàm kiểm tra phần mở rộng file và mở file
  void _openFile(String filePath) async {
    final extension = filePath.split('.').last.toLowerCase();
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];

    if (imageExtensions.contains(extension)) {
      // Nếu là hình ảnh, hiển thị trong Dialog với PhotoView
      final imageUrl = "${Constant.BASE_URL_IMAGE}$filePath";
      print('Hiển thị hình ảnh: $imageUrl');
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(0),
          child: Stack(
            children: [
              PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black87,
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                errorBuilder:
                    (context, error, stackTrace) => const Center(
                      child: Icon(Icons.error, color: Colors.red, size: 50),
                    ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
        barrierColor: Colors.black54,
      );
    } else {
      // Nếu không phải hình ảnh, tải file và mở bằng ứng dụng mặc định
      try {
        // Hiển thị thông báo đang tải
        // Utils.showSnackBar(
        //   title: 'Đang tải',
        //   message: 'Đang tải file, vui lòng chờ...',
        //   duration: const Duration(seconds: 10),
        // );

        // Xây dựng URL để tải file
        final fileUrl = "${Constant.BASE_URL_IMAGE}$filePath";

        // Tải file từ server
        final file = await APICaller.getInstance().downloadAndGetFile(filePath);

        if (file == null) {
          Utils.showSnackBar(
            title: 'Lỗi',
            message: 'Không thể tải file từ server. URL: $fileUrl',
          );
          return;
        }

        // Kiểm tra file có tồn tại và kích thước file
        final fileExists = await file.exists();
        final fileSize = await file.length();

        if (!fileExists || fileSize == 0) {
          Utils.showSnackBar(
            title: 'Lỗi',
            message:
                'File tải về không tồn tại hoặc rỗng. Vui lòng kiểm tra file trên server. URL: $fileUrl',
          );
          return;
        }

        // Mở file bằng open_file
        final result = await OpenFile.open(file.path);
        if (result.type != ResultType.done) {
          if (result.type == ResultType.noAppToOpen) {
            Utils.showSnackBar(
              title: 'Lỗi',
              message:
                  'Không tìm thấy ứng dụng để mở file ${extension.toUpperCase()}. Vui lòng cài ứng dụng hỗ trợ.',
            );
          } else {
            Utils.showSnackBar(
              title: 'Lỗi',
              message: 'Không thể mở file: ${result.message}',
            );
          }
        }
      } catch (e) {
        Utils.showSnackBar(
          title: 'Lỗi',
          message: 'Đã có lỗi xảy ra khi tải hoặc mở file: $e',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        title: const Text(
          "Chi tiết thành tích",
          style: TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () =>
            controller.isLoading.value
                ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorHex.primary,
                  ),
                )
                : ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 21,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              controller.detail.title ?? "",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 20,
                                color: ColorHex.text1,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/clock.svg",
                                height: 14,
                                width: 14,
                                fit: BoxFit.scaleDown,
                                colorFilter: const ColorFilter.mode(
                                  ColorHex.text7,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                Utils.formatDate(controller.detail.created),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: ColorHex.text7,
                                ),
                              ),
                              const SizedBox(width: 43),
                              SvgPicture.asset(
                                "assets/icons/privacy_${controller.detail.privacy}.svg",
                                height: 12,
                                width: 12,
                                fit: BoxFit.scaleDown,
                                colorFilter: const ColorFilter.mode(
                                  ColorHex.text3,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                controller.detail.privacy == 0
                                    ? 'Riêng tư'
                                    : 'Công khai',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: ColorHex.text3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              controller.detail.content ?? "",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: ColorHex.text2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (controller.detail.filePath != null &&
                              controller.detail.filePath!.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "File chứng chỉ:",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: ColorHex.text2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    // Gọi hàm mở file khi nhấn vào
                                    _openFile(controller.detail.filePath!);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: ColorHex.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/document.svg",
                                          height: 32,
                                          width: 32,
                                          fit: BoxFit.scaleDown,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            controller.detail.filePath!
                                                .split('/')
                                                .last,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: ColorHex.text1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
  }
}
