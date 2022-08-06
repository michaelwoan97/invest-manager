import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:invest_manager/pages/add_stock.dart';
import 'package:invest_manager/pages/home_page.dart';
import 'package:invest_manager/pages/login_register_page.dart';
import 'package:invest_manager/pages/take_picture_page.dart';
import 'package:invest_manager/pages/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp(camera: firstCamera,));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange
      ),
      home: WidgetTree(),
      routes: {
        WidgetTree.routeName: (context) => WidgetTree(),
        HomePage.routeName: (context) => HomePage(),
        AddStock.routeName: (context) => AddStock(),
        TakePictureScreen.routeName: (context) => TakePictureScreen(camera: camera)
      },
    );
  }
}
