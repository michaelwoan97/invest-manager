import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:invest_manager/controllers/interceptor_API.dart';
import 'package:invest_manager/models/sneaker_manager.dart';
import 'package:path/path.dart';

import '../models/sneaker.dart';

//https://invest-manager-app.herokuapp.com
//http://http://192.168.0.43:3000
class ManagementAPI {
  static final ManagementAPI _instance = ManagementAPI._internal();
  final String _url = "https://invest-manager-app.herokuapp.com";
  Dio dio = new Dio();

  factory ManagementAPI() {
    return _instance;
  }

  ManagementAPI._internal();

  // Future<List<Sneaker>> getSneakers(token) async {
  //   List<Sneaker> arrSneakers = [];
  //
  //   try {
  //     await dio
  //         .get("$_url/getdata/sneaker",
  //             options: Options(headers: {"Authorization": "Bearer $token"}))
  //         .then((val) {
  //       final res = json.decode(val.data);
  //       final data = res['msg'];
  //
  //       for (var e in data) {
  //         arrSneakers.add(Sneaker.fromJson(e));
  //       }
  //     });
  //   } on DioError catch (err) {
  //     rethrow;
  //   }
  //   return arrSneakers;
  // }

  Future<List<Sneaker>> getSneakers(token) async {
    List<Sneaker> arrSneakers = [];

    try {
      await dio
          .get("$_url/getdata/sneaker",
              options: Options(headers: {"requiresToken": true}))
          .then((val) {
        final res = json.decode(val.data);
        // final res = val.data;
        final data = res['msg'];

        for (var e in data) {
          arrSneakers.add(Sneaker.fromJson(e));
        }
      });
    } on DioError catch (err) {
      print(err.message);
      rethrow;
    }
    return arrSneakers;
  }

  getUserID(token) async {
    try {
      await dio
          .get("$_url/getdata/info",
              options: Options(headers: {"requiresToken": true}))
          .then((val) {
        final res = json.decode(val.data);
        // final res = val.data;
        SneakerManager().userID = res['msg']
            ["_id"]; // can move to sneaker manager to do some process parseing
      });
    } on DioError catch (e) {
      rethrow;
    }
  }

  addSneaker(token, userID, Sneaker newSneaker) async {
    String encodedSneaker = jsonEncode(newSneaker);

    try {
      return await dio.post(
        "$_url/updatedata/addsneaker",
        data: {"userID": userID, "newSneaker": encodedSneaker},
        options: Options(
            headers: {"requiresToken": true},
            contentType: Headers.formUrlEncodedContentType),
      ).then((val) {
        final res = json.decode(val.data);
        if(res['success']){
          Fluttertoast.showToast(msg: 'Successfully Added to The Sneaker list!',
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
    } on DioError catch (e) {
      rethrow;
    }
  }

  removeSneaker(token, userID, sneakerID) async {
    try {
      return await dio.post("$_url/updatedata/removesneaker",
          data: {"userID": userID, "sneakerID": sneakerID},
          options: Options(
              headers: {"requiresToken": true},
              contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      rethrow;
    }
  }

  updateSneaker(token, userID, sneakerID, updateStockInfo) async {
    String encodedSneaker = jsonEncode(updateStockInfo);

    try {
      return await dio
          .post("$_url/updatedata/updatesneaker",
              data: {
                "userID": userID,
                "sneakerID": sneakerID,
                "updateStockInfo": encodedSneaker
              },
              options: Options(
                  headers: {"requiresToken": true},
                  contentType: Headers.formUrlEncodedContentType))
          .then((val) {
        final res = json.decode(val.data);
        if(res['success']){
          Fluttertoast.showToast(msg: 'Successfully Updated The Sneaker list!',
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
    } on DioError catch (e) {
      rethrow;
    }
  }

  // refersh token
  refreshToken(userID) async {
    try {
      return await dio.post("$_url/token",
          data: {"userID": userID},
          options: Options(contentType: Headers.formUrlEncodedContentType));
    } on DioError catch (e) {
      rethrow;
    }
  }

// refreshToken(token) async {
//   try {
//     await dio
//         .post("$_url/token",
//             data: {"token": token},
//             options: Options(contentType: Headers.formUrlEncodedContentType))
//         .then((val) {
//       final res = json.decode(val.data);
//       if(res['success']){
//         print("success refresh token");
//         SneakerManager().refreshToken = res['msg'];
//
//       } else {
//         print('failed refresh token');
//       }
//     });
//   } on DioError catch (e) {
//     rethrow;
//   }
// }
}
