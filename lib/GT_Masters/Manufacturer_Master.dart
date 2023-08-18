import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../appbarWidget.dart';
import '../models/userdata.dart';
import 'Masters_UI/Manufacturer_Create.dart';
import 'Masters_UI/cuWidgets.dart';


class Manufacturer_Master extends StatefulWidget {
  @override
  _Manufacturer_MasterState createState() => _Manufacturer_MasterState();
}

class _Manufacturer_MasterState extends State<Manufacturer_Master> {


  CUWidgets cw=CUWidgets();


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





  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      appBar:
      PreferredSize(child: Appbarcustomwidget(
        uname:userName,
        branch:branchName,
        pref:pref,
        title:"Manufacturer", ), preferredSize: Size.fromHeight(80)),

      body: Create_Manufacturer(height: h,width: w,token: token,device_id: DeviceId,
        branch_Id: branchId,User_id: userId,TblShow: true,
      ),



    ));
  }
}
