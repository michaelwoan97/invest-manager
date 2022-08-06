
import 'package:invest_manager/models/sneaker.dart';

class SneakerManager{
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
    _arrSneakers = _arrSneakers;
  }
}