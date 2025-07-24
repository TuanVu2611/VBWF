import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future saveStringWithKey(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, value);
  }

  static Future saveIntWithKey(String key, int value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt(key, value);
  }

  static Future getStringValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key) ?? '';
  }

  static Future getIntValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(key) ?? 0;
  }

  static Future getBoolValueWithKey(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(key) ?? false;
  }

  static Future saveBoolWithKey(String key, bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(key, value);
  }

  static String formatVndCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      name: 'VND',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static void showSnackBar({
    required String title,
    required String message,
    Color? colorText = Colors.white,
    Widget? icon,
    bool isDismissible = true,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(seconds: 1),
    Color? backgroundColor = Colors.black,
    SnackPosition? direction = SnackPosition.TOP,
    Curve? animation,
  }) {
    Get.snackbar(
      title,
      message,
      colorText: colorText,
      duration: duration,
      animationDuration: animationDuration,
      icon: icon,
      backgroundColor: backgroundColor!.withOpacity(0.3),
      snackPosition: direction,
      forwardAnimationCurve: animation,
    );
  }

  static String formatDate(String? isoString, {bool isSorted = true}) {
    if (isoString == null || isoString.trim().isEmpty) {
      return "Không xác định";
    }

    try {
      DateTime dateTime = DateTime.parse(isoString);
      return isSorted
          ? DateFormat('dd/MM/yyyy').format(dateTime)
          : DateFormat('dd/MM/yyyy • HH:mm').format(dateTime);
    } catch (e) {
      return "Không xác định";
    }
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  static getImagePicker(int source) async {
    ImagePicker picker = ImagePicker();
    File? file;
    try {
      await picker
          .pickImage(
            source: source == 1 ? ImageSource.camera : ImageSource.gallery,
          )
          .then((value) {
            if (value != null) {
              file = File(value.path);
            }
          });
    } catch (e) {
      if (kDebugMode) {
        print('Error file: $e');
      }
    }
    return file;
  }

  static Future<File?> getFilePicker() async {
    File? file;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // hoặc FileType.image, FileType.custom, ...
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        file = File(result.files.single.path!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error picking file: $e');
      }
    }
    return file;
  }

  static void openURL(String url) {
    final Uri uri = Uri.parse(url);
    launchUrl(uri);
  }
}
