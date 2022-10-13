import 'dart:convert';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_manager/controllers/custom_auth.dart';
import 'package:invest_manager/controllers/mangement_API.dart';
import 'package:invest_manager/models/sneaker.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/add_stock.dart';
import 'package:invest_manager/pages/home_page.dart';
import 'package:invest_manager/utils/mange_token.dart';
import 'package:invest_manager/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth.dart';
import '../styles/responsive/breakpoints.dart';
import '../styles/theme_styles.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  static const emailField = "*Email";
  static const passField = "*Password";

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late GlobalKey<FormState> _formKey;
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKey = GlobalKey<FormState>();
    navigateToLastPage();
  }

  // Future<void> signInWithEmailAndPassword() async {
  //   try {
  //     await Auth().signInWithEmailAndPassword(
  //         email: _controllerEmail.text, password: _controllerPassword.text);
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       errorMessage = e.message;
  //     });
  //   }
  // }

  // Future<void> signInWithEmailAndPassword() async {
  //   try {
  //     await Auth().signInWithEmailAndPassword(
  //         email: _controllerEmail.text, password: _controllerPassword.text);
  //   } on FirebaseAuthException catch (e) {
  //     setState(() {
  //       errorMessage = e.message;
  //     });
  //   }
  // }

  // Future<void> createUserWithEmailAndPassword() async {
  //   try {
  //     await Auth().createUserWithEmailAndPassword(
  //         email: _controllerEmail.text, password: _controllerPassword.text);
  //   } on FirebaseAuthException catch (e) {
  //     errorMessage = e.message;
  //   }
  // }

  void signInWithEmailAndPassword() {
    AuthService()
        .login(_controllerEmail.text, _controllerPassword.text)
        .then((val) async {
      if (val == null) {
        setState(() {
          isLoading = false;
        });
      } else {
        final res = await json.decode(val.data);
        if (res['success']) {
          // save tokens
          // await token to be saved before continue
          await ManageToken.saveAccessToken(res['token']);
          await ManageToken.saveRefreshToken(res['refreshToken']);
          await ManageToken.saveUserID(res['userID']);

          // print("Refresh Token for authenticate is " + res['refreshToken']);
          setState(() {
            isLoading = false;
          });
          ManagementAPI().getUserID(SneakerManager()
              .accessToken); // save user id to sneaker_manager singleton
          Fluttertoast.showToast(
              msg: 'Authenticated',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  void addUser() {
    AuthService()
        .signUp(_controllerEmail.text, _controllerPassword.text)
        .then((val) {
      if (val == null) {
        setState(() {
          isLoading = false;
        });
      } else {
        if (val.data['success']) {
          Fluttertoast.showToast(
              msg: 'Successfully Created!!!',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    });
  }

  Widget _title(BuildContext context) {
    return Text('Home',
        style: MediaQuery.of(context).size.width > kTabletBreakPoint
            ? AppTheme.kFontSizeDesktopAppBarText
            : AppTheme.kFontSizeMobileAppBarText);
  }

  Widget _entryField(
      BuildContext context, String title, TextEditingController controller) {
    return TextFormField(
        controller: controller,
        obscureText: title == LoginPage.passField ? true : false,
        decoration: InputDecoration(
            labelText: title,
            labelStyle: MediaQuery.of(context).size.width > kTabletBreakPoint
                ? AppTheme.kFontSizeDesktopBodyText
                : AppTheme.kFontSizeMobileBodyText),
        validator: (value) {
          if (value == null || value.isEmpty) {
            String errorMsg = "";
            if (title == LoginPage.emailField) {
              errorMessage = "Please Enter Your Email!!!";
            } else if (title == LoginPage.passField) {
              errorMessage = "Please Enter Your Password!!!";
            }
            return errorMessage;
          }
          return null;
        });
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Hum ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // setstate lodading to true ... loading pop
            setState(() {
              isLoading = true;
            });
            if (isLogin) {
              // await
              signInWithEmailAndPassword();
            } else {
              // await
              addUser();
            }

            // process response
            // if true go to nextpage
            // else flutter toat with error message

          }
        },
        child: Text(isLogin ? 'Login' : 'Register',style: MediaQuery.of(context).size.width > kTabletBreakPoint
            ? AppTheme.kFontSizeDesktopBodyText
            : AppTheme.kFontSizeMobileBodyText));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(
          isLogin ? 'Register instead' : 'Login instead',
          style: MediaQuery.of(context).size.width > kTabletBreakPoint
              ? AppTheme.kFontSizeDesktopBodyText
              : AppTheme.kFontSizeMobileBodyText,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: _title(context),
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              margin: AppTheme.spaceBetweenSectionTop(),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/invest-manager.png"),
                      _entryField(
                          context, LoginPage.emailField, _controllerEmail),
                      _entryField(
                          context, LoginPage.passField, _controllerPassword),
                      _submitButton(),
                      _loginOrRegisterButton()
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  // purpose: used for save and navigate to the last screen
  void navigateToLastPage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastRoute = prefs.getString("last_route");

    if (lastRoute == null) return;

    // no need to push to another screen, if the last route was root
    if (lastRoute!.isNotEmpty && lastRoute != LoginPage.routeName) {
      final user = await ManageToken.getUserID();
      SneakerManager().userID = user;
      if (lastRoute == AddStock.routeName) {
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);

        // check whether there are arguments
        if (prefs.containsKey("sneaker")) {
          Sneaker sneaker =
              Sneaker.fromJson(json.decode(prefs.getString("sneaker")!));
          final scenarios = EnumToString.fromString(
              Scenarios.values, prefs.getString("scenario")!);
          Navigator.of(context)
              .pushNamed(lastRoute, arguments: [sneaker, scenarios]);
        } else {
          Navigator.of(context).pushNamed(lastRoute);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    }
  }
}
