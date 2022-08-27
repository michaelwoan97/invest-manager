import 'package:flutter/foundation.dart';
import 'package:invest_manager/models/sneaker_detail.dart';

class Sneaker with ChangeNotifier {
  late String _id;
  late String _sName;
  late String _sNotes;
  late String _sImgUrl;

  // the different between the two is one used for
  // completely new sneaker about add to list
  // the other one used for modifying and waiting whether user want to add
  late List<SneakerDetail> _arrAvailable;
  late List<SneakerDetail> _newAddedStockAvailable = []; // temp list


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
    _newAddedStockAvailable = [];

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


  List<SneakerDetail> get getNewAddedStockAvailable => _newAddedStockAvailable;

  set setNewAddedStockAvailable(List<SneakerDetail> value) {
    _newAddedStockAvailable = List.from(value);
  }

  set setAvailableStocks(List<SneakerDetail> arrAvailableStock) {
    _arrAvailable = List.from(arrAvailableStock);
    notifyListeners();
  }

  /*
  * The different functionality of this function is
  * it will add the stock info list to the newly create sneaker
  * then will notify the sneaker provider to change accordingly
  * but it will not be added to the main list sneaker unless user accepted
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
  void addToAvailableStockExisted(SneakerDetail sneaker){
    _newAddedStockAvailable.add(sneaker);
    notifyListeners();
  }
  // used for update a list which already existed in the data
  // provider then when user agree to merge it will with main list
  void modifyAvailableStockExisted(List<SneakerDetail> sneakerDetails){
    // check whether the array of available stock is empty
    if(_newAddedStockAvailable.isEmpty){
      setNewAddedStockAvailable = sneakerDetails;
    } else {
      for(var e in sneakerDetails){
        _newAddedStockAvailable.add(e);
      }
    }
    notifyListeners();
  }

  // used for editing elment in list but waiting for user agree to merge
  // void modifyStockAvailableNotNotify
  void _mergeTwoLists(){
    if(_newAddedStockAvailable.isNotEmpty){
      if(_arrAvailable.isNotEmpty){
        for(var stock in _arrAvailable){
          for(var e in _newAddedStockAvailable){
            if(stock.getStockID != e.getStockID){
              _arrAvailable.add(e);
            } else {
              stock.updateSneakerStockNoNotify(e);
            }
          }
        }

      } else {
        _arrAvailable = List.from(_newAddedStockAvailable);
      }
    }
  }

  void createCoptyOfStockList(){
    if(_arrAvailable.isNotEmpty){
      setNewAddedStockAvailable = List.from(_arrAvailable);
    }
  }
  void clearAvailableStockExisted(){
    _newAddedStockAvailable.clear();
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
}
