import 'dart:convert';
import 'dart:io';

import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

Future<String> convertImage(String image) async {
  File img = File(image);
  final size = ImageSizeGetter.getSize(FileInput(img));
  print('jpg = $size');
  final bytes = await img.readAsBytes();
  String img64 = base64Encode(bytes);
  print(img64);
  return img64;
}
// String base64Encode(List<int> bytes) => base64.encode(bytes);
