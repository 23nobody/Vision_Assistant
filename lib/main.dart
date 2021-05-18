import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:vision_assistant/camera_activity.dart';
import 'package:vision_assistant/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

List<CameraDescription> cameras;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/camera": (context) => CameraActivity(),
      },
    );
  }
}
