import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thehinhvn/Controller/Profile/CVManagement/UpsertCVController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class UpsertCV extends StatelessWidget {
  UpsertCV({super.key});

  final controller = Get.put(UpsertCVController());
  final _formKey = GlobalKey<FormState>();

  bool isValidDate(String date) {
    try {
      DateFormat('dd/MM/yyyy').parseStrict(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool isFutureDate(String date) {
    try {
      final inputDate = DateFormat('dd/MM/yyyy').parseStrict(date);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      return inputDate.isAfter(today);
    } catch (e) {
      return false;
    }
  }

  DateTime? stringToDate(String dateText) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateText);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Get.back();
            if (controller.isCreate) Get.back();
          },
          child: const Icon(Icons.chevron_left_sharp, size: 30),
        ),
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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 16,
                ),
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Utils.getImagePicker(2).then((value) {
                          if (value != null) {
                            controller.image.value = value;
                          }
                        });
                      },
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Obx(
                                    () => controller.image.value.path != ""
                                    ? Image.file(
                                  controller.image.value,
                                  fit: BoxFit.cover,
                                )
                                    : Image.network(
                                  "${Constant.BASE_URL_IMAGE}${controller.detail.value.imagePath}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                      ) {
                                    return Image.asset(
                                      'assets/images/avatar_default.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Thêm biểu tượng máy ảnh ở chính giữa
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.photo_camera,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    controller.detail.value.name ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      color: ColorHex.text1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text1,
                    ),
                    controller: controller.email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintStyle: const TextStyle(
                        color: ColorHex.text7,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Nhập email',
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return "Vui lòng nhập email";
                    //   }
                    //   return null;
                    // },
                  ).marginSymmetric(vertical: 6),
                  TextFormField(
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text1,
                    ),
                    controller: controller.phoneNumber,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintStyle: const TextStyle(
                        color: ColorHex.text7,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Nhập SĐT',
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                    ),
                  ).marginSymmetric(vertical: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Giới tính',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ColorHex.text8,
                        ),
                      ),
                      Row(
                        children: [
                          Obx(
                            () => Row(
                              children: [
                                Radio<int>(
                                  value: 0, // Nam
                                  groupValue: controller.gender.value,
                                  activeColor: ColorHex.primary,
                                  onChanged: (value) {
                                    controller.gender.value = value!;
                                  },
                                ),
                                const Text('Nam'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(
                            () => Row(
                              children: [
                                Radio<int>(
                                  value: 1, // Nữ
                                  groupValue: controller.gender.value,
                                  activeColor: ColorHex.primary,
                                  onChanged: (value) {
                                    controller.gender.value = value!;
                                  },
                                ),
                                const Text('Nữ'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextFormField(
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF202939),
                    ),
                    controller: controller.birthday,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^[0-9\/]*$'),
                      ),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        String text = newValue.text;
                        if (newValue.text.length == 2 &&
                            oldValue.text.length != 3) {
                          text += '/';
                        }
                        if (newValue.text.length == 5 &&
                            oldValue.text.length != 6) {
                          text += '/';
                        }
                        return newValue.copyWith(
                          text: text,
                          selection: TextSelection.collapsed(
                            offset: text.length,
                          ),
                        );
                      }),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintStyle: const TextStyle(
                        color: ColorHex.text7,
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'dd/mm/yyyy',
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: ColorHex.main,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                  ),
                                  // dialogBackgroundColor: Colors.orangeAccent, // Nền của toàn dialog
                                ),
                                child: child!,
                              );
                            },
                            context: context,
                            initialDate:
                                stringToDate(controller.birthday.text) ??
                                DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            controller.birthday.text = DateFormat(
                              'dd/MM/yyyy',
                            ).format(pickedDate);
                          }
                        },
                        child: SvgPicture.asset(
                          "assets/icons/calendar.svg",
                          fit: BoxFit.scaleDown,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ),
                    onChanged: (value) => {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      } else if (!isValidDate(value)) {
                        return 'Ngày tháng không hợp lệ. Xin kiểm tra lại';
                      } else if (isFutureDate(value)) {
                        return 'Ngày sinh không được là tương lai';
                      }
                      return null;
                    },
                  ).marginSymmetric(vertical: 6),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: controller.height,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text1,
                    ),
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final text = newValue.text.replaceAll(',', '');
                        if (text.isEmpty) {
                          return newValue;
                        }
                        // Đối với có phần thập phân 3 ký tự RegExp(r'^\d*\.?\d{0,3}$')
                        if (!RegExp(r'^\d*$').hasMatch(text)) {
                          return oldValue;
                        }
    
                        final parts = text.split('.');
                        if (parts.length == 1) {
                          final formattedText = NumberFormat(
                            '#,###',
                          ).format(int.parse(parts[0]));
                          return newValue.copyWith(
                            text: formattedText,
                            selection: TextSelection.collapsed(
                              offset: formattedText.length,
                            ),
                          );
                        } else {
                          final formattedText =
                              '${parts[0] == '' ? "" : NumberFormat('#,###').format(int.parse(parts[0]))}.${parts[1]}';
                          return newValue.copyWith(
                            text: formattedText,
                            selection: TextSelection.collapsed(
                              offset: formattedText.length,
                            ),
                          );
                        }
                      }),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintStyle: const TextStyle(
                        color: ColorHex.text7,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Nhập chiều cao',
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      suffix: Container(
                        padding: const EdgeInsets.only(left: 6),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 1,
                              color: Color(0xFFCDD5DF),
                            ),
                          ),
                        ),
                        child: Text(
                          'CM'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: ColorHex.text3,
                          ),
                        ),
                      ).marginOnly(left: 6),
                    ),
                  ).marginSymmetric(vertical: 6),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    controller: controller.weight,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text1,
                    ),
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final text = newValue.text.replaceAll(',', '');
                        if (text.isEmpty) {
                          return newValue;
                        }
                        // Đối với có phần thập phân 3 ký tự RegExp(r'^\d*\.?\d{0,3}$')
                        if (!RegExp(r'^\d*$').hasMatch(text)) {
                          return oldValue;
                        }
    
                        final parts = text.split('.');
                        if (parts.length == 1) {
                          final formattedText = NumberFormat(
                            '#,###',
                          ).format(int.parse(parts[0]));
                          return newValue.copyWith(
                            text: formattedText,
                            selection: TextSelection.collapsed(
                              offset: formattedText.length,
                            ),
                          );
                        } else {
                          final formattedText =
                              '${parts[0] == '' ? "" : NumberFormat('#,###').format(int.parse(parts[0]))}.${parts[1]}';
                          return newValue.copyWith(
                            text: formattedText,
                            selection: TextSelection.collapsed(
                              offset: formattedText.length,
                            ),
                          );
                        }
                      }),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintStyle: const TextStyle(
                        color: ColorHex.text7,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Nhập cân nặng',
                      contentPadding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                      ),
                      suffix: Container(
                        padding: const EdgeInsets.only(left: 6),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 1,
                              color: Color(0xFFCDD5DF),
                            ),
                          ),
                        ),
                        child: Text(
                          'KG'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            color: ColorHex.text3,
                          ),
                        ),
                      ).marginOnly(left: 6),
                    ),
                  ).marginSymmetric(vertical: 6),
                  TextFormField(
                    maxLines: 6,
                    minLines: 4,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text1,
                    ),
                    controller: controller.address,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintStyle: const TextStyle(
                        color: ColorHex.text7,
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Nhập địa chỉ chi tiết',
                    ),
                  ).marginSymmetric(vertical: 6),
                  TextFormField(
                    maxLines: 6,
                    minLines: 4,
                    maxLength: 2000,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text1,
                    ),
                    controller: controller.introduce,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintStyle: const TextStyle(
                        color: ColorHex.text7,
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Giới thiệu bản thân',
                    ),
                  ).marginSymmetric(vertical: 6),
                  _label(
                    title: 'HỌC VẤN',
                    type: "1",
                  ).marginSymmetric(vertical: 6),
                  Obx(
                    () => ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                      shrinkWrap: true,
                      itemCount:
                          controller.detail.value.educations?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${controller.convertDateFormat(controller.detail.value.educations?[index].fromDate, false)} - ${controller.convertDateFormat(controller.detail.value.educations?[index].toDate, false)}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorHex.text2,
                              ),
                            ),
                            Text(
                              controller
                                      .detail
                                      .value
                                      .educations?[index]
                                      .title ??
                                  "",
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: ColorHex.text1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              controller
                                      .detail
                                      .value
                                      .educations?[index]
                                      .content ??
                                  "",
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorHex.text2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  _label(
                    title: 'KINH NGHIỆM',
                    type: "2",
                  ).marginSymmetric(vertical: 6),
                  Obx(
                    () => ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                      shrinkWrap: true,
                      itemCount:
                          controller.detail.value.experiences?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${controller.convertDateFormat(controller.detail.value.experiences?[index].fromDate, false)} - ${controller.convertDateFormat(controller.detail.value.experiences?[index].toDate, false)}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorHex.text2,
                              ),
                            ),
                            Text(
                              controller
                                      .detail
                                      .value
                                      .experiences?[index]
                                      .title ??
                                  "",
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: ColorHex.text1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              controller
                                      .detail
                                      .value
                                      .experiences?[index]
                                      .content ??
                                  "",
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorHex.text2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  _label(
                    title: 'HOẠT ĐỘNG',
                    type: "4",
                  ).marginSymmetric(vertical: 6),
                  Obx(
                    () => ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                      shrinkWrap: true,
                      itemCount:
                          controller.detail.value.activities?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${controller.convertDateFormat(controller.detail.value.activities?[index].fromDate, false)} - ${controller.convertDateFormat(controller.detail.value.activities?[index].toDate, false)}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorHex.text2,
                              ),
                            ),
                            Text(
                              controller
                                      .detail
                                      .value
                                      .activities?[index]
                                      .title ??
                                  "",
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: ColorHex.text1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              controller
                                      .detail
                                      .value
                                      .activities?[index]
                                      .content ??
                                  "",
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorHex.text2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  _label(
                    title: 'CHỨNG CHỈ VÀ GIẢI THƯỞNG',
                    type: "3",
                  ).marginSymmetric(vertical: 6),
                  Obx(
                    () => ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                      shrinkWrap: true,
                      itemCount: controller.detail.value.awards?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${controller.convertDateFormat(controller.detail.value.awards?[index].fromDate, false)} - ${controller.convertDateFormat(controller.detail.value.awards?[index].toDate, false)}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorHex.text2,
                              ),
                            ),
                            Text(
                              controller.detail.value.awards?[index].title ??
                                  "",
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                color: ColorHex.text1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              controller
                                      .detail
                                      .value
                                      .awards?[index]
                                      .content ??
                                  "",
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                color: ColorHex.text2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  _label(title: 'KỸ NĂNG').marginSymmetric(vertical: 6),
                  TextFormField(
                    maxLines: 6,
                    minLines: 4,
                    maxLength: 2000,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text1,
                    ),
                    controller: controller.skill,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintStyle: const TextStyle(
                        color: ColorHex.text7,
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Nhập kỹ năng',
                    ),
                  ).marginSymmetric(vertical: 6),
                  _label(title: 'SỞ THÍCH').marginSymmetric(vertical: 6),
                  TextFormField(
                    maxLines: 6,
                    minLines: 4,
                    maxLength: 2000,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      color: ColorHex.text1,
                    ),
                    controller: controller.hobby,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          width: 1,
                          color: ColorHex.grey,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFFFFF),
                      hintStyle: const TextStyle(
                        color: ColorHex.text7,
                        fontSize: 13,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'Nhập sở thích',
                    ),
                  ).marginSymmetric(vertical: 6),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    offset: const Offset(0, -4), // shadow hướng lên trên
                    blurRadius: 6,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorHex.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed:
                      controller.isWaitSubmit.value
                          ? null
                          : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              controller.submit();
                            }
                          },
                  child: const Text(
                    'Xác nhận',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _label({required String title, String? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: ColorHex.text1,
            ),
          ),
        ),
        const SizedBox(width: 20),
        if (type != null)
          GestureDetector(
            onTap:
                () => Get.toNamed(
                  Routes.upsertActivity,
                  parameters: {"id": "", "type": type},
                ),
            child: Container(
              height: 24,
              width: 24,
              decoration: const BoxDecoration(
                color: ColorHex.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
      ],
    );
  }
}
