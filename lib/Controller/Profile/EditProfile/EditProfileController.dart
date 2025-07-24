import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Model/District.dart';
import 'package:thehinhvn/Model/EducationLevel.dart';
import 'package:thehinhvn/Model/Province.dart';
import 'package:thehinhvn/Model/Town.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';

class EditProfileController extends GetxController {
  var isLoading = false.obs;
  var isEditing = false.obs;

  var provinces = <Province>[].obs;
  var districts = <District>[].obs;
  var towns = <Town>[].obs;
  var educationLevels = <EducationLevel>[].obs;

  var selectedProvince = Province().obs;
  var selectedDistrict = District().obs;
  var selectedTown = Town().obs;
  var selectedEducationValue = 0.obs;
  var selectedGender = (-1).obs;
  var selectedIssuePlaceProvince = Province().obs;

  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressDetailController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final educationController = TextEditingController();
  final provinceController = TextEditingController();
  final districtController = TextEditingController();
  final townController = TextEditingController();
  final idNumberController = TextEditingController();
  final issueDateController = TextEditingController();
  final issuePlaceController = TextEditingController();

  var profileImage = Rxn<File>();
  RxString profileImageUrl = ''.obs;

  var frontIdCardImage = Rxn<File>();
  var backIdCardImage = Rxn<File>();
  RxString frontIdCardImageUrl = ''.obs;
  RxString backIdCardImageUrl = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    fetchProvinces();
    fetchEducationLevels();
    await fetchUserProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressDetailController.dispose();
    heightController.dispose();
    weightController.dispose();
    educationController.dispose();
    provinceController.dispose();
    districtController.dispose();
    townController.dispose();
    idNumberController.dispose();
    issueDateController.dispose();
    issuePlaceController.dispose();
    super.onClose();
  }

  String? formatDateForApi(String date) {
    try {
      final parsedDate = DateFormat('dd/MM/yyyy').parseStrict(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return null;
    }
  }

  String? formatDateForDisplay(String date) {
    try {
      final parsedDate = DateFormat('yyyy-MM-dd').parseStrict(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return null;
    }
  }

  bool isValidPhoneNumber(String phone) {
    final RegExp phoneRegex = RegExp(r'^0[0-9]{9}$');
    return phoneRegex.hasMatch(phone);
  }


  Future<void> fetchProvinces({String keyword = ''}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      var param = {'keyword': keyword};
      var response = await APICaller.getInstance().post(
        'v1/Province/get-list-province',
        param,
      );

      if (response != null && response['error']?['code'] == 0) {
        provinces.value =
            (response['data'] as List)
                .map((item) => Province.fromJson(item))
                .toList();
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDistricts({
    required String matp,
    String keyword = '',
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      var param = {'keyword': keyword, 'idParent': matp};
      var response = await APICaller.getInstance().post(
        'v1/Province/get-list-district',
        param,
      );

      if (response != null && response['error']?['code'] == 0) {
        districts.value =
            (response['data'] as List)
                .map((item) => District.fromJson(item))
                .toList();
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTowns({required String maqh, String keyword = ''}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      var param = {'keyword': keyword, 'idParent': maqh};
      var response = await APICaller.getInstance().post(
        'v1/Province/get-list-town',
        param,
      );

      if (response != null && response['error']?['code'] == 0) {
        towns.value =
            (response['data'] as List)
                .map((item) => Town.fromJson(item))
                .toList();
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEducationLevels() async {
    educationLevels.value = [
      EducationLevel(value: 1, label: 'THPT'),
      EducationLevel(value: 2, label: 'Trung cấp'),
      EducationLevel(value: 3, label: 'Cao đẳng'),
      EducationLevel(value: 4, label: 'Đại học'),
      EducationLevel(value: 5, label: 'Cao học'),
    ];
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      var response = await APICaller.getInstance().post(
        'v1/User/get-detail-register-app',
        null,
      );

      if (response != null && response['error']?['code'] == 0) {
        var data = response['data'];

        nameController.text = data['fullname'] ?? '';
        dobController.text =
            data['birthday'] != null
                ? formatDateForDisplay(data['birthday']) ?? ''
                : '';
        phoneController.text = data['phoneNumber'] ?? '';
        emailController.text = data['email'] ?? '';
        heightController.text = data['height']?.toString() ?? '';
        weightController.text = data['weight']?.toString() ?? '';
        educationController.text =
            data['education'] != null
                ? educationLevels
                    .firstWhere(
                      (e) => e.value == data['education'],
                      orElse: () => EducationLevel(value: 0, label: ''),
                    )
                    .label
                : '';
        selectedGender.value =
            data['gender'] != null && data['gender'] is int
                ? data['gender']
                : -1;
        selectedEducationValue.value = data['education'] ?? 0;

        if (data['addressInfo'] != null) {
          addressDetailController.text = data['addressInfo']['address1'] ?? '';

          if (data['addressInfo']['tp'] != null) {
            String provinceName = data['addressInfo']['tp']['name'] ?? '';
            provinceController.text = provinceName;
            selectedProvince.value = Province(
              matp:
                  data['addressInfo']['tp']['uuid'] ??
                  data['addressInfo']['tp']['code'] ??
                  '',
              name: provinceName,
            );
            if (selectedProvince.value.matp.toString().isNotEmpty) {
              await fetchDistricts(
                matp: selectedProvince.value.matp.toString(),
              );
            }
          }

          if (data['addressInfo']['qh'] != null) {
            String districtName = data['addressInfo']['qh']['name'] ?? '';
            districtController.text = districtName;
            selectedDistrict.value = District(
              maqh:
                  data['addressInfo']['qh']['uuid'] ??
                  data['addressInfo']['qh']['code'] ??
                  '',
              name: districtName,
            );
            if (selectedDistrict.value.maqh.toString().isNotEmpty) {
              await fetchTowns(maqh: selectedDistrict.value.maqh.toString());
            }
          }

          if (data['addressInfo']['xa'] != null) {
            String townName = data['addressInfo']['xa']['name'] ?? '';
            townController.text = townName;
            selectedTown.value = Town(
              xaid:
                  data['addressInfo']['xa']['uuid'] ??
                  data['addressInfo']['xa']['code'] ??
                  '',
              name: townName,
            );
          }
        }

        idNumberController.text = data['identityCode'] ?? '';
        issueDateController.text =
            data['identityDate'] != null
                ? formatDateForDisplay(data['identityDate']) ?? ''
                : '';
        if (data['identityPlace'] != null) {
          String identityPlace = data['identityPlace'];
          if (provinces.isEmpty) {
            await fetchProvinces();
          }
          try {
            var province = provinces.firstWhere(
              (p) => p.matp != null && p.matp == identityPlace,
              orElse: () => Province(matp: '', name: ''),
            );
            selectedIssuePlaceProvince.value = province;
            issuePlaceController.text = province.name ?? '';
          } catch (e) {
            issuePlaceController.text = '';
          }
        }

        profileImageUrl.value =
            data['imageCardPath'] != null &&
                    data['imageCardPath'].toString().isNotEmpty
                ? "${Constant.BASE_URL_IMAGE}${data['imageCardPath']}"
                : '';

        frontIdCardImageUrl.value =
            data['frontIdentityPath'] != null &&
                    data['frontIdentityPath'].toString().isNotEmpty
                ? "${Constant.BASE_URL_IMAGE}${data['frontIdentityPath']}"
                : '';
        backIdCardImageUrl.value =
            data['backIdentityPath'] != null &&
                    data['backIdentityPath'].toString().isNotEmpty
                ? "${Constant.BASE_URL_IMAGE}${data['backIdentityPath']}"
                : '';
      } else {
        // Utils.showSnackBar(
        //   title: 'Lỗi',
        //   message:
        //       response?['error']?['message'] ?? 'Lấy dữ liệu hồ sơ thất bại!',
        // );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void cancelEditing() {
    isEditing.value = false;
    profileImage.value = null;
    fetchUserProfile();
  }

  Future<String?> uploadImage(File image, int type) async {
    try {
      var response = await APICaller.getInstance().putFile(
        endpoint: 'v1/Upload/upload-single-image',
        filePath: image,
        type: type,
      );
      if (response != null && response['data'] != null) {
        return response['data'];
      }
      return null;
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Upload ảnh thất bại: $e');
      return null;
    }
  }

  Future<void> submit() async {
    if (!isValidPhoneNumber(phoneController.text)) {
      isLoading.value = false;
      Utils.showSnackBar(
        title: 'Lỗi',
        message: 'Số điện thoại phải bắt đầu bằng 0 và có đúng 10 chữ số!',
      );
      return;
    }
    isLoading.value = true;
    try {
      String? imagePath;
      if (profileImage.value != null) {
        imagePath = await uploadImage(profileImage.value!, 3);
        if (imagePath == null) {
          isLoading.value = false;
          Utils.showSnackBar(
            title: 'Lỗi',
            message: 'Upload ảnh đại diện thất bại',
          );
          return;
        }
      } else if (profileImageUrl.value.isNotEmpty) {
        imagePath = profileImageUrl.value.replaceFirst(
          Constant.BASE_URL_IMAGE,
          '',
        );
      }

      String? frontIdPath;
      if (frontIdCardImage.value != null) {
        frontIdPath = await uploadImage(frontIdCardImage.value!, 1);
      } else if (frontIdCardImageUrl.value.isNotEmpty) {
        frontIdPath = frontIdCardImageUrl.value.replaceFirst(
          Constant.BASE_URL_IMAGE,
          '',
        );
      }

      String? backIdPath;
      if (backIdCardImage.value != null) {
        backIdPath = await uploadImage(backIdCardImage.value!, 2);
      } else if (backIdCardImageUrl.value.isNotEmpty) {
        backIdPath = backIdCardImageUrl.value.replaceFirst(
          Constant.BASE_URL_IMAGE,
          '',
        );
      }

      String? formattedBirthday = formatDateForApi(dobController.text);
      String? formattedIssueDate = formatDateForApi(issueDateController.text);

      if (formattedBirthday == null || formattedIssueDate == null) {
        isLoading.value = false;
        Utils.showSnackBar(
          title: 'Lỗi',
          message:
              'Ngày sinh hoặc ngày cấp không hợp lệ. Vui lòng kiểm tra lại!',
        );
        return;
      }

      var body = {
        'imagePath': imagePath ?? '',
        'fullname': nameController.text,
        'gender': selectedGender.value,
        'birthday': formattedBirthday,
        'height': double.tryParse(heightController.text) ?? 0,
        'weight': double.tryParse(weightController.text) ?? 0,
        'education': selectedEducationValue.value,
        'phoneNumber': phoneController.text,
        'identityCode': idNumberController.text,
        'identityDate': formattedIssueDate,
        'identityPlace': selectedIssuePlaceProvince.value.matp,
        'addressUser': {
          'matp': selectedProvince.value.matp,
          'maqh': selectedDistrict.value.maqh,
          'xaid': selectedTown.value.xaid,
          'address1': addressDetailController.text,
        },
        'imagePaths': [
          if (frontIdPath != null) frontIdPath,
          if (backIdPath != null) backIdPath,
        ],
      };

      var response = await APICaller.getInstance().post(
        'v1/User/update-personal-user-app',
        body,
      );

      if (response != null && response['error']?['code'] == 0) {
        isEditing.value = false;
        profileImage.value = null;
        await fetchUserProfile();
        Get.back();
        Utils.showSnackBar(
          title: 'Thành công',
          message: 'Cập nhật hồ sơ thành công!',
        );
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message:
              response?['error']?['message'] ??
              'Cập nhật hồ sơ thất bại, vui lòng thử lại!',
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
