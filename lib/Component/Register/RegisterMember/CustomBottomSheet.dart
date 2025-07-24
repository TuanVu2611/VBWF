import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controller/Register/RegisterMember/RegisterMemberController.dart';
import '../../../Controller/Profile/EditProfile/EditProfileController.dart';
import '../../../Global/ColorHex.dart';
import '../../../Model/District.dart';
import '../../../Model/Town.dart';
import '../../../Utils/Utils.dart';

class CustomBottomSheet extends StatefulWidget {
  final String hintText;
  final String type;
  final TextEditingController controller;
  final Function(int, String)? onSelected;
  final Color backgroundColor;

  const CustomBottomSheet({
    super.key,
    required this.hintText,
    required this.type,
    required this.controller,
    this.onSelected,
    this.backgroundColor = Colors.white,
  });

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _isEmpty = widget.controller.text.isEmpty;
    widget.controller.addListener(() {
      setState(() {
        _isEmpty = widget.controller.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCustomBottomSheet(
          context: context,
          type: widget.type,
          controller: widget.controller,
          onSelected: widget.onSelected,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: const Color.fromRGBO(228, 230, 236, 1),
          ),
        ),
        child: TextField(
          controller: widget.controller,
          enabled: false,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: ColorHex.text5,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.arrow_drop_down,
                color: ColorHex.text9,
                size: 24,
              ),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorHex.primary, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 1, color: Colors.red),
            ),
          ),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

void showCustomBottomSheet({
  required BuildContext context,
  required String type,
  required TextEditingController controller,
  Function(int, String)? onSelected,
}) {
  dynamic profileController;
  try {
    profileController = Get.find<RegisterMemberController>();
  } catch (_) {
    try {
      profileController = Get.find<EditProfileController>();
    } catch (e) {
      Utils.showSnackBar(
        title: 'Lỗi',
        message: 'Không tìm thấy controller. Vui lòng thử lại!',
      );
      return;
    }
  }

  Widget content;
  switch (type) {
    case 'education':
      content = Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (profileController.educationLevels.isEmpty) {
          return const Center(child: Text('Không có dữ liệu học vấn'));
        }
        return ListView(
          children:
              profileController.educationLevels.map<Widget>((education) {
                bool isSelected = controller.text == education.label;
                return ListTile(
                  title: Text(
                    education.label,
                    style: const TextStyle(
                      fontSize: 14, // tăng size chữ từ 13 lên 14
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing:
                      isSelected
                          ? const Icon(
                            Icons.check,
                            color: ColorHex.primary,
                            size: 20,
                          )
                          : null,
                  onTap: () {
                    controller.text = education.label;
                    profileController.selectedEducationValue.value =
                        education.value;
                    if (onSelected != null) {
                      onSelected(education.value, education.label);
                    }
                    Get.back();
                  },
                );
              }).toList(),
        );
      });
      break;

    case 'province':
    case 'issuePlace':
      content = Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (profileController.provinces.isEmpty) {
          return const Center(child: Text('Không có dữ liệu tỉnh/thành phố'));
        }
        return ListView(
          children:
              profileController.provinces.map<Widget>((province) {
                bool isSelected = controller.text == (province.name ?? '');
                return ListTile(
                  title: Text(
                    province.name ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing:
                      isSelected
                          ? const Icon(
                            Icons.check,
                            color: ColorHex.primary,
                            size: 20,
                          )
                          : null,
                  onTap: () {
                    controller.text = province.name ?? '';
                    if (type == 'province') {
                      if (profileController.selectedProvince.value.matp !=
                          province.matp) {
                        profileController.selectedProvince.value = province;
                        profileController.districts.clear();
                        profileController.towns.clear();
                        profileController.selectedDistrict.value = District();
                        profileController.selectedTown.value = Town();
                        profileController.districtController.clear();
                        profileController.townController.clear();
                        if (province.matp != null &&
                            province.matp!.isNotEmpty) {
                          profileController.fetchDistricts(
                            matp: province.matp!,
                          );
                        }
                      }
                    } else if (type == 'issuePlace') {
                      profileController.selectedIssuePlaceProvince.value =
                          province;
                    }
                    Get.back();
                  },
                );
              }).toList(),
        );
      });
      break;

    case 'district':
      if (profileController.selectedProvince.value.matp == null) {
        content = const Center(
          child: Text('Vui lòng chọn tỉnh/thành phố trước'),
        );
      } else {
        content = Obx(() {
          if (profileController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (profileController.districts.isEmpty) {
            return const Center(child: Text('Không có dữ liệu quận/huyện'));
          }
          return ListView(
            children:
                profileController.districts.map<Widget>((district) {
                  bool isSelected = controller.text == (district.name ?? '');
                  return ListTile(
                    title: Text(
                      district.name ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing:
                        isSelected
                            ? const Icon(
                              Icons.check,
                              color: ColorHex.primary,
                              size: 20,
                            )
                            : null,
                    onTap: () {
                      if (profileController.selectedDistrict.value.maqh !=
                          district.maqh) {
                        controller.text = district.name ?? '';
                        profileController.selectedDistrict.value = district;
                        profileController.towns.clear();
                        profileController.selectedTown.value = Town();
                        profileController.townController.clear();
                        if (district.maqh != null &&
                            district.maqh!.isNotEmpty) {
                          profileController.fetchTowns(maqh: district.maqh!);
                        }
                      }
                      Get.back();
                    },
                  );
                }).toList(),
          );
        });
      }
      break;

    case 'town':
      if (profileController.selectedDistrict.value.maqh == null) {
        content = const Center(child: Text('Vui lòng chọn quận/huyện trước'));
      } else {
        content = Obx(() {
          if (profileController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (profileController.towns.isEmpty) {
            return const Center(child: Text('Không có dữ liệu xã/phường'));
          }
          return ListView(
            children:
                profileController.towns.map<Widget>((town) {
                  bool isSelected = controller.text == (town.name ?? '');
                  return ListTile(
                    title: Text(
                      town.name ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing:
                        isSelected
                            ? const Icon(
                              Icons.check,
                              color: ColorHex.primary,
                              size: 20,
                            )
                            : null,
                    onTap: () {
                      controller.text = town.name ?? '';
                      profileController.selectedTown.value = town;
                      Get.back();
                    },
                  );
                }).toList(),
          );
        });
      }
      break;

    default:
      content = const Center(child: Text('Không có dữ liệu'));
  }

  Get.bottomSheet(
    DropdownInput(child: content),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.transparent,
  );
}

class DropdownInput extends StatelessWidget {
  final Widget child;

  const DropdownInput({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: child,
        ),
      ),
    );
  }
}
