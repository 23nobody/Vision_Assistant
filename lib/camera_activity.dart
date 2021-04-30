import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vision_assistant/camera_services.dart';
import 'package:vision_assistant/main.dart';

class CameraActivity extends StatefulWidget {
  @override
  _CameraActivityState createState() => _CameraActivityState();
}

enum TtsState { playing, stopped, paused, continued }

class _CameraActivityState extends State<CameraActivity> {
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String _newVoiceText = "error!";

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;

  CameraController controller;
  CamService camService = CamService();
  XFile imageFile;
  @override
  void initState() {
    super.initState();
    initTts();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      print(controller.value.flashMode);
      print(controller.value.focusMode);
      setState(() {});
    });
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    if (isAndroid) {
      _getEngines();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });
    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(_newVoiceText);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  Future<void> callSpeak() async {
    // _newVoiceText = "error!";
    Uint8List im = await imageFileAsBytes(imageFile.path);
    String r = await camService.dioRequest(im);
    print(r);
    // Post p = await getPost();
    _newVoiceText = r;
    _speak();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
    flutterTts.stop();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      print("laaaaaaaaaaaaaaaaaaaaaaaaaa");
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
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
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Flutter TTS'),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            // child: Center(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              ),
            ),
            // ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _captureControlRowWidget(),
                _thumbnailWidget(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          imageFile == null
              ? Container()
              : SizedBox(
                  child: Image.file(File(imageFile.path)),
                  width: 64.0,
                  height: 64.0,
                ),
        ],
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    final CameraController cameraController = controller;

    return
        // Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.max,
        // children: <Widget>[
        Expanded(
      child: IconButton(
        icon: const Icon(Icons.camera_alt),
        color: Colors.blue,
        onPressed: cameraController != null &&
                cameraController.value.isInitialized &&
                !cameraController.value.isRecordingVideo
            ? onTakePictureButtonPressed
            : null,
      ),
    )
        // ],
        // )
        ;
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile file) {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {
          showInSnackBar('Picture saved to ${file.path}');
          callSpeak();
        }
      }
    });
  }

  Future<XFile> takePicture() async {
    final CameraController cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void logError(String code, String message) {
    if (message != null) {
      print('Error: $code\nError Message: $message');
    } else {
      print('Error: $code');
    }
  }
}
