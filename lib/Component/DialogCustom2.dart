import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:thehinhvn/Global/ColorHex.dart';

class DialogCustom2 extends StatelessWidget {
  DialogCustom2(
      {super.key,
      required this.title,
      required this.description,
      required this.svg});

  String title;
  String description;
  String svg;

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
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SvgPicture.asset(
              svg,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                decoration: BoxDecoration(
                    border: Border.all(width: .8, color: Color.fromRGBO(205, 213, 223, 1)),
                    borderRadius: BorderRadius.circular(31)),
                child: const Text(
                  'Đóng',
                  style: TextStyle(
                      color: ColorHex.text1,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
