import 'dart:ui';

class IntroduceInfo {
  final String imageFull;
  final String imageChild;
  final String title;
  final VoidCallback onPressed;

  IntroduceInfo({
    required this.imageFull,
    required this.imageChild,
    required this.title,
    required this.onPressed,
  });
}

class IntroduceData {
  List<IntroduceInfo> items = [
    IntroduceInfo(
      imageFull: 'assets/images/onboarding1.png',
      imageChild: 'assets/images/onboarding1_child.png',
      title: 'Chào mừng bạn đến với VBWF – nền tảng kết nối '
          'đam mê thể hình và sức mạnh! Dù bạn là người mới hay '
          'một vận động viên dày dạn kinh nghiệm, ứng '
          'dụng của chúng tôi giúp bạn dễ dàng khám phá, kết '
          'nối và tham gia các câu lạc bộ cử tạ, thể hình uy tín '
          'nhất gần bạn.',
      onPressed: () {},
    ),
    IntroduceInfo(
      imageFull: 'assets/images/onboarding2.png',
      imageChild: 'assets/images/onboarding2_child.png',
      title: 'Với VBWF, bạn có thể tìm kiếm các câu lạc bộ cử tạ, '
          'thể hình chất lượng, tham gia các buổi tập luyện '
          'chuyên sâu và cập nhật lịch trình sự kiện thể thao. '
          'Hãy kết nối với những người cùng chí hướng, học '
          'hỏi từ các huấn luyện viên hàng đầu và nâng cao '
          'trình độ của bạn mỗi ngày.',
      onPressed: () {},
    ),
    IntroduceInfo(
      imageFull: 'assets/images/onboarding3.png',
      imageChild: 'assets/images/onboarding3_child.png',
      title: 'Hành trình sức mạnh bắt đầu ngay tại đây! Hãy trải '
          'nghiệm và giao lưu cùng cộng đồng đam mê đông '
          'đảo, cùng nhau tham gia các thử thách hấp dẫn và '
          'nâng tầm thể chất của bạn cùng VBWF. Nhấn "Bắt '
          'đầu ngay" để bước vào cộng đồng cử tạ và thể hình '
          'đầy sôi động!',
      onPressed: () {},
    ),
  ];
}
