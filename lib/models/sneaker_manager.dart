
import 'package:flutter/foundation.dart';
import 'package:invest_manager/models/sneaker.dart';

class SneakerManager with ChangeNotifier{
  static final SneakerManager _instance = SneakerManager._internal();
  late List<Sneaker> _arrSneakers;

  factory SneakerManager(){
    return _instance;
  }

  SneakerManager._internal() {
    _arrSneakers = [];
  }

  List<Sneaker> get getListSneaker{
    return _arrSneakers;
  }

  set setListSneaker(List<Sneaker> arrSneakers ){
    _arrSneakers = List.from(arrSneakers);
  }

  void addNewSneakerToList(Sneaker newSneaker){
    _arrSneakers.add(newSneaker);
    notifyListeners();
  }
}