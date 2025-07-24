import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thehinhvn/Controller/Profile/Individual/UpsertActivityController.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class UpsertActivity extends StatelessWidget {
  UpsertActivity({super.key});

  final controller = Get.put(UpsertActivityController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isValidDate(String date) {
      try {
        DateFormat('dd/MM/yyyy').parseStrict(date);
        return true;
      } catch (e) {
        return false;
      }
    }

    bool isPassDate(String date) {
      try {
        final inputDate = DateFormat('dd/MM/yyyy').parseStrict(date);
        final fromDate = DateFormat(
          'dd/MM/yyyy',
        ).parseStrict(controller.fromDate.text);
        return inputDate.isBefore(fromDate);
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

    return Scaffold(
      backgroundColor: ColorHex.background,
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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 4),
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _labelForm(
                          label: "Loại hoạt động",
                          isRequired: true,
                        ).marginSymmetric(vertical: 6),
                        ButtonTheme(
                          alignedDropdown: true,
                          child: Obx(
                            () => DropdownButtonFormField<String>(
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(16),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: ColorHex.text7,
                              ),
                              style: const TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF202939),
                              ),
                              hint: const Text(
                                'Chọn loại hoạt động',
                                style: TextStyle(
                                  color: ColorHex.text7,
                                  fontSize: 13,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
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
                                filled: true,
                                fillColor: const Color(0xFFFFFFFF),
                                contentPadding: const EdgeInsets.only(
                                  right: 12,
                                ),
                              ),
                              items:
                                  [
                                    {
                                      "value": "0",
                                      "label": "--- Chọn loại hoạt động ---  ",
                                    }, // Thêm tùy chọn mặc định
                                    {"value": "1", "label": "Học vấn"},
                                    {"value": "2", "label": "Kinh nghiệm"},
                                    {"value": "3", "label": "Chứng chỉ"},
                                    {"value": "4", "label": "Hoạt động"},
                                    {"value": "5", "label": "Xã hội"},
                                    {"value": "6", "label": "Mục tiêu"},
                                    {"value": "7", "label": "Lịch sử"},
                                    {"value": "8", "label": "Kỹ năng"},
                                    {"value": "9", "label": "Hệ thống"},
                                    {"value": "10", "label": "Hỗ trợ"},
                                    {"value": "11", "label": "Đối tác"},
                                    {"value": "12", "label": "Ban lãnh đạo"},
                                  ].map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value["value"].toString(),
                                      child: Text(
                                        value["label"].toString(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          color: ColorHex.text1,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                controller.type.value =
                                    value ??
                                    "0"; // Giá trị mặc định là "0" nếu không chọn
                              },
                              value:
                                  controller.type.value == "0"
                                      ? null
                                      : controller.type.value,
                              // Hiển thị hint nếu không có giá trị
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng chọn loại hoạt động';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        Obx(
                          () =>
                              controller.type.value == "1" ||
                                      controller.type.value == "2" ||
                                      controller.type.value == "3" ||
                                      controller.type.value == "4"
                                  ? Column(
                                    children: [
                                      _labelForm(
                                        label: "Hiển thị trong CV",
                                      ).marginSymmetric(vertical: 6),
                                      Obx(
                                        () => Row(
                                          children: [
                                            Row(
                                              children: [
                                                Radio(
                                                  value: true,
                                                  groupValue:
                                                      controller.isIncv.value,
                                                  activeColor:
                                                      controller.isIncv.value
                                                          ? ColorHex.primary
                                                          : null,
                                                  onChanged: (value) {
                                                    controller.isIncv.value =
                                                        value ?? true;
                                                  },
                                                ),
                                                const Text(
                                                  'Hiển thị',
                                                  style: TextStyle(
                                                    color: Color(0xFF23262F),
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                  value: false,
                                                  groupValue:
                                                      controller.isIncv.value,
                                                  activeColor:
                                                      !controller.isIncv.value
                                                          ? ColorHex.primary
                                                          : null,
                                                  onChanged: (value) {
                                                    controller.isIncv.value =
                                                        value ?? false;
                                                  },
                                                ),
                                                const Text(
                                                  'Không hiển thị',
                                                  style: TextStyle(
                                                    color: Color(0xFF23262F),
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.normal,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ).marginSymmetric(horizontal: 20),
                                      ),
                                    ],
                                  )
                                  : const SizedBox(height: 0),
                        ),
                        _labelForm(
                          label: "Link truy cập",
                          // isRequired: true,
                        ).marginSymmetric(vertical: 6),
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: ColorHex.text1,
                          ),
                          controller: controller.url,
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
                            hintText: 'Nhập URL',
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return "Vui lòng nhập URL";
                          //   }
                          //   return null;
                          // },
                        ),
                        _labelForm(
                          label: "Ảnh",
                          isRequired: true,
                        ).marginSymmetric(vertical: 6),
                        GestureDetector(
                          onTap: () {
                            Utils.getImagePicker(2).then((value) {
                              if (value != null) {
                                controller.imageNetwork.value = "";
                                controller.image.value = value;
                              }
                            });
                          },
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 17,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 1,
                                color: ColorHex.grey,
                              ),
                              color: ColorHex.background,
                            ),
                            child: Obx(
                              () =>
                                  controller.imageNetwork.value != ""
                                      ? Image.network(
                                        controller.imageNetwork.value,
                                        fit: BoxFit.fitWidth,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: ColorHex.primary,
                                                ),
                                      )
                                      : controller.image.value.path != ""
                                      ? Image.file(
                                        controller.image.value,
                                        fit: BoxFit.fitWidth,
                                      )
                                      : Column(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/camera.svg",
                                            fit: BoxFit.scaleDown,
                                            height: 24,
                                            width: 24,
                                          ),
                                          const SizedBox(height: 12),
                                          const Text(
                                            'Chọn và tải lên ảnh',
                                            style: TextStyle(
                                              color: ColorHex.text1,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'PNG, JPG, GIF tối đa 5MB',
                                            style: TextStyle(
                                              color: ColorHex.text3,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                        _labelForm(
                          label: "Tiêu đề",
                          isRequired: true,
                        ).marginSymmetric(vertical: 6),
                        TextFormField(
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: ColorHex.text1,
                          ),
                          controller: controller.titleActivity,
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
                            hintText: 'Nhập tiêu đề',
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Vui lòng nhập tiêu đề";
                            }
                            return null;
                          },
                        ),
                        Obx(
                          () =>
                              controller.type.value == "1" ||
                                      controller.type.value == "2" ||
                                      controller.type.value == "3" ||
                                      controller.type.value == "4" ||
                                      controller.type.value == "5" ||
                                      controller.type.value == "6" ||
                                      controller.type.value == "7" ||
                                      controller.type.value == "8"
                                  ? Column(
                                    children: [
                                      _labelForm(
                                        label: "Ngày hoạt động",
                                        isRequired: true,
                                      ).marginSymmetric(vertical: 6),
                                      TextFormField(
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF202939),
                                        ),
                                        controller: controller.fromDate,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9\/]*$'),
                                          ),
                                          TextInputFormatter.withFunction((
                                            oldValue,
                                            newValue,
                                          ) {
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
                                              selection:
                                                  TextSelection.collapsed(
                                                    offset: text.length,
                                                  ),
                                            );
                                          }),
                                        ],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: ColorHex.grey,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: ColorHex.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: ColorHex.grey,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
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
                                              DateTime?
                                              pickedDate = await showDatePicker(
                                                builder: (
                                                  BuildContext context,
                                                  Widget? child,
                                                ) {
                                                  return Theme(
                                                    data: Theme.of(
                                                      context,
                                                    ).copyWith(
                                                      colorScheme:
                                                          const ColorScheme.light(
                                                            primary:
                                                                ColorHex.main,
                                                            onPrimary:
                                                                Colors.white,
                                                            surface:
                                                                Colors.white,
                                                          ),
                                                      // dialogBackgroundColor: Colors.orangeAccent, // Nền của toàn dialog
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                                context: context,
                                                initialDate:
                                                    stringToDate(
                                                      controller.fromDate.text,
                                                    ) ??
                                                    DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                              );
                                              if (pickedDate != null) {
                                                controller
                                                    .fromDate
                                                    .text = DateFormat(
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
                                            return 'Vui lòng chọn ngày bắt đầu';
                                          }
                                          if (!isValidDate(value)) {
                                            return 'Ngày tháng không hợp lệ. Xin kiểm tra lại';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  )
                                  : SizedBox(height: 0),
                        ),
                        Obx(
                          () =>
                              controller.type.value == "1" ||
                                      controller.type.value == "2" ||
                                      controller.type.value == "5" ||
                                      controller.type.value == "7"
                                  ? Column(
                                    children: [
                                      _labelForm(
                                        label: "Ngày kết thúc",
                                        isRequired: true,
                                      ).marginSymmetric(vertical: 6),
                                      TextFormField(
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF202939),
                                        ),
                                        controller: controller.toDate,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^[0-9\/]*$'),
                                          ),
                                          TextInputFormatter.withFunction((
                                            oldValue,
                                            newValue,
                                          ) {
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
                                              selection:
                                                  TextSelection.collapsed(
                                                    offset: text.length,
                                                  ),
                                            );
                                          }),
                                        ],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: ColorHex.grey,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: ColorHex.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                            borderSide: const BorderSide(
                                              width: 1,
                                              color: ColorHex.grey,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
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
                                              DateTime?
                                              pickedDate = await showDatePicker(
                                                builder: (
                                                  BuildContext context,
                                                  Widget? child,
                                                ) {
                                                  return Theme(
                                                    data: Theme.of(
                                                      context,
                                                    ).copyWith(
                                                      colorScheme:
                                                          const ColorScheme.light(
                                                            primary:
                                                                ColorHex.main,
                                                            onPrimary:
                                                                Colors.white,
                                                            surface:
                                                                Colors.white,
                                                          ),
                                                      // dialogBackgroundColor: Colors.orangeAccent, // Nền của toàn dialog
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                                context: context,
                                                initialDate:
                                                    stringToDate(
                                                      controller.toDate.text,
                                                    ) ??
                                                    DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2100),
                                              );
                                              if (pickedDate != null) {
                                                controller
                                                    .toDate
                                                    .text = DateFormat(
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
                                            return 'Vui lòng chọn ngày kết thúc';
                                          }
                                          if (!isValidDate(value)) {
                                            return 'Ngày tháng không hợp lệ. Xin kiểm tra lại';
                                          }
                                          if (isPassDate(value)) {
                                            return 'Ngày kết thúc phải lớn hơn ngày hoạt động';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  )
                                  : SizedBox(height: 0),
                        ),
                        _labelForm(
                          label: "Thứ tự",
                        ).marginSymmetric(vertical: 6),
                        TextFormField(
                          controller: controller.sort,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          style: const TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            color: ColorHex.text1,
                          ),
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
                              fontWeight: FontWeight.w400,
                            ),
                            hintText: 'Nhập thứ tự',
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Vui lòng nhập thứ tự';
                            }
                            int? number = int.tryParse(value);
                            if (number == null || number < 1 || number > 99) {
                              return 'Thứ tự phải từ 1 đến 99';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.sort.text = value;
                          },
                        ),
                        _labelForm(
                          label: "Nội dung",
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
                          controller: controller.content,
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
                            hintText: 'Nhập nội dung',
                          ),
                        ),
                        _labelForm(
                          label: "Hiển thị",
                          isRequired: true,
                        ).marginSymmetric(vertical: 6),
                        Obx(
                          () => Row(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 0,
                                    groupValue: controller.privacy.value,
                                    activeColor:
                                        controller.privacy.value == 0
                                            ? ColorHex.primary
                                            : null,
                                    onChanged: (value) {
                                      controller.privacy.value = value as int;
                                    },
                                  ),
                                  const Text(
                                    'Riêng tư',
                                    style: TextStyle(
                                      color: Color(0xFF23262F),
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue: controller.privacy.value,
                                    activeColor:
                                        controller.privacy.value == 1
                                            ? ColorHex.primary
                                            : null,
                                    onChanged: (value) {
                                      controller.privacy.value = value as int;
                                    },
                                  ),
                                  const Text(
                                    'Công khai',
                                    style: TextStyle(
                                      color: Color(0xFF23262F),
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ).marginSymmetric(horizontal: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                    'Lưu lại',
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

  Row _labelForm({required String label, bool isRequired = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: ColorHex.text2,
          ),
        ),
        const SizedBox(width: 4),
        if (isRequired)
          const Text(
            "*",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: ColorHex.red,
            ),
          ),
      ],
    );
  }
}
