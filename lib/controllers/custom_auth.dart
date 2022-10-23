import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_manager/models/sneaker_manager.dart';

/*
* class: AuthService
* purpose: This class used for authenticating users by using custom server
* server-detail:
* */
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
      ).then((val) {
        final res = json.decode(val.data);
        if(res['success']){
          Fluttertoast.showToast(msg: 'Successfully Registered!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(msg: res['msg'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
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

  logOut(refreshToken, String userID) async{
    SneakerManager().refreshToken = "";
    print(refreshToken);
    try{
      return await dio.delete(
          "$_url/logout",
          data: {"token": refreshToken, "userID": userID},
          options: Options(contentType: Headers.formUrlEncodedContentType)
      ).then((val) {
        final res = json.decode(val.data);
        if(res['success']){
          Fluttertoast.showToast(msg: 'Successfully Logged out!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(msg: res['msg'],
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
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
