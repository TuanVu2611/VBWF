import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Global/ColorHex.dart';

class NoLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String newText = newValue.text;

    // Loại bỏ các số 0 ở đầu, nhưng giữ lại số 0 nếu là số thập phân (ví dụ: 0.5)
    if (newText.startsWith('0') && newText.length > 1 && !newText.startsWith('0.')) {
      newText = newText.replaceFirst(RegExp(r'^0+'), '');
      if (newText.isEmpty) newText = '0'; // Đảm bảo không để trống
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class HeightWeightInput extends StatelessWidget {
  final String hintText;
  final String suffixText;
  final String fieldKey; // Thêm thuộc tính để xác định trường
  final TextEditingController controller; // Controller để lưu dữ liệu
  final Color backgroundColor;

  const HeightWeightInput({
    super.key,
    required this.hintText,
    required this.suffixText,
    required this.fieldKey,
    required this.controller,
    this.backgroundColor = Colors.white,
  });

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
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: ColorHex.text5,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 1,
                  height: 20,
                  color: const Color.fromRGBO(228, 230, 236, 1),
                  margin: const EdgeInsets.only(right: 8),
                ),
                Text(
                  suffixText.toUpperCase(),
                  style: const TextStyle(
                    color: ColorHex.text9,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: ColorHex.primary,
              width: 1,
            ),
          ),
        ),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')), // Chỉ cho phép số và dấu chấm
          NoLeadingZeroFormatter(), // Xóa số 0 ở đầu
        ],
      ),
    );
  }
}
