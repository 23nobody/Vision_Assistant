import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vision_assistant/post_model.dart';
import 'package:vision_assistant/post_services.dart';

class ExperimentAcitvity extends StatefulWidget {
  @override
  _ExperimentAcitvityState createState() => _ExperimentAcitvityState();
}

class _ExperimentAcitvityState extends State<ExperimentAcitvity> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter TTS'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            FutureBuilder<Post>(
                future: getPost(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return Text(
                        'Title from Post JSON : ${snapshot.data.title}');
                  else
                    return CircularProgressIndicator();
                }),
          ]),
        ),
      ),
    );
  }
}
