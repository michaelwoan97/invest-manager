import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:invest_manager/controllers/mangement_API.dart';
import 'package:invest_manager/controllers/my_route_observer.dart';
import 'package:invest_manager/pages/add_stock.dart';
import 'package:invest_manager/pages/home_page.dart';
import 'package:invest_manager/pages/login_register_page.dart';
import 'package:invest_manager/pages/take_picture_page.dart';
import 'package:invest_manager/pages/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:invest_manager/styles/theme_styles.dart';
import 'package:provider/provider.dart';

import 'controllers/interceptor_API.dart';
import 'models/sneaker_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();


  try{
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;

    // WidgetsFlutterBinding.ensureInitialized();
    // WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    runApp(MyApp(
      camera: firstCamera,
    ));
  } on CameraException catch(err){
    // check whether camera is available
    if(err.code == "cameraNotFound"){
      runApp(MyAppNoCam());
    }
  }

  // // Obtain a list of the available cameras on the device.
  // final cameras = await availableCameras();
  //
  // // Get a specific camera from the list of available cameras.
  // final firstCamera = cameras.first;
  //
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // runApp(MyApp(
  //   camera: firstCamera,
  // ));
}

/*
* class: MyApp
* purpose: this class is used for creating the invest manager app (when camera is available)
* */
class MyApp extends StatefulWidget {
  final CameraDescription camera;

  MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // test
    ManagementAPI().dio.interceptors.add(InterceptorAPI(ManagementAPI().dio));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        SneakerManager();
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        navigatorObservers: [MyRouteObserver()],
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          HomePage.routeName: (context) => HomePage(),
          AddStock.routeName: (context) => AddStock(),
          TakePictureScreen.routeName: (context) =>
              TakePictureScreen(camera: widget.camera)
        },
      ),
    );
  }
}

/*
* class: MyAppNoCam
* purpose: this class is used for creating the invest manager app (when no camera is available)
* */
class MyAppNoCam extends StatefulWidget {

  MyAppNoCam({Key? key}) : super(key: key);

  @override
  State<MyAppNoCam> createState() => _MyAppNoCamState();
}

class _MyAppNoCamState extends State<MyAppNoCam> {
  @override
  void initState() {
    super.initState();

    // test
    ManagementAPI().dio.interceptors.add(InterceptorAPI(ManagementAPI().dio));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        SneakerManager();
        SneakerManager().isNoCamera = true;
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        navigatorObservers: [MyRouteObserver()],
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          HomePage.routeName: (context) => HomePage(),
          AddStock.routeName: (context) => AddStock(),
        },
      ),
    );
  }

}
