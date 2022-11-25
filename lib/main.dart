import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:socketio_chat_app/Screens/camera_screen.dart';
import 'package:socketio_chat_app/Screens/home_screen.dart';
import 'package:socketio_chat_app/Screens/login_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket IO Chat Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: LoginScreen()
    );
  }
}
