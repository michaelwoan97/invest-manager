import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_manager/controllers/custom_auth.dart';
import 'package:invest_manager/controllers/mangement_API.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:invest_manager/pages/home_page.dart';
import 'package:invest_manager/utils/mange_token.dart';
import '../controllers/auth.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

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
    AuthService().login(_controllerEmail.text, _controllerPassword.text).then( (val) async {
      final res = await json.decode(val.data);
      if(res['success']){

        // save tokens
        ManageToken.saveAccessToken(res['token']);
        ManageToken.saveRefreshToken(res['refreshToken']);
        final accessToken = await ManageToken.getAccessToken();
        final refreshToken = await ManageToken.getRefreshToken();

        SneakerManager().accessToken = accessToken;
        SneakerManager().refreshToken = refreshToken;

        ManagementAPI().getUserID(SneakerManager().accessToken); // save user id to sneaker_manager singleton
        Fluttertoast.showToast(msg: 'Authenticated',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    });
  }

  void addUser() {
    AuthService().signUp(_controllerEmail.text, _controllerPassword.text).then( (val) {
      if(val.data['success']){
        Fluttertoast.showToast(msg: 'Successfully Created!!!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  Widget _title() {
    return const Text('Invest Manager');
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: title.toLowerCase()  == "password" ? true : false,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Hum ? $errorMessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : addUser,
        child: Text(isLogin ? 'Login' : 'Register'));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Register instead' : 'Login instead'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/invest-manager.png"),

            _entryField('Email', _controllerEmail),
            _entryField('Password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton()
          ],
        ),
      ),
    );
  }
}
