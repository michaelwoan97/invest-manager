import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:invest_manager/models/sneaker.dart';

import '../models/sneaker_manager.dart';

class ReadJsonFile{

  static Future<List<Sneaker>> readJson(String filePath) async {
    final String response = await rootBundle.loadString("assets/data/sneaker_data.json");
    final data = await json.decode(response);
    List<Sneaker> arrSneakers = [];
    
    for(var e in data){
      arrSneakers.add(Sneaker.fromJson(e));
    }

    return arrSneakers;
  }
}