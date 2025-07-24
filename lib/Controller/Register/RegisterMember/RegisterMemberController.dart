import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Model/District.dart';
import 'package:thehinhvn/Model/EducationLevel.dart';
import 'package:thehinhvn/Model/Province.dart';
import 'package:thehinhvn/Model/Town.dart';
import 'package:thehinhvn/Service/APICaller.dart';
import 'package:thehinhvn/Utils/Utils.dart';
import 'package:thehinhvn/View/Register/RegisterMember/RegisterMember.dart';

class RegisterMemberController extends GetxController {
  var isChecked = false.obs;
  var isLoading = false.obs;

  var provinces = <Province>[].obs;
  var issuePlaceProvinces = <Province>[].obs; // Danh sách riêng cho nơi cấp
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
  final idNumberController = TextEditingController();
  final issueDateController = TextEditingController();
  final issuePlaceController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  final educationController = TextEditingController();
  final provinceController = TextEditingController();
  final districtController = TextEditingController();
  final townController = TextEditingController();

  var profileImage = Rxn<File>();
  var frontIdCardImage = Rxn<File>();
  var backIdCardImage = Rxn<File>();

  var hasSubmitted = false.obs;
  var registerStatus = 0.obs;
  var rejectedReason = ''.obs;

  RxString profileImageUrl = ''.obs;
  RxString frontIdCardImageUrl = ''.obs;
  RxString backIdCardImageUrl = ''.obs;

  var policyContent = ''.obs;

  Rx<int?> statusTest = (-1).obs;

  @override
  void onInit() async {
    super.onInit();
    // Tải danh sách tỉnh cho địa chỉ và nơi cấp
    await fetchProvinces();
    await fetchIssuePlaceProvinces();
    fetchEducationLevels();
    fetchPolicyContent();

    final arguments = Get.arguments;
    statusTest.value = arguments?['registerStatus'] ?? -1;

    // Lấy email từ arguments hoặc SharedPreferences
    String? email;
    if (arguments != null &&
        arguments['email'] != null &&
        arguments['email'].isNotEmpty) {
      email = arguments['email'];
      emailController.text = email!;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
    } else {
      final prefs = await SharedPreferences.getInstance();
      email = prefs.getString('user_email');
      if (email != null && email.isNotEmpty) {
        emailController.text = email;
      }
    }

    // Nếu có email hoặc arguments, lấy thông tin hồ sơ
    if (email != null || arguments != null) {
      await fetchUserProfile();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    dobController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressDetailController.dispose();
    idNumberController.dispose();
    issueDateController.dispose();
    issuePlaceController.dispose();
    heightController.dispose();
    weightController.dispose();
    educationController.dispose();
    provinceController.dispose();
    districtController.dispose();
    townController.dispose();
    super.onClose();
  }

  // Hàm định dạng ngày
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

  // Gọi API
  Future<void> fetchPolicyContent() async {
    try {
      isLoading.value = true;
      var response = await APICaller.getInstance().post(
        'v1/Policy/get-detail-policy',
        null,
      );

      if (response != null && response['error']?['code'] == 0) {
        policyContent.value = response['data']['content'] ?? '';
      } else {
        // Utils.showSnackBar(
        //   title: 'Lỗi',
        //   message:
        //       response?['error']?['message'] ??
        //       'Lấy nội dung chính sách thất bại!',
        // );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
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
      } else {
        // Utils.showSnackBar(
        //   title: 'Lỗi',
        //   message:
        //       response?['error']?['message'] ??
        //       'Lấy danh sách tỉnh/thành phố thất bại!',
        // );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchIssuePlaceProvinces({String keyword = ''}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      var param = {'keyword': keyword};
      var response = await APICaller.getInstance().post(
        'v1/Province/get-list-province',
        param,
      );

      if (response != null && response['error']?['code'] == 0) {
        issuePlaceProvinces.value =
            (response['data'] as List)
                .map((item) => Province.fromJson(item))
                .toList();
      } else {
        // Utils.showSnackBar(
        //   title: 'Lỗi',
        //   message:
        //       response?['error']?['message'] ??
        //       'Lấy danh sách tỉnh/thành phố cho nơi cấp thất bại!',
        // );
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
      } else {
        // Utils.showSnackBar(
        //   title: 'Lỗi',
        //   message:
        //       response?['error']?['message'] ??
        //       'Lấy danh sách quận/huyện thất bại!',
        // );
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
      } else {
        // Utils.showSnackBar(
        //   title: 'Lỗi',
        //   message:
        //       response?['error']?['message'] ??
        //       'Lấy danh sách xã/phường thất bại!',
        // );
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

  // Future<void> fetchUserProfile() async {
  //   try {
  //     isLoading.value = true;
  //     var response = await APICaller.getInstance().post(
  //       'v1/User/get-detail-register-app',
  //       null,
  //     );
  //
  //     if (response != null && response['error']?['code'] == 0) {
  //       var data = response['data'];
  //
  //       // Cập nhật email
  //       if (data['email'] != null && data['email'].isNotEmpty) {
  //         emailController.text = data['email'];
  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString('user_email', data['email']);
  //       }
  //
  //       // Cập nhật các trường khác
  //       nameController.text = data['fullname'] ?? '';
  //       dobController.text =
  //           data['birthday'] != null
  //               ? formatDateForDisplay(data['birthday']) ?? ''
  //               : '';
  //       phoneController.text = data['phoneNumber'] ?? '';
  //       heightController.text = data['height']?.toString() ?? '';
  //       weightController.text = data['weight']?.toString() ?? '';
  //       educationController.text =
  //           data['education'] != null
  //               ? educationLevels
  //                   .firstWhere(
  //                     (e) => e.value == data['education'],
  //                     orElse: () => EducationLevel(value: 0, label: ''),
  //                   )
  //                   .label
  //               : '';
  //       selectedGender.value =
  //           data['gender'] != null && data['gender'] is int
  //               ? data['gender']
  //               : -1;
  //       selectedEducationValue.value = data['REPLACE_WITH_ACTUAL_VALUE'] ?? 0;
  //       rejectedReason.value = data['rejectedReason'] ?? '';
  //
  //       // Cập nhật thông tin địa chỉ
  //       if (data['addressInfo'] != null) {
  //         addressDetailController.text = data['addressInfo']['address1'] ?? '';
  //         if (data['addressInfo']['tp'] != null) {
  //           String provinceName = data['addressInfo']['tp']['name'] ?? '';
  //           provinceController.text = provinceName;
  //           selectedProvince.value = Province(
  //             matp:
  //                 data['addressInfo']['tp']['uuid'] ??
  //                 data['addressInfo']['tp']['code'] ??
  //                 '',
  //             name: provinceName,
  //           );
  //           if (selectedProvince.value.matp.toString().isNotEmpty) {
  //             await fetchDistricts(
  //               matp: selectedProvince.value.matp.toString(),
  //             );
  //           }
  //         }
  //         if (data['addressInfo']['qh'] != null) {
  //           String districtName = data['addressInfo']['qh']['name'] ?? '';
  //           districtController.text = districtName;
  //           selectedDistrict.value = District(
  //             maqh:
  //                 data['addressInfo']['qh']['uuid'] ??
  //                 data['addressInfo']['qh']['code'] ??
  //                 '',
  //             name: districtName,
  //           );
  //           if (selectedDistrict.value.maqh.toString().isNotEmpty) {
  //             await fetchTowns(maqh: selectedDistrict.value.maqh.toString());
  //           }
  //         }
  //         if (data['addressInfo']['xa'] != null) {
  //           String townName = data['addressInfo']['xa']['name'] ?? '';
  //           townController.text = townName;
  //           selectedTown.value = Town(
  //             xaid:
  //                 data['addressInfo']['xa']['uuid'] ??
  //                 data['addressInfo']['xa']['code'] ??
  //                 '',
  //             name: townName,
  //           );
  //         }
  //       }
  //
  //       // Cập nhật thông tin CMND/CCCD
  //       idNumberController.text = data['identityCode'] ?? '';
  //       issueDateController.text =
  //           data['identityDate'] != null
  //               ? formatDateForDisplay(data['identityDate']) ?? ''
  //               : '';
  //
  //       // Cập nhật nơi cấp (identityPlace)
  //       if (data['identityPlace'] != null && data['identityPlace'].isNotEmpty) {
  //         String identityPlace = data['identityPlace'];
  //         if (issuePlaceProvinces.isEmpty) {
  //           await fetchIssuePlaceProvinces();
  //         }
  //         var province = issuePlaceProvinces.firstWhere(
  //           (p) => p.matp == identityPlace,
  //           orElse: () => Province(name: identityPlace),
  //         );
  //         selectedIssuePlaceProvince.value = province;
  //         issuePlaceController.text = province.name ?? identityPlace;
  //       }
  //
  //       // Cập nhật hình ảnh
  //       profileImageUrl.value =
  //           data['imageCardPath'] != null
  //               ? "${Constant.BASE_URL_IMAGE}${data['imageCardPath']}"
  //               : '';
  //       frontIdCardImageUrl.value =
  //           data['frontIdentityPath'] != null
  //               ? "${Constant.BASE_URL_IMAGE}${data['frontIdentityPath']}"
  //               : '';
  //       backIdCardImageUrl.value =
  //           data['backIdentityPath'] != null
  //               ? "${Constant.BASE_URL_IMAGE}${data['backIdentityPath']}"
  //               : '';
  //
  //       // Kiểm tra nếu hồ sơ đã được gửi
  //       if (data['fullname'] != null && data['fullname'].isNotEmpty) {
  //         hasSubmitted.value = true;
  //       }
  //     }
  //   } catch (e) {
  //     // Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      var response = await APICaller.getInstance().post(
        'v1/User/get-detail-register-app',
        null,
      );

      if (response != null && response['error']?['code'] == 0) {
        var data = response['data'];

        // Cập nhật email
        if (data['email'] != null && data['email'].isNotEmpty) {
          emailController.text = data['email'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_email', data['email']);
        }

        // Cập nhật các trường khác
        nameController.text = data['fullname'] ?? '';
        dobController.text =
            data['birthday'] != null
                ? formatDateForDisplay(data['birthday']) ?? ''
                : '';
        phoneController.text = data['phoneNumber'] ?? '';
        heightController.text = data['height']?.toString() ?? '';
        weightController.text = data['weight']?.toString() ?? '';

        // Cập nhật trình độ học vấn
        if (data['education'] != null && data['education'] is int) {
          selectedEducationValue.value = data['education'];
          var education = educationLevels.firstWhere(
            (e) => e.value == data['education'],
            orElse: () => EducationLevel(value: 0, label: ''),
          );
          educationController.text = education.label;
        } else {
          selectedEducationValue.value = 0;
          educationController.text = '';
        }

        selectedGender.value =
            data['gender'] != null && data['gender'] is int
                ? data['gender']
                : -1;
        rejectedReason.value = data['rejectedReason'] ?? '';

        // Cập nhật thông tin địa chỉ
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

        // Cập nhật thông tin CMND/CCCD
        idNumberController.text = data['identityCode'] ?? '';
        issueDateController.text =
            data['identityDate'] != null
                ? formatDateForDisplay(data['identityDate']) ?? ''
                : '';

        // Cập nhật nơi cấp (identityPlace)
        if (data['identityPlace'] != null && data['identityPlace'].isNotEmpty) {
          String identityPlace = data['identityPlace'];
          if (issuePlaceProvinces.isEmpty) {
            await fetchIssuePlaceProvinces();
          }
          var province = issuePlaceProvinces.firstWhere(
            (p) => p.matp == identityPlace,
            orElse: () => Province(name: identityPlace),
          );
          selectedIssuePlaceProvince.value = province;
          issuePlaceController.text = province.name ?? identityPlace;
        }

        // Cập nhật hình ảnh
        profileImageUrl.value =
            data['imageCardPath'] != null
                ? "${Constant.BASE_URL_IMAGE}${data['imageCardPath']}"
                : '';
        frontIdCardImageUrl.value =
            data['frontIdentityPath'] != null
                ? "${Constant.BASE_URL_IMAGE}${data['frontIdentityPath']}"
                : '';
        backIdCardImageUrl.value =
            data['backIdentityPath'] != null
                ? "${Constant.BASE_URL_IMAGE}${data['backIdentityPath']}"
                : '';

        // Kiểm tra nếu hồ sơ đã được gửi
        if (data['fullname'] != null && data['fullname'].isNotEmpty) {
          hasSubmitted.value = true;
        }
      }
    } catch (e) {
      // Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false;
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

  // Kiểm tra các trường bắt buộc
  String? validateInputs() {
    if (nameController.text.trim().isEmpty) {
      return 'Vui lòng nhập họ và tên';
    }
    if (dobController.text.trim().isEmpty) {
      return 'Vui lòng nhập ngày sinh';
    }
    if (selectedGender.value == -1) {
      return 'Vui lòng chọn giới tính';
    }
    // if (heightController.text.trim().isEmpty) {
    //   return 'Vui lòng nhập chiều cao';
    // }
    // if (weightController.text.trim().isEmpty) {
    //   return 'Vui lòng nhập cân nặng';
    // }
    // if (educationController.text.trim().isEmpty ||
    //     selectedEducationValue.value == 0) {
    //   return 'Vui lòng chọn trình độ học vấn';
    // }
    if (!RegExp(r'^0\d{9}$').hasMatch(phoneController.text.trim())) {
      return 'Số điện thoại phải có đúng 10 số và bắt đầu bằng 0';
    }
    // if (emailController.text.trim().isEmpty) {
    //   return 'Vui lòng nhập email';
    // }
    if (provinceController.text.trim().isEmpty ||
        selectedProvince.value.matp.toString().isEmpty) {
      return 'Vui lòng chọn tỉnh/thành phố';
    }
    if (districtController.text.trim().isEmpty ||
        selectedDistrict.value.maqh.toString().isEmpty) {
      return 'Vui lòng chọn quận/huyện';
    }
    if (townController.text.trim().isEmpty ||
        selectedTown.value.xaid.toString().isEmpty) {
      return 'Vui lòng chọn thị trấn/xã';
    }
    if (addressDetailController.text.trim().isEmpty) {
      return 'Vui lòng nhập địa chỉ chi tiết';
    }
    if (idNumberController.text.trim().isEmpty) {
      return 'Vui lòng nhập số CMND/CCCD';
    }
    if (issueDateController.text.trim().isEmpty) {
      return 'Vui lòng nhập ngày cấp CMND/CCCD';
    }
    if (profileImage.value == null && profileImageUrl.value.isEmpty) {
      return 'Vui lòng tải lên ảnh đại diện';
    }
    if (issuePlaceController.text.trim().isEmpty ||
        selectedIssuePlaceProvince.value.matp.toString().isEmpty) {
      return 'Vui lòng chọn nơi cấp CMND/CCCD';
    }
    if (frontIdCardImage.value == null && frontIdCardImageUrl.value.isEmpty) {
      return 'Vui lòng cung cấp ảnh mặt trước CMND/CCCD';
    }
    if (backIdCardImage.value == null && backIdCardImageUrl.value.isEmpty) {
      return 'Vui lòng cung cấp ảnh mặt sau CMND/CCCD';
    }
    return null; // Không có lỗi
  }

  Future<void> submit() async {
    // Kiểm tra các trường bắt buộc
    String? validationError = validateInputs();
    if (validationError != null) {
      Utils.showSnackBar(title: 'Lỗi', message: validationError);
      isLoading.value = false;
      return;
    }

    if (!isChecked.value) {
      Utils.showSnackBar(
        title: 'Lỗi',
        message: 'Vui lòng đồng ý với chính sách & điều khoản',
      );
      return;
    }

    isLoading.value = true;

    try {
      List<String> imagePaths = [];

      // Tải ảnh đại diện
      if (profileImage.value != null) {
        String? profilePath = await uploadImage(profileImage.value!, 3);
        if (profilePath != null) {
          imagePaths.add(profilePath);
        } else {
          isLoading.value = false;
          Utils.showSnackBar(
            title: 'Lỗi',
            message: 'Upload ảnh đại diện thất bại',
          );
          return;
        }
      } else if (profileImageUrl.value.isNotEmpty) {
        imagePaths.add(
          profileImageUrl.value.replaceFirst(Constant.BASE_URL_IMAGE, ''),
        );
      }

      // Tải ảnh mặt trước CMND/CCCD
      String? frontIdPath;
      if (frontIdCardImage.value != null) {
        frontIdPath = await uploadImage(frontIdCardImage.value!, 1);
      } else if (frontIdCardImageUrl.value.isNotEmpty) {
        frontIdPath = frontIdCardImageUrl.value.replaceFirst(
          Constant.BASE_URL_IMAGE,
          '',
        );
      }

      // Tải ảnh mặt sau CMND/CCCD
      String? backIdPath;
      if (backIdCardImage.value != null) {
        backIdPath = await uploadImage(backIdCardImage.value!, 2);
      } else if (backIdCardImageUrl.value.isNotEmpty) {
        backIdPath = backIdCardImageUrl.value.replaceFirst(
          Constant.BASE_URL_IMAGE,
          '',
        );
      }

      if (frontIdPath == null || backIdPath == null) {
        isLoading.value = false;
        Utils.showSnackBar(
          title: 'Lỗi',
          message: 'Vui lòng cung cấp cả ảnh mặt trước và mặt sau CMND/CCCD',
        );
        return;
      }

      imagePaths.addAll([frontIdPath, backIdPath]);

      final String id = await Utils.getStringValueWithKey(
        Constant.UUID_USER_ACC,
      );

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
        'accountUuid': id,
        'fullname': nameController.text,
        'identityCode': idNumberController.text,
        'identityPlace': selectedIssuePlaceProvince.value.matp,
        'identityDate': formattedIssueDate,
        'addressForRegister': {
          'matp': selectedProvince.value.matp,
          'maqh': selectedDistrict.value.maqh,
          'xaid': selectedTown.value.xaid,
          'address1': addressDetailController.text,
        },
        'gender': selectedGender.value,
        'birthday': formattedBirthday,
        'height': double.tryParse(heightController.text) ?? 0,
        'weight': double.tryParse(weightController.text) ?? 0,
        'education': selectedEducationValue.value,
        'phoneNumber': phoneController.text,
        'imagePaths': imagePaths,
      };

      var response = await APICaller.getInstance().post(
        'v1/User/register-user-app',
        body,
      );

      if (response != null && response['error']?['code'] == 0) {
        hasSubmitted.value = true;
        registerStatus.value = 1;
        statusTest.value = 1;
        showDialog(
          context: Get.context!,
          builder: (context) => const ShowSuccessDialog(),
        );
      } else {
        Utils.showSnackBar(
          title: 'Lỗi',
          message:
              response?['error'] != null
                  ? response!['error']['message'] ??
                      'Gửi lại yêu cầu thất bại, vui lòng thử lại!'
                  : 'Gửi lại yêu cầu thất bại, vui lòng thử lại!',
        );
      }
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Đã có lỗi xảy ra: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
