
import 'package:flutter/foundation.dart';
import 'package:invest_manager/models/sneaker.dart';

class SneakerManager with ChangeNotifier{
  static final SneakerManager _instance = SneakerManager._internal();
  late List<Sneaker> _arrSneakers;
  late int _totalAvaiProducts;
  late double _totalSoldProducts;


  factory SneakerManager(){
    return _instance;
  }

  SneakerManager._internal() {
    _arrSneakers = [];
    _totalAvaiProducts = 0;
    _totalSoldProducts = 0.0;
  }

  List<Sneaker> get getListSneaker{
    return _arrSneakers;
  }

  set setListSneaker(List<Sneaker> arrSneakers ){
    _arrSneakers = List.from(arrSneakers);
  }


  int get totalAvaiProducts => _totalAvaiProducts;

  set totalAvaiProducts(int value) {
    _totalAvaiProducts = value;
  }

  void addNewSneakerToList(Sneaker newSneaker){
    _arrSneakers.add(newSneaker);
    notifyListeners();
  }

  void calculateTotalQuantityProducts(){
    for(var e in _arrSneakers){
      _totalAvaiProducts += e.getAvailableStocks.length;
    }
  }

  void calculateTotalProductSold(){
    for(var e in _arrSneakers){
      for(var stock in e.getAvailableStocks){
        // check whether it is integer or double
        // if(int.tryParse(stock.getSneakerSoldPrice) == true){
        //   _totalSoldProducts += int.parse(stock.getSneakerSoldPrice);
        // } else {
        //   _totalSoldProducts += double.parse(stock.getSneakerSoldPrice);
        // }
        if(stock.getSneakerSoldPrice.isNotEmpty){
          _totalSoldProducts += double.parse(stock.getSneakerSoldPrice);
        }

      }
    }
  }

  void updateTotalAvaiSoldProducts(int iUpdatedQuantity, double iUpdatedPrice){
    totalAvaiProducts += iUpdatedQuantity;
    totalSoldProducts += iUpdatedPrice;
    notifyListeners();
  }

  void deleteTotalAvaiSoldProducts(int iUpdatedQuantity, double iUpdatedPrice){
    totalAvaiProducts -= iUpdatedQuantity;
    totalSoldProducts -= iUpdatedPrice;
    notifyListeners();
  }

  void deleteSneaker(String sneakerID){
    int totalMinusProduct = 0;
    double totalMinusSold = 0;
    int removeIndex = 0;

    if(totalAvaiProducts != 0 && totalSoldProducts != 0.0){
      for(var i = 0; i < _arrSneakers.length; i++){
        if(_arrSneakers[i].getID == sneakerID){
          if(_arrSneakers[i].getID == sneakerID){

            // minus total product and price
            totalMinusProduct = _arrSneakers[i].getAvailableStocks.isNotEmpty ? _arrSneakers[i].getAvailableStocks.length : 0;
            if(_arrSneakers[i].getAvailableStocks.isNotEmpty){
              for(var stock in _arrSneakers[i].getAvailableStocks){
                totalMinusSold += double.parse(stock.getSneakerSoldPrice);
              }
            }

            removeIndex = i;
            break;
          }
        }
      }

      // update
      _arrSneakers.removeAt(removeIndex);
      deleteTotalAvaiSoldProducts(totalMinusProduct, totalMinusSold);
    }


  }

  double get totalSoldProducts => _totalSoldProducts;

  set totalSoldProducts(double value) {
    _totalSoldProducts = value;
  }
}