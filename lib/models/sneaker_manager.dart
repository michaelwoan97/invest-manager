import 'package:flutter/foundation.dart';
import 'package:invest_manager/models/sneaker.dart';

/*
* class: SneakerManager
* purpose: This class represent as a data provider for the whole app. It also a singleton object
*           so it helps to manage the data of the app conveniently
* */
class SneakerManager with ChangeNotifier {
  static final SneakerManager _instance = SneakerManager._internal();
  late List<Sneaker> _arrSneakers;
  late int _totalAvaiProducts;
  late double _totalSoldProducts;

  late String _userID;
  late String _accessToken;
  late String _refreshToken;
  late bool _isTotalCalculated;
  late bool _fetchedSneakers;
  late bool _isNoCamera;

  factory SneakerManager() {
    return _instance;
  }

  SneakerManager._internal() {
    _arrSneakers = [];
    _totalAvaiProducts = 0;
    _totalSoldProducts = 0.0;
    _accessToken = "";
    _refreshToken = "";
    _userID = "";
    _isTotalCalculated = false;
    _fetchedSneakers = false;
    _isNoCamera = false;
  }

  bool get isTotalCalculated => _isTotalCalculated;

  set isTotalCalculated(bool value) {
    _isTotalCalculated = value;
  }

  List<Sneaker> get getListSneaker {
    return _arrSneakers;
  }

  set setListSneaker(List<Sneaker> arrSneakers) {
    _arrSneakers = List.from(arrSneakers);
  }

  int get totalAvaiProducts => _totalAvaiProducts;

  set totalAvaiProducts(int value) {
    _totalAvaiProducts = value;
  }

  double get totalSoldProducts => _totalSoldProducts;

  set totalSoldProducts(double value) {
    _totalSoldProducts = value;
  }

  String get refreshToken => _refreshToken;

  set refreshToken(String value) {
    _refreshToken = value;
  }

  String get accessToken => _accessToken;

  set accessToken(String value) {
    _accessToken = value;
  }

  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  bool get fetchedSneakers => _fetchedSneakers;

  set fetchedSneakers(bool value) {
    _fetchedSneakers = value;
  }


  bool get isNoCamera => _isNoCamera;

  set isNoCamera(bool value) {
    _isNoCamera = value;
  }

  void addNewSneakerToList(Sneaker newSneaker) {
    _arrSneakers.add(newSneaker);
    notifyListeners();
  }

  void calculateTotalQuantityProducts() {
    for (var e in _arrSneakers) {
      _totalAvaiProducts += e.getAvailableStocks.length;
    }
  }

  void calculateTotalProductSold() {
    for (var e in _arrSneakers) {
      for (var stock in e.getAvailableStocks) {
        if (stock.getSneakerSoldPrice.isNotEmpty) {
          _totalSoldProducts += double.parse(stock.getSneakerSoldPrice);
        }
      }
    }
  }

  void updateTotalAvaiSoldProducts(int iUpdatedQuantity, double iUpdatedPrice) {
    totalAvaiProducts += iUpdatedQuantity;
    totalSoldProducts += iUpdatedPrice;
    notifyListeners();
  }

  void deleteTotalAvaiSoldProducts(int iUpdatedQuantity, double iUpdatedPrice) {
    totalAvaiProducts -= iUpdatedQuantity;
    totalSoldProducts -= iUpdatedPrice;
    notifyListeners();
  }

  void deleteSneaker(String sneakerID) {
    int totalMinusProduct = 0;
    double totalMinusSold = 0;
    int removeIndex = 0;

    if (totalAvaiProducts != 0 && totalSoldProducts != 0.0) {
      // loop through list and delete the element
      for (var i = 0; i < _arrSneakers.length; i++) {
        // check whether the ids are matched
        if (_arrSneakers[i].getID == sneakerID) {
          // minus total product and price
          totalMinusProduct = _arrSneakers[i].getAvailableStocks.isNotEmpty
              ? _arrSneakers[i].getAvailableStocks.length
              : 0;
          if (_arrSneakers[i].getAvailableStocks.isNotEmpty) {
            for (var stock in _arrSneakers[i].getAvailableStocks) {
              if (stock.getSneakerSoldPrice.isEmpty) {
                continue;
              }
              totalMinusSold += double.parse(stock.getSneakerSoldPrice);
            }
          }

          removeIndex = i;
          break;
        }
      }

      // update
      _arrSneakers.removeAt(removeIndex);
      deleteTotalAvaiSoldProducts(totalMinusProduct, totalMinusSold);
    } else if (totalAvaiProducts == 0 && totalSoldProducts == 0.0) {
      // loop through list and delete the element
      for (var i = 0; i < _arrSneakers.length; i++) {
        // check whether the ids are matched
        if (_arrSneakers[i].getID == sneakerID) {
          removeIndex = i;
          break;
        }
      }

      // update
      _arrSneakers.removeAt(removeIndex);
      deleteTotalAvaiSoldProducts(totalMinusProduct, totalMinusSold);
    } else if (totalAvaiProducts != 0 && totalSoldProducts == 0.0) {
      // loop through list and delete the element
      for (var i = 0; i < _arrSneakers.length; i++) {
        // check whether the ids are matched
        if (_arrSneakers[i].getID == sneakerID) {
          // minus total product
          totalMinusProduct = _arrSneakers[i].getAvailableStocks.isNotEmpty
              ? _arrSneakers[i].getAvailableStocks.length
              : 0;
          if (_arrSneakers[i].getAvailableStocks.isNotEmpty) {
            for (var stock in _arrSneakers[i].getAvailableStocks) {
              if (stock.getSneakerSoldPrice.isEmpty) {
                continue;
              }
              totalMinusSold += double.parse(stock.getSneakerSoldPrice);
            }
          }
          removeIndex = i;
          break;
        }
      }

      // update
      _arrSneakers.removeAt(removeIndex);
      deleteTotalAvaiSoldProducts(totalMinusProduct, totalMinusSold);
    }
  }
}
