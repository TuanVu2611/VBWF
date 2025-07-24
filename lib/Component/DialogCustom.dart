import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thehinhvn/Global/ColorHex.dart';

class DialogCustom extends StatelessWidget {
  DialogCustom(
      {super.key,
      required this.title,
      required this.description,
      required this.svg,
      this.svgColor,
      this.btnColor,
      this.input,
      required this.onTap});

  String title;
  String description;
  String svg;
  Color? svgColor;
  Color? btnColor;
  Widget? input;
  GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              svg,
              colorFilter: svgColor == null
                  ? null
                  : ColorFilter.mode(
                      svgColor!,
                      BlendMode.srcIn,
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            if (input != null) input!,
            const SizedBox(height: 7),
            Text(
              description,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6)),
                    child: const Text(
                      'Hủy bỏ',
                      style: TextStyle(
                          color: ColorHex.text1,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                    decoration: BoxDecoration(
                        color: btnColor ?? ColorHex.primary,
                        borderRadius: BorderRadius.circular(6)),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
