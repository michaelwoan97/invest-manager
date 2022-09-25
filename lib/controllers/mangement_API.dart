import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/sneaker.dart';

class ManagementAPI{
  static final ManagementAPI _instance = ManagementAPI._internal();
  Dio dio = new Dio();

  factory ManagementAPI(){
    return _instance;
  }

  ManagementAPI._internal();

  Future<List<Sneaker>> getSneakers(token) async {
    List<Sneaker> arrSneakers = [];

    try{
       await dio.get(
          "https://invest-manager-app.herokuapp.com/getdata/sneaker",
          options: Options( headers: {
            "Authorization": "Bearer $token"
          })
      ).then((val) async {
           final res = await json.decode(val.data);
           final data = res['msg'];

           for(var e in data){
             arrSneakers.add(Sneaker.fromJson(e));
           }


       });
    } on DioError catch(err){
      rethrow;
    }
    return arrSneakers;
  }




}