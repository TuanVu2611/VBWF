import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Global/ColorHex.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String iconPath;
  final bool obscureText;
  final Function(String)? onChanged;
  final VoidCallback? onTapSuffix;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconPath,
    this.obscureText = false,
    this.onChanged,
    this.onTapSuffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: const Color.fromRGBO(228, 230, 236, 1),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,

        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: ColorHex.text7,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: SvgPicture.asset(
              iconPath,
              height: 20,
              width: 20,
              fit: BoxFit.cover,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: ColorHex.primary,
              width: 1,
            ),
          ),
          suffixIcon: onTapSuffix != null
              ? InkWell(
                  onTap: onTapSuffix,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: SvgPicture.asset(
                      obscureText
                          ? 'assets/icons/eye_slash.svg'
                          : 'assets/icons/eye.svg',
                      height: 20,
                      width: 20,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : null,
        ),
        style: const TextStyle(
          color: ColorHex.text1,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
