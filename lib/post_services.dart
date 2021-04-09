import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:vision_assistant/post_model.dart';

String url = 'https://jsonplaceholder.typicode.com/posts';

Future<Post> getPost() async {
  final response = await http.get(Uri.parse('$url/1'));
  return postFromJson(response.body);
}

Future<http.Response> createPost(Post post) async {
  final response = await http.post(Uri.parse('$url'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: ''
      },
      body: postToJson(post));
  return response;
}
