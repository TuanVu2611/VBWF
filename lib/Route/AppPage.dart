import 'package:get/get.dart';
import 'package:thehinhvn/View/Blog/BlogDetail.dart';
import 'package:thehinhvn/View/Blog/BlogList.dart';
import 'package:thehinhvn/View/Dashboard.dart';
import 'package:thehinhvn/View/ForgotPassword/ForgotPassword.dart';
import 'package:thehinhvn/View/Home/Information.dart';
import 'package:thehinhvn/View/Login/Introduce.dart';
import 'package:thehinhvn/View/Login/Login.dart';
import 'package:thehinhvn/View/Login/Splash.dart';
import 'package:thehinhvn/View/Notification/Notification.dart';
import 'package:thehinhvn/View/Profile/CVManagement/CVManagement.dart';
import 'package:thehinhvn/View/Profile/CVManagement/UpsertCV.dart';
import 'package:thehinhvn/View/Profile/ChangePass/ChangePass.dart';
import 'package:thehinhvn/View/Profile/History/DetailHistory.dart';
import 'package:thehinhvn/View/Profile/History/History.dart';
import 'package:thehinhvn/View/Profile/Individual/DetailAchievement.dart';
import 'package:thehinhvn/View/Profile/Individual/DetailActivity.dart';
import 'package:thehinhvn/View/Profile/Individual/UpsertAchievement.dart';
import 'package:thehinhvn/View/Profile/Individual/UpsertActivity.dart';
import 'package:thehinhvn/View/Profile/Individual/individual.dart';
import 'package:thehinhvn/View/Profile/InfoPage/InfoPage.dart';
import 'package:thehinhvn/View/Profile/InfoPage/Social.dart';
import 'package:thehinhvn/View/QRCode/MyQR.dart';
import 'package:thehinhvn/View/QRCode/QRCode.dart';
import 'package:thehinhvn/View/Register/Register.dart';
import 'package:thehinhvn/View/Video/VideoList.dart';

import '../View/Profile/CardIssuance/CardIssuance.dart';
import '../View/Profile/EditProfile/EditProfile.dart';
import '../View/Profile/Statistical/Statistical.dart';
import '../View/Register/RegisterMember/RegisterMember.dart';

part 'AppRoute.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.dashboard;
  static const splash = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => Splash(),
    ),
    GetPage(
      name: Routes.introduce,
      page: () => const IntroduceScreen(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const Login(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => Dashboard(),
    ),
    GetPage(
      name: Routes.individual,
      page: () => Individual(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const Register(),
    ),
    GetPage(
      name: Routes.registerMember,
      page: () => const RegisterMember(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => const ForgotPassword(),
    ),
    GetPage(
      name: Routes.blogDetail,
      page: () => const BlogDetail(),
    ),
    GetPage(
      name: Routes.upsertActivity,
      page: () => UpsertActivity(),
    ),
    GetPage(
      name: Routes.detailActivity,
      page: () => DetailActivity(),
    ),
    GetPage(
      name: Routes.detailAchievement,
      page: () => DetailAchievement(),
    ),
    GetPage(
      name: Routes.upsertAchievement,
      page: () => UpsertAchievement(),
    ),
    GetPage(
      name: Routes.changePass,
      page: () => ChangePass(),
    ),
    GetPage(
      name: Routes.blogList,
      page: () => const BlogList(),
    ),
    GetPage(
      name: Routes.videoList,
      page: () => const VideoList(),
    ),
    GetPage(
      name: Routes.history,
      page: () => History(),
    ),
    GetPage(
      name: Routes.detailHistory,
      page: () => DetailHistory(),
    ),
    GetPage(
      name: Routes.cv,
      page: () => CVManagement(),
    ),
    GetPage(
      name: Routes.upsertCV,
      page: () => UpsertCV(),
    ),
    GetPage(
      name: Routes.information,
      page: () => Information(),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfile(),
    ),
    GetPage(
      name: Routes.statistical,
      page: () => const Statistical(),
    ),
    GetPage(
      name: Routes.qrCode,
      page: () => Qrcode(),
    ),
    GetPage(
      name: Routes.myQR,
      page: () => MyQR(),
    ),
    GetPage(
      name: Routes.infoPage,
      page: () => InfoPage(),
    ),
    GetPage(
      name: Routes.cardissuance,
      page: () => CardIssuance(),
    ),
    GetPage(
      name: Routes.social,
      page: () => Social(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => Notification(),
    ),
  ];
}
