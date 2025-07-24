import 'package:flutter/material.dart';
import '../../../Global/ColorHex.dart';

class InputCustom extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final String fieldKey;
  final TextEditingController controller;
  final bool enabled;
  final Color backgroundColor;

  const InputCustom({
    super.key,
    required this.hintText,
    required this.fieldKey,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.white,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(228, 230, 236, 1),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hintText,
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
        ),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: ColorHex.text5,
        ),
      ),
    );
  }
}
