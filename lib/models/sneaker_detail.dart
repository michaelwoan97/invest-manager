import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class SneakerDetail with ChangeNotifier{
  late String _id;
  late String _sSeller;
  late String _sDate;
  late String _sSize;
  late String _sPrice;
  late bool _isSold;
  late String _sPriceSold;


  SneakerDetail({String? id ,required sSeller, required String sDate, required String sSize, required String sPrice, bool? isSold, String? sPriceSold}){
    if(id == null){
      var uuid = Uuid();
      _id = uuid.v1();
    } else {
      _id = id;
    }
    _sSeller = sSeller;
    _sDate = sDate;
    _sSize = sSize;
    _sPrice = sPrice;
    if(isSold != null){
      _isSold = isSold;
      _sPriceSold = _isSold ? sPriceSold! : "";
    } else {
      _isSold = false;
      _sPriceSold = "";
    }
  }

  factory SneakerDetail.fromJson(Map<String, dynamic> json){
    return SneakerDetail(sSeller: json['seller'], sDate: json['date'], sSize: json['size'], sPrice: json['price'] ,isSold: json['isSold'], sPriceSold: json['priceSold']);
  }


  String get getStockID => _id;

  set setStockID(String value) {
    _id = value;
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

  /*
  * the purpose of this function is to update the stock info
  * of the sneaker and immediately notify the sneaker data provider
  * about the change. So if this get call on the sneaker's stock info
  * that already existed, it would change other places without user knowing it
  * */
  void updateSneakerStock(SneakerDetail newSneakerStock){
    updateSneakerStockNoNotify(newSneakerStock);
    notifyListeners();
  }

  /*
   * Same purpose with the updateSneakerStock but
   * it will update and notify on the copy of the sneaker stock lit
   * when user want to modify the current element of the existing list
   */
  // void updateCopiedSneakerStock(SneakerDetail newSneakerStock){
  //
  // }
  /*


  * The purpose of this function is to update info without notifying the provider
  * */
  void updateSneakerStockNoNotify(SneakerDetail newSneakerStock) {
    setSellerName = newSneakerStock.getSellerName;
    setDatePurchased = newSneakerStock.getDatePurchased;
    setSneakerSize = newSneakerStock.getSneakerSize;
    setSneakerPrice = newSneakerStock.getSneakerPrice;
    setIsSneakerSold = newSneakerStock.isSneakerSold;
    setSneakerSoldPrice = newSneakerStock.isSneakerSold ? newSneakerStock.getSneakerSoldPrice : "";
  }

}