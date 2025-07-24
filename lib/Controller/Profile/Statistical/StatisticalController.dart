import 'package:get/get.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class StatisticalController extends GetxController {
  RxInt countViewProfile = 0.obs;
  RxInt countSaveContacts = 0.obs;
  RxInt countScanNFC = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatisticalData();
  }

  Future<void> fetchStatisticalData() async {
    try {
      var response = await APICaller.getInstance().post(
        'v1/Dashboard/dashboard-user-app',
        null,
      );

      if (response != null && response['error']?['code'] == 0) {
        countViewProfile.value = response['data']?['countViewProfile'] ?? 0;
        countSaveContacts.value = response['data']?['countSaveContacts'] ?? 0;
        countScanNFC.value = response['data']?['countScanNFC'] ?? 0;
      } else {
        String errorMessage =
            response['error']?['message'] ?? 'Failed to fetch data!';
        Utils.showSnackBar(title: 'Error', message: errorMessage);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Error', message: 'An error occurred: $e');
    }
  }
}
