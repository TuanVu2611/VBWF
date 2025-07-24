import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/Profile/Statistical/StatisticalController.dart';
import '../../../Global/ColorHex.dart';

class Statistical extends StatelessWidget {
  const Statistical({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo controller
    final StatisticalController controller = Get.put(StatisticalController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        title: const Text(
          "Thống kê",
          style: TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(
            () => Column(
              // Sử dụng Obx để tự động cập nhật giao diện khi dữ liệu thay đổi
              children: [
                Card(
                  color: Colors.white,
                  child: ListTile(
                    title: const Text(
                      "Tổng lượt xem",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: ColorHex.text14,
                      ),
                    ),
                    subtitle: Text(
                      "${controller.countViewProfile.value}",
                      style: const TextStyle(
                        color: ColorHex.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Card(
                  color: Colors.white,
                  child: ListTile(
                    title: const Text(
                      "Tổng lượt lưu danh bạ",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: ColorHex.text14,
                      ),
                    ),
                    subtitle: Text(
                      "${controller.countSaveContacts.value}",
                      style: const TextStyle(
                        color: ColorHex.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Card(
                  color: Colors.white,
                  child: ListTile(
                    title: const Text(
                      "Tổng lượt quét danh thiếp",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: ColorHex.text14,
                      ),
                    ),
                    subtitle: Text(
                      "${controller.countScanNFC.value}",
                      style: const TextStyle(
                        color: ColorHex.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
