part of 'AppPage.dart';

abstract class Routes {
  static const dashboard = _Paths.dashboard;
  static const home = _Paths.home;
  static const splash = _Paths.splash;
  static const login = _Paths.login;
  static const introduce = _Paths.introduce;
  static const individual = _Paths.individual;
  static const register = _Paths.register;
  static const registerMember = _Paths.registerMember;
  static const forgotPassword = _Paths.forgotPassword;
  static const blogDetail = _Paths.blogDetail;
  static const upsertActivity = _Paths.upsertActivity;
  static const detailActivity = _Paths.detailActivity;
  static const detailAchievement = _Paths.detailAchievement;
  static const upsertAchievement = _Paths.upsertAchievement;
  static const changePass = _Paths.changePass;
  static const blogList = _Paths.blogList;
  static const videoList = _Paths.videoList;
  static const history = _Paths.history;
  static const detailHistory = _Paths.detailHistory;
  static const cv = _Paths.cv;
  static const upsertCV = _Paths.upsertCV;
  static const information = _Paths.information;
  static const editProfile = _Paths.editProfile;
  static const statistical = _Paths.statistical;
  static const qrCode = _Paths.qrCode;
  static const myQR = _Paths.myQR;
  static const infoPage = _Paths.infoPage;
  static const cardissuance = _Paths.cardissuance;
  static const social = _Paths.social;
  static const notification = _Paths.notification;
  Routes._();
}

abstract class _Paths {
  _Paths._();
  static const dashboard = '/';
  static const home = '/home';
  static const splash = '/splash';
  static const login = '/login';
  static const introduce = '/introduce';
  static const individual = '/individual';
  static const register = '/register';
  static const registerMember = '/registerMember';
  static const forgotPassword = '/forgotPassword';
  static const blogDetail = '/blog-detail';
  static const upsertActivity = '/upsert-activity';
  static const detailActivity = '/detail-activity';
  static const detailAchievement = '/detail-achievement';
  static const upsertAchievement = '/upsert-achievement';
  static const changePass = '/change-pass';
  static const blogList = '/blog-list';
  static const videoList = '/video-list';
  static const history = '/history';
  static const detailHistory = '/detail-history';
  static const cv = '/cv-management';
  static const upsertCV = '/upsert-cv';
  static const information = '/information';
  static const editProfile = '/editProfile';
  static const statistical = '/statistical';
  static const qrCode = '/qr-code';
  static const myQR = '/my-qr';
  static const infoPage = '/infor-page';
  static const cardissuance = '/cardissuance';
  static const social = '/social';
  static const notification = '/notification';
}
