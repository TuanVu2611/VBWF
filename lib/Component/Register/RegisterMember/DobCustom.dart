import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../Global/ColorHex.dart';

class DobInput extends StatelessWidget {
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final BuildContext context;
  final Color backgroundColor;

  const DobInput({
    super.key,
    required this.label,
    required this.controller,
    required this.context,
    this.isRequired = false,
    this.backgroundColor = Colors.white,
  });

  // Hàm kiểm tra định dạng ngày (dd/MM/yyyy)
  bool isValidDate(String value) {
    try {
      DateFormat('dd/MM/yyyy').parseStrict(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Hàm chuyển chuỗi sang DateTime
  DateTime? stringToDate(String date) {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(date);
    } catch (e) {
      return null;
    }
  }

  // Hàm định dạng ngày cho API (yyyy-MM-dd)
  String? formatForApi(String date) {
    try {
      final parsedDate = DateFormat('dd/MM/yyyy').parseStrict(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(228, 230, 236, 1),
        ),
      ),
      child: TextFormField(
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        controller: controller,
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9\/]*$')),
          TextInputFormatter.withFunction((oldValue, newValue) {
            String text = newValue.text;
            if (newValue.text.length == 2 && oldValue.text.length != 3) {
              text += '/';
            }
            if (newValue.text.length == 5 && oldValue.text.length != 6) {
              text += '/';
            }
            return newValue.copyWith(
              text: text,
              selection: TextSelection.collapsed(offset: text.length),
            );
          }),
        ],
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
            color: ColorHex.text5,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: ColorHex.primary, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 1, color: Colors.red),
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
                    ),
                    child: child!,
                  );
                },
                context: context,
                initialDate: stringToDate(controller.text) ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
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
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Vui lòng chọn ngày tháng';
          }
          if (value != null && value.isNotEmpty && !isValidDate(value)) {
            return 'Ngày tháng không hợp lệ. Vui lòng kiểm tra lại';
          }
          return null;
        },
      ),
    );
  }
}