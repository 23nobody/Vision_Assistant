import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vision_assistant/main.dart';

class CameraActivity extends StatefulWidget {
  @override
  _CameraActivityState createState() => _CameraActivityState();
}

class _CameraActivityState extends State<CameraActivity> {
  @override
  Widget build(BuildContext context) {
    CameraController controller;

    // @override
    // void didChangeAppLifecycleState(AppLifecycleState state) {
    //   // App state changed before we got the chance to initialize.
    //   if (controller == null || !controller.value.isInitialized) {
    //     return;
    //   }
    //   if (state == AppLifecycleState.inactive) {
    //     controller?.dispose();
    //   } else if (state == AppLifecycleState.resumed) {
    //     if (controller != null) {
    //       onNewCameraSelected(controller.description);
    //     }
    //   }
    // }

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
            body: Container(
              child: Text("Hello Camera"),
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
}
