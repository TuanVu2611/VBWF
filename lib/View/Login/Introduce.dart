import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Component/IntroduceComponent.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Route/AppPage.dart';

class IntroduceScreen extends StatefulWidget {
  const IntroduceScreen({super.key});

  @override
  State<IntroduceScreen> createState() => _IntroduceScreenState();
}

class _IntroduceScreenState extends State<IntroduceScreen> {
  final PageController _pageController = PageController();
  final IntroduceData introduceData = IntroduceData();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView nội dung giới thiệu
          PageView.builder(
            controller: _pageController,
            itemCount: introduceData.items.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final item = introduceData.items[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    item.imageFull,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.7),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Image.asset(
                            item.imageChild,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            item.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0.07,
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Nút Skip cố định
          if (_currentPage != introduceData.items.length - 1)
            Positioned(
              top: 20,
              right: 20,
              child: SafeArea(
                child: TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.dashboard);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Skip',
                        style: TextStyle(
                          color: ColorHex.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: ColorHex.primary,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Dot indicator và nút tiếp tục
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      introduceData.items.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 10,
                        width: _currentPage == index ? 20 : 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        if (_currentPage < introduceData.items.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Get.offAllNamed(Routes.dashboard);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                        _currentPage == introduceData.items.length - 1
                            ? ColorHex.primary
                            : Colors.white.withOpacity(0.2),
                        side: BorderSide(
                          color:
                          _currentPage == introduceData.items.length - 1
                              ? ColorHex.primary
                              : Colors.white.withOpacity(0.4),
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _currentPage == introduceData.items.length - 1
                            ? 'Bắt đầu ngay'
                            : 'Tiếp tục',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
