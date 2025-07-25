// import 'package:get/get.dart';
// import '../../../Service/APICaller.dart';
// import '../../../Utils/Utils.dart';
//
// class CardIssuanceController extends GetxController {
//   // var cardState = (-1).obs;
//   var cardState = Rxn<int>();
//   var cardRejected = ''.obs;
//   var showRequestButton = true.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     checkCardStatus();
//   }
//
//   Future<void> cardIssuance() async {
//     try {
//       var response = await APICaller.getInstance().post(
//         'v1/User/create-card-request-app',
//         null,
//       );
//
//       if (response != null && response['error']?['code'] == 0) {
//         // Utils.showSnackBar(
//         //   title: 'Thành công',
//         //   message: 'Yêu cầu phát hành thẻ của bạn đã được gửi thành công!',
//         // );
//         showRequestButton.value = false;
//         await checkCardStatus();
//       } else {
//         String errorMessage =
//             response['error']?['message'] ?? 'Không thể lấy dữ liệu!';
//         Utils.showSnackBar(title: 'Lỗi', message: errorMessage);
//       }
//     } catch (e) {
//       Utils.showSnackBar(title: 'Lỗi', message: 'Đã xảy ra lỗi: $e');
//     }
//   }
//
//   Future<void> checkCardStatus() async {
//     try {
//       var response = await APICaller.getInstance().post(
//         'v1/User/get-detail-card-request-app',
//         null,
//       );
//
//       if (response != null && response['error']?['code'] == 0) {
//         cardState.value = response['data']?['cardState'] ?? null;
//         cardRejected.value = response['data']?['cardRejected'] ?? '';
//         // showRequestButton.value =
//         //     cardState.value == -1 ||
//         //     cardState.value == null ||
//         //     cardState.value == 0;
//       } else {
//         String errorMessage =
//             response['error']?['message'] ?? 'Không thể lấy dữ liệu!';
//         Utils.showSnackBar(title: 'Lỗi', message: errorMessage);
//       }
//     } catch (e) {
//       Utils.showSnackBar(title: 'Lỗi', message: 'Đã xảy ra lỗi: $e');
//     }
//   }
//
//   String getStatusText() {
//     if (cardState.value == null) {
//       return 'Chưa đăng ký';
//     }
//     switch (cardState.value) {
//       case 0:
//         // return cardRejected.isNotEmpty
//         //     ? 'Từ chối: ${cardRejected.value}'
//         //     : 'Từ chối';
//         return 'Từ chối';
//       case 1:
//         return 'Chờ duyệt';
//       case 2:
//         return 'Đã duyệt';
//       case 3:
//         return 'Đã đóng tiền';
//       case 4:
//         return 'Chờ phát hành thẻ';
//       case 5:
//         return 'Đã phát hành thẻ';
//       default:
//         return 'Chưa đăng ký';
//     }
//   }
// }

import 'dart:ui';

import 'package:get/get.dart';
import '../../../Service/APICaller.dart';
import '../../../Utils/Utils.dart';
import '../../../Global/ColorHex.dart';

class CardIssuanceController extends GetxController {
  var cardState = Rxn<int>();
  var cardRejected = ''.obs;
  var showRequestButton = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkCardStatus();
  }

  Future<bool> cardIssuance() async {
    try {
      var response = await APICaller.getInstance().post(
        'v1/User/create-card-request-app',
        null,
      );
      if (response != null && response['error']?['code'] == 0) {
        showRequestButton.value = false;
        await checkCardStatus();
        return true;
      }
      return false;
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã xảy ra lỗi: $e');
      return false;
    }
  }

  Future<void> checkCardStatus() async {
    try {
      var response = await APICaller.getInstance().post(
        'v1/User/get-detail-card-request-app',
        null,
      );
      if (response != null && response['error']?['code'] == 0) {
        cardState.value = response['data']?['cardState'] ?? null;
        cardRejected.value = response['data']?['cardRejected'] ?? '';
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã xảy ra lỗi: $e');
    }
  }

  String getStatusText() {
    if (cardState.value == null) {
      return 'Chưa đăng ký';
    }
    switch (cardState.value) {
      case 0:
        return 'Từ chối';
      case 1:
        return 'Chờ duyệt';
      case 2:
        return 'Đã duyệt';
      case 3:
        return 'Đã đóng tiền';
      case 4:
        return 'Chờ phát hành thẻ';
      case 5:
        return 'Đã phát hành thẻ';
      default:
        return 'Chưa đăng ký';
    }
  }

  Color getStatusColor() {
    switch (cardState.value) {
      case 1: // Chờ duyệt
        return ColorHex.cardNoti2;
      case 2: // Đã duyệt
        return ColorHex.cardNoti3;
      case 3: // Đã đóng tiền
        return ColorHex.cardNoti4;
      case 4: // Chờ phát hành thẻ
        return ColorHex.cardNoti5;
      case 5: // Đã phát hành thẻ
        return ColorHex.cardNoti6;
      case 0: // Từ chối
      default: // Chưa đăng ký
        return ColorHex.cardNoti1;
    }
  }
}
