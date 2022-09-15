import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  Dio dio = new Dio();

  login(name,password) async{
    try{
      return await dio.post(
        "https://invest-manager-app.herokuapp.com/authenticate",
        data: {"name": name, "password": password},
        options: Options(contentType: Headers.formUrlEncodedContentType)
      );
    } on DioError catch(e){
      Fluttertoast.showToast(msg: e.response!.data['msg'],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
    }
  }

  signUp(name,password) async{
    try{
      return await dio.post(
          "https://invest-manager-app.herokuapp.com/adduser",
          data: {"name": name, "password": password, "data": ""},
          options: Options(contentType: Headers.formUrlEncodedContentType)
      );
    } on DioError catch(e){
      Fluttertoast.showToast(msg: e.response!.data['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


}
