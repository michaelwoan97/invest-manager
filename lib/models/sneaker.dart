import 'package:flutter/foundation.dart';
import 'package:invest_manager/models/sneaker_detail.dart';

class Sneaker with ChangeNotifier {
  late String _id;
  late String _sName;
  late String _sNotes;
  late String _sImgUrl;
  late List<SneakerDetail> _arrAvailable;

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
    notifyListeners();
  }

  List<SneakerDetail> get getAvailableStocks {
    return _arrAvailable;
  }

  set setAvailableStocks(List<SneakerDetail> arrAvailableStock) {
    _arrAvailable = List.from(arrAvailableStock);
    notifyListeners();
  }

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

  void updateSneakerStockInfo(SneakerDetail sneaker,int pos){
    _arrAvailable[pos].updateSneakerStock(sneaker);
  }
}
