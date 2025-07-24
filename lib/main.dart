import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Controller/Home/HomeController.dart';
import 'package:thehinhvn/Controller/Register/RegisterMember/RegisterMemberController.dart';
import 'package:thehinhvn/Route/AppPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:thehinhvn/Service/Auth.dart';
import 'package:thehinhvn/firebase_options.dart';

Future<void> _backgroundMessaging(RemoteMessage message) async {}

final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Khởi tạo thông báo local
Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await _localNotificationsPlugin.initialize(initializationSettings);
}

/// Hiển thị thông báo local
Future<void> _showNotification({
  required String title,
  required String body,
}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'high_importance_channel', // ID kênh
        'Thông báo quan trọng', // Tên kênh
        channelDescription: 'Kênh dành cho các thông báo quan trọng',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await _localNotificationsPlugin.show(
    0, // ID thông báo
    title,
    body,
    platformChannelSpecifics,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_backgroundMessaging);
  await _initializeNotifications();

  FirebaseMessaging.onMessage.listen((event) {
    String title = event.notification?.title ?? "Thông báo";
    String body = event.notification?.body ?? "Không có nội dung";

    // Gọi hàm hiển thị thông báo local
    _showNotification(title: title, body: body);

    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().isHaveNewNoti.value = true;
    }

    if (Get.isRegistered<RegisterMemberController>()) {
      if (event.data['state'] == "2") {
        Auth.login();
      }
      Get.find<RegisterMemberController>().rejectedReason.value =
          event.data['rejectedReason'];
      Get.find<RegisterMemberController>().statusTest.value = int.tryParse(
        event.data['state'],
      );
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<void> initDeepLinks() async {
    // Handle links
    AppLinks().uriLinkStream.listen((uri) {
      String code = uri.queryParameters['id']!;
      Future.delayed(Duration(milliseconds: 1500)).whenComplete(() {
        Get.toNamed(Routes.individual, arguments: {"code": code});
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    initDeepLinks();
    return GetMaterialApp(
      // for app version
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          titleSpacing: 20,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.splash,
      getPages: AppPages.routes,
      supportedLocales: [const Locale('en', 'US'), const Locale('vi', 'VN')],
      locale: const Locale('vi', 'VN'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
    // return GetMaterialApp(
    //   //for web version
    //   theme: ThemeData(
    //     appBarTheme: const AppBarTheme(
    //       titleSpacing: 20,
    //       elevation: 0,
    //       backgroundColor: Colors.white,
    //     ),
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   initialRoute: AppPages.splash,
    //   getPages: AppPages.routes,
    //   supportedLocales: [const Locale('en', 'US'), const Locale('vi', 'VN')],
    //   locale: const Locale('vi', 'VN'),
    //   localizationsDelegates: const [
    //     GlobalMaterialLocalizations.delegate,
    //     GlobalWidgetsLocalizations.delegate,
    //     GlobalCupertinoLocalizations.delegate,
    //   ],

    //   /// ✅ Đây là phần bạn thêm vào:
    //   builder: (context, child) {
    //     return Center(
    //       child: ConstrainedBox(
    //         constraints: const BoxConstraints(
    //           maxWidth: 700, // để tránh bị kéo dài toàn trang
    //         ),
    //         child: child!,
    //       ),
    //     );
    //   },
    // );
  }
}
