class SneakerDetail{
  late String _sSeller;
  late String _sDate;
  late String _sSize;
  late bool _isSold;


  SneakerDetail({required sSeller, required String sDate, required String sSize, bool? isSold}){
    if(isSold != null){
      _isSold = isSold;
    }
  }

  factory SneakerDetail.fromJson(Map<String, dynamic> json){
    return SneakerDetail(sSeller: json['seller'], sDate: json['date'], sSize: json['size'], isSold: json['isSold']);
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

  bool get isSneakerSold{
    return _isSold;
  }

  set setIsSneakerSold(bool isSneakerSold){
    _isSold = isSneakerSold;
  }
}