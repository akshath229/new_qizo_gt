import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../appbarWidget.dart';
import '../models/userdata.dart';
import 'Masters_UI/Unit_create_CW.dart';
import 'Masters_UI/cuWidgets.dart';
import 'Models/Unit_model.dart';


class UnitMaster extends StatefulWidget {
  @override
  _UnitMasterState createState() => _UnitMasterState();
}

class _UnitMasterState extends State<UnitMaster> {


  CUWidgets cw=CUWidgets();
  static List<Unit> unit = [];

  late SharedPreferences pref;
  dynamic data;
  dynamic branch;
  var res;
  dynamic user;
  late int branchId;
  late int userId;
  late UserData userData;
  String branchName = "";
  dynamic userName;
  late String token;
  late String DeviceId;

// //----------------------------------
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((value) {
        pref = value;
        read();
        GetUnit();
      });
    });
  }

  // //------------------for appbar------------
  read() async {
    var v = pref.getString("userData");
    var c = json.decode(v!);
    user = UserData.fromJson(c); // token gets this code user.user["token"]
    setState(() {
      branchId = int.parse(c["BranchId"]);
      token = user.user["token"]; //  passes this user.user["token"]
      pref.setString("customerToken", user.user["token"]);
      branchName = user.branchName;
      userName = user.user["userName"];
      userId = user.user["userId"];
      DeviceId = user.deviceId;
    });
  }

// //---------------end---for appbar------------
//--------------Get unit-----------------------

  GetUnit() async {
    var jsonres = await cw.CUget_With_Parm(api: "Gtunits", Token: token);

    if (jsonres != false) {
      var res = jsonDecode(jsonres);
      //  print("Unites = $res");
setState(() {
  List<dynamic> unitdetl = res["gtunit"];
  List<Unit> p =
  unitdetl.map((unitdetl) => Unit.fromJson(unitdetl)).toList();
  unit = p;
});

    }
  }

 // Create_Unit k=Create_Unit();
var height=0.0;
var width=0.0;

  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.height;
    return  SafeArea(child:
    Scaffold(

      appBar: PreferredSize(child:
      Appbarcustomwidget(uname:userName, branch:branchName, pref: pref, title: "Unit Master"),
          preferredSize: Size.fromHeight(80)),
      // bottomNavigationBar: cw.CUButton(name: "ui",H: 50,W: 50,function:() {

      // }),

      body:Create_Unit(UnitList: unit,
        Height:height,
        Wedth: width,
        Token: token,
        visibility: true,
        deviceId:DeviceId,),



    ));
  }



}









