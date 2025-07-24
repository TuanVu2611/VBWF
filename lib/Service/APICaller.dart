import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thehinhvn/Global/GlobalValue.dart';
import 'package:thehinhvn/Service/Auth.dart';
import 'package:thehinhvn/Utils/Utils.dart';

import '../Global/Constant.dart';

class APICaller {
  static APICaller _apiCaller = APICaller();
  //final String BASE_URL = "http://vbwf-api.mobiplus.vn/api/";
  final String BASE_URL = "https://api.vbwf.org.vn/api/";
  static APICaller getInstance() {
    if (_apiCaller == null) {
      _apiCaller = APICaller();
    }
    return _apiCaller;
  }

  Future<dynamic> get(String endpoint, {dynamic body}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    Uri uri = Uri.parse(BASE_URL + endpoint);
    final finalUri = uri.replace(queryParameters: body);

    final response = await http
        .get(finalUri, headers: requestHeaders)
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            return http.Response(
              'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.',
              408,
            );
          },
        );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: jsonDecode(response.body)['error']['message'],
      );
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> post(String endpoint, dynamic body) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);
    Map<String, dynamic> safeBody =
        body != null && body is Map<String, dynamic> ? body : {};
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    final request = {
      "keyCert": Utils.generateMd5(
        Constant.NEXT_PUBLIC_KEY_CERT + formattedTime,
      ),
      "time": formattedTime,
      // "keyCert": "string",
      // "time": "string",
      ...safeBody,
    };

    final response = await http
        .post(uri, headers: requestHeaders, body: jsonEncode(request))
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            return http.Response(
              'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.',
              408,
            );
          },
        );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    if (response.statusCode != 200) {
      if (response.statusCode == 400) {
        Utils.showSnackBar(
          title: 'Thông báo',
          message: jsonDecode(response.body)['error']['message'],
        );
      }
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: jsonDecode(response.body)['error']['message'],
      );
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> postFile({
    required String endpoint,
    required File filePath,
    required String type,
    required String keyCert,
    required String time,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      await http.MultipartFile.fromPath('ImageFiles', filePath.path),
    );
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);

    request.fields['Type'] = type;
    request.fields['keyCert'] = Utils.generateMd5(
      Constant.NEXT_PUBLIC_KEY_CERT + formattedTime,
    );
    request.fields['time'] = formattedTime;
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
          'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.',
          408,
        );
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    ;
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: jsonDecode(response.body)['error']['message'],
      );
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> postFiles(String endpoint, List<File> filePath) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('POST', uri);
    List<http.MultipartFile> files = [];
    for (File file in filePath) {
      var f = await http.MultipartFile.fromPath('files', file.path);
      files.add(f);
    }
    request.files.addAll(files);
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
          'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.',
          408,
        );
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    ;
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: jsonDecode(response.body)['error']['message'],
      );
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> put(String endpoint, dynamic body) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final response = await http
        .put(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            return http.Response(
              'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.',
              408,
            );
          },
        );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    ;
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: jsonDecode(response.body)['error']['message'],
      );
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<File?> downloadAndGetFile1(String endpoint) async {
    Map<String, String> requestHeaders = {
      'Accept': '*/*',
      'Authorization': GlobalValue.getInstance().getToken(),
    };

    Uri uri = Uri.parse(BASE_URL + endpoint);

    try {
      final response = await http
          .get(uri, headers: requestHeaders)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              return http.Response('Không kết nối được đến máy chủ.', 408);
            },
          );

      if (response.statusCode == 401) {
        Auth.backLogin(true);
        Utils.showSnackBar(
          title: 'Thông báo',
          message: 'Đã hết phiên đăng nhập',
        );
        return null;
      }

      // if (response.statusCode != 200) {
      //   Utils.showSnackBar(title: 'Lỗi', message: 'Tải file thất bại.');
      //   return null;
      // }

      // Lấy tên file từ header
      String? fileName;
      String? contentDisposition = response.headers['content-disposition'];
      if (contentDisposition != null &&
          contentDisposition.contains('filename=')) {
        final regex = RegExp(r'filename="?(.+?)"?$', caseSensitive: false);
        final match = regex.firstMatch(contentDisposition);
        if (match != null) {
          fileName = match.group(1);
        }
      } else {
        fileName = endpoint.split('/').last;
      }

      // Lưu file tạm thời
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return file;
    } catch (e) {
      Utils.showSnackBar(title: 'Lỗi', message: 'Có lỗi xảy ra khi tải file.');
      return null;
    }
  }

  Future<File?> downloadAndGetFile(String filePath) async {
    try {
      final fileUrl = "${Constant.BASE_URL_IMAGE}$filePath";
      final response = await http.get(Uri.parse(fileUrl));
      if (response.statusCode != 200) {
        return null;
      }
      if (response.bodyBytes.isEmpty) {
        return null;
      }
      final dir = await getTemporaryDirectory();
      final fileName = filePath.split('/').last;
      final file = File("${dir.path}/$fileName");

      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> putFile({
    required String endpoint,
    required File filePath,
    required int type,
  }) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'multipart/form-data',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final request = http.MultipartRequest('PUT', uri);
    request.files.add(
      await http.MultipartFile.fromPath('FileData', filePath.path),
    );
    DateTime timeNow = DateTime.now();
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);

    request.fields['Type'] = '$type';
    request.fields['KeyCert'] = Utils.generateMd5(
      Constant.NEXT_PUBLIC_KEY_CERT + formattedTime,
    );
    request.fields['Time'] = formattedTime;
    request.headers.addAll(requestHeaders);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        return http.Response(
          'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.',
          408,
        );
      },
    );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: jsonDecode(response.body)['error']['message'],
      );
      return null;
    }
    return jsonDecode(response.body);
  }

  Future<dynamic> delete(String endpoint, {dynamic body}) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': GlobalValue.getInstance().getToken(),
    };
    final uri = Uri.parse(BASE_URL + endpoint);

    final response = await http
        .delete(uri, headers: requestHeaders, body: jsonEncode(body))
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            return http.Response(
              'Không kết nối được đến máy chủ, bạn vui lòng kiểm tra lại.',
              408,
            );
          },
        );
    bool code401 = response.statusCode == 401;
    if (code401) {
      Auth.backLogin(code401);
      Utils.showSnackBar(title: 'Thông báo', message: 'Đã hết phiên đăng nhập');
    }
    ;
    if (response.statusCode != 200) {
      // Utils.showSnackBar(
      //     title: TextByNation.getStringByKey('notification'),
      //     message: response.body);
      return null;
    }
    if (jsonDecode(response.body)['error']['code'] != 0) {
      Utils.showSnackBar(
        title: 'Thông báo',
        message: jsonDecode(response.body)['error']['message'],
      );
      return null;
    }
    return jsonDecode(response.body);
  }
}
