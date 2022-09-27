import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  Dio dio = new Dio();
  final String _url = "https://invest-manager-app.herokuapp.com";

  login(name,password) async{
    print("$_url/authenticate");
    try{
      return await dio.post(
        "$_url/authenticate",
        data: {"name": name, "password": password},
        options: Options(contentType: Headers.formUrlEncodedContentType)
      );
    } on DioError catch(e){
      final data = json.decode(e.response!.data);
      Fluttertoast.showToast(msg: data['msg'],
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
          "$_url/adduser",
          data: {"name": name, "password": password, "data": ""},
          options: Options(contentType: Headers.formUrlEncodedContentType)
      );
    } on DioError catch(e){
      final data = json.decode(e.response!.data);
      Fluttertoast.showToast(msg: data['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


}
