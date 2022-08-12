import 'package:flutter/cupertino.dart';

class SneakerDetail with ChangeNotifier{
  late String _sSeller;
  late String _sDate;
  late String _sSize;
  late String _sPrice;
  late bool _isSold;
  late String _sPriceSold;


  SneakerDetail({required sSeller, required String sDate, required String sSize, required String sPrice, bool? isSold, String? sPriceSold}){
    _sSeller = sSeller;
    _sDate = sDate;
    _sSize = sSize;
    _sPrice = sPrice;
    if(isSold != null){
      _isSold = isSold;
      _sPriceSold = sPriceSold!;
    } else {
      _isSold = false;
      _sPriceSold = "";
    }
  }

  factory SneakerDetail.fromJson(Map<String, dynamic> json){
    return SneakerDetail(sSeller: json['seller'], sDate: json['date'], sSize: json['size'], sPrice: json['price'] ,isSold: json['isSold'], sPriceSold: json['priceSold']);
  }
  String get getSellerName{
    return _sSeller;
  }

  set setSellerName (String sSellerName){
    _sSeller = sSellerName;

  }

  String get getDatePurchased{
    return _sDate;
  }

  set setDatePurchased(String sDate){
    _sDate = sDate;

  }

  String get getSneakerSize{
    return _sSize;
  }

  set setSneakerSize(String sSneakerSize){
    _sSize = sSneakerSize;

  }


  String get getSneakerPrice => _sPrice;

  set setSneakerPrice(String value) {
    _sPrice = value;

  }

  bool get isSneakerSold{
    return _isSold;
  }

  set setIsSneakerSold(bool isSneakerSold){
    _isSold = isSneakerSold;

  }

  String get getSneakerSoldPrice => _sPriceSold;

  set setSneakerSoldPrice(String value) {
    _sPriceSold = value;

  }

  void updateSneakerStock(SneakerDetail newSneakerStock){
    setSellerName = newSneakerStock.getSellerName;
    setDatePurchased = newSneakerStock.getDatePurchased;
    setSneakerSize = newSneakerStock.getSneakerSize;
    setSneakerPrice = newSneakerStock.getSneakerPrice;
    setIsSneakerSold = newSneakerStock.isSneakerSold;
    setSneakerSoldPrice = newSneakerStock.isSneakerSold ? newSneakerStock.getSneakerSoldPrice : "";
    notifyListeners();
  }
}