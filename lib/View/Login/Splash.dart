import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:thehinhvn/Controller/Login/SplashController.dart';

class Splash extends StatelessWidget {
  Splash({super.key});

  final controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [ColorHex.main, ColorHex.main],
          //   stops: [0, 1],
          // ),
          image: DecorationImage(
            image: AssetImage('assets/images/launch.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
            Lottie.asset('assets/json/loading.json')
          ],
        ),
      ),
    );
  }
}
