import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:thehinhvn/Component/Register/RegisterMember/CustomBottomSheet.dart';
import 'package:thehinhvn/Component/Register/RegisterMember/HeightWeightInput.dart';
import 'package:thehinhvn/Component/Register/RegisterMember/InputCustom.dart';
import 'package:thehinhvn/Global/ColorHex.dart';
import 'package:thehinhvn/Global/Constant.dart';
import 'package:thehinhvn/Utils/Utils.dart';
import '../../../Component/Register/RegisterMember/DobCustom.dart';
import '../../../Controller/Profile/EditProfile/EditProfileController.dart';
import '../../../Model/District.dart';
import '../../../Model/Province.dart';
import '../../../Model/Town.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: const Text(
          'Chỉnh sửa hồ sơ',
          style: TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: ColorHex.text5),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const _ImgProfile(),
                    const SizedBox(height: 20),
                    _ProfileInfo(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, -4),
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Obx(
                  () =>
                      controller.isEditing.value
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.cancelEditing();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Hủy bỏ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.submit();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 16,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: ColorHex.primary,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Xác nhận',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : GestureDetector(
                            onTap: () {
                              controller.isEditing.value = true;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              decoration: const BoxDecoration(
                                color: ColorHex.primary,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Chỉnh sửa',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImgProfile extends StatelessWidget {
  const _ImgProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.find<EditProfileController>();

    return Center(
      child: Obx(() {
        return GestureDetector(
          onTap:
              controller.isEditing.value
                  ? () async {
                    try {
                      File? pickedFile = await Utils.getImagePicker(0);
                      if (pickedFile != null) {
                        controller.profileImage.value = pickedFile;
                      }
                    } catch (e) {
                      Utils.showSnackBar(
                        title: 'Lỗi',
                        message: 'Không thể chọn ảnh: $e',
                      );
                    }
                  }
                  : () {},
          child: Stack(
            alignment: Alignment.center,
            children: [
              Obx(() {
                if (controller.profileImage.value != null) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: FileImage(controller.profileImage.value!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else if (controller.profileImageUrl.value.isNotEmpty &&
                    controller.profileImageUrl.value !=
                        Constant.BASE_URL_IMAGE) {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.network(
                        controller.profileImageUrl.value,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Image(
                              image: AssetImage(
                                'assets/images/avatar_default.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                      ),
                    ),
                  );
                } else {
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/avatar_default.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              }),
              if (controller.isEditing.value)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorHex.text8,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => IgnorePointer(
            ignoring: !controller.isEditing.value,
            child: InputCustom(
              hintText: 'Họ và tên',
              fieldKey: 'name',
              controller: controller.nameController,
              backgroundColor:
                  controller.isEditing.value
                      ? Colors.white
                      : ColorHex.background,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => IgnorePointer(
            ignoring: !controller.isEditing.value,
            child: DobInput(
              label: "Ngày sinh",
              isRequired: true,
              controller: controller.dobController,
              context: context,
              backgroundColor:
                  controller.isEditing.value
                      ? Colors.white
                      : ColorHex.background,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _CheckGender(),
        const SizedBox(height: 12),
        Obx(
          () => IgnorePointer(
            ignoring: !controller.isEditing.value,
            child: HeightWeightInput(
              hintText: 'Chiều cao',
              suffixText: 'CM',
              fieldKey: 'height',
              controller: controller.heightController,
              backgroundColor:
                  controller.isEditing.value
                      ? Colors.white
                      : ColorHex.background,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => IgnorePointer(
            ignoring: !controller.isEditing.value,
            child: HeightWeightInput(
              hintText: 'Cân nặng',
              suffixText: 'KG',
              fieldKey: 'weight',
              controller: controller.weightController,
              backgroundColor:
                  controller.isEditing.value
                      ? Colors.white
                      : ColorHex.background,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => IgnorePointer(
            ignoring: !controller.isEditing.value,
            child: CustomBottomSheet(
              hintText: 'Trình độ học vấn',
              type: 'education',
              controller: controller.educationController,
              backgroundColor:
                  controller.isEditing.value
                      ? Colors.white
                      : ColorHex.background,
              onSelected: (value, label) {
                controller.selectedEducationValue.value = value;
                controller.educationController.text = label;
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => IgnorePointer(
            ignoring: !controller.isEditing.value,
            child: InputCustom(
              hintText: 'Số điện thoại',
              fieldKey: 'phone',
              controller: controller.phoneController,
              keyboardType: TextInputType.number,
              backgroundColor:
                  controller.isEditing.value
                      ? Colors.white
                      : ColorHex.background,
            ),
          ),
        ),
        const SizedBox(height: 12),
        IgnorePointer(
          ignoring: true,
          child: InputCustom(
            hintText: 'Email',
            fieldKey: 'email',
            controller: controller.emailController,
            backgroundColor:
                controller.isEditing.value ? Colors.white : ColorHex.background,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Địa chỉ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorHex.text8,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => IgnorePointer(
            ignoring: !controller.isEditing.value,
            child: CustomBottomSheet(
              hintText: 'Tỉnh/ TP',
              type: 'province',
              controller: controller.provinceController,
              backgroundColor:
                  controller.isEditing.value
                      ? Colors.white
                      : ColorHex.background,
              onSelected: (value, label) {
                controller.selectedProvince.value = controller.provinces
                    .firstWhere(
                      (p) => p.matp == value,
                      orElse: () => Province(),
                    );
                controller.provinceController.text = label;
                controller.selectedDistrict.value = District();
                controller.districtController.clear();
                controller.selectedTown.value = Town();
                controller.townController.clear();
                controller.districts.clear();
                controller.towns.clear();
                if (value.toString().isNotEmpty) {
                  controller.fetchDistricts(matp: value.toString());
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => IgnorePointer(
            ignoring:
                !controller.isEditing.value ||
                controller.selectedProvince.value.matp.toString().isEmpty ||
                controller.districts.isEmpty,
            child: CustomBottomSheet(
              hintText: 'Quận/ Huyện',
              type: 'district',
              controller: controller.districtController,
              backgroundColor:
                  controller.isEditing.value
                      ? Colors.white
                      : ColorHex.background,
              onSelected: (value, label) {
                controller.selectedDistrict.value = controller.districts
                    .firstWhere(
                      (d) => d.maqh == value,
                      orElse: () => District(),
                    );
                controller.districtController.text = label;
                controller.selectedTown.value = Town();
                controller.townController.clear();
                controller.towns.clear();
                if (value.toString().isNotEmpty) {
                  controller.fetchTowns(maqh: value.toString());
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => IgnorePointer(
            ignoring:
                !controller.isEditing.value ||
                controller.selectedDistrict.value.maqh.toString().isEmpty ||
                controller.towns.isEmpty,
            child: CustomBottomSheet(
              hintText: 'Thị trấn/ Xã',
              type: 'town',
              controller: controller.townController,
              backgroundColor:
                  controller.isEditing.value
                      ? Colors.white
                      : ColorHex.background,
              onSelected: (value, label) {
                controller.selectedTown.value = controller.towns.firstWhere(
                  (t) => t.xaid == value,
                  orElse: () => Town(),
                );
                controller.townController.text = label;
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => IgnorePointer(
            ignoring: !controller.isEditing.value,
            child: InputCustom(
              hintText: 'Địa chỉ chi tiết',
              fieldKey: 'addressDetail',
              controller: controller.addressDetailController,
              backgroundColor:
                  controller.isEditing.value
                      ? Colors.white
                      : ColorHex.background,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Thông tin CMND/CCCD',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorHex.text8,
          ),
        ),
        const SizedBox(height: 16),
        IgnorePointer(
          ignoring: true,
          child: InputCustom(
            hintText: 'Số CMND/CCCD',
            fieldKey: 'idNumber',
            controller: controller.idNumberController,
            backgroundColor:
                controller.isEditing.value ? Colors.white : ColorHex.background,
          ),
        ),
        const SizedBox(height: 12),
        IgnorePointer(
          ignoring: true,
          child: DobInput(
            label: "Ngày cấp",
            isRequired: true,
            controller: controller.issueDateController,
            context: context,
            backgroundColor:
                controller.isEditing.value ? Colors.white : ColorHex.background,
          ),
        ),
        const SizedBox(height: 12),
        IgnorePointer(
          ignoring: true,
          child: InputCustom(
            hintText: 'Nơi cấp',
            fieldKey: 'issuePlace',
            controller: controller.issuePlaceController,
            backgroundColor:
                controller.isEditing.value ? Colors.white : ColorHex.background,
          ),
        ),
        const SizedBox(height: 12),
        _IdCardDisplay(),
      ],
    );
  }
}

class _CheckGender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.find();

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Chọn giới tính',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: ColorHex.text8,
            ),
          ),
          Row(
            children: [
              Row(
                children: [
                  Radio<int>(
                    value: 0,
                    groupValue: controller.selectedGender.value,
                    activeColor: ColorHex.primary,
                    onChanged:
                        controller.isEditing.value
                            ? (value) {
                              controller.selectedGender.value = value!;
                            }
                            : null,
                  ),
                  const Text('Nam'),
                ],
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Radio<int>(
                    value: 1,
                    groupValue: controller.selectedGender.value,
                    activeColor: ColorHex.primary,
                    onChanged:
                        controller.isEditing.value
                            ? (value) {
                              controller.selectedGender.value = value!;
                            }
                            : null,
                  ),
                  const Text('Nữ'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IdCardDisplay extends StatelessWidget {
  Widget _buildImageDisplay(
    String label,
    Rx<File?> image,
    RxString imageUrl,
    int imageType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ColorHex.text8,
          ),
        ),
        const SizedBox(height: 8),
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          dashPattern: const [6, 3],
          strokeWidth: 1.5,
          color: ColorHex.text8.withOpacity(0.7),
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(() {
              if (image.value != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    image.value!,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => const SizedBox(),
                  ),
                );
              } else if (imageUrl.value.isNotEmpty) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl.value,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => const SizedBox(),
                  ),
                );
              }
              return Center(
                child: Text(
                  'Không có ảnh',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorHex.text8.withOpacity(0.7),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final EditProfileController controller = Get.find();

    return Column(
      children: [
        _buildImageDisplay(
          'Ảnh mặt trước CMND/CCCD',
          controller.frontIdCardImage,
          controller.frontIdCardImageUrl,
          1,
        ),
        const SizedBox(height: 12),
        _buildImageDisplay(
          'Ảnh mặt sau CMND/CCCD',
          controller.backIdCardImage,
          controller.backIdCardImageUrl,
          2,
        ),
      ],
    );
  }
}
