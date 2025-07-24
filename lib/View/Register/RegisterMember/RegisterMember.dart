import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:thehinhvn/Component/Register/RegisterMember/CustomBottomSheet.dart';
import 'package:thehinhvn/Component/Register/RegisterMember/HeightWeightInput.dart';
import '../../../Component/Register/RegisterMember/DobCustom.dart';
import '../../../Component/Register/RegisterMember/InputCustom.dart';
import '../../../Controller/Register/RegisterMember/RegisterMemberController.dart';
import '../../../Global/ColorHex.dart';
import '../../../Model/Province.dart';
import '../../../Service/Auth.dart';
import '../../../Utils/Utils.dart';
import 'package:dotted_border/dotted_border.dart';

class RegisterMember extends StatelessWidget {
  const RegisterMember({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterMemberController controller = Get.put(
      RegisterMemberController(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        shadowColor: ColorHex.text1,
        foregroundColor: ColorHex.text1,
        scrolledUnderElevation: 0,
        title: const Text(
          'Hồ sơ cá nhân',
          style: TextStyle(
            fontSize: 20,
            color: ColorHex.text1,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Auth.backLogin(true);
          },
          icon: const Icon(Icons.arrow_back, color: ColorHex.text5),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    _ImgProfile(),
                    SizedBox(height: 20),
                    _profileInfo(),
                    SizedBox(height: 20),
                    _AgreeTermsCheckbox(),
                    SizedBox(height: 80),
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
                      offset: const Offset(0, -4), // shadow hướng lên trên
                      blurRadius: 6,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Obx(
                  () =>
                      controller.hasSubmitted.value
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Nút Hủy
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Auth.backLogin(
                                      true,
                                    ); // Quay về màn đăng nhập
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ColorHex.primary,
                                        width:
                                            1, // Xác định rõ độ rộng của viền
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Hủy bỏ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                          color: ColorHex.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Nút Gửi lại
                              Expanded(
                                child: GestureDetector(
                                  onTap:
                                      controller.registerStatus.value == 1
                                          ? null // Vô hiệu hóa nếu đang chờ (registerStatus == 1)
                                          : controller.isChecked.value
                                          ? () {
                                            controller.submit();
                                          }
                                          : null,
                                  child: Opacity(
                                    opacity:
                                        controller.registerStatus.value == 1
                                            ? 0.5
                                            : controller.isChecked.value
                                            ? 1.0
                                            : 0.5,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorHex.primary,
                                        borderRadius: BorderRadius.circular(12),
                                        // Thêm border trong suốt để đảm bảo kích thước giống nút Hủy bỏ
                                        border: Border.all(
                                          color: Colors.transparent,
                                          width: 1,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Gửi lại yêu cầu',
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
                            ],
                          )
                          : GestureDetector(
                            onTap:
                                controller.isChecked.value
                                    ? () {
                                      controller.submit();
                                    }
                                    : null,
                            child: Opacity(
                              opacity: controller.isChecked.value ? 1.0 : 0.5,
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
  const _ImgProfile();

  @override
  Widget build(BuildContext context) {
    final RegisterMemberController controller = Get.find();

    return Center(
      child: GestureDetector(
        onTap: () async {
          File? pickedFile = await Utils.getImagePicker(0);
          if (pickedFile != null) {
            controller.profileImage.value = pickedFile;
          }
        },
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
              } else if (controller.profileImageUrl.value.isNotEmpty) {
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
            Container(
              width: 36,
              height: 36,
              // decoration: const BoxDecoration(
              //   shape: BoxShape.circle,
              //   color: Colors.black54,
              // ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _profileInfo extends StatelessWidget {
  const _profileInfo();

  @override
  Widget build(BuildContext context) {
    final RegisterMemberController controller = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () =>
              controller.statusTest.value == 0
                  ? Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.close, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Tài khoản không được phê duyệt',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rất tiếc, tài khoản của bạn đã bị từ chối phê duyệt.\nLý do: ${controller.rejectedReason.value}\nNếu bạn cho rằng đây là sai sót, hãy chỉnh sửa lại hồ sơ cá nhân hoặc liên hệ với chúng tôi để được hỗ trợ.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  )
                  : controller.statusTest.value == 1
                  ? Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.lock, color: Colors.orange, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Tài khoản đang chờ phê duyệt',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Cảm ơn bạn đã đăng ký!\nKhi được phê duyệt bạn sẽ được thông báo qua email ngay khi quá trình phê duyệt hoàn tất.\nNếu bạn cần hỗ trợ, vui lòng liên hệ chúng tôi qua [email/hotline].',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  )
                  : Text(""),
        ),
        const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorHex.text8,
          ),
        ),
        const SizedBox(height: 16),
        InputCustom(
          hintText: 'Họ và tên',
          fieldKey: 'name',
          controller: controller.nameController,
        ),
        const SizedBox(height: 12),
        // InputCustom(
        //   hintText: 'Ngày sinh',
        //   fieldKey: 'dob',
        //   controller: controller.dobController,
        //   keyboardType: TextInputType.datetime,
        // ),
        DobInput(
          label: "Ngày sinh",
          isRequired: true,
          controller: controller.dobController,
          context: context,
        ),
        const SizedBox(height: 12),
        const _checkGender(),
        const SizedBox(height: 12),
        HeightWeightInput(
          hintText: 'Chiều cao',
          suffixText: 'CM',
          fieldKey: 'height',
          controller: controller.heightController,
        ),
        const SizedBox(height: 12),
        HeightWeightInput(
          hintText: 'Cân nặng',
          suffixText: 'KG',
          fieldKey: 'weight',
          controller: controller.weightController,
        ),
        const SizedBox(height: 12),
        CustomBottomSheet(
          hintText: 'Trình độ học vấn',
          type: 'education',
          controller: controller.educationController,
          onSelected: (value, label) {
            controller.selectedEducationValue.value = value;
            controller.educationController.text = label;
          },
        ),
        const SizedBox(height: 12),
        InputCustom(
          hintText: 'Số điện thoại',
          fieldKey: 'phone',
          controller: controller.phoneController,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        InputCustom(
          hintText: 'Email',
          fieldKey: 'email',
          controller: controller.emailController,
          enabled: false,
          backgroundColor: ColorHex.background,
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
        CustomBottomSheet(
          hintText: 'Tỉnh/ TP',
          type: 'province',
          controller: controller.provinceController,
        ),
        const SizedBox(height: 12),
        CustomBottomSheet(
          hintText: 'Quận/ Huyện',
          type: 'district',
          controller: controller.districtController,
        ),
        const SizedBox(height: 12),
        CustomBottomSheet(
          hintText: 'Thị trấn/ Xã',
          type: 'town',
          controller: controller.townController,
        ),
        const SizedBox(height: 12),
        InputCustom(
          hintText: 'Địa chỉ chi tiết',
          fieldKey: 'addressDetail',
          controller: controller.addressDetailController,
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
        InputCustom(
          hintText: 'Số CMND/CCCD',
          fieldKey: 'idNumber',
          controller: controller.idNumberController,
        ),
        const SizedBox(height: 12),
        // InputCustom(
        //   hintText: 'Ngày cấp',
        //   fieldKey: 'issueDate',
        //   controller: controller.issueDateController,
        //   keyboardType: TextInputType.datetime,
        // ),
        DobInput(
          label: "Ngày cấp",
          isRequired: true,
          controller: controller.issueDateController,
          context: context,
        ),
        const SizedBox(height: 12),
        CustomBottomSheet(
          hintText: 'Nơi cấp',
          type: 'issuePlace',
          controller: controller.issuePlaceController,
          onSelected: (value, label) {
            controller.selectedIssuePlaceProvince.value = Province(name: label);
          },
        ),
        const SizedBox(height: 12),
        const IdCardUpload(),
      ],
    );
  }
}

class _checkGender extends StatefulWidget {
  const _checkGender();

  @override
  State<_checkGender> createState() => _checkGenderState();
}

class _checkGenderState extends State<_checkGender> {
  final RegisterMemberController controller = Get.find();

  @override
  Widget build(BuildContext context) {
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
                    value: 0, // Nam
                    groupValue: controller.selectedGender.value,
                    activeColor: ColorHex.primary,
                    onChanged: (value) {
                      controller.selectedGender.value = value!;
                    },
                  ),
                  const Text('Nam'),
                ],
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Radio<int>(
                    value: 1, // Nữ
                    groupValue: controller.selectedGender.value,
                    activeColor: ColorHex.primary,
                    onChanged: (value) {
                      controller.selectedGender.value = value!;
                    },
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

class IdCardUpload extends StatelessWidget {
  const IdCardUpload({super.key});

  Widget _buildImagePicker(
    String label,
    Rx<File?> image,
    RxString imageUrl,
    String type,
    RegisterMemberController controller,
  ) {
    return GestureDetector(
      onTap: () async {
        File? pickedFile = await Utils.getImagePicker(0);
        if (pickedFile != null) {
          if (type == 'front') {
            controller.frontIdCardImage.value = pickedFile;
          } else {
            controller.backIdCardImage.value = pickedFile;
          }
        }
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        dashPattern: const [6, 3],
        color: ColorHex.dot,
        strokeWidth: 1.5,
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Obx(() {
                if (image.value != null) {
                  return Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        image.value!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const SizedBox(),
                      ),
                    ),
                  );
                } else if (imageUrl.value.isNotEmpty) {
                  return Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageUrl.value,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const SizedBox(),
                      ),
                    ),
                  );
                }

                return const SizedBox();
              }),
              Obx(
                () =>
                    (image.value == null && imageUrl.value.isEmpty)
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 24,
                              color: ColorHex.text8.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 16,
                                color: ColorHex.text8.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        )
                        : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final RegisterMemberController controller = Get.find();

    return Column(
      children: [
        _buildImagePicker(
          'Ảnh mặt trước CMND/CCCD',
          controller.frontIdCardImage,
          controller.frontIdCardImageUrl,
          'front',
          controller,
        ),
        const SizedBox(height: 11),
        _buildImagePicker(
          'Ảnh mặt sau CMND/CCCD',
          controller.backIdCardImage,
          controller.backIdCardImageUrl,
          'back',
          controller,
        ),
      ],
    );
  }
}

class _AgreeTermsCheckbox extends StatelessWidget {
  const _AgreeTermsCheckbox();

  @override
  Widget build(BuildContext context) {
    final RegisterMemberController controller = Get.find();

    return Row(
      children: [
        Obx(
          () => Checkbox(
            side: WidgetStateBorderSide.resolveWith((states) {
              return const BorderSide(color: ColorHex.primary, width: 1);
            }),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            value: controller.isChecked.value,
            activeColor: ColorHex.primary,
            onChanged: (value) {
              controller.toggleCheckbox(value);
            },
          ),
        ),
        const Text('Đồng ý ', style: TextStyle(color: ColorHex.text11)),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Title & Close Button - Phần này sẽ cố định
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Image.asset(
                              'assets/images/exit_icon.png',
                              width: 14,
                              height: 14,
                            ),
                          ),
                        ],
                      ),

                      // Phần nội dung có thể cuộn
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () =>
                                    controller.isLoading.value
                                        ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                        : controller.policyContent.value.isEmpty
                                        ? const Text(
                                          'Không có nội dung chính sách.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: ColorHex.text13,
                                          ),
                                        )
                                        : Html(
                                          data: controller.policyContent.value,
                                          style: {
                                            // Tùy chỉnh style cho HTML nếu cần
                                            "body": Style(
                                              fontSize: FontSize(14),
                                              color: ColorHex.text13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            "h1": Style(
                                              fontSize: FontSize(16),
                                              fontWeight: FontWeight.w700,
                                              color: ColorHex.text8,
                                            ),
                                            "li": Style(
                                              margin: Margins(
                                                bottom: Margin(6, Unit.px),
                                              ),
                                            ),
                                          },
                                        ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Text(
            'chính sách & điều khoản',
            style: TextStyle(color: ColorHex.text10),
          ),
        ),
      ],
    );
  }
}

class ShowSuccessDialog extends StatelessWidget {
  const ShowSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/icons/check 1.svg', width: 48, height: 48),
          const SizedBox(height: 16),
          const Text(
            'Đăng ký thành công',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ColorHex.text14,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Cảm ơn bạn đã đăng ký tài khoản. \nTài khoản của bạn hiện đang chờ phê duyệt từ quản trị viên. Chúng tôi sẽ gửi email thông báo ngay khi tài khoản được kích hoạt.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: ColorHex.text14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD0D5DD)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Đóng',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorHex.text14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
