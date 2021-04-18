import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:vision_assistant/post_model.dart';

String url = 'https://d20a65bb491b.ngrok.io/predict';

Future<Post> getPost() async {
  final response = await http.get(Uri.parse('$url/1'));
  Post p = postFromJson(response.body);
  // newVoiceText = p.body;
  return p;
}

Future<String> createPost(String img64) async {
  // final response = await http.post(Uri.parse('$url'),
  //     headers: {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       HttpHeaders.authorizationHeader: ''
  //     },
  //     body: postToJson(post));
  // return response;
  String r = "Error!";
  var request = new http.MultipartRequest("POST", Uri.parse('$url'));
  // request.fields['user'] = 'someone@somewhere.com';
  request.files.add(http.MultipartFile.fromString('file', img64));
  await request.send().then((response) async {
    if (response.statusCode == 200) {
      print("Uploaded! " + response.toString());
      final respStr = await response.stream.bytesToString();
      print("zoooooooooo " + respStr);
      r = respStr;
    } else {
      print("Errorrrrrrrrrrr " + response.statusCode.toString());
    }
  });
  return r;
}
