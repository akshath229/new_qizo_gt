//import 'package:flutter_app/models/usersession.dart';




// "tsalesloadingDetails": [
// {
// "tldHeaderId": 1,
// "tldItemId": 31,
// "tldQty": 2.0,
// "relSalesLoadingBarcodeDetails": [
// {
// "SlbLoadingDetailsId":1,
// "SlbBarcode":"BC101"
// },
// {
// "SlbLoadingDetailsId":1,
// "SlbBarcode":"BC102"
// }
// ]
// },
// {
// "tldHeaderId": 1,
// "tldItemId": 32,
// "tldQty": 15.0,
// "relSalesLoadingBarcodeDetails": [
// {
// "SlbBarcode":"BC201"
// },
// {
// "SlbBarcode":"BC202"
// },
// {
// "SlbBarcode":"BC202"
// }
// ]
// }
// ]

class UserData {
  late String deviceId;
  late String branchName;
  late String BranchId;
  dynamic user;
  dynamic password;
  dynamic ledgerId;
  dynamic countryName;
  dynamic currencyName;
  dynamic currencyCoinName;
  dynamic appType;
  var godownid;
  dynamic user_typ;
  //dynamic Url;

  UserData({required this.deviceId,
    required this.branchName,
    required this.BranchId,
    this.user,
    this.password,
    this.ledgerId,
    this.countryName,
    this.currencyCoinName,
    this.currencyName,
    this.appType,
    this.godownid,
    this.user_typ,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    deviceId =json['deviceId'];
    branchName = json['BranchName'];
    BranchId = json['BranchId'];
    user = json['user'];
    ledgerId =json['ledgerId'];
    password = json['password'];
    countryName = json['countryName'];
    currencyName = json['currencyName'];
    currencyCoinName = json['currencyCoinName'];
    godownid = json['godownid'];
    appType = json['appType'];
    user_typ = json['user_typ'];
  //  Url = json['Url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    data['BranchName'] = this.branchName;
    data['BranchId'] = this.BranchId;
    data['ledgerId'] = this.ledgerId;
    data['user'] = this.user;
    data['godownid']= this.godownid;
    data['password'] = this.password;
    data['currencyName'] = this.currencyName;
    data['countryName'] = this.countryName;
    data['appType'] = this.appType;
    data['user_typ'] = this.user_typ;
   // data['Url'] = this.Url;
    return data;
  }
}


//
//UserData();
//
//UserData.fromJson(Map<String, dynamic>json)
//: Branc
