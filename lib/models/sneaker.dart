import 'package:flutter/foundation.dart';
import 'package:invest_manager/models/sneaker_detail.dart';
import 'package:invest_manager/models/sneaker_manager.dart';


/*
* class: Sneaker
* purpose: This class represent for the model of a sneaker. It uses singleton pattern and provider state management
* */
class Sneaker with ChangeNotifier {
  late String _id;
  late String _sName;
  late String _sNotes;
  late String _sImgUrl;

  // the different between the two is one used for
  // completely new sneaker about add to list
  // the other one used for modifying and waiting whether user want to add
  late List<SneakerDetail> _arrAvailable;
  late List<SneakerDetail> _copiedOfArrAvailable = []; // copied of the og list
  late List<SneakerDetail> _stockToBeDeleted = [];


  Sneaker(
      {required String sID,
        String? sName,
      String? sNotes,
      String? sImageUrl,
      List<SneakerDetail>? arrStockAvailable}) {
    _id = sID;
    _sName = sName ?? '';
    _sNotes = sNotes ?? '';
    _sImgUrl = sImageUrl ?? '';
    _copiedOfArrAvailable = [];
    _stockToBeDeleted = [];

    if (arrStockAvailable != null) {
      _arrAvailable = arrStockAvailable;
    } else {
      _arrAvailable = [];
    }
  }

  factory Sneaker.fromJson(Map<String, dynamic> json) {

    // check whether the sneaker has more than 1 size
    List<dynamic> availableSizes = json['available'];
    List<SneakerDetail> arrAvailableSizes = [];
    if(availableSizes.isNotEmpty){
      for(var e in availableSizes){
        arrAvailableSizes.add(SneakerDetail.fromJson(e));
      }
    }

    return Sneaker(
        sID: json['id'],
        sName: json['name'],
        sNotes: json['notes'],
        sImageUrl: json['img'],
        arrStockAvailable: arrAvailableSizes);
  }

  Map toJson() => {
    "id": _id,
    "name": _sName,
    "notes": _sNotes,
    "img": _sImgUrl,
    "available": _arrAvailable
  };

  String get getID {
    return _id;
  }

  set setID(String sId) {
    _id = sId;
  }

  String get getSneakerName {
    return _sName;
  }

  set setSneakerName(String sSneakerName) {
    _sName = sSneakerName;
  }

  String get getNotes {
    return _sNotes;
  }

  set setNotes(String sNotes) {
    _sNotes = sNotes;
  }

  String get getImgUrl {
    return _sImgUrl;
  }

  set setImgUrl(String sImgUrl) {
    _sImgUrl = sImgUrl;
  }

  List<SneakerDetail> get getAvailableStocks {
    return _arrAvailable;
  }


  List<SneakerDetail> get getCopiedOfArrAvailable => _copiedOfArrAvailable;

  /*
  * Function: setNewAddedStockAvailable
  * Purpose: The purpose of the function is to get the copy of the list without using its pointer.
  *         Therefore modification on the copied list will not reflect on the OG list
  * */
  set setCopiedOfArrAvailable(List<SneakerDetail> value) {
    _copiedOfArrAvailable = value.map((e) => SneakerDetail(id: e.getStockID ,sSeller: e.getSellerName, sDate: e.getDatePurchased, sSize: e.getSneakerSize, sPrice: e.getSneakerPrice, isSold: e.isSneakerSold, sPriceSold: e.getSneakerSoldPrice)).toList();
  }

  set setAvailableStocks(List<SneakerDetail> arrAvailableStock) {
    _arrAvailable = List.from(arrAvailableStock);
    notifyListeners();
  }

  /*
  * The different functionality of this function is
  * it will add the stock info list to the newly create sneaker
  * then will notify the sneaker provider to change accordingly
  * but it will not be added to the main list sneaker unless user accept it
  * */
  void modifyAvailableStocks(List<SneakerDetail> sneakerDetails){
    // check whether the array of available stock is empty
    if(_arrAvailable.isEmpty){
      setAvailableStocks = sneakerDetails;
    } else {
      for(var e in sneakerDetails){
        _arrAvailable.add(e);
      }

      notifyListeners();
    }
  }

  // The pupose if this function is to update the temporary stock info list
  // which is created for the purpose of holding the new data until the user
  // accepted to the new sneaker to main list sneaker
  void addToCopiedAvailableStock(SneakerDetail sneaker){
    _copiedOfArrAvailable.add(sneaker);
    notifyListeners();
  }

  // used for update a list which already existed in the data
  // provider then when user agree to merge it will with main list
  void modifyAvailableStockExisted(List<SneakerDetail> sneakerDetails){
    // check whether the array of available stock is empty
    if(_copiedOfArrAvailable.isEmpty){
      setCopiedOfArrAvailable = sneakerDetails;
    } else {
      for(var e in sneakerDetails){
        _copiedOfArrAvailable.add(e);
      }
    }
    notifyListeners();
  }

  /*
  * The purpose of this function is to merge the og list and copied list
  * when user agree to update
  * */
  void _mergeTwoLists(){
    // check whether there are something to change to the list or not,
    if(_copiedOfArrAvailable.isNotEmpty){
      // update total avai & sold products
      updateTotalInfo();
      if(_arrAvailable.isNotEmpty){
        // copy new values from the copied and updated list
        // no need to traverse and upadte each element
        // since brand new copy contain old and updated values
        _arrAvailable.clear();
        _arrAvailable = List.from(_copiedOfArrAvailable);

      } else {
        _arrAvailable = List.from(_copiedOfArrAvailable);
      }


    } else {

      if(_arrAvailable.isNotEmpty){
        _arrAvailable.clear();
        updateTotalInfo();
      }
    }


  }

  /*
   * The purpose of this function is to update total product available and sold products
   * in the app
   */
  void updateTotalInfo() {
    int updateQuantity = _copiedOfArrAvailable.length - _arrAvailable.length;

    // update total price sold
    double oldTotalSold = 0;
    for(var e in _arrAvailable){
      if(e.getSneakerSoldPrice.isNotEmpty){
        oldTotalSold += double.parse(e.getSneakerSoldPrice);
      }
    }

    double newTotalSold = 0;
    for(var e in _copiedOfArrAvailable){
      if(e.getSneakerSoldPrice.isNotEmpty){
        newTotalSold += double.parse(e.getSneakerSoldPrice);
      }
    }
    double updateTotalSold = newTotalSold - oldTotalSold;

    SneakerManager().updateTotalAvaiSoldProducts(updateQuantity, updateTotalSold);
  }

  /*
  * create a temp copied list from og list
  * to perform CRUD operation
  * */
  void createCoptyOfStockList(){
    if(_arrAvailable.isNotEmpty){
      setCopiedOfArrAvailable = _arrAvailable;
      // for(var e in _arrAvailable){
      //   _newAddedStockAvailable.add(e);
      // }
    }
  }

  /*
  * The purpose of this function is clear every temp copied list
  * when user decided to update it or not
  * */
  void clearAvailableStockExisted(){
    _copiedOfArrAvailable.clear();
    _stockToBeDeleted.clear();
    notifyListeners();
  }


  void updateSneakerStockInfo(SneakerDetail sneaker,int pos){
    _arrAvailable[pos].updateSneakerStock(sneaker);
  }

  void updateImgURLNotify(String imgURL){
    _sImgUrl = imgURL;
    notifyListeners();
  }

  void updateSneaker({required String newSneakerName, String? sNewNotes, String? sNewImgURL}){
    _sName = newSneakerName;
    _sNotes = sNewNotes ?? "";
    _sImgUrl = sNewImgURL ?? "";
    _mergeTwoLists();
    notifyListeners();
  }

  void notifyWithoutUpdateData(){
    notifyListeners();
  }

  /*
  * The purpose of this function is to delete a stock in the temp copied list
  * and updating the copied list so user can see change immediately without
  * chaning the og list
  * */
  void deleteStockCopiedList(int index){
    SneakerDetail stockToBeDeleted;
    if(_copiedOfArrAvailable.isNotEmpty){
      stockToBeDeleted = _copiedOfArrAvailable[index];
      if(stockToBeDeleted != null){
        _stockToBeDeleted.add(stockToBeDeleted);
        _copiedOfArrAvailable.removeAt(index);
        notifyListeners();
      }
    }
  }
}
