import 'dart:convert';
import 'dart:io';

import 'package:xfile/xfile.dart';

Future<String> convertImage(XFile image) async {
  File img = image.toFile();
  final bytes = await img.readAsBytes();
  String img64 = base64Encode(bytes);
  print(img64);
  return img64;
}
// String base64Encode(List<int> bytes) => base64.encode(bytes);
