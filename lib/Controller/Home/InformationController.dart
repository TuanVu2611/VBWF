import 'package:get/get.dart';
import 'package:thehinhvn/Model/Home/ProfileInformation.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class InformationController extends GetxController {
  RxBool isLoading = true.obs;
  ProfileInformation profileInformation = ProfileInformation();

  @override
  void onInit() async {
    await getProfileInformation();
    isLoading.value = false;
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getProfileInformation() async {
    try {
      var data = await APICaller.getInstance().post('v1/Profile/get-home-profile-detail-app', null);
      if (data != null) {
        profileInformation = ProfileInformation.fromJson(data['data']);
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Thông báo', message: '$e');
    }
  }

}