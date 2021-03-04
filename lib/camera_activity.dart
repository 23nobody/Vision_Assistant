import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vision_assistant/main.dart';

class CameraActivity extends StatefulWidget {
  @override
  _CameraActivityState createState() => _CameraActivityState();
}

class _CameraActivityState extends State<CameraActivity> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      print("laaaaaaaaaaaaaaaaaaaaaaaaaa");
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Flutter TTS'),
          ),
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(),
            ]),
          ),
        ),
      );
    }
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
