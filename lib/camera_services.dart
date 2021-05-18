import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CamService {
  Dio dio = Dio();
  Future<String> _accessUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url = preferences.getString('kUrl') ?? 'Please set URL';
    return url;
  }

  Future<String> dioRequest(Uint8List imagedata) async {
    String url = await _accessUrl();
    print(url);
    String r = "Error!";
    if (url == 'Please set URL') {
      return "Please set URL first!";
    }
    try {
      var encodedData = await compute(base64Encode, imagedata);
      Response response = await dio.post(url, data: {'image': encodedData});
      if (response.statusCode == 200) {
        r = response.data;
        print("Uploaded! " + response.data);
      } else {
        print("Errorrrrrrrrrrr " + response.statusCode.toString());
      }
    } catch (e) {
      print("error aayaaaaa ");
      print(e);
    }
    return r;
  }

  Future<Uint8List> imageFileAsBytes(String image) async {
    File img = File(image);
    final size = ImageSizeGetter.getSize(FileInput(img));
    print('jpg = $size');
    // print(size.toString());
    final bytes = await img.readAsBytes();
    return bytes;
  }

  Future<String> convertImage(String image) async {
    File img = File(image);
    final size = ImageSizeGetter.getSize(FileInput(img));
    print('jpg = $size');
    final bytes = await img.readAsBytes();
    String img64 = base64Encode(bytes);
    print(img64);
    return img64;
  }
}

// String base64Encode(List<int> bytes) => base64.encode(bytes);
