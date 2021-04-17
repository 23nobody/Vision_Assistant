import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:vision_assistant/post_model.dart';

String url = 'https://b1a4f0ef92ee.ngrok.io/predict';

Future<Post> getPost() async {
  final response = await http.get(Uri.parse('$url/1'));
  Post p = postFromJson(response.body);
  // newVoiceText = p.body;
  return p;
}

Future<http.Response> createPost(String img64) async {
  // final response = await http.post(Uri.parse('$url'),
  //     headers: {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //       HttpHeaders.authorizationHeader: ''
  //     },
  //     body: postToJson(post));
  // return response;
  var request = new http.MultipartRequest("POST", Uri.parse('$url'));
  request.fields['user'] = 'someone@somewhere.com';
  request.files.add(http.MultipartFile.fromString('file', img64));
  request.send().then((response) {
    if (response.statusCode == 200) {
      print("Uploaded! " + response.toString());
    } else {
      print("Errorrrrrrrrrrr " + response.statusCode.toString());
    }
    return response;
  });
}
